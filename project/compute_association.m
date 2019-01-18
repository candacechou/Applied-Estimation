function [nis]= compute_association(x,P,z,R,idx)



[zp,H]= observe_model(x, idx);
v= z-zp; 
v(2)= mod(v(2)+pi,2*pi)-pi;

S = H*P*H' + R; 
K = 
nis= v'*inv(S)*v;
end
