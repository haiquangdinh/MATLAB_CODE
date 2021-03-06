% Test the NCCDbasic.m

% Clear everything in the workspace
clear all %#ok<CLALL>
% Load a file, consider this reference image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HV\FP0121\c00007a283p50.mat");
% Now save a portion of SAR data , a 850 x 400 windows, to imIn1 for easy
% to remember and then clear data variable
imIn1 = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
% Load another file, consider this target image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\HV\FP0124\c00007a283p50.mat");
% Now save a portion of SAR data , a 850 x 400 windows, to imIn1 for easy
% to remember and then clear data variable
imIn2 = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;
[imOut,RChange] = NCCDbasic( imIn1,imIn2,2 ); 

% Try a convinient detector by "A statistical and geometrical edge detector
% for SAR image"
% imOutC = zeros(size(imOut));
%  for i = 1: size(imOut,1)
%      for j = 1:size(imOut,2)
%          if (imOut(i,j)<=1)
%              imOutC(i,j)=imOut(i,j);
%          else
%              imOutC(i,j) = 1/imOut(i,j);
%          end
%      end
%  end
 imshow(imOut), figure, imshow(RChange)
