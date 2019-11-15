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
histeq(med_saltp);
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
ssim_gauss=ssim(img,uint8(w_rec));
mse_gauss=mse(img,uint8(w_rec));
psnr_gauss=psnr(img,uint8(w_rec));
wpsnr_gauss=WPSNR(img,uint8(w_rec));
%% Frequency filtering
% degradation, fourier transform and plotting of degradated image and its spectra
L=256;
r = 8; % radius of guassian blur kernel
h = myblurgen('gaussian',r);
g = min(max(round(conv2(img, h, 'same')),0),L-1);
subplot(3,2,1);
imshow(img);
title('Original image')

img_fourier = fft2(img);
subplot(3,2,3);
showfs(log(1+abs(img_fourier)));
title('FFT-2D spectra original image')
%pause

subplot(3,2,2);
imshow(uint8(g));
title('Degradated image')
 
g_fourier = fft2(g);
subplot(3,2,4);
showfs(log(1+abs(g_fourier)));
title('FFT-2D spectra degradated image')

%pause

subplot(3,2,5);
showfs(log(1+abs(fftshift(img_fourier))));
title('Shifted spectra')

subplot(3,2,6);
showfs(log(1+abs(fftshift(g_fourier))));
title('Shifted spectra')

%% inverse filtering
h_inv=1./h;
f_rec=conv2(g,h_inv,'same');
showgrey(f_rec);
%% Modified Inverse Filtering
B=zeros(size(h));
for i=0:size(B,1)-1
    for j=0:size(B,2)-1
        B(i+1,j+1)=1/(1+((i^2+j^2)*100)^3);
    end
end
T=B./fft2(h);
t_rec=conv2(g,ifft2(T),'same');
showgrey(real(t_rec));
%% Wiener filtering
H=fft2(h);
T=conj(H)./(abs(H).^2+0.03);
t=ifft2(T);
w_rec=conv2(g,t,'same');
showgrey(w_rec);
%% Constrained LS Filtering
p=[0 -1 0;-1 4 -1;0 -1 0];
P=fft2(p,size(h,1),size(h,2));
H=fft2(h);
C=conj(H)./(abs(H).^2+0.6*abs(P).^2);
c=ifft2(C);
c_rec=conv2(g,c,'same');
showgrey(c_rec);

