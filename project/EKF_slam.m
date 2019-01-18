function data = EKF_slam (Gesling1_DR,Gesling1_TD,Gesling1_TL, Gesling1_GT,time_count)

%%%%       Gesling1_DR : Odometry Input 
%%%%       Gesling1_TD : Measurement
%%%%       Gesling1_TL : Landmark actual position
%%%%       Gesling1_GT : Ground Truth

num_lm = size(Gesling1_TL,1);
%%%%%%% the area you can change
appro_loc_num = 20;
sigmaR = 0.9;
sigmaR1 = 0.9;
sigmaB = 5;
R_land = diag([sigmaR,sigmaR1,sigmaB]);  
R = 5;
%%% coeffifient for drift
K_ss = 0.0005;
K_sa = 0;
K_aa = 0.0001;
%%%%%
Q = diag([sigmaR,sigmaR1,0.01*pi/180]);
%   sigma 33x33
sigma = [eye(3)*0,zeros(3,30);zeros(30,3),eye(30)*1e10];

%%% setup plot 


%%% 1 plot true landmarks
fig = figure(1);
plot(Gesling1_TL(:,3),Gesling1_TL(:,2),'b*');
axis([-20,70,-20,120]);
hold on, axis equal; 
grid;
plot(Gesling1_GT(1:time_count,3),Gesling1_GT(1:time_count,2),'r');
xlabel('y position(m)')
ylabel('x position(m)')
title('EKF slam for range only data');
set(fig,'name','EKF slam for range only data');

%%%%% Initialization
count = 1;
x = zeros(33,1); %%% position;
x(1) = Gesling1_GT(1,2);
x(2) = Gesling1_GT(1,3);
x(3) = Gesling1_GT(1,4);

num_mark = size(Gesling1_TL,1);

%%% error
errorpose = [];
pperror = [];
count_mark = zeros(2,num_mark);
%%%% calculate how many time we meet a landmark
for i=1:num_mark
    count_mark(1,i) = Gesling1_TL(i,1);
    x(3+3*i,1) = Gesling1_TL(i,1);
    init_beacon(1,i) = Gesling1_TL(i,1);
end
%%%% store the circle for voting
voting = zeros(appro_loc_num,5,num_lm);
time1 = Gesling1_DR(:,1);
time2 = Gesling1_TD(:,1);
%%%% deal with the time

Gesling1_DR(:,1) = round(Gesling1_DR(:,1)*10)/10;
Gesling1_TD(:,1) = round(Gesling1_TD(:,1)*10)/10;
Gesling1_GT(:,1) = round(Gesling1_GT(:,1)*10)/10;

time = Gesling1_DR(2,1);
xx = [];
xxx = [];
pp = [];
xte = [];
%%%% main
a=0;
b=1;
while count < time_count
       count = count + 1;
       time = Gesling1_DR(count,1);
       
       if round((Gesling1_DR(count,1)-Gesling1_DR(count-1,1))*10)/10 == 0.1
           a = a+1;
           delta_D = Gesling1_DR(count,2);
           delta_o = Gesling1_DR(count,3);
       else
           %b = b+ 1
           round((Gesling1_DR(count,1)-Gesling1_DR(count-1,1))*10)/10 ;
           
           time = Gesling1_DR(count-1,1) + 0.1;
           count = count-1;
           delta_D = Gesling1_DR(count,2);
           delta_o = Gesling1_DR(count,3);
           count = count+1;
       end
       
    %%%% predict part
    
    u = find_odometry(x,delta_D,delta_o,Q);
    [x,sigma] = predict(x,sigma,u,Q);
    xx = [xx;x(1:2)'];
    
    %%%% find Q
    
     Q(1,1) = K_ss * abs(delta_D * cos(x(3)));
     Q(2,2) = K_ss * abs(delta_D * sin(x(3)));
     Q(3,3) = K_sa * abs(delta_D) + K_aa * abs(delta_o);
%     
    
    %%%% receive the measurement or not 
%     
     meindex = find(Gesling1_TD(:,1) == time); %%% measurement index
     
     if ~meindex
         continue
     else
         for i = 1:size(meindex)
             
             [~,idx] = find(count_mark(1,:) == Gesling1_TD(meindex(i),3));
             
             count_mark(2,idx) = count_mark(2,idx)+1;
             %%% adjust range
             range = adjust_range(Gesling1_TD(meindex(i),2),Gesling1_TD(meindex(i),4));
             if count_mark(2,idx) <= appro_loc_num
                 voting(count_mark(2,idx),1,idx) = x(1);
                 voting(count_mark(2,idx),2,idx) = x(2);
                 voting(count_mark(2,idx),3,idx) = range;
                 voting(count_mark(2,idx),4,idx) = Gesling1_TD(meindex(i),2); %% ID
                 voting(count_mark(2,idx),5,idx) = x(3); %% heading angle
                 
                 if count_mark(2,idx) == appro_loc_num
                     Gesling1_TD(meindex(i),3);
                     count_mark(1,idx);
                     [xpos,ypos]= observation_appropos(voting,idx,R_land);
                     x(3+3*idx-2) = xpos;
                     x(3+3*idx-1) = ypos;
                     init_beacon(2,idx) = xpos;
                     init_beacon(3,idx) = ypos;
                     [bx,by] = find(Gesling1_TL == count_mark(1,idx));
                     pperror = [pperror;Gesling1_TD(meindex(i),3), xpos - Gesling1_TL(bx,2),ypos - Gesling1_TL(bx,3)];
                     pp = [pp;Gesling1_TD(meindex(i),3),xpos,ypos];
                 end
             else
                 [j,~] = find(x == count_mark(1,idx));
                 [ppi,ppj] = find(pp == count_mark(1,idx));
                 [bx,by] = find(Gesling1_TL == count_mark(1,idx));
                 %z = Gesling1_TD(meindex(i),4);
                 [x,sigma] = update_func(x,sigma,range,R,j);
                 pp(ppi,2) = x(j-2);
                 pp(ppi,3) = x(j-1);
                 pperror(ppi,2) = x(j-2) - Gesling1_TL(bx,2);
                 pperror(ppi,3) = x(j-1) - Gesling1_TL(bx,3);
                 
                 
                 
                 
                 
               end
           end
     end
     
 xxx=[xxx;x(1:3)'];
 gtindex = find(Gesling1_GT(:,1) == time);
 errorpose = [errorpose;x(1:3)'- Gesling1_GT(gtindex,2:4)];
 
 xtefoo =sqrt((Gesling1_GT(gtindex,2)-x(1)).^2 + (Gesling1_GT(gtindex,3)-x(2)).^2);
 xte = [xte;xtefoo];
end   
 %%%% CALCULATE ERROR
 
 %%%% 1. mean  error
 mex = mean(errorpose(:,1));
 mey = mean(errorpose(:,2));
 metheta = mean(errorpose(:,3));
 mexb = mean(pperror(:,2));
 meyb = mean(pperror(:,3));
 %%%% 2. abs mean square error
 amsex = mean(abs(errorpose(:,1)));
 amsey = mean(abs(errorpose(:,2)));
 amsetheta = mean(abs(errorpose(:,3)));
 amsexb = mean(abs(pperror(:,2)));
 amseyb = mean(abs(pperror(:,3)));
 display(sprintf(' mean error(x, y, theta)=(%f, %f, %f)\n mean absolute error=(%f, %f, %f)',mex,mey,metheta, amsex,amsey,amsetheta));
 display(sprintf(' mean error of beacon(x,y)=(%f, %f)\n mean absolute error of beacon (%f, %f)',mexb,meyb,amsexb,amseyb));
 display(sprintf(' xte(mean,max,min)  = (%f,%f,%f)',mean(xte),max(xte),min(xte)));
    plot(pp(:,3),pp(:,2),'r*');
    %plot(init_beacon(2,:),init_beacon(3,:),'g*');
    
    plot(xxx(:,2),xxx(:,1),'k');
    plot(xx(:,2),xx(:,1),'b');
    legend('actual beacons','ground truth','estimated beacons','estimated path');
 
    %pp(:,2:3)
   %%%% plot error
    figure(2);
    clf;
    subplot(3,1,1);
    plot(errorpose(:,1));
    title(sprintf('error on x, mean error=%f, mean absolute err=%f',mex,amsex));
    subplot(3,1,2);
    plot(errorpose(2,:));
    title(sprintf('error on y, mean error=%f, mean absolute err=%f',mey,amsey));
    subplot(3,1,3);
    plot(errorpose(3,:));
    title(sprintf('error on theta, mean error=%f, mean absolute err=%f',metheta,amsetheta));
   %%%%  error beacon
   %%%% beacon only
   figure(3);
   clf;
   plot(Gesling1_TL(:,3),Gesling1_TL(:,2),'b*');
   xlabel('y position(m)')
   ylabel('x position(m)')
   title('EKF slam for estimated beacons');
   hold on,axis equal;
   plot(pp(:,3),pp(:,2),'r*');
   legend('Actual Beacons','Estimated Beacons');

   grid;
   
   
end

                   
                     
                       
                     
                 
                 
                 
      
                        
         
    
    
    
    
    
