clear all %#ok<CLALL>
% Load a file, consider this reference image:
data = load("D:\Users\haiqu\Documents\MATLAB\SAR_DATA\VV\FP0120\c00007a283p50.mat");
% Now save a portion of SAR data , a 850 x 400 windows, to imIn1 for easy
% to remember and then clear data variable
imIn1 = data.SARdataOut(2000:2850-1,2950:3350-1); clear data;

% Wavelet decomposition of x. 
n = 1; w = 'db7'; [c,l] = wavedec2(imIn1,n,w);

% Wavelet coefficients thresholding. 
% thr = 20; 
% keepapp = 1;
[THR,NKEEP] = wdcbm2(c,l,3);
[xd,cxd,lxd,perf0,perfl2] = ...
                  wdencmp('lvd',c,l,w,n,THR,'s');
              
% imshow(abs(imIn1))
figure,imshow(abs(xd))