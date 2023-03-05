%function [x_bar,P_bar] = update_func(x,P,z,R,idx,ID)

% this function is to do the update part of EKF slam without outlier
% rejection
% 
% 
% input
% 
%   x - state vector                                 33x1
%   P - covariance of the state (sigma)             33x33
%   z - measurement                                   1x1
%   R - covariance of measurement                     1x1
%   idx - the index of this measurement               1x1
%   ID - the ID of the landmark (used for getting H)  1x1 
%   
%   output
%   
%   x_bar                                             33x1  
%   P_bar                                             33x33        

function [x_bar,P_bar] = update_func(x,P,z,R,idx)

[z_hat,h_hat] = observe_model(x,idx);

K = P* h_hat' * inv(h_hat * P * h_hat'+ R);

x_bar = x - K * (z_hat-z);
P_bar = (eye(33) - K * h_hat) * P;
end

