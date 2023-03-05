% function [c,outlier, nu, S, H] = associate(mu_bar,sigma_bar,z_i,M,Lambda_m,Q)
% This function should perform the maximum likelihood association and outlier detection.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           Q                   2X2
%           z_i(t)              2X1
%           M                   2XN
%           Lambda_m            1X1
% Outputs: 
%           c(t)                1X1
%           outlier             1X1
%           nu^i(t)             2XN
%           S^i(t)              2X2XN
%           H^i(t)              2X3XN
function [c,outlier, nu, S, H] = associate(mu_bar,sigma_bar,z_i,M,Lambda_m,Q)
% FILL IN HERE
   N = size(M,2);
   H = zeros(2,3,N);
   S = zeros(2,2,N);
   nu = zeros(2,N);
   D_M = zeros(1,N)';
   phi = zeros(1,N);
   
    for i= 1:N
        z_hat = observation_model(mu_bar,M,i);
        H(:,:,i) = jacobian_observation_model(mu_bar,M,i,z_hat,1);
        S(:,:,i) = H(:,:,i)*sigma_bar*H(:,:,i)' + Q;
        nu(:,i) = z_i-z_hat;
        nu(2,i) = mod(nu(2,i)+pi,2*pi)-pi;
        D_M(i) = (nu(:,i)'/S(:,:,i)) * nu(:,i);
        phi(i) = det(2*pi*S(:,:,i)).^(-(1/2)) * exp(-(1/2) * D_M(i));
    end
    c = find(phi == max(phi));
    outlier = logical(D_M(c) >= Lambda_m);
end