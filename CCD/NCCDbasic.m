function [imOut, RChange] = NCCDbasic( imIn1,imIn2,winSize )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs a basic non-coherent change detection (NCCD)  %
% operation.  The inputs are:                                          %
%                                                                      %
% imIn1:  First input image (reference image)                          %
% imIn2:  Second input image (mission image)                           %
% winSize:  Size of window (can be rectangular or square)              %
%     For square window, winSize is a scalar, and the resulting window %
%         has dimensions (2*winSize+1) x (2*winSize+1)                 %
%           e.g. winSize = 1 --> windows 3x3 windows, 9 elements       %
%     For rectangular window, winSize is a 2-vector, and the resulting %
%         window has dimensions (2*winSize(1)+1) x (2*winSize(2)+1)    %
%                                                                      %
% The output is:                                                       %
% imOut:  The R map (quotion of variance)                              %
% RChange: binary map of change or not according to the algorithm      %
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

% Calucalte the upper critical value and the lower critical value
alpha = 0.01; % test significant level
F_Ru = 1 - alpha/2; % upper critical F value
F_Rl = alpha/2; % lower critical F value
N = numel(winFunc); % number of look
df = 2*N; % degree of freedom for both data
Ru = findCriticalValueIncompleteBeta(F_Ru,N); % upper critical value R
Rl = findCriticalValueIncompleteBeta(F_Rl,N); % upper critical value R
% Make the change map in which 0 value for change and 1 value for no change
NullHypothesisRejected=(imOut > (Ru*ones(size(imOut))))|...
    (imOut < (Rl*ones(size(imOut))));
RChange = ~NullHypothesisRejected;

end

% Assuming the F-Test is incomplete beta function, search for the critical
% value Rc that has F(Rc|H0)=FValue = I(Rc/(1+Rc),N, N)
% A note that incomplete beta function is a linear function
function RCritical = findCriticalValueIncompleteBeta(FValue,N)
    Error = 0.0001; MaxIt = 10000; % Stop conditions
    RCritical =  0; err = 1; It = 0;%initial value
    while ((err > Error)&&(It < MaxIt))
        X = RCritical/(1+RCritical);
        fValue = betainc(X,N,N); % calculate incomplete beta function value
        err = FValue-fValue;
        if (err > 0) 
            RCritical = RCritical + 0.001; % increase RCritical
        else
            RCritical = RCritical - 0.001; % decreasse RCritical
        end
        It = It + 1;
    end
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
