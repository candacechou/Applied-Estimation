% function u = find_odometry(mu,delta_D,delta_o,noise)
% This function should calculate the odometry information
% Inputs:
%      
%           delta_o:        1X1
%           delta_D:        1X1
%           mu:             33X1
%           Q               3x3
% Outputs:
%           u(t):           3X1
function u = find_odometry(mu,delta_D, delta_o,Q)
             u = zeros(33,1);
             
             u(1) = delta_D * cos(mu(3))+ rand() * Q(1,1);
             u(2) = delta_D * sin(mu(3)) + rand() * Q(2,2);
             u(3) = delta_o + rand()* Q(3,3);
             u(3) = mod(u(3)+pi,2*pi)-pi;
          
end