% function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate(S_bar,z,W,Lambda_psi,Q)
% FILL IN HERE
M = size(S_bar,2);
n = size(z,2);
N = size(W,2);
Psi = zeros(1,n,M);
zhat = zeros(2,M,n);
CLh = zeros(N,M,n);
for i=1:N
    zhat(:,:,i) = observation_model(S_bar,W,i);
    zhat(2,:,i) = mod(zhat(2,:,i)+pi,2*pi)-pi;
end
for i=1:n
    zrep = repmat(z(:,i),1,M);
    
    for k=1:N
        v = zrep - zhat(:,:,k);
        v(2,:) = mod(v(2,:)+pi,2*pi)-pi;
        D = -0.5 * v' * inv(Q) * v; 
        D = diag(D);
        x=(1/(2 * pi * det(Q)^0.5));
        Dx = x*exp(D);
        CLh(k,:,i) = Dx';
        
        
    end
  
   x = max(CLh(:,:,i),[],1);
   
   Psi(1,i,:) = x';
   
   outlier(i) = logical(mean(x) <= Lambda_psi);
end



    