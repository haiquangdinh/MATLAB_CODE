function y = NMSE(I,R)
    y = sum(sum((double(I)-double(R)).^2))/sum(sum(double(I).^2));