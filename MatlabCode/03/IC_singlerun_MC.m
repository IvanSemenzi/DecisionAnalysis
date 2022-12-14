%% File name: IC_singlerun_MC.m

function [x, u, gt] = IC_singlerun_MC(T_max)



%% Parameters

% Maximum capacity
C=10;

% Demand distribution: w = 0,...,W_max
W_max = 4;
pW = [0.2 0.2 0.3 0.2 0.1]; % probabilities

% Stage cost
c1 = 10; % fixed cost for ordering
c2 = 2;  % unitary cost for holding stock

% Reorder if x below x_min
x_min=W_max;

% Markov chain state, possible values 0,1,...,C
XX = [0:C];

% Transition probability matrix
pWf=fliplr(pW); % flip probabilty vector
P1 = [zeros(x_min,C-x_min) repmat(pWf,x_min,1)];
for k=1:C-x_min+1
  P2(k,:) = [zeros(1,k-1) pWf zeros(1,C-x_min-k+1)];
end
P=[P1; P2];     



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



%% Main loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main loop %%%%%%%%%%%%%%%%%%%%%
%
% Initial inventory level (full)
x(1) = C;
for t=1:T_max

  % Save costs and inputs
  %
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

  % Select pmf of next state
  %
  % ATTENTION: 
  %                x(t) = 0,1...,C
  %   index of matrix P = 1,2,..,C+1
  %
  %   if x(t)=i -> take row i+1 of matrix P
  %
  r = P(x(t)+1,:);
  
  % Sample next state
  x(t+1) = randsample(XX, 1, true, r);
 
end



