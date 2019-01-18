% function S_bar = weight(S_bar,Psi,outlier)
%           S_bar(t)            4XM
%           outlier             1Xn
%           Psi(t)              1XnXM
% Outputs: 
%           S_bar(t)            4XM
function S_bar = weight(S_bar,Psi,outlier)
% FILL IN HERE
    psinon=Psi(1,find(~outlier),:);
    p=prod(psinon,2);
    p=p/sum(p);
    S_bar(4,:) = p;
%BE CAREFUL TO NORMALIZE THE FINAL WEIGHTS

end
