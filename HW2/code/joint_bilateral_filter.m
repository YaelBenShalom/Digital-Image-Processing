%bfilter2 function: perfrom two dimensional bilateral gaussian filtering.
%The standard deviations of the bilateral filter are given by sigma1 and
%sigma2, where the standard deviation of spatial-domain is given by sigma1
% and the standard deviation intensity-domain is given by sigma2.
%This function presents both bilateral filter and joint-bilateral filter.
%If you use the same image as image1 and image2, it is the normal bilateral
%filter; however, if you use different images in image1 and image2, you can
%use it as joint-bilateral filter, where the intensity-domain (range weight)
%calculations are performed using image2 and the spatial-domain (space weight)
%calculations are performed using image1.
%Usage:
%   %Example1: normal bilateral filter using 5x5 kernel, spatial-sigma=6, and
%   %intensity-sigma= 0.25:
%   image=bfilter2(I1,I1,5,1.2,0.25);
%   %Example2: joint-bilateral filter using 5x5 kernel, spatial-sigma=1.2,
%   %and range-sigma= 0.25, the spatial-domain calculations are performed
%   %using image (I1) and the intensity-domain calulcations (range weight)
%   %are performed using image (I2):
%   image=bfilter2(I1,I2,5,1.2,0.25);
%   %Example3: use the default values for n, sigma1, and sigma2
%   image=bfilter2(I1);
%Input:
%   -image1: the spatial-domain image
%   -image2: the intensity-domain (range weight) image (use the same image
%   for the normal bilateral filter. Use different images for joint-bilateral
%   filter.
%   (default, use the same image; i.e. image2=image1)
%   -n: kernel (window) size [nxn], should be odd number (default=5)
%   -sigma1: the standard deviation of spatial-domain (default=1.2)
%   sigma2: the standard deviation of intensity-domain (default=0.25)
%Author: Mahmoud Afifi, York University. 

% implementation from https://www.mathworks.com/matlabcentral/fileexchange/62455-joint-bilateral-filter


function outpImg = joint_bilateral_filter(inpImg, guideImg, sigma_r, sigma_d)
% Implements bilateral filtering for joint images.

% bilateral filter half-width
filt_size = 2*ceil(3*sigma_d) + 1;
n = filt_size; 
w=floor(n/2);

display('processing...');

% spatial-domain weights.
[X,Y] = meshgrid(-w:w,-w:w);
gs = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

%normalize images
if isa(inpImg,'uint8')==1
    inpImg=double(inpImg)/255;
end

if isa(guideImg,'uint8')==1
    guideImg=double(guideImg)/255;
end

%intialize img_out
img_out=zeros(size(inpImg,1),size(inpImg,2),size(inpImg,3));

%padd both iamges
inpImg=padarray(inpImg,[w w],'replicate','both');
guideImg=padarray(guideImg,[w w],'replicate','both');

for i=ceil(n/2):size(inpImg,1)-w
    for j=ceil(n/2):size(inpImg,2)-w
        patch1(:,:,:)=inpImg(i-w:i+w,j-w:j+w,:);
        patch2(:,:,:)=guideImg(i-w:i+w,j-w:j+w,:);
        d=(repmat(guideImg(i,j,:),[n,n])-patch2).^2;
        
        % intensity-domain weights. (range weights)
        gr=exp(-(d)/(2*sigma_r^2));
        for c=1:size(inpImg,3)
            g(:,:,c)=gs.*gr(:,:,c); %bilateral filter
            normfactor=1/sum(sum(g(:,:,c))); %normalization factor

            img_out(i-ceil(n/2)+1,j-ceil(n/2)+1,c)=...
                sum(sum(g(:,:,c).*patch1(:,:,c)))*normfactor;
        end
    end
end
outpImg = img_out;

end