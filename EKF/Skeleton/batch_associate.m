% function [c,outlier, nu_bar, H_bar] = batch_associate(mu_bar,sigma_bar,z,M,Lambda_m,Q)
% This function should perform the maximum likelihood association and outlier detection.
% Note that the bearing error lies in the interval [-pi,pi)
%           mu_bar(t)           3X1
%           sigma_bar(t)        3X3
%           Q                   2X2
%           z(t)                2Xn
%           M                   2XN
%           Lambda_m            1X1
% Outputs: 
%           c(t)                1Xn
%           outlier             1Xn
%           nu_bar(t)           2nX1
%           H_bar(t)            2nX3
function [c,outlier, nu_bar, H_bar] = batch_associate(mu_bar,sigma_bar,z,M,Lambda_m,Q)
% FILL IN HERE
n = size(z,2);
c = zeros(1,n);
outlier = zeros(1,n);
nu_bar = zeros(2*n,1);
H_bar = zeros(2*n,3);
for i=1:n
    [cE,outlierE,nu_bar_E,SE,HE ] =associate(mu_bar,sigma_bar,z(:,i),M,Lambda_m,Q);
    c(i) = cE;
    outlier(i) = outlierE;
    nu_bar_T = nu_bar_E(:,cE);
    nu_bar_T(2,:) = mod(nu_bar_T(2,:)+pi,2*pi)-pi;
    index = (i - 1) * 2 + 1;
    nu_bar(index:index+1,:) = nu_bar_T;
    H_bar(index:index+1,:) = HE(:,:,cE);
end
    
     
end