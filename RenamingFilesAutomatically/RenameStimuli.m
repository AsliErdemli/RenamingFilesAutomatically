% RenameStimuli.m

%% Purpose of the script
%This script is to automatically name some files (The renaming could be
% sequential or randomized, depending on your preference).

%% Requirements before use
%The directory of the files to rename should be put in the folder
%containing this script. If files to rename are not in a directory, it is
%advised to do so.

%newNamePrefix == should be a char of what needs to be the fixed part of
%the newname. Ex: If we want MyNewImageName_1.png, MyNewImageName_2.png,
%MyNewImageName_3.png,  We should set newnameprefix as 'MyNewImageName_'

%% External ressources needed
%This script uses natsorfiles and natsortrows for getting the correct order of files:
% https://ch.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort
% https://ch.mathworks.com/matlabcentral/fileexchange/47433-natural-order-row-sort
% Download them and put them in the same directory.

%% IMPORTANT: The renamed files will overwrite the old ones so be careful not to lose data! Copy them somewhere else before trying.

%% Ownership
% Fixed and modified by Asli Erdemli in December 2021. Source file modified by Asli:
% https://github.com/BumbleBee0819/RenameFilesWithRandomizedIndex/blob/master/RenameFilesWithRandomizedIndex.m,
% written by Wenyan Bi Sep. 26, 2017. This source code had bugs.
clear all

%% INPUTS YOU NEED TO ADAPT
%REPLACE THIS WITH THE CONSTANT PART OF THE NAME YOU WISH:
newNamePrefix= 'QuestionsHigh_';
MyFileFormat= '.txt'; %The format you wish
SequentialFiles= 1; %Put 1 for sequential numbering, 0 for random numbering

%% Path

%First, enter directory in which we want to make modifications:
% TODO: check if this has to be where the script is or not.
myDirectory = 'C:\Users\erdemli\Documents\Matlab_Dell\RenamingFilesAutomatically'; %insert here path where this script is. Put natsort.m and natsortrows.m and the directory conatining the files to rename in there too.
addpath(genpath(myDirectory));



%% Find visibles directory and files in the directory

%Let's make a structure listing out of all elements of the directory:
allInMyDirectory = dir(myDirectory);

%Let's extract the names of all the files in this directory (visible or not, directory or file):
namesInMyDirectory = {allInMyDirectory.name};

%Let's extract whether these are directories or not (visible or invisible):
isItADirectory = {allInMyDirectory.isdir};  % In cell format
isItADirectory = [isItADirectory{:}]; % In logical format

%Let's get rid of invisible directories/files
nbNamesInMyDirectory = length(namesInMyDirectory);
visible = logical(zeros(nbNamesInMyDirectory, 1));


for nName = 1:nbNamesInMyDirectory
    aName = namesInMyDirectory{nName};
    if aName(1) ~= '.'
        visible(nName) = 1;
    end
end
namesInMyDirectory = namesInMyDirectory(visible); % Names of visible directories and files

%Beware: this is all visible but directories AND files!
isItADirectory = isItADirectory(visible);

%% Find all visible directories

% This is only visible directories
list.visibleDirectories = {namesInMyDirectory{[isItADirectory]}};
% We make sure that functions directory is not renamed.
list.visibleDirectories(strcmp(list.visibleDirectories,'functions')) = []

%%

workDir = myDirectory;
%For each visible directory do the following:
%for
iDirectory = 1:length(list.visibleDirectories) %This line was changed from the original because it bugged
tmpdir = fullfile([myDirectory,'\',[list.visibleDirectories{iDirectory}]]); %Go to first/next one of the visible directories


%WB% Get all unhidden files
file_d = dir(list.visibleDirectories{iDirectory});
file_d=struct2table(file_d)
file_d = natsortrows(file_d)
file_names = file_d.name;


file_isdirs = {file_d.isdir};
file_isdirs = [file_isdirs{:}];


file_numnames = length(file_names);
file_visible = logical(zeros(file_numnames, 1));
for cnt = 1:file_numnames
    file_name = file_names{cnt};
    if ~strcmp(file_name(1),'.')
        file_visible(cnt) = 1;
    end
end

file_names = file_names(file_visible);
%WB% Get all unhiden files
file_d = file_d(file_visible, :);

%WB% How many image files in total
len_files = length(file_names);

if SequentialFiles == 1
    %If you want sequential naming:
    new_file_sequence = 1:(len_files);
else
    %If you want random naming:
    new_file_sequence = randperm(len_files);
end

%WB% Rename the files with the new index
for nFile = 1:len_files
    name_new = [newNamePrefix,int2str(new_file_sequence(nFile)),MyFileFormat];
    try
        movefile(fullfile(tmpdir,file_d.name{nFile,1}),fullfile(tmpdir,name_new));
    end
end

cd(workDir);

%end
