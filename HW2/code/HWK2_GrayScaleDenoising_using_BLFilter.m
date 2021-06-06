function HWK2_GrayScaleDenoising_using_BLFilter()
  clc,close all
  
% GrayScale image Bilateral filtering 
  im_noisy = im2double(imread('../images/NoisyGrayImage.png'));matlab -softwareopengl
  fprintf('The image size is is: %d.\n', size(im_noisy));
  
% Compute the noise variance
%  patch = imcrop(im_noisy,[50 50 100 100]);

% Identify a patch that has uniform intensity
% Use the intensity variance of this patch to identify sigma_r
  sigma_s = 6.7; % You need to supply this value
  sigma_r = 0.4; % You need to supply this value
  %
  [im_blf,im_glpf] = gray_bilateral_filter(im_noisy,sigma_r,sigma_s);

% Display the noisy image, the result of bilateral filtering
% Use MATLAB's imshow() to display the image
% Use MATLAB's subplot() function if necessary
%
figure
  subplot(3,1,1)
  imshow(im_noisy, [], 'InitialMagnification','fit')
  title('Original Image')
  
  subplot(3,1,2)
  imshow(im_glpf, [])
  title('Gaussian Filtering')

  subplot(3,1,3)
  imshow(im_blf, [])
  title('Bilateral Filtering')
 
figure
  imshow(im_blf, [])
  title('Bilateral Filtering')
  
  %subplot(2,2,4), imshow(patch, [])
  %title('Intensity Noise Variance')
  
end