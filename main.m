%% IMAGE PROCESSING (EQ2330) - PROJECT 1, 20.11.2019
%% Federico Favia - Yue Song

%% Initialization
clear ; close all; clc

path = 'path_of_the_image';
L = 256; % number grey levels

%% ==================== Part 1: Histogram equalization ====================
img = imread(path); % read image

if(size(img,3) > 1) % if not gray scale convert
    img = rgb2gray(img);
end

img_vec = img(:); % vectorize image, reading mat column by column

% plot orginal image and hist (8 bits resolution --> 256 bins)
fig1 = figure();
subplot(2,3,1); imshow(img); title('Original image')

% hist not recomm. anymore, histogram instead, same result if using im instead of im_vector
subplot(2,3,4); hist = histogram(img_vec, L); title('Hist 8bits original')
xlabel('Gray scale intensity') 
ylabel('# Pixels') 

% simulate low-contrast image
a = 0.2; b = 50; % values of function for reducing dynamic range of image
low_con_img_vec = min(max(round(a .* img_vec + b),0), L-1); % reduce dynamic range
low_con_img = reshape(low_con_img_vec, [size(img,1), size(img,2)]); % reshape to mat

% plot low-contrast image and its histogram
subplot(2,3,2); imshow(low_con_img); title('Low-contrast image')

subplot(2,3,5); hist_low_con = histogram(low_con_img_vec, L); title('Hist 8bits low-contrast')
xlabel('Gray scale intensity') 
ylabel('# Pixels') 

% histogram equalization alg. to the contrast-reduced image from sec 3.3.1 
[counts,s,eq_im] = histequalization(low_con_img, L);

% plotting equalized image and its histogram
subplot(2,3,3); imshow(eq_im); title('Equalized image')

subplot(2,3,6); hist_eq = histogram(eq_im, L); title('Hist 8bits equalized')
xlabel('Gray scale intensity') 
ylabel('# Pixels')

pause

%% ==================== Part 2: Image denoising ====================
% Add salt noise
im_saltp = img;
p0 = .05; p1 = .05;
n = mynoisegen('saltpepper', size(img,1), size(img,2), p0, p1);
im_saltp(n==0) = 0;
im_saltp(n==1) = L-1;

% Add Gaussian noise
im_gauss = img;
mean_g = 0; 
variance_g = 64;
im_gauss = double(im_gauss) + mynoisegen('gaussian', size(img,1), size(img,2), mean_g, variance_g);

% Image, noise and corresponding hist
fig2 = figure();
subplot(2,3,1); imshow(img); title('Original Image')
subplot(2,3,2); imshow(im_saltp); title('Image with Salt Noise')
subplot(2,3,3); imshow(uint8(im_gauss)); title('Image with Gaussian Noise')
subplot(2,3,4); histogram(img); title('Histogram of Original Image');
subplot(2,3,5); histogram(im_saltp); title('Histogram of Image with Salt Noise');
subplot(2,3,6); histogram(im_gauss); title('Histogram of Image with Gaussian Noise');

% Mean and Median filter 
filter_size = 3;
mean_gauss = meanfilt(im_gauss,[filter_size,filter_size]);
mean_saltp = meanfilt(im_saltp,[filter_size,filter_size]);
med_gauss = medfilt(im_gauss,filter_size,filter_size);
med_saltp = medfilt(im_saltp,filter_size,filter_size);

pause

fig3 = figure();
subplot(2,4,1); imshow(img); title('Original Image')
subplot(2,4,2); imshow(im_saltp); title('Image with Salt Noise')
subplot(2,4,3); imshow(uint8(mean_saltp)); title('3x3 Mean filter On Salt')
subplot(2,4,4); imshow(uint8(med_saltp)); title('3x3 Median filter On Salt')
subplot(2,4,5); histogram(img); title('Histogram of Original Image');
subplot(2,4,6); histogram(im_saltp); title('Histogram of Image with Salt Noise');
subplot(2,4,7); histogram(mean_saltp); title('Histogram of Mean filter On Salt');
subplot(2,4,8); histogram(med_saltp); title('Histogram of Median filter On Salt');

pause

fig4 = figure();
subplot(2,4,1); imshow(img); title('Original Image')
subplot(2,4,2); imshow(uint8(im_gauss)); title('Image with Gaussian Noise')
subplot(2,4,3); imshow(uint8(mean_gauss)); title('3x3 Mean filter On Gaussian')
subplot(2,4,4); imshow(uint8(med_gauss)); title('3x3 Median filter On Gaussian')
subplot(2,4,5); histogram(img); title('Histogram of Original Image');
subplot(2,4,6); histogram(im_gauss); title('Histogram of Image with Gaussian Noise');
subplot(2,4,7); histogram(mean_gauss); title('Histogram of Mean filter On Gaussian');
subplot(2,4,8); histogram(med_gauss); title('Histogram of Median filter On Gaussian');

pause

%% Evaluation for filtered noisy images (changing input with mean__saltp,med_saltp,mean_gauss and med_gauss)
% ssim_filt = ssim(img,uint8(mean_saltp));
% mse_filt = mse(img,uint8(mean_saltp));
% psnr_filt = psnr(img,uint8(mean_saltp));
% wpsnr_filt = WPSNR(img,uint8(mean_saltp));

%% ==================== Part 3: Frequency domain filtering ====================
% fourier transform and plotting of image and its log spectrum 
fig5 = figure(); 
subplot(2,3,1); imshow(img); title('Original image')

IMG = fft2(img);
subplot(2,3,2); showgrey(log(1 + abs(IMG))); title('FFT-2D spectra original image')

% degradation, fourier transform and plotting of Degraded image and its log spectrum
r = 8; % radius of guassian blur kernel
h = myblurgen('gaussian',r);
g = min(max(round(conv2(img, h, 'same')),0),L-1); % degradation fct -> g is quantized
subplot(2,3,4); imshow(uint8(g)); title('Degraded image')

G = fft2(g);
subplot(2,3,5); showgrey(log(1 + abs(G))); title('FFT-2D spectra degraded image')

% shifted versions of spectra
subplot(2,3,3); showgrey(log(1 + abs(fftshift(IMG)))); title('Shifted spectra original')
subplot(2,3,6); showgrey(log(1 + abs(fftshift(G)))); title('Shifted spectra degraded')

pause

%% various restoration approaches
%% inverse filtering
[h_inv,f_rec] = inversefilter(g, h);

fig6 = figure(); % plotting original image, degraded and reconstructed with different approaches
subplot(2,3,1); imshow(img); title('Original image')
subplot(2,3,4); imshow(uint8(g)); title('Degraded image')
subplot(2,3,2); showgrey(f_rec); title('Inverse filtering')

%% Modified Inverse Filtering
[W,H,T,t_rec] = modinverse(g,h);
subplot(2,3,5); showgrey(real(t_rec)); title('Mod. Inverse filtering')

%% Wiener filtering (make use of H computed before)
of = conv2(img, h, 'same'); % out of focus image (not quantized) for noise variance estimation
noise = g - of;
sn = sum( sum (noise - mean(mean(noise))).^2) / numel(g);
% sf = periodogram2(img); % estimation sf problems
[WIENER,w,w_rec] = wienerfilt(g,h,0.031); %best k is 0.031
subplot(2,3,3); showgrey(w_rec); title('Wiener filtering')

%% Constrained LS Filtering
[C,c,c_rec] = leastsquares(g,h,0.6); %best gamma is 0.6 for lena
subplot(2,3,6); showgrey(c_rec); title('Constrained LS filtering')

%% Evaluation for reconstructed images (changing input with f_rec,t_rec,w_rec and c_rec)
ssim_rec = ssim(img,uint8(w_rec));
mse_rec = mse(img,uint8(w_rec));
psnr_rec = psnr(img,uint8(w_rec));
wpsnr_rec = WPSNR(img,uint8(w_rec));
