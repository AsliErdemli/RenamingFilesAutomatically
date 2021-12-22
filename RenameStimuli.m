function CURIODORrename
%This function is to automatically name some files (The renaming could be 
% sequential or randomized, depending on your preference).
%The directories of the files to rename should be put in the folder 
%containing this script. If files to rename are not in a directory, it is
%advised to do so. 

%newNamePrefix == should be a char of what needs to be the fixed part of
%the newname. Ex: If we want MyNewImageName_1.png, MyNewImageName_2.png, 
%MyNewImageName_3.png,  We should set newnameprefix as 'MyNewImageName_' 

% Fixed and modified by Asli Erdemli in December 2021. Source file modified by Asli:
% https://github.com/BumbleBee0819/RenameFilesWithRandomizedIndex/blob/master/RenameFilesWithRandomizedIndex.m,
% written by Wenyan Bi Sep. 26, 2017. This source code had bugs. 

%% IMPORTANT: The renamed files will overwrite the old ones so be careful not to lose data! Copy them somewhere else before trying.

clear all

%% INPUTS YOU NEED TO ADAPT
%REPLACE THIS WITH THE CONSTANT PART OF THE NAME YOU WISH:
newNamePrefix= 'MyNewName_FixPart_MUST_CHANGE';
MyFileFormat= '.txt'; %The format you wish
SequentialFiles= 1; %Put 1 for sequential numbering, 0 for random numbering
%%
%First, enter directory in which we want to make modifications:
directory = pwd;

%Let's make a structure listing out of all elements of the directory:
d = dir (directory);

%Let's extract the names of all the files in this dirctory (visible or not, directory or file):
names = {d.name};

%Let's extract whether these are directories or not (visible or invisible):
isdirs = {d.isdir};  
isdirs = [isdirs{:}]; 

%Let's get rid of invisible directories/files
numnames = length(names);
visible = logical(zeros(numnames, 1));
for n = 1:numnames
    name = names{n};
    if name(1) ~= '.'
        visible(n) = 1;
    end
end
names = names(visible); % Names of visible directories and files

%Beware: this is all visible but directories and files!
isdirs = isdirs(visible);

%This is only visible directories
list.dirs = {names{[isdirs]}};  


workDir = pwd;
%For each visible directory do the following: 
for i = 1: length(list.dirs) %This line was changed from the original because it bugged
    tmpdir = [list.dirs{i}]; %Go to first/next one of the visible directories
    cd(tmpdir);
    
    %WB% Get all unhidden files
    file_d = dir(pwd);
    file_names = {file_d.name};  
    file_isdirs = {file_d.isdir};  
    file_isdirs = [file_isdirs{:}]; 
    
    
    file_numnames = length(file_names);
    file_visible = logical(zeros(file_numnames, 1));
    for cnt = 1:file_numnames
        file_name = file_names{cnt};
        if file_name(1) ~= '.'
            file_visible(cnt) = 1;
        end
    end
    
    file_names = file_names(file_visible);
    %WB% Get all unhiden files
    file_d = file_d(file_visible);   
    %WB% How many image files in total
    len_frames = length(file_names);
    
    if SequentialFiles == 1
    %If you want sequential naming: 
    new_frame_sequence = 1: (len_frames);
    else 
    %If you want random naming: 
     new_frame_sequence = randperm(len_frames);
    end
    
    %WB% Rename the image files with the new index
    for frames = 1:len_frames
        name_new = [newNamePrefix,int2str(new_frame_sequence(frames)),MyFileFormat];
        try
            movefile(file_d(frames).name,name_new);
        end
    end
    
    cd(workDir);
end
    
