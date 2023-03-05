%%%% case 1
%%%% plotting ground truth
figure(1)
plot (Gesling1_GT(:,3), Gesling1_GT(:,2),'r');
axis([-20,70,-20,120]);
grid;
xlabel('y position(m)')
ylabel('x position(m)')
hold on, axis equal;
plot(Gesling1_TL(:,3),Gesling1_TL(:,2),'b*');
title('Ground Truth of Gesling1')
%%%% plotting dead reckoning
figure(2)
plot (Gesling1_DRp(:,3), Gesling1_DRp(:,2),'k');
axis([-20,70,-20,120]);
grid;
xlabel('y position(m)')
ylabel('x position(m)')
hold on, axis equal;
plot(Gesling1_TL(:,3),Gesling1_TL(:,2),'b*');
title('Dead Reconing of Gesling1')

%%%% case 2

figure(3)
plot (Gesling3_GT(1:11412,3), Gesling3_GT(1:11412,2),'r');
axis([-20,70,-20,120]);
grid;
xlabel('y position(m)')
ylabel('x position(m)')
hold on, axis equal;
plot(Gesling3_TL(:,3),Gesling3_TL(:,2),'b*');
title('Ground Truth of Gesling3')
%%%% plotting dead reckoning
figure(4)
plot (Gesling3_DRp(1:11412,3), Gesling3_DRp(1:11412,2),'g');
axis([-20,70,-20,120]);
grid;
xlabel('y position(m)')
ylabel('x position(m)')
hold on, axis equal;
plot(Gesling3_TL(:,3),Gesling3_TL(:,2),'b*');
title('Dead Reconing of Gesling3')
