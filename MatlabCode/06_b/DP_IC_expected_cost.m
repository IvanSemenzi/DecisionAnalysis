function [ec]=DP_IC_expected_cost(s,u,V_next)

%% Compute expected cost

% s is current state, u is current input, V_next is a column vector 
% containing optimal value function at next time for all possible states
%
% ec is the expected value of stage cost + cost-to-go



%% Parameters

% Load some parameters defined in file DP_IC_setup.m:
%   max capcity (C), demand prob (pW), stage cost coeff. (cost), 
%   max demand (W_max) and possible demand values (W_set)
[pW,cost,~,~,W_set]=DP_IC_setup();

% Number of possible demand values
N_w = length(W_set);



%% Expected value of stage cost 

% Stage cost is deterministic E[g]=g
esc = DP_IC_stage_cost(s,u,cost);



%% Expected value of cost-to-go 

% Compute possible next states and corresponding probabilities
for l=1:N_w 
    
  % All possible next states
  x_next(l) = DP_IC_f(s,u,W_set(l));
  
  % Corresponding probabilities
  p_x_next(l) = pW(l);

end

% Compute expected value, 
% N.B. State x is in row x+1 of vector V_next
ev=0;
for h=1:N_w
  ev=ev+p_x_next(h)*V_next(x_next(h)+1);
end



%% Expected value of stage cost + cost-to-go

% Expected cost is stage cost + expected cost-to-go
ec = esc + ev;



%% Note to advanced user
% Alternative method for ecomputing expected value avoiding the "for" loop:
%ev2=p_x_next*V_next(x_next+1);
