function quantData = BAQ( data,bit_rate,block_size )
%Block Adaptive Quantization
% x:signal
% bit_rate : number of bit per sample: could be 2,3,4,5
% block size : size of the block : could be 16 -> 256
% see [1] for below specific number
x{1} = 0.9816; % 2 bps
y{1} = [0.4528,1.510];
x{2} = [0.5006, 1.05, 1.748]; % 3 bps
y{2} = [0.2451, 0.756, 1.344, 2.152];
x{3} = [0.2582, 0.5224, 0.7996, 1.099, 1.437, 1.844, 2.401]; % 4 bps
y{3} = [0.1284, 0.3881, 0.6568, 0.9424, 1.256, 1.618, 2.069, 2.733];
x{4} = [0.1320, 0.2648, 0.3991, 0.5359, 0.6761, 0.8210, 0.9718, 1.130, 1.299, 1.482, 1.682, 1.908, 2.174, 2.505, 2.977]; % 5 bps
y{4} = [0.0659, 0.1981, 0.3314, 0.4668, 0.6050, 0.7473, 0.8947, 1.049, 1.212, 1.387, 1.577, 1.788, 2.029, 2.319, 2.692, 3.263];

if (nargin<3)
    block_size = 32; %default
elseif (nargin<2)
    bit_rate = 2;
    block_size = 32; 
end
if ((bit_rate<2) || (bit_rate>5))
    error('the bit rate has to be from 2 to 5');
end
if ((block_size<4) || (block_size>256))
    error('the block size has to be from 4 to 256');
end

xi = [-fliplr(x{bit_rate-1}), 0 , x{bit_rate-1}];
yi = [-fliplr(y{bit_rate-1}), y{bit_rate-1}];
quantData = zeros(size(data));
if (isreal(data)) % use if compress only I or Q
    for k=1:block_size:size(data,1)
        klimit = min(k+block_size,size(data,1));
        for n=1:block_size:size(data,2)
            nlimit = min(n+block_size,size(data,2));
            blk_temp = data(k:klimit,n:nlimit);
            sigma = std2(blk_temp);
            partition = xi*sigma;
            codebook = yi*sigma; 
            [~,quants] = quantiz(blk_temp(:),partition,codebook);
            quantData(k:klimit,n:nlimit)= reshape(quants,size(blk_temp));
        end
    end    
else % compress both I and Q
    dataI = real(data);
    dataQ = imag(data);
    for k=1:block_size:size(data,1)
        klimit = min(k+block_size,size(data,1));
        for n=1:block_size:size(data,2)
            nlimit = min(n+block_size,size(data,2));
            blk_tempI = dataI(k:klimit,n:nlimit);
            blk_tempQ = dataQ(k:klimit,n:nlimit);
            sigmaI = std2(blk_tempI);
            partitionI = xi*sigmaI;
            codebookI = yi*sigmaI; 
            [~,quantsI] = quantiz(blk_tempI(:),partitionI,codebookI);
            sigmaQ = std2(blk_tempQ);
            partitionQ = xi*sigmaQ;
            codebookQ = yi*sigmaQ; 
            [~,quantsQ] = quantiz(blk_tempQ(:),partitionQ,codebookQ);
            quantData(k:klimit,n:nlimit)= reshape(quantsI,size(blk_tempI)) + 1i*reshape(quantsQ,size(blk_tempQ));
        end
    end    
    
end
%[1] Joel Max, "Quantizing for Minimum Distortion"