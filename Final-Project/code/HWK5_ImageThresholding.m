function HWK5_ImageThresholding()
  clc; clear all;
  close all;
  
  % Load image
  I = imread('iceberg.tif');
  [width, height] = size(I);
  figure, imshow(I);
  title('Original image');

  % Display histogram
  histImage = imhist(I);
  figure, bar(histImage);
  title('Image Histogram');

  % Binarize image
  [binImage,k] = my_GrayThresh(I);

  % Display binarized image
  figure, imshow(binImage);
  title('Binarized image');
  
  % Display threshold histogram
  histImage = imhist(I);
  figure, bar(histImage);
  title('Image Histogram with Threshold'); hold on
  plot([k, k], [0 max(histImage)], 'r'); hold off

  % Compare your threshold to MATLAB's threshold
  T = graythresh(I);
  Matlab_threshold = imbinarize(I,T);
  figure, imshow(Matlab_threshold);
  title('MATLAB Otsu Threshold');
  
  % Printing images threshold and mean
  fprintf('My Otsu threshold %f\n', k);
  fprintf('MATLAB Otsu threshold %f\n', 255*T);
  fprintf('MATLAB Otsu threshold %f\n', mean(I(:)));

end
