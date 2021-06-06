function HWK6_DetectCircles()
  clc, close all
  clear all

  numCircles = 26;  % Number of circles we want to detect
  radius = 24;    % Radius of circles you are trying to detect 

  %% STEP 1. Select image
  im_rgb = im2double(imread('coloredChips.png'));
  if size(im_rgb,3) > 1 % If color convert to grayscale
    im_gray = im2double(rgb2gray(im_rgb));
  end

  % Display original image
  figure
    imshow(im_rgb, [], 'InitialMagnification', 'fit');
    title("Original Image");
    
  %% STEP 2. Threshold gradient or use Canny edge detector
  im_binary = edge(im_gray,'Canny', [0.05 0.15],'both');
  
  % Display edge image
  figure
    imshow(im_binary, [], 'InitialMagnification', 'fit');
    title("Edge Image")
   
  %% STEP 3. Build Hough Accumulator
  % WARNING: You need to complete this code
  [HS,a,b] = houghTransform_for_Circles(im_binary, radius);
    
  %% STEP 4. Detect local maxima in Hough Space
  % Use built-in function provided by MATLAB
  % does non-maximum suppression for you
  % Pick different thresholds...What do you see?
  P  = houghpeaks(HS,numCircles,'Threshold',2);  
  centers = [ P(:,2) , P(:,1) ]; % X,Y coordinates of circle centers

  % Display hough space image & overlay peaks
  figure
    imshow(imadjust(rescale(HS)),'XData',b,'YData',-a,'InitialMagnification','fit');
    xlabel('\theta'), ylabel('\rho');
    axis on, axis normal, hold on;
    title("Hough Space Image");
    
  %% STEP 5. Draw circles associated with peaks in Hough Space
  
  % Defining a vector of radii
  radius_vector = zeros(1, length(centers)) + radius;
  
  % Display circles associated with peaks in Hough Space
  figure
    imshow(im_rgb, [], 'InitialMagnification', 'fit');
    viscircles(centers, radius_vector);
    title("Circles Associated with Peaks in Hough Space");
  
  %% STEP 6. Find yellow circles
  
  yellow = zeros(4, 2);
  ctr = 1;
  
  for i = 1 : numCircles
      % Finding the centers of all circles
      center_i = centers(i, :);
      y = center_i(1, 1);
      x = center_i(1, 2);
      circle_color = [im_rgb(x, y, 1), im_rgb(x, y, 2), im_rgb(x, y, 3)];
      
      % Storing the centers of the yellow circles
      if (circle_color(1,1,1) > 0.97) && (circle_color(1,2,1) > 0.5) && (circle_color(1,3,1) < 0.25) 
          yellow(ctr, :) = [y, x];
          ctr = ctr + 1;
        
      end
  end
 
  % Defining a vector of yellow radii
  yellow_radius_vector = zeros(1, length(yellow)) + radius;
  
  % Display yellow circles
  figure
    imshow(im_rgb, [], 'InitialMagnification', 'fit');
    viscircles(yellow, yellow_radius_vector);
    title("Yellow Circles Image");
  
end