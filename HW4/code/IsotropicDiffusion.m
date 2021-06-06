function [Iend,Ipoll] = IsotropicDiffusion(I0,dt,Tend,Tpoll)
% Isotropic heat equation
% ~~~~~~~~~~~~~~~~~~~~~~~
% Inputs: 
%   I0: Initial image 
%   dt: time step
%   Tend: end time
%   Tpoll: times at which to poll 
% 
% Output: Solution of the Isotropic diffusion equation (aka Heat Equation)

  [m,n] = size(I0);
  Ipoll = zeros(m,n,numel(Tpoll));
  
  K = 1; % Assumes constant conductivity
  
  %Initialize
  u = I0;
  %
  ctr = 1;
  for t = 0 : dt : Tend
    u_xx = u(:,[2:n,n]) - 2*u + u(:,[1,1:n-1]);   % 2nd derivaative in X direction
    u_yy = u([2:m,m],:) - 2*u + u([1,1:m-1],:);   % 2nd derivative in Y direction
    
    u = u + K * dt * (u_xx + u_yy);               % Isotropic diffusion
    
    % Intermediate images
    if abs(t-Tpoll(ctr)) < 1e-8
      Ipoll(:,:,ctr) = u;
      ctr = ctr + 1;
    end
  end
  
  % Final image
  Iend = u;
end

