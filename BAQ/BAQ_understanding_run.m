% run detail of BAQ to understand the algorithm
% a shorter and more convienient to use is function BAQ with using
% demonstration in runBAQ
clear all, close all, clc
load raw_data

testData = real(im1);

up_blk_limit = 256; %upper block size limit
low_blk_limit = 16; %lower block size limit

init_std = std2(testData);

%calculate the best block size (minimize the average std)
blk_size = 16; %2/18/2013 given a fixed block size

%bit rate: bit/sample for each I and each Q
% see [2] for below specific number
x2_i = 0.9816; y2_i = [0.4528,1.510];
x2 = [-fliplr(x2_i), 0, x2_i]; y2 = [-fliplr(y2_i), y2_i];
x3_i = [0.5006, 1.05, 1.748]; y3_i = [0.2451, 0.756, 1.344, 2.152];
x3 = [-fliplr(x3_i), 0, x3_i]; y3 = [-fliplr(y3_i), y3_i];
x4_i = [0.2582, 0.5224, 0.7996, 1.099, 1.437, 1.844, 2.401]; 
y4_i = [0.1284, 0.3881, 0.6568, 0.9424, 1.256, 1.618, 2.069, 2.733];
x4 = [-fliplr(x4_i), 0, x4_i]; y4 = [-fliplr(y4_i), y4_i];
x5_i = [0.1320, 0.2648, 0.3991, 0.5359, 0.6761, 0.8210, 0.9718, 1.130, 1.299, 1.482, 1.682, 1.908, 2.174, 2.505, 2.977];
y5_i = [0.0659, 0.1981, 0.3314, 0.4668, 0.6050, 0.7473, 0.8947, 1.049, 1.212, 1.387, 1.577, 1.788, 2.029, 2.319, 2.692, 3.263];
x5 = [-fliplr(x5_i), 0, x5_i]; y5 = [-fliplr(y5_i), y5_i];

%BAQ quantization
for k=1:blk_size:size(testData,1)
    klimit = min(k+blk_size,size(testData,1));
    for n=1:blk_size:size(testData,2)
        nlimit = min(n+blk_size,size(testData,2));
        blk_temp = testData(k:klimit,n:nlimit);
        sigma = std2(blk_temp);
        partition2 = x2*sigma;
        codebook2 = y2*sigma; 
        [index2,quants2] = quantiz(blk_temp(:),partition2,codebook2);
        quantData2(k:klimit,n:nlimit)= reshape(quants2,size(blk_temp));
        partition3 = x3*sigma;
        codebook3 = y3*sigma; 
        [index3,quants3] = quantiz(blk_temp(:),partition3,codebook3);
        quantData3(k:klimit,n:nlimit)= reshape(quants3,size(blk_temp));
        partition4 = x4*sigma;
        codebook4 = y4*sigma; 
        [index4,quants4] = quantiz(blk_temp(:),partition4,codebook4);
        quantData4(k:klimit,n:nlimit)= reshape(quants4,size(blk_temp));
        partition5 = x5*sigma;
        codebook5 = y5*sigma; 
        [index5,quants5] = quantiz(blk_temp(:),partition5,codebook5);
        quantData5(k:klimit,n:nlimit)= reshape(quants5,size(blk_temp));
    end
end
SQNR(testData,quantData2)
SQNR(testData,quantData3)
SQNR(testData,quantData4)
SQNR(testData,quantData5)

%[2] Joel Max, "Quantizing for Minimum Distortion"