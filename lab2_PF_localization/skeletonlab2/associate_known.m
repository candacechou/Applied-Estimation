% function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
%           S_bar(t)            4XM
%           z(t)                2Xn
%           W                   2XN
%           Lambda_psi          1X1
%           Q                   2X2
%           known_associations  1Xn
% Outputs: 
%           outlier             1Xn
%           Psi(t)              1XnXM
function [outlier,Psi] = associate_known(S_bar,z,W,Lambda_psi,Q,known_associations)
% FILL IN HERE
    M=size(S_bar,2);%particles
    N=size(W,2);%landmarks
    n=size(z,2);%observations
    
    z_hat=zeros(2,M,N);
    v=zeros(size(z_hat));
    Psi=zeros(n,M);
    c=zeros(n,M);
    CLH=zeros(n,M,N);
    outlier=zeros(1,n);
    
    for j=1:N
        z_hat(:,:,j)=observation_model(S_bar,W,j);
    end
    for i=1:n
        for m=1:M
            for j=1:N
                v(:,m,j)=z(:,i)-z_hat(:,m,j);
                v(2,m,j)=mod(v(2,m,j)+pi,2*pi)-pi;
                D=(v(:,m,j)'*inv(Q))*v(:,m,j);
                CLH(i,m,j)=det(2*pi*Q).^(-1/2)*exp(-1/2*D);
            end
            k=find(CLH(i,m,:)==max(CLH(i,m,:)));
            c(i,m)=k(1);
            Psi(i,m)=CLH(i,m,known_associations(i));
            
        end
        Psi_bar=mean(Psi(i,:));
        outlier(i)=Psi_bar<=Lambda_psi;
    end
    Psi=reshape(Psi,[1 n M]);
end
      
        
       
        
        
%BE SURE THAT YOUR innovation 'nu' has its second component in [-pi, pi]

% also notice that you have to do something here even if you do not have to maximize the likelihood.

