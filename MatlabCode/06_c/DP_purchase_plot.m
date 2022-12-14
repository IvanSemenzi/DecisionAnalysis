function [] = DP_purchase_plot(U,x,u)

% Load setup data
[F,H,pF,pH,~,~,~]=DP_purchase_setup();

% Time horizon
T=size(U,4);

% Colormap
cmap=[1 0.1 0.1; 0 0 1; 0 1 0];
colormap(cmap) % used by pcolor 


% Animation with optimal policy
figure(1)
dF=F(2)-F(1);
dH=H(2)-H(1);
for t=1:T
  % Add one row and one column to U since pcolor does not use last
  % row and last column
  pcolor(-dH/2+[H H(end)+dH],-dF/2+[F F(end)+dF],[U(:,:,1,t) U(:,end,1,t); U(end,:,1,t) 1]);  
  title(['\mu_t^*(s) at t=' num2str(t) ': buy (green) or wait (red)' ]);
  %xticks(H)
  %yticks(F)
  axis equal
  xlabel('Hotel price');
  ylabel('Flight  price');
  set(gca,'FontSize',12)
  if t==1
      pause;
  else
      pause(0.5);
  end
end

% Plot optimal policy at 3 different time instants
II=[1 round(3*T/4) T-1];
for h=1:length(II)
  figure
  colormap(cmap) % used by pcolor 
  pcolor(-dH/2+[H H(end)+dH],-dF/2+[F F(end)+dF],[U(:,:,1,II(h)) U(:,end,1,II(h)); U(end,:,1,II(h)) 1]);  
  title(['\mu_t^*(s) at t=' num2str(II(h)) ': buy (green) or wait (red)' ]);
  %xticks(H)
  %yticks(F)
  axis equal
  xlabel('Hotel price');
  ylabel('Flight  price');
  set(gca,'FontSize',12)  
end


% Optimal policy is to buy if flight + hotel price is below a
% threshold. Try to find this threshold
for t=1:T
  clear ix iy;
  [ix,iy]=find(U(:,:,1,t)==2);
  threshold(t) = max(F(ix)+H(iy));
end

% Mean value of total cost
mc = pF*F'+pH*H';

figure;
hold on;
stairs([1:T],threshold,'b-','LineWidth',2);
plot([1 T],[mc mc],'r--','LineWidth',2);
legend('threshold','average price')
xlabel('time');
ylabel('Flight + Hotel price (EUR)');
title('Optimal threshold (blue)');
ylim([min(threshold)*0.9 min(threshold)*1.1])
axis([1 T F(1)+H(1) F(end)+H(end)])
grid;
set(gca,'FontSize',12)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State evolution
%
%
% Find when tickets have been purchased
to=find(u==2);
%
t1=[1:to];
t2=[to+1:T+1];

figure
hold on;

% Price evolution before purchasing
hh=area([t1; t1]',[F(x(1,t1)); H(x(2,t1))]');
set(hh(1),'FaceColor','g');
set(hh(2),'FaceColor','c');

% Stopped price evoloution
hh=area([t2-1; t2-1]',[F(x(1,to))*ones(size(t2)); H(x(2,to))*ones(size(t2))]');
set(hh(1),'FaceColor','g');
set(hh(2),'FaceColor','c');

% Mean total price
plot(threshold,'b--','LineWidth',2);

title('Flight + Hotel price, optimal threshold')
set(gca,'FontSize',12)
