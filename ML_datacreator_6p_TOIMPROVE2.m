close all
clear 
clc

save_name="test";

profile on

ML_datacreator_6p(save_name);

profile off
profile viewer


function [DATA_SET, DATA_SET_mod, TEST_SET, TEST_SET_mod, TARGET_DATA, TARGET_TEST] = ML_datacreator_6p(save_name)

parentFolder = 'C:\Users\d105457\Documents\GitHub\MatlabOpt';
total_files_list = getAllFiles(parentFolder, ".s6p");

% find training set files
substring = 'DATA_SET';
indexes = [];
for i = 1:numel(total_files_list)
    if any(contains(total_files_list{i}, substring))
        indexes = [indexes, i];
    end
end

FILES_LIST_data = total_files_list(indexes); %list of files to use as training set
FILES_LIST_test = total_files_list;
FILES_LIST_test(indexes) = []; %the rest of the files are used as test set

n_training_elements = length(FILES_LIST_data);
n_test_elements = length(FILES_LIST_test);

% preallocation
n_points = 101;
port_quantity=6;
S_matrix_size=port_quantity^2;

%DATA_SET = zeros(n_points*60, n_training_elements);
%DATA_SET_mod = zeros(n_points*30, n_training_elements);

TEST_SET = zeros(n_points*60, n_test_elements);
TEST_SET_mod = zeros(n_points*30, n_test_elements);

TARGET_DATA = zeros(n_training_elements,1);
TARGET_TEST = zeros(n_test_elements, 1);

%% DATA SET
[DATA_SET,DATA_SET_mod] = putData (n_training_elements,FILES_LIST_data,S_matrix_size,port_quantity,n_points);

%% TEST SET
[TEST_SET,TEST_SET_mod] = putData (n_test_elements,FILES_LIST_test,S_matrix_size,port_quantity,n_points);


save(strcat(save_name, ".mat"), "DATA_SET", "DATA_SET_mod", "TEST_SET", "TEST_SET_mod", "TARGET_DATA", "TARGET_TEST", "FILES_LIST_data", "FILES_LIST_test");

end


function data= readSparams(filePath,S_matrix_size)
    fid = fopen(filePath, 'rt');
    datacell = textscan(fid,'%f','HeaderLines', 4+S_matrix_size);%4 to skip first two lines
    %and last two lines  where there is date etc and Smatrix size because 
    % it is written S11,S12... etc 
    fclose(fid);

    data = datacell{1};%all characters are transformed to NaN and all numbers are transformed to double
    data = data(~isnan(data)); %removing all NaN
    data(data>1)=[];
end

function [SET,SET_mod] = putData (n_element,FILES_LIST,S_matrix_size,port_quantity,n_points)
    SET=zeros((S_matrix_size-port_quantity)*2*101,n_element);
    SET_mod=zeros((S_matrix_size-port_quantity)*101,n_element);

    %(S_matrix_size-port_quantity)*101 represents all S parametrers without reflection coefficients
    % data set has *2 because there are im and real values separately
    
    for n_file=1:n_element
    
        filePath = FILES_LIST{n_file}
    
        disp(['Opened file: ' filePath]);
    
        % LABEL
        if contains(filePath, "CSF_H")
            TARGET_DATA(n_file) = 0;
        else
            TARGET_DATA(n_file) = 1;
        end
    
        % processFile(data);
        S=readSparams(filePath,S_matrix_size);
        % remove reflection coefficients
        %S = removeReflection(S,port_quantity,n_points);
        %SET(:,n_file)=S;
    
        %S_mod=S(1:2:end-1).^2 + S(2:2:end).^2;
        %SET_mod(:,n_file)=sqrt(S_mod);
    end

end