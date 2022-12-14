%% File name: IC_singlerun.m

function [x, u, gt, W_real] = IC_singlerun(T_max)



%% Parameters

% Maximum capacity
C=10;

% Demand distribution: w = 0,...,W_max
W_max = 4;
WW = [0:W_max]; % possible values
pW = [ 0.2 0.2 0.3 0.2 0.1]; % probabilities

% Stage cost
c1 = 10; % fixed cost for ordering
c2 = 2;  % unitary cost for holding stock

% Reorder if x below x_min
x_min=W_max;



%% Initialization

%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%

% Inizialize vectors to store results of simulation 
% Not necessary, but improves efficiency

% State 
x=zeros(T_max+1,1);

% Stage cost
gt = zeros(T_max,1);

% Input
u = zeros(T_max,1);

% Demand
W_real = zeros(T_max,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Simulate the demand

% Generate T_max IID realizations of w
W_real = randsample(WW, T_max, true, pW);



%% Main loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main loop %%%%%%%%%%%%%%%%%%%%%
%
% Initial inventory level (full)
x(1) = C;

for t=1:T_max
  
  % Policy: reorder (up to C) if the level is below x_min
  if x(t) < x_min
    
    % Refill
    u(t) = C - x(t);
    
    % stage cost when ordering
    gt(t) = c1 + c2*x(t);
    
  else
    
    % Do not order
    u(t) = 0;
    
    % stage cost when not ordering
    gt(t) = c2*x(t);
    
  end
  
  %     Take: current stock level, current order, current demand
  % Generate:    next stock level
  x(t+1)=x(t)+u(t)-W_real(t);
  
end



