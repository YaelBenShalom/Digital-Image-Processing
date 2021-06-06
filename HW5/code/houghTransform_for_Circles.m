function [houghSpace,a,b] = houghTransform_for_Circles(im,radius)
  %Define the hough space
  [nR,nC] = size(im);
  
  if nargin < 2
    error('ERROR: Need to provide radius.');
  else
    assert( radius < norm([nR,nC])/2,'ERROR: ' );
  end

    % The Hough Accumulator array for circles is parametrized by two
  % quantities: the center of each circle
  % The candidate centers could be anywhere in the image
  % Thus, the houghSpace must have size nR x nC
  
  %Find the "edge" pixels
  [edge_x, edge_y] = find(im);
  
  % Define Hough Parameter Space
  HS = zeros(nR, nC);
  a_vector = zeros(1,1);
  b_vector = zeros(1,1);
  
  % Angle parameter Used to create circles
  theta_max = 361;
  
  % Accumlate Hough votes
  for i = 1 : length(edge_x)
      for theta = 1 : theta_max
          a = round(edge_x(i) - radius * cosd(theta));
          b = round(edge_y(i) + radius * sind(theta));
          
          if (a > 0) && (b > 0) && (a <= nR-1) && (b <= nC-1)
              HS(a, b) = HS(a, b) + 1;
              a_vector(1, i) = a;
              b_vector(1, i) = b;
          end

      end
  end
  
  houghSpace = HS;
  a = a_vector;
  b = b_vector;
  
end