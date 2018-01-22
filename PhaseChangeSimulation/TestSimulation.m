% Test simulation of adding phase

% Clear everything in the workspace
clear all %#ok<CLALL>
% Load a file, consider this reference image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0120\c00007a283p50.mat");
% Now save a portion of SAR data , a 850 x 400 windows, to imIn1 for easy
% to remember and then clear data variable
imIn1 = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;

% Adding noise (a 50 pixel strip) to create a second image
imIn2 = imIn1;
W = sqrt(1).*randn(size(imIn1(:,200:250-1)));
imIn2(:,200:250-1) = imIn1(:,200:250-1).*exp(1i*W);

% Perform the basic CCD and show result
imOut = NCCDbasic(imIn1,imIn2,2);
figure; imshow(abs(imIn1));
figure; imshow(abs(imIn2));
figure; imshow(imOut);
imOutC = zeros(size(imOut));
 for i = 1: size(imOut,1)
     for j = 1:size(imOut,2)
         if (imOut(i,j)<=1)
             imOutC(i,j)=imOut(i,j);
         else
             imOutC(i,j) = 1/imOut(i,j);
         end
     end
 end
 imshow(imOutC)

 %
 imOut2 = CCDbasic(imIn1,imIn2,2);figure; imshow(imOut2);