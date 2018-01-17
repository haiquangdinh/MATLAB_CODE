function imOut = NCCDbasic( imIn1,imIn2,winSize )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs a basic non-coherent change detection (NCCD)  %
% operation.  The inputs are:                                          %
%                                                                      %
% imIn1:  First input image (reference image)                          %
% imIn2:  Second input image (mission image)                           %
% winSize:  Size of window (can be rectangular or square)              %
%     For square window, winSize is a scalar, and the resulting window %
%         has dimensions (2*winSize+1) x (2*winSize+1)                 %
%     For rectangular window, winSize is a 2-vector, and the resulting %
%         window has dimensions (2*winSize(1)+1) x (2*winSize(2)+1)    %
%                                                                      %
% The output is:                                                       %
% imOut:  The NCCD coherence map.                                      %
% References:                                                          %
%   Miriam Chad "Two-Stage Change Detection for SAR"                   %
%       IEEE Transactions on Geoscience and remote sensing             %
%       Vol 53, NO. 12, Dec 2015                                       %
% Date Released:  14 January 2018                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the window function
switch length(winSize)
    case 1
        winFunc = ones(2*winSize + 1, 2*winSize + 1);
    case 2
        winFunc = ones(2*winSize(1) + 1, 2*winSize(2) + 1);
    otherwise
        error('winSize must have a length of 1 or 2');
end

% Calculate the variance in imIn1 over a spatial window
num = varMatrix(imIn1,winFunc);

% Calculate the variance in imIn2 over a spatial window
denom = varMatrix(imIn2,winFunc);

% Calculate the change statistic (quotient approach)
imOut = num./denom;
end

function varOut = varMatrix(imIn,winFunc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs an estimation of local variance using the variance
% at one location over a spatial windows. The inputs are:                                          
% imIn:  the input data in a matrix
% winFunc:  the window (can be rectangular or square)             
% The output is:                                                       
% varOut:  The matrix that has variance at local pixel calculated by using
% the variance of neighbor pixel
% Date Released:  14 January 2018                                      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create block processing function that return the variance of a block
fun = @(x) var(x(:));

% Using nlfilter for sliding-neighborhood operations
varOut = nlfilter(imIn,size(winFunc),fun);

end
