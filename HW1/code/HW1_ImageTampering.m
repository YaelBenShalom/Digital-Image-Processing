function HW1_ImageTampering()

  clc,close all
  
% Original image
  im_original = rgb2gray(imread('../images/starry-night-reference.jpg'));
  disp(size(im_original));
% Tampered image
  im_tampered = (generate_tampered_image(im_original));
  
  
% Generate difference image
    % without typecasting
  im_difference = abs(im_tampered - im_original);
  
    % with typecasting
  im_difference_typecasting = abs(double(im_tampered - im_original));

% Display results to detect evidence of tampering
  figure
    imshow( im_original,[] );
    title('Original Image')
  figure
    imshow( im_tampered,[] );
    title('Tampered Image')
  figure
    imshow( im_difference,[] );
    title('Difference Image Without Typecasting')
  figure
    imshow( im_difference_typecasting,[] );
    title('Difference Image With Typecasting')

end

