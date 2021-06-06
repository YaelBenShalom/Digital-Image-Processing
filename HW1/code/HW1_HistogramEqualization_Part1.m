function HW1_HistogramEqualization_Part1()

  clc,close all
  
% Original image
  im_original = im2gray(imread('../images/Dark_Road.jpg'));
  disp(size(im_original));
  
  im_equalized = histeq(im_original);

% Display results:
  figure
    imshow( im_original,[] );
    title('Original Image')
  figure
    imhist(im_original);
    title('Original Image Histogram')
  figure
    imshow( im_equalized,[] );
    title('Equalized Image')
  figure
    imhist(im_equalized);
    title('Equalized Image Histogram')

end

