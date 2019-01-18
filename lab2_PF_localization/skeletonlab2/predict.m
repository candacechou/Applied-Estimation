% function [S_bar] = predict(S,u,R)
% This function should perform the prediction step of MCL
% Inputs:
%           S(t-1)              4XM
%           v(t)                1X1
%           omega(t)            1X1
%           R                   3X3
%           delta_t             1X1
% Outputs:
%           S_bar(t)            4XM
function [S_bar] = predict(S,v,omega,R,delta_t)
% FILL IN HERE
 sz = size(S,2);
 S(1,:) = S(1,:) + v * cos(S(3,:)) * delta_t + R(1,1) .* randn(1,sz);
 S(2,:) = S(2,:) + v * sin(S(3,:)) * delta_t + R(2,2) .* randn(1,sz) ;
 S(3,:) = S(3,:) + omega * delta_t + + R(3,3) .* randn(1,sz);
 S_bar = S;
 
end