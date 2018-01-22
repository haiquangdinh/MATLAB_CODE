% Test the Bartlett distance of PolSAR

% Load HH, VV, and HV components of a PolSAR data
% Clear everything in the workspace
clear all %#ok<CLALL>
% Load HH, VV, and HV components of a PolSAR data and save a portion of
% data 850x400 windows, consider this reference image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HH\FP0120\c00007a283p50.mat");
imIn1(:,:,1) = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0120\c00007a283p50.mat");
imIn1(:,:,2) = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HV\FP0120\c00007a283p50.mat");
imIn1(:,:,3) = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
% Load another HH, VV, and HV components of a PolSAR data and save a portion of
% data 850x400 windows, consider this target image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HH\FP0121\c00007a283p50.mat");
imIn2(:,:,1) = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0121\c00007a283p50.mat");
imIn2(:,:,2) = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HV\FP0121\c00007a283p50.mat");
imIn2(:,:,3) = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;

imOut = CCDWishartPol(imIn1,imIn2,2);