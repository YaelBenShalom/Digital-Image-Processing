function HWK2_ColorImageFiltering_using_BLFilter()
  clc,close all
  
% Color image Bilateral filtering
% Compare wit result from MATLAB
  % convert to Lab space
  imRGB = im2double(imread('coloredChips.png'));
  imLAB = rgb2lab(imRGB);
  
% Find a patch in the image with near constant intensity
% Use the variance of this patch to identify sigma_r
% sigma_r = 2*std(patch)
  patch = imcrop(imLAB,[34,71,60,55]);
  patchSq = patch.^2;
  edist = sqrt(sum(patchSq,3));
  patchStd = std2(edist);
  patchVar = patchStd.^2;

% Attempt Bilateral Filtering using your implementation
  sigma_s = 7;                % Spatial sigma - You need to supply this value
  sigma_r = 4*patchStd;       % Intensity sigma - You need to supply this value
  % 
  [im_blf,im_glpf] = bilateral_filter(imLAB,sigma_r,sigma_s);
  im_blf = lab2rgb(im_blf);
  im_glpf = lab2rgb(im_glpf);

% Display output of your Bilateral filtering implementation
  figure
    subplot(131),
    imshow(imRGB,[],'InitialMagnification','fit');
    title('Original Image');
    %
    subplot(132),imshow(im_blf,[],'InitialMagnification','fit');
    title('Bilateral Filtering');
    %
    subplot(133),imshow(im_glpf,[],'InitialMagnification','fit'); 
    title('Gaussian LPF');

% MATLAB bilateral filter output   
  sigma_s = 7;        % Spatial sigma
  DoS = sigma_r^2;    % Intensity variance sigma_r^2
  %
  im_blf_MATLAB = imbilatfilt(imLAB,DoS,sigma_s);
  im_blf_MATLAB = lab2rgb(im_blf_MATLAB);
  
% Display difference between your implementation and MATLAB's  
  figure
    imshowpair( im_blf,im_blf_MATLAB,'diff' );
  title('Difference between my implementation & MATLAB');
    
end