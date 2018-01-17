function [ quantA ] = fcnQuantRunningLloyds( A ,bitRate )
% A as 2-D matrix 
% The quantization is applied with running lloyds trainning
len = 2^bitRate;
if (isreal(A)) % use if compress only I or Q
    [partition,codebook] = lloyds(A(:),len);
    [~,quantA] = quantiz(A(:),partition,codebook);
    quantA = reshape(quantA,size(A));
else
    tempR = real(A);
    [partition,codebook] = lloyds(tempR(:),len);
    [~,quantsR] = quantiz(tempR(:),partition,codebook);
    tempI = imag(A);
    [partition,codebook] = lloyds(tempI(:),len);
    [~,quantsI] = quantiz(tempI(:),partition,codebook);
    quantA = reshape(quantsR,size(tempR)) + 1i*reshape(quantsI,size(tempI));
end

