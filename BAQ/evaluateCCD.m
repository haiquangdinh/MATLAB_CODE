function [ PD, PFA ] = evaluateCCD( CM1, CM2, th1, th2 )
% evaluate the probability of CCD
% PD : detected probability
% PFA : false alarm probability
% CM1 and CM2 : Coherence value matrix
% th : threshold to classify target or clutter

[~,CV1] = quantiz(CM1(:), th1, [1, 3]);
[~,CV2] = quantiz(CM2(:), th2, [4, 5]);
CV = CV1 + CV2;
PD = numel(find(CV==8))/numel(find(CV1==3));
PFA = numel(find(CV==6))/numel(find(CV1==1));
end

