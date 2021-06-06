function HWK3_SuppressingMoire()
  clc,close all
  
  im = im2double(imread('../images/Moire_Example1.png'));
  sz_orig = size(im)

  % Zero-pad image
  im_zpad = kron([1,0;0,0],im);
  sz = size(im_zpad)
  
  % Multiply by (-1)^(X+Y) 
  [X,Y] = meshgrid(1:sz(2),1:sz(1));
  Pttrn = (-1).^(X+Y);
  
  % Compute Fourier Transform
  ft_im = fft2( Pttrn .* im_zpad );
  abs_ft_im = abs(ft_im);
  
  % Find peaks in Fourier domain
  HW = 5; % half-width of mask for finding nearest peak in Fourier modulus
  peak1 = [713,775]; 
  peak2 = [820,251]; % Row,Col
  center_freq(1,:) = find_nearest_peak(abs_ft_im,peak1,HW)-sz/2;
  center_freq(2,:) = -center_freq(1,:);   % Row,Col
  center_freq(3,:) = find_nearest_peak(abs_ft_im,peak2,HW)-sz/2;
  center_freq(4,:) = -center_freq(3,:);   % Row,Col
  figure
    imshow( log10(abs(ft_im)),[] )
    title('Fourier Domain Image Before Filtering') 
    axis on, hold on
  %
  for nn = 1:size(center_freq,1)
    plot(center_freq(nn,2)+sz(2)/2,center_freq(nn,1)+sz(1)/2,'r.');
  end  
  
  % Create notch filter centered at each of the peaks
  D0 = 20;
  [Xi,Eta] = meshgrid(1:sz(2),1:sz(1));
  ft_fltr = ones(sz);
  for nn = 1:size(center_freq,1)
    Xi_nn   = Xi-sz(2)/2-center_freq(nn,2);
    Eta_nn  = Eta-sz(1)/2-center_freq(nn,1);
    lcl_fltr = 1-exp( -1/D0^2 *(Xi_nn.^2+Eta_nn.^2) ) ;
    ft_fltr = ft_fltr .* lcl_fltr;
  end
  
  % Display results (original image, filtered image, difference image)
  figure
    imshow( ft_fltr,[] )
    title('Notch Filter Image') 
    axis on    
  %
  ft_fltrd_im = ft_im .* ft_fltr;
  figure
    imshow( log10(abs(ft_fltrd_im)),[] )
    title('Fourier Domain Image After Filtering') 
    axis on, hold on
  %
  im_fltrd = real(ifft2(ft_fltrd_im));
  im_fltrd = im_fltrd .* Pttrn;
  im_fltrd = im_fltrd(1:sz_orig(1),1:sz_orig(2));
  
  figure
    imshow(im, [])
    title('Original Image')
    
  figure
    imshow(im_fltrd, [])
    title('Filtered Image') 
    
  im_diff = im_fltrd - im;  
  figure
    imshow( im_diff, [] )
    title('Difference Image') 
    
end

% Find row,column coordinares of nearest intensity peak in image given
% candidate row,column coordinates of the peak
function rc_cntr = find_nearest_peak(inp_img,rc_cntr,HW)
  mask = zeros(size(inp_img));
  r_cntr = rc_cntr(1);
  c_cntr = rc_cntr(2);
  mask(r_cntr-HW:r_cntr+HW,c_cntr-HW:c_cntr+HW) = 1.0;
  inp_img = inp_img .* mask;
  [rp,cp] = find( inp_img == max(inp_img(:)) );
  rc_cntr = [rp,cp];
end