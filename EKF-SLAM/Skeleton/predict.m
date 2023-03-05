% function [mu_bar,sigma_bar] = predict(mu,sigma,u,Q)
% This function should perform the prediction step.
% Inputs:
%           mu(t-1)           33X1   
%           sigma(t-1)        33X33
%           u(t)              3X1
%           Q                 3X3
% Outputs:   
%           mu_bar(t)         33X1
%           sigma_bar(t)      33X33

function [mu_bar,sigma_bar] = predict(mu,sigma,u,Q)
        
        mu_bar = mu + u;
        
        mu_bar(3) = mod(mu_bar(3)+pi,2*pi)-pi;
        F = [eye(3),zeros(3,30)]; %%3x33
        G = eye(33) + F'*[0,0,-u(2);0,0,u(1);0,0,0]*F;
        sigma_bar = G * sigma * G' + F' * Q * F;
end