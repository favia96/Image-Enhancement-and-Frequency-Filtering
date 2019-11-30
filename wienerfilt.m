function [WIENER,w,w_rec] = wienerfilt(g,h,k)
%WIENERFILT Summary of this function goes here


H = fft2(h);

%%first implementation not working (because of matrix size and estimation of sf
% H_wiener = fft2(h,512,512);
% %noise_variance = 0.0833; % in case of out-of-focus images
% sf = ( abs(G).^2 - noise_variance) ./ abs(H_wiener).^2; % estimate power spectral density original image
%WIENER = conj(H) ./ (abs(H).^2 + sn./sf); % wiener in freq
% w = ifft2(WIENER,17,17);
% w_rec = conv2(g, w,'same');

%%second implementation with constant K
WIENER = conj(H)./(abs(H).^2 + k);
w = ifft2(WIENER);
w_rec = conv2(g,w,'same');

end

