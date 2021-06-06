function [Iend,Ipoll] = PMDiffusion(u,dt,Tend,Tpoll,K)
% Perona Malik diffusion equation
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Inputs: 
%   u: Initial image 
%   dt: time step
%   Tend: end time
%   Tpoll: times at which to poll
%   K: edge strength threshold
% 
% Output: Solution of the PM diffusion equation

    [m,n] = size(u);
    Ipoll = zeros(m,n,numel(Tpoll));
    counter = 1;
    
    for t = 0 : dt : Tend
        % Evaluating the gradient magnitude at each pixel (i, j)
        % Gmag = |grad(u_ij)|^2
        [Gmag, Gdir] = imgradient(u, 'central');
        
        % Evaluating the Perona-Malik diffusivity at pixel (i, j)
        G = exp((-K^(-2))*(Gmag.^2));
        
        % Computing the diffusivity at pixels (i+-1, j), (i, j+-1)
        G_n = G([2:m, m], :);
        G_s = G([1, 1:m - 1],:);
        G_e = G(:, [2:n, n]);
        G_w = G(:, [1, 1:n - 1]);
        
        % Computing the diffusivity at pixels (i+-1/2, j), (i, j+-1/2)
        G_n_half = (G_n + G)/2;
        G_s_half = (G_s + G)/2;
        G_e_half = (G_e + G)/2;
        G_w_half = (G_w + G)/2;

        % Computing the gradient magnitude at a pixel (i, j) in the diffusivity estimation
        U_n = u([2:m, m], :) - u ;
        U_s = u - u([1, 1:m - 1], :);
        U_e = u(:, [2:n, n]) - u ;
        U_w = u - u(:, [1, 1:n - 1]);
        
        % Updating the image
        u = u + dt * (G_n_half.*U_n - G_s_half.*U_s + G_e_half.*U_e - G_w_half.*U_w);

        % polling
        if abs(t - Tpoll(counter)) < 1e-8
            Ipoll(:, :, counter) = u;
            counter = counter + 1;
        end
    end
    
    % returning image
    Iend = u; 
    
end

