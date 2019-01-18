% function [xpos,ypos]= observation_appropos(lmmatrix,idx)
% this function should find the approximate position of landmarks when it
% appear three times
% Inputs:
%           lmmatrix          5x3x10 (10 : number of landmarks)  
%           idx               1x1
%           Q_Lm              3x3 (noise of landmark)

% lmatrix(:,:,idx) = [x1,y1,r1,ID,heading angle;
%                     x2,y2,r2,ID,heading angle;
%                     x3,y3,r3,ID,heading angle;
%                     x4,y4,r4,ID,heading angle;]
%      
% Outputs:   
%           xpos              1X1
%           ypos              1x1
%           



function [xpos,ypos]= observation_appropos(lmmatrix,idx,Q_Lm)
k = 100;
g = 0;
smap = 121 * k;
kmap = 121 * k;
maps = zeros(kmap,smap);
land = lmmatrix(:,:,idx);
[w,h] = size(land);
for i=1:w
    ID = land(i,4);
    
    if ID == 0
        
        angle = land(i,5);
        angle = angle * 180 / pi;
        %angle = 180 - angle;
%          phi1 = atan(55/45.7)* 180 / pi;
% %         
%          land(i,1) = land(i,1) + 0.01 * sqrt(55^2+45.7^2)*sin(degtorad(phi1));
%          land(i,2) = land(i,2) + 0.01 * sqrt(55^2+45.7^2)*cos(degtorad(phi1));
%         
        
        for a = angle - g : 5 : angle + 90 + g
            an = degtorad(a);
           
                for l = -Q_Lm(3,3):0.1:Q_Lm(3,3)
                cx1 = land(i,1) + (land(i,3)+l)*cos(an)+1;
                cy1 = land(i,2) + (land(i,3)+l)*sin(an)+1;
              
            
            if round(cx1*k) > 0 && round(cy1*k) > 0 && round(cx1*k) <= size(maps,1) && round(cy1*k)<= size(maps,2)
                maps(round(cx1*k),round(cy1*k)) = maps(round(cx1*k),round(cy1*k)) + 1;
            end
          end
            
        end
        
    elseif ID == 1
        
        angle = land(i,5);
        angle = angle * 180/pi;
        
        for a = angle+90 - g :5:angle + 180 + g
            an = degtorad(a);
           
%             
            for l = -Q_Lm(3,3):0.1:Q_Lm(3,3)
                cx1 = land(i,1) + (land(i,3)+l)*cos(an)+1;
                cy1 = land(i,2) + (land(i,3)+l)*sin(an)+1;
            if round(cx1*k) > 0 && round(cy1*k) > 0 && round(cx1*k)<= size(maps,1) && round(cy1*k)<=size(maps,2)
            maps(round(cx1*k),round(cy1*k)) = maps(round(cx1*k),round(cy1*k)) + 1;
            end
            end
            
        end
            
    elseif ID == 2
        
        angle = land(i,5);
        angle = angle * 180/pi;
        
        for a = angle+180 - g: 5 : angle + 270 + g
            
            an = degtorad(a);
            %land(i,3) = land(i,3) + sqrt(2.43^2 + 0.368^2);
%             cx = land(i,1) +  (land(i,3) + rand() * Q_Lm(3,3)) * cos(an) + 1;
%             cy = land(i,2) +  (land(i,3) + rand() * Q_Lm(3,3)) * sin(an) + 1;
%             
%             if round(cx*k) > 0 && round(cy*k) > 0  && round(cx*k) <= size(maps,1) && round(cy*k)<= size(maps,2)
%             maps(round(cx*k),round(cy*k)) = maps(round(cx*k),round(cy*k)) + 2;
%             end
%             
%             cx1 = cx + rand() * Q_Lm(1,1);
%             cy1 = cy + rand() * Q_Lm(2,2);
%             
%            
%            if round(cx1*k) > 0 && round(cy1*k) > 0 && round(cx1*k)<= size(maps,1) && round(cy1*k)<=size(maps,2)
%             maps(round(cx1*k),round(cy1*k)) = maps(round(cx1*k),round(cy1*k)) + 1;
%            end
%             
%             cx1 = cx - rand() * Q_Lm(1,1);
%             cy1 = cy - rand() * Q_Lm(2,2);
            for l = -Q_Lm(3,3):0.1:Q_Lm(3,3)
                cx1 = land(i,1) + (land(i,3)+l)*cos(an)+1;
                cy1 = land(i,2) + (land(i,3)+l)*sin(an)+1;
            if round(cx1*k) > 0 && round(cy1*k) > 0 && round(cx1*k)<= size(maps,1) && round(cy1*k)<=size(maps,2)
            maps(round(cx1*k),round(cy1*k)) = maps(round(cx1*k),round(cy1*k)) + 1;
            end
            end
        end
    elseif ID == 3
        
         angle = land(i,5);
         angle = angle * 180/pi;
         %angle = 180 - angle;
%          phi1 = atan(55/45.7)* 180 / pi; 
%          land(i,1) = land(i,1) + 0.01 * sqrt(55^2+45.7^2)* sin(degtorad(phi1));
%          land(i,2) = land(i,2) - 0.01 * sqrt(55^2+45.7^2)* cos(degtorad(phi1));
        for a = angle+270-g:5:angle+360+g
            
            an = degtorad(a);
            %land(i,3) = land(i,3) + sqrt(0.457^2 + 0.55^2);
%             cx = land(i,1) +  (land(i,3) + rand() * Q_Lm(3,3)) * cos(an) + 1;
%             cy = land(i,2) +  (land(i,3) + rand() * Q_Lm(3,3)) * sin(an) + 1;
%             
%             if round(cx*k) > 0 && round(cy*k) > 0 && round(cx*k) <= size(maps,1) && round(cy*k)<= size(maps,2)
%             maps(round(cx*k),round(cy*k)) = maps(round(cx*k),round(cy*k)) + 2;
%             end
%             
%             cx1 = cx + rand() * Q_Lm(1,1);
%             cy1 = cy + rand() * Q_Lm(2,2);
%             
%            if round(cx1*k) > 0 && round(cy1*k) > 0 && round(cx1*k) <= size(maps,1) && round(cy1*k)<=size(maps,2)
%             
%                maps(round(cx1*k),round(cy1*k)) = maps(round(cx1*k),round(cy1*k)) + 1;
%            end
%             
%             cx1 = cx - rand() * Q_Lm(1,1);
%             cy1 = cy - rand() * Q_Lm(2,2);
            for l = -Q_Lm(3,3):0.1:Q_Lm(3,3)
                cx1 = land(i,1) + (land(i,3)+l)*cos(an)+1;
                cy1 = land(i,2) + (land(i,3)+l)*sin(an)+1;
            
            if round(cx1*k) > 0 && round(cy1*k) > 0 && round(cx1*k)<= size(maps,1) && round(cy1*k)<=size(maps,2)
            maps(round(cx1*k),round(cy1*k)) = maps(round(cx1*k),round(cy1*k)) + 1;
            end
            end
        end
    end
end
[xp,yp]=find(maps == max(maps(:)));
if size(xp,1)~=1
    mindiff = 1e10;
    for i=1:size(xp)
        diff = 0;
        
        for j=1:w
            cx = land(j,1);
            cy = land(j,2);
            r = land(j,3);
            diff = diff + abs(sqrt((xp(i)-1-cx)^2+(yp(i)-1-cy)^2)-r);
           
        end
        if diff < mindiff 
            mindiff = diff;
            xpos = xp(i,1);
            ypos = yp(i,1);
        end
    end
else
    xpos = xp ;
    ypos = yp ;
end
 xpos = xpos/k - 1;
 ypos = ypos/k - 1;
 
    
% dx = 0:1:120;
% dy = 0:1:120;
% [x,y] = meshgrid(dx,dy);
% [w,h,d]=size(lmmatrix);
% z = x.* y * 0;
% for i=1:w
%     cx = lmmatrix(i,1,idx);
%     cy = lmmatrix(i,2,idx);
%     r = lmmatrix(i,3,idx);
%     z = z + (abs(sqrt((x - cx).^2 + (y - cy).^2) - r) < (rand() * Q_Lm(3,3)).^2);
%    %viscircles([cx,cy],r);
%     %hold on
% end
%   
% [xp,yp]=find(z == max(z(:)));
% %figure
% %contourf(z);
% mindiff = 100000;
% if size(xp,1)~=1
%     for i=1:size(xp)
%         diff = 0;
%         for j=1:w
%             cx = lmmatrix(j,1,idx);
%             cy = lmmatrix(j,2,idx);
%             r = lmmatrix(j,3,idx);
%             diff = diff + sqrt((xp(i)-cx)^2+(yp(i)-cy)^2)-r^2;
%            
%         end
%         if diff < mindiff 
%             mindiff = diff;
%             xpos = xp(i,1);
%             ypos = yp(i,1);
%         end
%     end
% else
%     xpos = xp ;
%     ypos = yp ;
% end
%  xpos = xpos + rand() * Q_Lm(1,1);
%  ypos = ypos + rand() * Q_Lm(2,2);
 
end
        