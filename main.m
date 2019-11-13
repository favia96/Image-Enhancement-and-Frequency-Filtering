clc;clear
addpath(genpath('E:\KTH\P2\Image Processing\Project1'))
%% Add image Noise
img=imread('E:\KTH\P2\Image Processing\Project1\images\lena512.bmp');
% Add salt noise
im_saltp = img;
n = mynoisegen('saltpepper', 512, 512, .05, .05);
im_saltp(n==0) = 0;
im_saltp(n==1) = 255;
% Add Gaussian noise
im_gauss = img;
im_gauss = double(im_gauss)+mynoisegen('gaussian', 512, 512, 0, 64);
%Image, noise and corresponding hist
figure;
subplot(2,3,1); imshow(img); title('Original Image')
subplot(2,3,2); imshow(im_saltp); title('Image with Salt Noise')
subplot(2,3,3); imshow(uint8(im_gauss)); title('Image with Gaussian Noise')
subplot(2,3,4); histogram(img); title('Histogram of Original Image');
subplot(2,3,5); histogram(im_saltp); title('Histogram of Image with Salt Noise');
subplot(2,3,6); histogram(im_gauss); title('Histogram of Image with Gaussian Noise');
%% Mean and Median filter
mean_gauss=meanfilt(im_gauss,[3,3]);
mean_saltp=meanfilt(im_saltp,[3,3]);
med_gauss=medfilt(im_gauss,3,3);
med_saltp=medfilt(im_saltp,3,3);
figure;
subplot(2,4,1); imshow(img); title('Original Image')
subplot(2,4,2); imshow(im_saltp); title('Image with Salt Noise')
subplot(2,4,3); imshow(uint8(mean_saltp)); title('3x3 Mean filter On Salt')
subplot(2,4,4); imshow(uint8(med_saltp)); title('3x3 Median filter On Salt')
subplot(2,4,5); histogram(img); title('Histogram of Original Image');
subplot(2,4,6); histogram(im_saltp); title('Histogram of Image with Salt Noise');
subplot(2,4,7); histogram(mean_saltp); title('Histogram of Mean filter On Salt');
subplot(2,4,8); histogram(med_saltp); title('Histogram of Median filter On Salt');
figure;
subplot(2,4,1); imshow(img); title('Original Image')
subplot(2,4,2); imshow(uint8(im_gauss)); title('Image with Gaussian Noise')
subplot(2,4,3); imshow(uint8(mean_gauss)); title('3x3 Mean filter On Gaussian')
subplot(2,4,4); imshow(uint8(med_gauss)); title('3x3 Median filter On Gaussian')
subplot(2,4,5); histogram(img); title('Histogram of Original Image');
subplot(2,4,6); histogram(im_gauss); title('Histogram of Image with Gaussian Noise');
subplot(2,4,7); histogram(mean_gauss); title('Histogram of Mean filter On Gaussian');
subplot(2,4,8); histogram(med_gauss); title('Histogram of Median filter On Gaussian');
%% Evaluation
ssim_gauss=ssim(img,uint8(im_gauss));
mse_gauss=mse(img,uint8(im_gauss));
psnr_gauss=psnr(img,uint8(im_gauss));
wpsnr_gauss=WPSNR(img,uint8(im_gauss));