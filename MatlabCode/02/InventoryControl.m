%% File name: InventoryControl.m

%% Clean workspace

close all;
clear all;
clc;



%% Parameters

% Final simulation time
T_max = 100;

% Time horizon
T=[0:T_max-1]'; 



%% Initialization

% Inizialize matrices to store results of simulation runs
% Not necessary, but improves efficiency
x=zeros(T_max+1,1);
u=zeros(T_max,1);
gt=zeros(T_max,1);
w=zeros(T_max,1);



%% Single run simulation

% Simulate IC over t=0,...,T_max
% Dynamic system representation
[x, u, gt, w] = IC_singlerun(T_max);



%% Write results

% Write some results
disp(['        Time horizon T:  ' num2str(T_max) ]);
disp(' ');
disp(['            Total cost: ' num2str(sum(gt))]);
disp(['    First reorder time:    ' num2str(find(u,1)-1)]);
disp(['Total number of orders:   ' num2str(sum(u>0))]);



%% Figure 1: state

% Plot x vs. time
figure
hold on;
stairs([T; T_max],x,'LineWidth',2);
xlabel('t');
ylabel('x_t');
title('State (stock level)');
xlim([0 T_max])
grid;



%% Figure 2: input

% Plot u vs. time
figure
hold on;
bar(T,u);
xlabel('t');
ylabel('u_t');
title('Input (ordered quantity)');
xlim([0 T_max])
grid;



%% Figure 3: stage cost

% Plot gt vs. time
figure
hold on;
bar(T,gt);
xlabel('t');
ylabel('g_t');
title('Stage cost');
xlim([0 T_max])
grid;



%% Figure 4: total cost

% Plot J vs. time
figure
hold on;
area(T,cumsum(gt),'FaceColor','r');
xlabel('t');
ylabel('J');
title('Total cost');
xlim([0 T_max])
grid;
