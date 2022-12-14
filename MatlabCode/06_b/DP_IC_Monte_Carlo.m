%% Monte Carlo simulation

clear all
close all;
clc;



%% Parameters

% Number of simulation runs
Nrun=1000; 

% Length of each run
T=100; 

% Load some parameters defined in file DP_IC_setup.m:
%   max capcity (C), demand prob (pW), stage cost coeff. (cost), 
%   max demand (W_max) and possible demand values (W_set)
[pW,cost,C,W_max,W_set]=DP_IC_setup();



%% Initialization

% Inizialize matrices to store results of simulation runs
x_star=zeros(T+1,Nrun);
u_star=zeros(T,Nrun);
gt_star=zeros(T,Nrun);
w_star=zeros(T,Nrun);

x_h1=zeros(T+1,Nrun);
u_h1=zeros(T,Nrun);
gt_h1=zeros(T,Nrun);
w_h1=zeros(T,Nrun);

x_h2=zeros(T+1,Nrun);
u_h2=zeros(T,Nrun);
gt_h2=zeros(T,Nrun);
w_h2=zeros(T,Nrun);



%% Compute different policies: Optimal, Heuristic 1, Heuristic 2

% Optimal Policy
[U_star, V] = DP_IC_optimal_policy(T);


% Heuristic policy 1: when level below max demand, refill inventory
u1=[C:-1:C-W_max+1];
u2=zeros(1,C-W_max+1);
U_h1 = repmat([u1 u2]',1,T);

% Heuristic policy 2: when level below max demand, order minimum quantity 
% to ensure the fulfillment of the demand 
u1=[W_max:-1:1];
u2=zeros(1,C-W_max+1);
U_h2 = repmat([u1 u2]',1,T);



%% Main loop

% Initial state: full
x0=C;

for k=1:Nrun
  % Optimal policy
  [x_star(:,k), u_star(:,k), gt_star(:,k), w_star(:,k)] = DP_IC_singlerun(T,U_star,x0); 
  
  % Heuristic policy 1
  [x_h1(:,k), u_h1(:,k), gt_h1(:,k), w_h1(:,k)] = DP_IC_singlerun(T,U_h1,x0); 

  % Heuristic policy 1
  [x_h2(:,k), u_h2(:,k), gt_h2(:,k), w_h2(:,k)] = DP_IC_singlerun(T,U_h2,x0); 

end



%% Plot and write results 

% Some plots
[J_star, J_h1, J_h2] = DP_IC_plot(gt_star, gt_h1, gt_h2, Nrun, T);

% Write some results
disp(' ');
disp(['Time horizon T = ' num2str(T) ]);
disp(['Number of simulation runs = ' num2str(Nrun)])
disp(['Initial condition x0 = ' num2str(x0)])
disp(' ');
disp(['Optimal policy mu(x) = [' num2str(U_star(:,1)') ']''']);
disp(' ');
disp('********* Average total cost ***********' )
disp(['Optimal policy     = ' num2str(mean(J_star))]); 
disp(['Heuristic policy 1 = ' num2str(mean(J_h1))]); 
disp(['Heuristic policy 2 = ' num2str(mean(J_h2))]); 
disp(' ');
disp(['Expected optimal total cost from x0: V0(x0) = ' num2str(sum(V(end,1))) ] );
