function HWK3_ImageRestoration()

  im1 = im2double(imread('../images/Image1_Degraded.tiff'));
  sz_orig1 = size(im1)
  im2 = im2double(imread('../images/Image2_Degraaded.tiff'));
  sz_orig2 = size(im2)
  
  % Define the blur kernel
  sigma_b1 = 5; % I chose the value of sigma_b that gets the best results (visually)
  sigma_b2 = 6; % I chose the value of sigma_b that gets the best results (visually)

  filt_size1 = 2 * ceil( 3 * sigma_b1) + 1; % filter size
  filt_size2 = 2 * ceil( 3 * sigma_b2) + 1; % filter size
  PSF1 = fspecial('gaussian', filt_size1, sigma_b1);
  PSF2 = fspecial('gaussian', filt_size2, sigma_b2);
  
  % Compute the Laplacian mask of the image
  L1 = fspecial('laplacian', 0); % alpha = 0 - Shape of the Laplacian
  L2 = fspecial('laplacian', 1); % alpha = 1 - Shape of the Laplacian
  
  % The noise estimation
  N = 2 * (L2 - L1);
  
  im1_blurred = imfilter(im1, N);
  im2_blurred = imfilter(im2, N);
  
  sigma_n1 = 0;
  for i = 1:sz_orig1(1)
    for j = 1:sz_orig1(2)
      sigma_n_new1 = sigma_n1 + im1_blurred(i, j);
      sigma_n1 = sigma_n_new1;
    end
  end
  
  sigma_n2 = 0;
  for i = 1:sz_orig2(1)
    for j = 1:sz_orig2(2)
      sigma_n_new2 = sigma_n2 + im2_blurred(i, j);
      sigma_n2 = sigma_n_new2;
    end
  end  
  
  % Compute the variance of the noise
  sigma_n1 = 1/(36 * (sz_orig1(1) - 2) * (sz_orig1(2) - 2)) * sigma_n_new1;
  sigma_n2 = 1/(36 * (sz_orig2(1) - 2) * (sz_orig2(2) - 2)) * sigma_n_new2;

  noise_var1 = sqrt(sigma_n1);
  noise_var2 = sqrt(sigma_n2);
  
  % Restoration using estimate of the noise-to-signal-power ratio
  estimated_nsr1 = noise_var1 / var(im1(:));
  estimated_nsr2 = noise_var2 / var(im1(:));
   
  wnr1 = deconvwnr(im1, PSF1, estimated_nsr1);
  wnr2 = deconvwnr(im2, PSF2, estimated_nsr2);

 % Display results (original image, restored image)    
 figure
    subplot(121),
    imshow(im1, [])
    title("Original Image1");
    
    subplot(122),
    imshow(wnr1, [])
    title("Restored Image1");

  figure
    subplot(121),
    imshow(im2, [])
    title("Original Image2");
    
    subplot(122),
    imshow(wnr2, [])
    title("Restored Image2"); 
  
end