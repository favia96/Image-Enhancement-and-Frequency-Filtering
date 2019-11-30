function [W,H,T,t_rec] = modinverse(g,h)
%MODINVERSE Summary of this function goes here
%   Detailed explanation goes here
W = zeros(size(h));
for i = 0 : size(W,1)-1
    for j = 0 : size(W,2)-1
        W(i+1,j+1) = 1 /(1+((i^2 + j^2)*100)^3);
    end
end

H = fft2(h);
T = W ./ H;
t_rec = conv2(g, ifft2(T),'same');

end

