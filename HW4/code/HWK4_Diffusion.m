function HWK4_Diffusion()
  clc,close all
  
% Step-1: Read images
% ~~~~~~~~~~~~~~~~~~~  
%   I0 = im2double(imread('cameraman.tif'));
  I0 = im2double(rgb2gray(imread('coloredChips.png')));
%   I0 = im2double(rgb2gray(imread('images/shapes_and_colors.png')));
%   I0 = im2double(rgb2gray(imread('images/Photo - Yeal Ben Shalom.jpg')));

  % Replace with 2 images of your choice
  % Explain why you picked these images
  
% Step-2: Diffusion
% ~~~~~~~~~~~~~~~~~
  % Setup diffusion parameters
  dt = 0.15;
  L = 12;
  Tpoll = (2.^(0:2:L-1)) * dt;  % Example
  Tend = Tpoll(end);            % Example
  
  % Implement diffusion  
  % Isotropic diffusion  
  [I_IsoDiff, It_IsoDiff] = IsotropicDiffusion( I0,dt,Tend,Tpoll );  
  
  % Perona-Malik diffusion
  K = 0.05; % You need to pick this value
  [I_PMDiff, It_PMDiff] = PMDiffusion( I0,dt,Tend,Tpoll,K );

% Step-3: Compute edge maps of each image in It
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  I0_edge = edge(I0,'canny');
  I_IsoDiff_edge = edge(I_IsoDiff,'canny');
  I_PMDiff_edge = edge(I_PMDiff,'canny');

% Step-4: Display
% ~~~~~~~~~~~~~~~
  % Display original image
%   figure
%     subplot(2,1,1);
%     imshow( I0,[], 'InitialMagnification', 'fit' );
%     title('Original Image');
%     subplot(2,1,2);
%     imshow( I0_edge,[], 'InitialMagnification', 'fit' );
%     title('Original Image Edges');
%     
%     pause(0.5)
%     
  % Display filtered image - Isotropic Diffusion
  figure
    subplot(2,1,1);
    imshow( I_IsoDiff,[], 'InitialMagnification', 'fit' );
    title(sprintf('Final Isotropic Diffusion Image at time t=%f', Tend));
    subplot(2,1,2);
    imshow( I_IsoDiff_edge,[], 'InitialMagnification', 'fit' );
    title('Isotropic Diffusion Image Edges');
    
    pause(0.5)
    
  % Display filtered image - Perona-Malik Diffusion
  figure
    subplot(2,1,1);
    imshow( I_PMDiff,[],'InitialMagnification', 'fit' );
    title(sprintf('Final Perona-Malik Diffusion Image at time t=%f', Tend));
    subplot(2,1,2);
    imshow( I_PMDiff_edge, [], 'InitialMagnification', 'fit' );
    title(sprintf('Perona-Malik Diffusion Image Edges K=%f', K));    
    
    pause(0.5)
    
    
  % Display all intermediate images
%   figure(101)
%     set(gcf,'units','normalized','outerposition',[0 0 1 1]); % full-screen
%     % Single title
%     sgtitle('Result of Filtering by Isotropic Diffusion'); % Only in MATLAB R2018b
%     
%     pause(0.5)
%     
%   figure(201)
%     set(gcf,'units','normalized','outerposition',[0 0 1 1]); % full-screen
%     % Single title
%     sgtitle(sprintf('Result of Filtering by Perona-Malik Diffusion (K=%f)',K)); % Only in MATLAB R2018b
%     
%     pause(0.5)
%     
  figure(301)
    set(gcf,'units','normalized','outerposition',[0 0 1 1]); % full-screen
    % Single title
    sgtitle('Edge Maps of Filtered Images'); % Only in MATLAB R2018b
    
    pause(0.5)
    
  %
  numT = numel(Tpoll);
  
  for nitr = 1:numT
%     % Display intermediate images at different times 
%     figure(101)
%       subplot(2,numT,nitr);
%       imshow( It_IsoDiff(:,:,nitr),[],'InitialMagnification','fit' );
%       title(sprintf('t=%f',Tpoll(nitr)),'FontName','Courier New','FontSize',8);      
%     
%     % Display edge images at different times
%       subplot(2,numT,nitr+numT);
%       imshow( edge(It_IsoDiff(:,:,nitr),'canny'),[],'InitialMagnification','fit' );
%       title(sprintf('t=%f',Tpoll(nitr)),'FontName','Courier New','FontSize',8); 
%       
%       pause(0.5)
%       
%     % Display intermediate images at different times 
%     figure(201)
%       subplot(2,numT,nitr);
%       imshow( It_PMDiff(:,:,nitr),[],'InitialMagnification','fit' );
%       title(sprintf('t=%f',Tpoll(nitr)),'FontName','Courier New','FontSize',8);      
%     
%     % Display edge images at different times
%       subplot(2,numT,nitr+numT);
%       imshow( edge(It_PMDiff(:,:,nitr),'canny'),[],'InitialMagnification','fit' );
%       title(sprintf('t=%f',Tpoll(nitr)),'FontName','Courier New','FontSize',8);
%       
%       pause(0.5)
%       
%     % Display intermediate images at different times 
    figure(301)
      subplot(3,numT,nitr);
      imshow( edge(It_IsoDiff(:,:,nitr),'canny'),[],'InitialMagnification','fit' );
      title(sprintf('t=%f Isotropic Diffusion',Tpoll(nitr)),'FontName','Courier New','FontSize',8);      
    
    % Display edge images at different times
      subplot(3,numT,nitr+numT); 
      imshow( edge(It_PMDiff(:,:,nitr),'canny'),[],'InitialMagnification','fit' );
      title(sprintf('t=%f Perona-Malik Diffusion',Tpoll(nitr)),'FontName','Courier New','FontSize',8);      
      
      subplot(3,numT,nitr+numT+numT); 
      imshow( abs(edge(It_PMDiff(:,:,nitr),'canny') - edge(It_IsoDiff(:,:,nitr),'canny')),[],'InitialMagnification','fit' );
      title(sprintf('t=%f Difference image',Tpoll(nitr)),'FontName','Courier New','FontSize',8);
  end
end