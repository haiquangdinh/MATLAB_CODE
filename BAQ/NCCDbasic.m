function imOut = NCCDbasic(imIn1,imIn2,winSize)

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
% imOut:  The NCCD image output.  Positive values indicate departures  %
%     (brighter intensities in the reference image) and negative       %
%     values indicate arrivals (brighter intensities in the mission    %
%     image).                                                          %
%                                                                      %
% References:                                                          %
%   Scarborough, S. "A Challenge Problem for SAR Change Detection and  %
%       Data Compression," SPIE Algorithms for Synthetic Aperture      %
%       Radar Imagery XVII, Orlando, FL, April, 2010.                  %
%                                                                      %
%   Novak, L. "Change Detection for Multi-Polarization, Multi-Pass     %
%       SAR," SPIE Algorithms for Synthetic Aperture Radar Imagery XII,%
%       Orlando, FL, March, 2005.                                      %
%                                                                      %
% Contact Information:                                                 %
% Steven Scarborough and LeRoy Gorham (AFRL/RYAP)                      %
% Email:  steven.scarborough@wpafb.af.mil / leroy.gorham@wpafb.af.mil  %                                  %
% Date Released:  8 Apr 2011                                           %
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

% Calculate the magnitude squared of the input images
p1 = abs(imIn1).^2;
p2 = abs(imIn2).^2;

% Convolve the images with the window function
sig1 = conv2(p1,winFunc,'same');
sig2 = conv2(p2,winFunc,'same');

% Calculate the NCCD metric
imOut = sign(sig1-sig2) .* abs(10*log10(sig1) - 10*log10(sig2));

return