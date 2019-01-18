% function S = multinomial_resample(S_bar)
% This function performs systematic re-sampling
% Inputs:   
%           S_bar(t):       4XM
% Outputs:
%           S(t):           4XM
function S = multinomial_resample(S_bar)
% FILL IN HERE
    S = zeros(size(S_bar));
    M = size(S_bar,2);
    CDF =zeros(1,M);
    for m=1:M
        CDF(m) = sum(S_bar(4,1:m));
    end
    for m = 1:M
        Rm = abs(rand());
        i = find(CDF > Rm,1,'first');
        S(:,m)=S_bar(:,i);
        S(4,m) = 1/M;
    end
        
end
