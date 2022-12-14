function [N_state,r,c,p,alpha]=DP_CR_setup()


%% Model parameters 

% N_state = number of possible wear states of the component (x=1 is lowest
% wear, ... , x=N_state is highest wear (replacement is mandatory))
%
% r is cost of replacement
%
% c is used to compute stage cost when no replacement occurs: g=c*x^2
%
% p is the probability of increasing the wear by one at t+1
% 1-p is the probability of not increasing the wear at t+1
%
% alpha is the discount factor for infinite horizon DP

% Number of states 
N_state=10;

% Replacement cost
r=100;

% Stage cost coefficient
c=2;

% Probability of increasing wear
p=0.8;

% Disount factor
alpha=0.97;
