function [C,c,c_rec] = leastsquares(g,h,gamma)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
p = [0 -1 0; 
    -1 4 -1; 
    0 -1 0];
P = fft2(p, size(h, 1), size(h,2));
H = fft2(h);
C = conj(H) ./ (abs(H).^2 + gamma*abs(P).^2);
c = ifft2(C);
c_rec = conv2(g, c,'same');
end

