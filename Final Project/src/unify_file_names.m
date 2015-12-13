function [num, file_addr] = unify_file_names(folder_addr, name_, format)
% ** Yiwen Xu, Dec 6, 2015
% This function rename all files in given folder into given format. (example: pano_1.jpg)
% 
% [Input]
% - folder_addr: folder address, ending in '/'(example:'./folder/')
% - name_: first string in file name
% - format: change filetype in filenames, starting with '.'(example:'.jpg')
% 
% [Ouput]
% - num: number of files in the folder
% - file_addr: folder_addr follow with name_
% 
% [Notes]
% - formatting with 'sprintf'
% - Avoid Error with temp name: movefile cannot move a file onto itself

    % Get all files in the current folder
    files = dir(folder_addr);
    files = files(4:end); % delete first '.' and '..' folder in the directory
    num = length(files);
    file_addr = [folder_addr,name_];
    
    % Change the file names into 'name_.xxx'
    for id = 1:length(files)
        oldname = [folder_addr,files(id).name];
        tempname = [folder_addr,'temp', format];
        newname = [folder_addr,name_, sprintf('%03d',id), format];
        
        movefile(oldname,tempname);
        movefile(tempname,newname);
        
    end
end