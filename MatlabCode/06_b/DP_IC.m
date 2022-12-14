%% Dynamic programming for inventory control (stochastic)

close all;
clear all;
clc;



%% Parameters and initialization

% Time horizon
%    slides: t = 0,...,T-1
%      code: t = 1,...,T
T = 100;

% Time horizon
TT=[1:T]'; 

% Load some parameters defined in file DP_IC_setup.m:
%   max capcity (C), demand prob (pW), stage cost coeff. (cost), 
%   max demand (W_max) and possible demand values (W_set)
[pW,cost,C,W_max,W_set]=DP_IC_setup();

% Number of states = C+1
N_state = C+1;

% Initializize some matrices to store results

% Matrix to store optimal policy 
% U(x,t) optimal input if in state x at time t
U=zeros(N_state,T);

% Optimal value functions (cost-to-go functions)
% V(x,t) cost-to-go if in state x at time t
V = zeros(N_state, T+1);



%% Compute Optimal Policy

[U, V] = DP_IC_optimal_policy(T);



%% Simulate Optimal Policy (1 run)

% Initial state: full
x0=C;

% Single run simulation
[x, u, gt, w] = DP_IC_singlerun(T,U,x0);



%% Display results

% Write some results
disp(' ');
disp(['Time horizon T = ' num2str(T) ]);
disp(' ');
disp(['Total cost = ' num2str(sum(gt))]); 
disp(['Expected total cost from x0 (value function V0(x0)) = ' num2str(sum(V(end,1)))]);
disp(['Average stage cost = ' num2str(mean(gt))]);
disp(['First reorder at time instant ' num2str(find(u,1)-1)]);
disp(['Average time between consecutive reorders ' num2str(mean(diff(find(u)))) ]);

% Plot x vs. time
hold on;
stairs([TT; T+1],x);
xlabel('time');
ylabel('x');
title('State (stock level)');
grid;


% Plot u vs. time
figure
hold on;
stairs(TT,u);
xlabel('time');
ylabel('u');
title('Input (ordered quantity)');
grid;

% Plot gt vs. time
figure
hold on;
bar(TT,gt);
xlabel('time');
ylabel('gt');
title('Stage cost');
xlim([0 T]);
grid;

% Plot J vs. time
figure
hold on;
area(TT,cumsum(gt),'FaceColor','r');
xlabel('time');
ylabel('J');
title('Total cost');
grid;
