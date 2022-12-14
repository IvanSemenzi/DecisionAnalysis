function [pW,cost,C,W_max,W_set]=DP_IC_setup()

%% Model parameters

% pW = row vector of demand probabilities
%       possible values of demand are 0,...,length(pW)-1
%
% cost = [c1 c2], stage cost gt = c1 + c2 * x_t
%
% C = maximum capacity
%

% Maximum capacity
C=10;

% Demand distribution: w = 0,...,W_max
W_max = 4;
W_set = [0:W_max]; % possible values

% Demand probability: p(w), w = 0,...,W_max
pW = [ 0.2 0.2 0.3 0.2 0.1]; % probabilities

% Stage cost
cost(1) = 10; % fixed cost for ordering
cost(2) = 2;  % unitary cost for holding stock



