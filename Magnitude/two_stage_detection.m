% Test the two-stage detection

% Clear everything in the workspace
clear all %#ok<CLALL>
% Load a file, consider this reference image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0120\c00007a283p50.mat");
% Now save a portion of SAR data , a 850 x 400 windows, to imIn1 for easy
% to remember and then clear data variable
% imIn1 = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
imIn1 = data.SARdataOut; clear data;
% Load another file, consider this target image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0121\c00007a283p50.mat");
% Now save a portion of SAR data , a 850 x 400 windows, to imIn1 for easy
% to remember and then clear data variable
% imIn2 = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
imIn2 = data.SARdataOut; clear data;

% Calculate the map
[imOutNCCD,RChange] = NCCDbasic( imIn1,imIn2,2 ); 
imOutCCD = CCDBerger( imIn1,imIn2,2 ); 
imOut2Step = RChange.*imOutCCD;
subplot(1,3,1), imshow(RChange)
subplot(1,3,2), imshow(imOutCCD)
subplot(1,3,3), imshow(imOut2Step)
