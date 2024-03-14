close all
clear 
clc
profile on;
%% Variables definition
FILES_LIST_data = [];
FILES_LIST_test = [];

%data
DATA_SET = [];
DATA_SET_abs = [];
TEST_SET = [];
TEST_SET_abs = [];

%labels
TARGET_DATA = [];
TARGET_TEST = [];
 
S_MP = []; %temporary array containing module and phase values of a single Sparameter
S_RI = []; %temporary array containing real and imaginary values of a single Sparameter

n_points = 101;

%% DATA SET + TEST SET
%parentFolder = 'E:\Leonardo\matlab code to optimize';
parentFolder = 'C:\Users\d105457\Documents\GitHub\MatlabOpt';

subfolders = dir(parentFolder);
subfolders = subfolders([subfolders.isdir]); % Keep only the subfolders

% Loop through each subfolder
for r = 1:length(subfolders)
    subfolderName = subfolders(r).name;
    if ~strcmp(subfolderName, '.') && ~strcmp(subfolderName, '..')
        % Ignore the "." and ".." folders (current and parent directories)
        subfolderPath = fullfile(parentFolder, subfolderName);
        disp(['Opening subfolder: ' subfolderPath]);
        
        % Loop through each sub-subfolder
        sub_subfolders = dir(subfolderPath);
        sub_subfolders = sub_subfolders([sub_subfolders.isdir]);
        
        for m = 1:length(sub_subfolders)
            sub_subfolderName = sub_subfolders(m).name;
            if ~strcmp(sub_subfolderName, '.') && ~strcmp(sub_subfolderName, '..')
                % Ignore the "." and ".." folders (current and parent directories)
                sub_subfolderPath = fullfile(subfolderPath, sub_subfolderName);
                disp(['Opening sub-subfolder: ' sub_subfolderPath]);
                
                % Loop through each sub-sub-subfolder
                sub_sub_subfolders = dir(sub_subfolderPath);
                sub_sub_subfolders = sub_sub_subfolders([sub_sub_subfolders.isdir]);
                for s = 1:length(sub_sub_subfolders)
                    sub_sub_subfolderName = sub_sub_subfolders(s).name;
                    if ~strcmp(sub_sub_subfolderName, '.') && ~strcmp(sub_sub_subfolderName, '..')
                        % Ignore the "." and ".." folders (current and parent directories)
                        sub_sub_subfolderPath = fullfile(sub_subfolderPath, sub_sub_subfolderName);
                        
                        disp(['Opening sub-sub-subfolder: ' sub_sub_subfolderPath]);
                        
                        files = dir(fullfile(sub_sub_subfolderPath, '*.s6p')); 

                        % Loop through each file
                        for q = 1:length(files)
                            filePath = fullfile(sub_sub_subfolderPath, files(q).name)
                            
                            data = importdata(filePath);
                            disp(['Opened file: ' filePath]);
                            
                            
                            % processFile(data);
                            S = sparameters(filePath);

                            % put diagonal values to 0
                            S = sii_to_zero(S);
                            
                            %% PUT DATA IN THE MATRICES
                            for j = 1:6
                                for k = 1:6
                                    S_parameter = rfparam(S,j,k);
                                    S_parameter = reshape(S_parameter,1,n_points);
                                    for n = 1:length(S_parameter)
                                            
                                        % REAL AND IMAGINARY
                                        Real = real(S_parameter(n));
                                        Imag = imag(S_parameter(n));

                                        S_RI = [S_RI, [Real, Imag]];
                                           
                                        % MODULE AND PHASE
                                        Module = abs(S_parameter(n));
                                        Phase = angle(S_parameter(n));

                                        S_MP = [S_MP, [Module, Phase]];

                                    end
                                end
                            end

                            % DATA SET (TRAINING)
                            if strcmp(subfolderPath,"E:\Leonardo\matlab code to optimize\DATA_SET_simplified") == 1

                                FILES_LIST_data = [FILES_LIST_data, filePath];
                                                             
                                DATA_SET = cat(1,DATA_SET,S_RI); %INSERT DATA IN THE DATASET MATRIX
                                DATA_SET_abs = cat(1,DATA_SET_abs,S_MP); %INSERT DATA IN THE DATASET MATRIX

                                %clear temporary variables
                                S_MP = [];
                                S_RI = [];

                                if filePath((length(filePath)-6):(length(filePath)-4)) == "m10"
                                    
                                    if filePath((length(filePath)-12):(length(filePath)-8)) == "CSF_H"
                                        
                                        TARGET_DATA = cat(1,TARGET_DATA,0);
                                    else
                                        TARGET_DATA = cat(1,TARGET_DATA,1);
                                        
                                    end
                                else
                                    if filePath((length(filePath)-11):(length(filePath)-7)) == "CSF_H"
                                        
                                        TARGET_DATA = cat(1,TARGET_DATA,0);
                                    else
                                        TARGET_DATA = cat(1,TARGET_DATA,1);
                                    end
                                end
                            end
                            % TEST SET 
                            if strcmp(subfolderPath,"E:\Leonardo\matlab code to optimize\TEST_SET_simplified") == 1

                                FILES_LIST_test = [FILES_LIST_test, filePath];
                                
                                TEST_SET = cat(1,TEST_SET,S_RI); % INSERT DATA IN THE TESTSET MATRIX
                                TEST_SET_abs = cat(1,TEST_SET_abs,S_MP); % INSERT DATA IN THE TESTSET MATRIX

                                %clear temporary variables
                                S_MP = []; 
                                S_RI = [];
                                
                                if filePath((length(filePath)-6):(length(filePath)-4)) == "m10"
                                    
                                    if filePath((length(filePath)-12):(length(filePath)-8)) == "CSF_H"
                                        
                                        TARGET_TEST = cat(1,TARGET_TEST,0);
                                    else
                                        TARGET_TEST = cat(1,TARGET_TEST,1);
                                        
                                    end
                                else
                                    if filePath((length(filePath)-11):(length(filePath)-7)) == "CSF_H"
                                        
                                        TARGET_TEST = cat(1,TARGET_TEST,0);
                                    else
                                        TARGET_TEST = cat(1,TARGET_TEST,1);
                                    end
                                end
                            end    
                        end
                    end
                end
            end
        end
    end
end

% remove columns of 0
DATA_SET(:,all(~any(DATA_SET),1)) = [];
TEST_SET(:,all(~any(TEST_SET),1)) = [];
DATA_SET_abs(:,all(~any(DATA_SET_abs),1)) = [];
TEST_SET_abs(:,all(~any(TEST_SET_abs),1)) = [];

save_name = "DATASET.mat"
save(strcat(save_name, ".mat"), "DATA_SET", "DATA_SET_abs", "TEST_SET", "TEST_SET_abs", "TARGET_DATA", "TARGET_TEST", "FILES_LIST_data", "FILES_LIST_test");

profile off
profile viewer