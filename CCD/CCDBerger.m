function imOut = CCDBerger(imIn1,imIn2,winSize)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs a Berger's alternative coherent change        %
% detection operation.  The inputs are:                                %
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
% imOut:  The CCD coherence map.  The output values are from 0 to 1,   %
%     with 0 indicating no coherence in the two images and 1           %
%     indicating full coherence.                                       %
%                                                                      %
% References:                                                          %
%  "On the correlation coefficient of a bivariate, equal variance,     %
%  complex Gaussian sample"                                            %
%  "Two-Stage Change Detection for Synthetic Aperture Radar"           %
% Date Released:  20 Jan 2018                                          %
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

% Calculate the numerator of the coherence function
num = 2*abs(conv2(imIn1.*conj(imIn2),winFunc,'same'));

% Calculate the denominator of the coherence function
denom = (conv2(abs(imIn1).^2,winFunc,'same') + ...
    conv2(abs(imIn2).^2,winFunc,'same'));
  
% Calculate the coherence function
imOut = num./denom;

return