clear all, close all
load CFP0120.mat
Cdata2 = Cdata;
%Cdata2(:,800:900) = Cdata(:,800:900).*exp(1i*pi/3);
W = sqrt(1).*randn(size(Cdata2(:,230:240)));
Cdata2(:,230:240) = Cdata(:,230:240).*exp(1i*W);
W2 = sqrt(1).*randn(size(Cdata2(:,800:900)));
Cdata2(:,800:900) = Cdata(:,800:900).*exp(1i*W2);

imout = CCDbasic(Cdata,Cdata2,3);
figure; imshow(abs(Cdata));
figure; imshow(abs(Cdata2));
figure; imshow(imout);

% search complex SAR in IEEE; notebly the IET seems publish more on SAR
