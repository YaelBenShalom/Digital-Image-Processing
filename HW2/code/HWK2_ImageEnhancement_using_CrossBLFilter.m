function HWK2_ImageEnhancement_using_CrossBLFilter()
  clc,close all
  
% Load images  
% -------------------
% No Flash image
  imRGB_noisy = im2double(imread('../images/NoFlash.png'));
  imLAB_noisy = rgb2lab(imRGB_noisy);
  
% Flash image
  imRGB_guide = im2double(imread('../images/WithFlash.png'));
  imLAB_guide = rgb2lab(imRGB_guide);
  
% Identify patch variance
% -------------------------------
% Find a patch in the image with near constant intensity
% Use the variance of this patch to identify sigma_r
  patch = imcrop(imLAB_guide,[1,1,50,50]);
  patchSq = patch.^2;
  edist = sqrt(sum(patchSq,3));
  patchStd = std2(edist);

% Denoise NoFlash image using Flash image and Cross Bilateral Filtering
  sigma_s = 1.2   % Spatial sigma
  sigma_r = 4*patchStd   % Intensity sigma
  % 
  imLAB_denoise = joint_bilateral_filter(imLAB_noisy,imLAB_guide,sigma_s,sigma_r);
  imRGB_denoise = lab2rgb(imLAB_denoise);
    
% Display outputs - No-flash image, Flash image, Result of Joint Bilateral
% filtering
  figure
    subplot(131),
    imshow(imRGB_noisy,[],'InitialMagnification','fit');
    title('No-flash image');
    %
    subplot(132),imshow(imRGB_guide,[],'InitialMagnification','fit');
    title('Flash image');
    %
    subplot(133),imshow(imRGB_denoise ,[],'InitialMagnification','fit'); 
    title('Joint Bilateral Filtering');

% Extract detail from Flash image using Bilateral Filtering
  sigma_s = 5.7;   % Spatial sigma
  sigma_r = 4*patchStd;   % Intensity sigma
  % 
  imLAB_blf = bilateral_filter(imLAB_guide,sigma_s,sigma_r);
  imRGB_blf = lab2rgb(imLAB_blf);
  
  imRGB_detail = imRGB_guide ./ imRGB_blf;
  imRGB_detail_disp = imRGB_detail - 0.5;
  % 
  
% Display outputs - Flash image, Result of Bilateral filtering, Detail
% component
  figure
    subplot(131),
    imshow( imRGB_guide, [],'InitialMagnification','fit');
    title('Flash Image');
    %
    subplot(132),imshow(imRGB_blf,[],'InitialMagnification','fit');
    title('Result of Bilateral filtering');
    %
    subplot(133),imshow(imRGB_detail_disp,[],'InitialMagnification','fit'); 
    title('Detail Component');
    
% Final result of enhancement  
  imRGB_composite = imRGB_denoise .* imRGB_detail;

% Display outputs - No Flash image, Flash image, Enhanced image  
  figure
    subplot(131),
    imshow(imRGB_noisy,[],'InitialMagnification','fit');
    title('No flash image');
    %
    subplot(132),imshow(imRGB_guide,[],'InitialMagnification','fit');
    title('Flash image');
    %
    subplot(133),imshow(imRGB_composite,[],'InitialMagnification','fit'); 
    title('Enhanced Image');
    
end