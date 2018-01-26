function [imOut,num,denom] = CCDWishartPol(imIn1,imIn2,winSize)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function performs a Wishart Test Statistic on Polarimetric SAR  %
% The inputs are:                                          %
%                                                                      %
% imIn1:  First input image (reference image): include HH, VV, HV      %
% imIn2:  Second input image (mission image): include HH, VV, HV       %
% winSize:  Size of window (can be rectangular or square)              %
%     For square window, winSize is a scalar, and the resulting window %
%         has dimensions (2*winSize+1) x (2*winSize+1)                 %
%     For rectangular window, winSize is a 2-vector, and the resulting %
%         window has dimensions (2*winSize(1)+1) x (2*winSize(2)+1)    %
%                                                                      %
% The output is:                                                       %
% imOut:  The Bartlett like distance                                   %                             %
% Date Released:  21 Jan 2011                                          %
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

% Build the average PCM matrix for each image
PCMimIn1 = PCMim(imIn1,winFunc);
PCMimIn2 = PCMim(imIn2,winFunc);

% Calculate the numerator of the coherence function
num = detMultiDimensionXY(PCMimIn1,PCMimIn2);

% Calculate the denominator of the coherence function
denom = sqrt(detMultiDimension(PCMimIn1).*detMultiDimension(PCMimIn2));
  
% Calculate the coherence function
imOut = 2*log(num./denom);

end

function detOut = detMultiDimension(data)
    detOut = zeros([size(data,1),size(data,2)]);
    for p=1:size(data,1)
        for q=1:size(data,2)
            detOut(p,q) = det(squeeze(data(p,q,:,:)));
        end
    end
end

function detOut = detMultiDimensionXY(dataX,dataY)
    detOut = zeros([size(dataX,1),size(dataX,2)]);
    for p=1:size(dataX,1)
        for q=1:size(dataX,2)
            detOut(p,q) = det((squeeze(dataX(p,q,:,:)) + squeeze(dataY(p,q,:,:)))/2);
        end
    end
end

function PCMout = PCMim(data,winFunc)
    k = zeros(size(data));
    PCMoutS = zeros([size(data) 3]); % single look
    PCMout = zeros(size(PCMoutS)); % multiple look
    % for each pixel single look
    for p=1:size(data,1)
        for q=1:size(data,2)
            % make a Pauli vector
            k(p,q,:) = [data(p,q,1)+data(p,q,2),...
                data(p,q,1)-data(p,q,2),...
                2*data(p,q,3)]';
            PCMoutS(p,q,:,:)=1/2*squeeze(k(p,q,:))*ctranspose(squeeze(k(p,q,:)));
        end
    end
    % Calculate multi look by average over a winFunc window
    % Create block processing function that return the average of a block
    fun = @(x) mean(x(:));
    % Using nlfilter for sliding-neighborhood operations
    for p=1:3
        for q=1:3
            PCMout(:,:,p,q) = nlfilter(PCMoutS(:,:,p,q),...
                size(winFunc),fun);
        end
    end
end
