clear all %#ok<CLALL>
DataFolder = 'D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV';
Files = dir(strcat(DataFolder,'/**/*.mat')); % search in folder and all subfolder any file with .mat extension
FileNames = strings(size(Files,1),1);
for n = 1:size(Files,1)
    FileNames(n) = fullfile(Files(n).folder,Files(n).name);
end
strFile = fullfile(DataFolder,'FileNames.mat');
save(strFile,'FileNames')
