% function u = calculate_odometry(e_l,e_R,E_T,B,delta_t,mu)
% This function should calculate the odometry information
% Inputs:
%           e_L(t):         1X1
%           e_R(t):         1X1
%           E_T:            1X1
%           B:              1X1
%           R_L:            1X1
%           R_R:            1X1
%           delta_t:        1X1
%           mu(t-1):        3X1
% Outputs:
%           u(t):           3X1
function u = calculate_odometry(e_R,e_L,E_T,B,R_R,R_L,delta_t,mu)
if ~delta_t
    u = [0;0;0];
    return;
end
 WRt = (2 * pi * e_R) / (E_T * delta_t);
 WLt = (2 * pi * e_L) / (E_T * delta_t);
 Wt = (WRt * R_R - WLt * R_L) / B;
 Vt = (WRt * R_R + WLt * R_L) / 2;
 u = [ Vt * delta_t * cos(mu(3));
       Vt * delta_t * sin(mu(3)); 
       Wt * delta_t ];

end