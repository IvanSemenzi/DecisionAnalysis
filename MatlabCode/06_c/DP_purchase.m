%% Purchasing with a deadline (see Bertsekas, Vol. I, Ch. 4, Sec. 4)

close all;
clear all;
clc;



%% Parameters

% Time horizon
T = 30;

% Model parameters
[F,H,pF,pH,NF,NH,NK]=DP_purchase_setup();



%% Compute Optimal Policy
[U, V, C] = DP_purchase_optimal_policy(T);



%% Simulate Optimal Policy (single run)

% State (i,j,k)=(Flight price, Hotel price, Already purchased or not)

% Generate initial prices at random
x0(1,1) = randsample([1:NF],1,true,pF);
x0(2,1) = randsample([1:NH],1,true,pH);

% Initially, we have not purchased yet
x0(3,1) = 1;

% Single run simulation
[x, u, gt] = DP_purchase_singlerun(T,U,x0);



%% Plot results
DP_purchase_plot(U,x,u);

