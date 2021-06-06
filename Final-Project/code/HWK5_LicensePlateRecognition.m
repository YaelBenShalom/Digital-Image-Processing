function HWK5_LicensePlateRecognition()
  clc; clear all;
  close all;
  
  % Load and binarize test image
  imgPlate_RGB = imread('LicensePlate_Custom.png');
  imgPlate_Gray = rgb2gray(imgPlate_RGB);

  % Specify ROI in image where you will search for the license plate
  % characters
  ROI_rows = [90 150]; 
  ROI_cols = [20 450];
  
  % Otsu thresholding
  [~,threshold] = my_GrayThresh(imgPlate_Gray); 
  
  % Convert gray-scale image to binary
  imgPlate_Bin = (imgPlate_Gray < threshold);

  % Display thesrholded image of license plate
  figure(2); 
    imshow(imgPlate_Bin);
    h = gca;
    h.Visible = 'On';
    title('The binarized image');
    
  % Load and binarize character templates
  letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  imLetterTemplates = cell(1, length(letters));
  figure(1); 
  
  for nLetter = 1:length(letters)
    imgLetter_RGB = imread(sprintf('Character_Templates/%s.png', letters(nLetter)));
    imgLetter_Gray = rgb2gray(imgLetter_RGB);
    
    % Binarise image....YOU NEED TO COMPLETE THIS !!
    imLetterTemplates{nLetter} = double(imgLetter_Gray < threshold);

    % Display
    subplot(6, 6, nLetter);
    imshow( imLetterTemplates{nLetter} );
  end % nLetter 
  sgtitle('Character Templates')
  
  % Instructions
  % imLetterTemplates{1} contains 62x62 image of character A
  % imLetterTemplates{2} contains 62x62 image of character B
  % and so forth
  
  i = 1;
  detected = zeros(size(imgPlate_Bin));
  
  % Detect each character by applyign a hit-miss transform
  for nLetter = 1:length(letters)
    % Structuring element for letter
    se_letter = imLetterTemplates{nLetter};
    
    % Structuring element for boundary of letter
    % Obtained by subtracting dilated version of template from template
    img_dilate5 = imdilate(se_letter, strel('square', 5));
    img_dilate3 = imdilate(se_letter, strel('square', 3));
    
    % Computing the difference of two dilated character templates
    se_boundary = img_dilate5 - img_dilate3;
    
    % Hit or Miss transform
    HoM_transform = bwhitmiss(imgPlate_Bin, se_letter, se_boundary);
    
    % Compute sum in ROI
    ROI_transform = HoM_transform(ROI_rows(1):ROI_rows(2), ROI_cols(1):ROI_cols(2));
    ROI_sum = sum(sum(ROI_transform));
    
    % Check if hit
    if ROI_sum > 0
      imdilate_letter = imdilate(HoM_transform, se_letter);
      fprintf('Detected character %s\n', letters(nLetter));
      
      % Display result of dilating output of hit-miss 
      subplot(4, 2, i)
      imshow(imdilate_letter);
      title(sprintf('Detected Character %s',letters(nLetter)));
      detected = detected + imdilate_letter;
      i = i + 1;
    end
    
    subplot(4, 2, i)
    imshow(detected);
    title('All Detected Characters');
  end % nLetter
  
end