% Test the NCCDbasic.m

% Clear everything in the workspace
clear all %#ok<CLALL>
% Load a file, consider this reference image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0120\c00007a283p50.mat");
% Now save a portion of SAR data , a 850 x 400 windows, to imIn1 for easy
% to remember and then clear data variable
imIn1 = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
% Load another file, consider this target image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0121\c00007a283p50.mat");
% Now save a portion of SAR data , a 850 x 400 windows, to imIn1 for easy
% to remember and then clear data variable
imIn2 = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
imOut = NCCDbasic( imIn1,imIn2,5 );