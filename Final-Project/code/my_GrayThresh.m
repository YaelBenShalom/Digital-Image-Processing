function [binImage,kopt] = my_GrayThresh( inp_GrayImage )
  % Your implementation goes here

  [m,n] = size(inp_GrayImage);
  
  % Get histogram. hist(i) is the count of pixels with value x(i).
  hist = imhist(inp_GrayImage, 256)';
  normalized_hist = hist / sum(hist);
  
  % Convert to probability;
  P = zeros(size(hist));
  sigma_square_max = 0;
  
  for i = 1:256
      array_before_i = [1 : i];
      array_after_i = [i+1 : 256];
      
      % Compute the cumulative sums for all 𝑘∈0,𝐿−1
      P1 = sum(normalized_hist(1:i));
      P2 = 1 - P1;
  
      % Compute the means
      miu1 = (sum(array_before_i .* normalized_hist(1:i))) / P1;
      miu2 = (sum(array_after_i .* normalized_hist(i+1:end))) / P2;

      % Compute the inter-class variance
      sigma_square = P1 * P2 * ((miu1 - miu2)^2);
      
      % Find 𝑘∗ that maximizes 𝜎^2
      if (sigma_square >= sigma_square_max)
          sigma_square_max = sigma_square;
          k_star = i;
      end
 
  end
  
  % Threshold image
  inp_GrayImage(inp_GrayImage <= k_star) = 0;
  inp_GrayImage(inp_GrayImage > k_star) = 255;
  
  binImage = inp_GrayImage;
  kopt = k_star;
end