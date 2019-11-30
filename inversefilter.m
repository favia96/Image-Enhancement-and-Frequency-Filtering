function [h_inv,f_rec] = inversefilter(g,h)
%INVERSEFILTER Summary of this function goes here
%   Detailed explanation goes here
h_inv = 1 ./ h;
f_rec = conv2(g, h_inv,'same');
end

