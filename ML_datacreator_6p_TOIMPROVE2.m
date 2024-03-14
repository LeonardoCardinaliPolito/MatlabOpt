save_name="test";
ML_datacreator_6p_TOIMPROVE(save_name)

function [DATA_SET, DATA_SET_mod, TEST_SET, TEST_SET_mod, TARGET_DATA, TARGET_TEST, FILES_LIST_data, FILES_LIST_test] = ML_datacreator_6p_TOIMPROVE(save_name)

parentFolder = 'C:\Users\d058003\OneDrive - Politecnico di Torino\Documenti\GitHub\MatlabOpt';
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

DATA_SET = zeros(n_points*60, n_training_elements);
DATA_SET_mod = zeros(n_points*30, n_training_elements);

TEST_SET = zeros(n_points*60, n_test_elements);
TEST_SET_mod = zeros(n_points*30, n_test_elements);

TARGET_DATA = zeros(n_training_elements,1);
TARGET_TEST = zeros(n_test_elements, 1);

%% DATA SET
for n_file=1:n_training_elements
for n_file_train=1:n_training_elements

    filePath = FILES_LIST_data{n_file_train};

    disp(['Opened file: ' filePath]);

    % LABEL
    if contains(filePath, "CSF_H")
        TARGET_DATA(n_file_train) = 0;
    else
        TARGET_DATA(n_file_train) = 1;
    end

    % processFile(data);
    S = sparameters(filePath);

    % initialize counter to fill S_RI and S_M
    ind = 1;

    %% PUT DATA IN THE MATRICES
    for j = 1:6
        for k = 1:6

            if j~=k % self-terms of the matrix are excluded

                S_parameter = rfparam(S,j,k);
                S_parameter = reshape(S_parameter,1,n_points);

                % REAL AND IMAGINARY
                Real = real(S_parameter);
                Imag = imag(S_parameter);

                DATA_SET(2*101*(ind-1) + 1 : 2*101*ind, n_file_train) = [Real, Imag];

                % MODULE
                Module = abs(S_parameter);

                DATA_SET_mod(101*(ind-1) + 1 : 101*ind, n_file_train) = Module;

                ind = ind+1; %update counter
            end
        end
    end
end

%% TEST SET
for n_file_test=1:n_test_elements

    filePath = FILES_LIST_test{n_file_test};

    disp(['Opened file: ' filePath]);

    % LABEL
    if contains(filePath, "CSF_H")
        TARGET_TEST(n_file_test) = 0;
    else
        TARGET_TEST(n_file_test) = 1;
    end

    % processFile(data);
    S = sparameters(filePath);

    % put diagonal values to 0
    S = sii_to_zero(S);

    % initialize counter to fill S_RI and S_M
    ind = 1;

    %% PUT DATA IN THE MATRICES
    for j = 1:6
        for k = 1:6

            if j~=k % self-terms of the matrix are excluded

                S_parameter = rfparam(S,j,k);
                S_parameter = reshape(S_parameter,1,n_points);

                % REAL AND IMAGINARY
                Real = real(S_parameter);
                Imag = imag(S_parameter);

                TEST_SET(2*101*(ind-1) + 1 : 2*101*ind, n_file_test) = [Real, Imag];

                % MODULE
                Module = abs(S_parameter);

                TEST_SET_mod(101*(ind-1) + 1 : 101*ind, n_file_test) = Module;
             
                ind = ind+1; %update counter
            end
        end
    end
end

save(strcat(save_name, ".mat"), "DATA_SET", "DATA_SET_mod", "TEST_SET", "TEST_SET_mod", "TARGET_DATA", "TARGET_TEST", "FILES_LIST_data", "FILES_LIST_test");

end 