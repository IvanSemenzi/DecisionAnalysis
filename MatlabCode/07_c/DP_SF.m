%% The spider and the fly 

% Minimum-time problem [Bertsekas, Vol. I, Example 7.2.2]

close all;
clear all;
clc;



%% Parameters

% Number of positions on a ring
N_state=7;

% Possible states are (i,j), i,j=1,...,N_state
% i is fly position, j is spider position
%
% if i=j (fly has been caught) and system enters termination state S

% p is the probability of fly moving +/- 1 position (modulo N_state)
% 1-2*p is probability of remaining in the same position
%
% p must be < 0.5
p = 0.25;

% Try  (N_state=8,p=0.25),  (N_state=8,p=0.45), (N_state=10,p=0.45), (N_state=12,p=0.45), 
%     (N_state=14,p=0.45), (N_state=16,p=0.45), (N_state=18,p=0.45), (N_state=26,p=0.45)

% Matrices to store optimal policy and optimal value function

% uu(i,j) is optimal input when in state (i,j)
uu=zeros(N_state,N_state);

% vv(i,j) is optimal value function when starting from state (i,j)
vv=zeros(N_state,N_state);



%% Compute optimal policy

% Infinite horizon, with total cost

% Returns also U_aux and V_aux containing u and v at each iteration
[uu, vv, U_aux, V_aux] = DP_SF_optimal_policy(N_state,p);



%% Simulate optimal policy


% Initial state: (i,j)=(fly position, spider position)
% On opposite sides
x0(1) = round(N_state/2)+1;
x0(2) = 1;

% Single run simulation
[x, u, gt, T, max_it] = DP_SF_singlerun(uu,x0,N_state,p);

% Check if the spider has caught the fly
if max_it==1
  
  disp(' ' );
  disp(['Warning, simulation ended without fly being caught (reached Tmax = ' num2str(T) ')']);

else
  
  disp(' ' );
  disp(['Fly caught at time t = ' num2str(T)]);

end



%% Display results

% Visualize optimal policy (as a function of (i,j))
figure

% counterclockwise (green), stay put (red), clockwise (blue)
cmap=[0 0 1; 1 0 0; 0 1 0];
colormap(cmap);

% Add one row and one column to U since pcolor does not use last
% row and last column
xind=0.5+[0:N_state];
yind=0.5+[0:N_state];
pcolor(xind,yind,[uu uu(:,end); uu(end,:) -1]);  

% Labels, title, etc. 
title(['Optimal policy: counterclockwise (blue), stay put (red), clockwise (green)' ]);
xlabel('Spider position');
ylabel('Fly position');
xticks([1:N_state]);
yticks([1:N_state]);
set(gca,'FontSize',12);
axis equal

% Visualize optimal policy (as a function of i-j)
figure
hold on;

% Plot places on a ring as circles with different colors
R=20*N_state;
theta=linspace(pi/2,5/2*pi,N_state+1);
theta=flipdim(theta(2:end),2);
center(1,:) = R*cos(theta);
center(2,:) = R*sin(theta);

% counterclockwise (green), stay put (red), clockwise (blue)
colmu = ['b' 'r' 'g'];
r=2*N_state;
Npoints=5*r;
for k=1:N_state
  DP_SF_plot_circle(center(:,k),r,Npoints,colmu(uu(k,1)+2));
  text(center(1,k)-r,center(2,k)+r,num2str(k))
end
h=DP_SF_plot_circle(center(:,1),r,Npoints,colmu(uu(1,1)+2));

% Labels, title, etc.
set(h,'LineWidth',5)
tt=text(center(1,1)+r,center(2,1)+r,'Spider');
set(tt,'FontSize',12);
title(['Optimal move for all possible fly positions, when spider is in position 1:' sprintf('\n') 'counterclockwise (blue), stay put (red), clockwise (green)' ]);
ylim([-1.2*R 1.2*R]);
axis equal
set(gca,'FontSize',12);



%% Plot animation of a single run with optimal policy
DP_SF_animation(x,N_state,center,r,R,Npoints,T);

