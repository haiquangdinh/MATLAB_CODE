% Test the Bartlett distance of PolSAR

% Load HH, VV, and HV components of a PolSAR data
% Clear everything in the workspace
clear all %#ok<CLALL>
% Load HH, VV, and HV components of a PolSAR data and save a portion of
% data 850x400 windows, consider this reference image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HH\FP0121\c00007a283p50.mat");
imIn1(:,:,1) = data.SARdataOut; clear data;
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0121\c00007a283p50.mat");
imIn1(:,:,2) = data.SARdataOut; clear data;
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HV\FP0121\c00007a283p50.mat");
imIn1(:,:,3) = data.SARdataOut; clear data;
% Load another HH, VV, and HV components of a PolSAR data and save a portion of
% data 850x400 windows, consider this target image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HH\FP0124\c00007a283p50.mat");
imIn2(:,:,1) = data.SARdataOut; clear data;
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0124\c00007a283p50.mat");
imIn2(:,:,2) = data.SARdataOut; clear data;
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HV\FP0124\c00007a283p50.mat");
imIn2(:,:,3) = data.SARdataOut; clear data;

imOut = CCDWishartPol(imIn1,imIn2,3);

% Here is just a random idea of testing Ostu thresholding
%[level,EM] = graythresh(abs(imOut));BW = imbinarize(abs(imOut),level);figure,imshow(BW)

figure,imagesc(abs(imOut)),axis image, axis off;
