% BFILTER2 Two dimensional bilateral filtering.
%    This function implements 2-D bilateral filtering using
%    the method outlined in:
%
%       C. Tomasi and R. Manduchi. Bilateral Filtering for 
%       Gray and Color Images. In Proceedings of the IEEE 
%       International Conference on Computer Vision, 1998. 
%
%    B = bfilter2(A,W,SIGMA) performs 2-D bilateral filtering
%    for the grayscale or color image A. A should be a double
%    precision matrix of size NxMx1 or NxMx3 (i.e., grayscale
%    or color images, respectively) with normalized values in
%    the closed interval [0,1]. The half-size of the Gaussian
%    bilateral filter window is defined by W. The standard
%    deviations of the bilateral filter are given by SIGMA,
%    where the spatial-domain standard deviation is given by
%    SIGMA(1) and the intensity-domain standard deviation is
%    given by SIGMA(2).
%
% Douglas R. Lanman, Brown University, September 2006.
% dlanman@brown.edu, http://mesh.brown.edu/dlanman

% implementation from https://www.mathworks.com/matlabcentral/fileexchange/12191-bilateral-filtering

function [outpImg,outpImg_glpf] = bilateral_filter(inpImg, sigma_r, sigma_d)

% bilateral filter half-width
filt_size = 2*ceil(3*sigma_d) + 1;
w = floor(filt_size / 2);

% Pre-compute Gaussian domain weights.
[X,Y] = meshgrid(-w:w,-w:w);
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

%Create Gaussian filtered image
Gs = imgaussfilt(inpImg, sigma_d);

% Apply bilateral filter.
dim = size(inpImg);
B = zeros(dim);
for i = 1:dim(1)
   for j = 1:dim(2)
      
         % Extract local region.
         iMin = max(i-w,1);
         iMax = min(i+w,dim(1));
         jMin = max(j-w,1);
         jMax = min(j+w,dim(2));
         I = inpImg(iMin:iMax,jMin:jMax,:);
      
         % Compute Gaussian range weights.
         dL = I(:,:,1)-inpImg(i,j,1);
         da = I(:,:,2)-inpImg(i,j,2);
         db = I(:,:,3)-inpImg(i,j,3);
         H = exp(-(dL.^2+da.^2+db.^2)/(2*sigma_r^2));
      
         % Calculate bilateral filter response.
         F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
         norm_F = sum(F(:));
         B(i,j,1) = sum(sum(F.*I(:,:,1)))/norm_F;
         B(i,j,2) = sum(sum(F.*I(:,:,2)))/norm_F;
         B(i,j,3) = sum(sum(F.*I(:,:,3)))/norm_F;
                
   end
outpImg = B;
outpImg_glpf = Gs;
end