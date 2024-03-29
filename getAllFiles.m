% Function to get all files with a specific extension recursively
function fileList = getAllFiles(dirName, fileExtension)
% Initialize the output list
fileList = {};

% Get the list of all files and folders in the directory
files = dir(dirName);

% Iterate over all the files and folders
for i = 1:numel(files)
    % Exclude current directory and parent directory
    if ~strcmp(files(i).name, '.') && ~strcmp(files(i).name, '..')
        % Create the full file path
        filePath = fullfile(dirName, files(i).name);

        % Check if the current item is a file or a folder
        if files(i).isdir
            % Recursive call to get files from subfolder
            fileList = [fileList; getAllFiles(filePath, fileExtension)];
        else
            % Check if the file has the specified extension
            [~, ~, extension] = fileparts(filePath);
            if strcmp(extension, fileExtension)
                fileList = [fileList; filePath];
            end
        end
    end
end
