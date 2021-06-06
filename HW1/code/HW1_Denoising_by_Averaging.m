function HW1_Denoising_by_Averaging()

  clc,close all
  
% Original image
  im_original = double(imread('../images/sombrero-galaxy-original.tif'));

% Finding the largest and smalleHW1_HistogramEqualization_Part2()st intensities in the original image:
  fprintf('The largest intensity in the original image is: %d.\n', max(im_original(:)));
  fprintf('The smallest intensity in the original image is: %d.\n', min(im_original(:)));

% Generating noisy observations:
  im_noised = zeros([size(im_original), 100]);

  for i = 1:100
      im_noised(:, :, i) = (sqrt(16) * randn(size(im_original))) + 0 + im_original;
  end
  
% Denoising by averaging for the first 25 noisy images:
   im_ave_25 = zeros(size(im_original));
   for i = 1:25
       im_ave_25 = im_ave_25 + im_noised(:, :, i);
   end
   im_ave_25 = im_ave_25/25;

% Denoising by averaging for the first 50 noisy images:
   im_ave_50 = zeros(size(im_original));
   for i = 1:50
       im_ave_50 = im_ave_50 + im_noised(:, :, i);
   end
   im_ave_50 = im_ave_50/50;
   
 % Denoising by averaging for the first 100 noisy images:
   im_ave_100 = zeros(size(im_original));
   for i = 1:100
       im_ave_100 = im_ave_100 + im_noised(:, :, i);
   end
   im_ave_100 = im_ave_100/100;
   
   
% Assessing the quality of denoising:
    err_25 = im_original - im_ave_25;
    mse_25 = mean(err_25(:).^2);
    fprintf('The MSE for average of 25 images is: %5.3d.\n', mse_25);

    err_50 = im_original - im_ave_50;
    mse_50 = mean(err_50(:).^2);
    fprintf('The MSE for average of 50 images is: %5.3d.\n', mse_50);

    err_100 = im_original - im_ave_100;
    mse_100 = mean(err_100(:).^2);
    fprintf('The MSE for average of 100 images is: %5.3d.\n', mse_100);
    
% Display results:
  figure
    imshow( im_original,[] );
    title('Original Image')
  figure
    imshow( im_ave_25,[] );
    title('Denoised Image (Average of 25 Images)')
  figure
    imshow( im_ave_50,[] );
    title('Denoised Image (Average of 50 Images)')
  figure
    imshow( im_ave_100,[] );
    title('Denoised Image (Average of 100 Images)')

end

