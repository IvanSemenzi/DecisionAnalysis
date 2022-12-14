function [x, u, gt, W_real] = DP_IC_singlerun(T,U,x0)



%% Parameters and initialization

% Load some parameters defined in file DP_IC_setup.m:
%   max capcity (C), demand prob (pW), stage cost coeff. (cost), 
%   max demand (W_max) and possible demand values (W_set)
[pW,cost,C,W_max,W_set]=DP_IC_setup();

% State 
x=zeros(T+1,1);

% Stage cost
gt = zeros(T,1);

% Input
u = zeros(T,1);



%% Simulate stochastic demand

% Generate T i.i.d. realizations of demand (r.v. w)
W_real = randsample(W_set, T, true, pW);



%% Main loop 

% Initial inventory level (full)
x(1) = x0;
for t=1:T
  
  % Use policy stored in matrix U
  % N.B. State x is in row x+1 of matrix U
  u(t) = U(x(t)+1,t);
  
  % Generate next inventory level
  x(t+1)=x(t)+u(t)-W_real(t);
  
  % Compute stage cost
  gt(t) = DP_IC_stage_cost(x(t), u(t), cost);
  
end
