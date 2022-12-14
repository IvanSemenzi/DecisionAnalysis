function []=DP_SF_animation(x,N_state,center,r,R,Npoints,T)


%%%%%%%%%%%%%%%%%%%%%%%%% Single run results %%%%%%%%%%%%%%%%%%
% Animation
figure
hold on
% Initialize
for k=1:N_state
  hh(k)=DP_SF_plot_circle(center(:,k),r,Npoints,'w');
  text(center(1,k)-r,center(2,k)+r,num2str(k))
end
ylim([-1.2*R 1.2*R]);
axis equal
colormap jet;
set(gca,'FontSize',12);
% Automatically maximize figure window
%pause(.1)
%wh=get(handle(gcf),'JavaFrame');
%set(wh,'Maximized',1);
%pause(1);

for t=1:T
  title(['Fly (green) and spider (magenta) at time t=' num2str(t-1)])
  % Draw fly
  set(hh(x(t,1)),'FaceColor','g');
  % Draw spider
  set(hh(x(t,2)),'FaceColor','m');
  ylim([-1.2*R 1.2*R]);
  axis equal
  if t==1
      pause;
  else
      pause(1);
  end
  % Delete fly
  set(hh(x(t,1)),'FaceColor','w');
  % Delete spider
  set(hh(x(t,2)),'FaceColor','w');
end
title(['Caught at time t=' num2str(t-1)])
set(hh(x(t,1)),'FaceColor','k');
  
