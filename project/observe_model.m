%     function [z,H] = observe_model(x,j)
%     this function is used to do the observation
% 
%     Input:
% 
%     x - state vectors                      23x1
%     j - index of the landmarks (features)   1x1
%     
% 
%     Output:
% 
%     z - predicted observation               1X1
%     H - observation Jacobian                1X33
function [z,H] = observe_model(x,j)
idx = j-2; %%% this is the index of  the position of the landmark in state vector
z = sqrt((x(1)-x(idx))^2 + (x(2) - x(idx+1))^2);
H  = zeros(1,33);
H(idx) = -(x(1)-x(idx))/z;
H(idx+1) = -(x(2) - x(idx+1))/z;
H(1) = (x(1) - x(idx))/z;
H(2) = (x(2) - x(idx+1))/z;

end
   


%idx = 3 + j*3 - 2; %%% this is the index of  the position of the landmark in state vector
%   H= zeros(3, length(x));
%   
%   del_x = x(idx)-x(1);
%   del_y = x(idx+1)-x(2);
%   q = del_x^2 + del_y^2;
%   d = sqrt(q);
%   z =[ d;
%       atan2(del_y,del_x)-x(3);
%       x(idx+2)];
%   %%%
%   z(2) = mod(z(2)+pi,2*pi)-pi;
%   z(2) = 0;
%   
%   H(:,1:3) = [-del_x/d -del_y/d 0;
%                del_x/q del_y/q  -1;
%                0 0 0];
%            
%   H(:,idx-2:idx) = [del_x/d del_y/d 0 ;
%                    -del_y/q del_x/q 0 ;
%                    0 0 1];%%%