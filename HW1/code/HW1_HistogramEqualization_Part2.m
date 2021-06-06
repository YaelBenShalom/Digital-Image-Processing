function HW1_HistogramEqualization_Part2()

  clc,close all
  
% Original image
  im_original = im2gray(imread('../images/Checkerboard.png'));
  disp(size(im_original));
  disp(max(im_original(:)));

  im_equalized = histeq(im_original);

% Display results:
  figure
    imshow( im_original );
    title('Original Image')
  figure
    imhist(im_original);
    xlim([-10, 265]);
    title('Original Image Histogram')
  figure
    imshow( im_equalized );
    title('Equalized Image')
  figure
    imhist(im_equalized);
    xlim([-10, 265]);
    title('Equalized Image Histogram')

end

