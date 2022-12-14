function [ec]=DP_CR_expected_cost(x,u,V_curr)

%% Compute expected cost

% x is current state, u is current input, V_next is a column vector
% containing current approximation of value function 
%
% ec is the expected value of stage cost + alpha * value function



%% Parameters and Initialization

% Load setup data: number of states (N_state), replacement cost (r),
% stage cost coefficient (c), probability of increasing wear (p),
% discount factor (alpha)
[N_state,r,c,p,alpha]=DP_CR_setup();



%% Expected value of stage cost 

% Stage cost is deterministic
esc = DP_CR_stage_cost(x,u,r,c);



%% Expected value of cost-to-go 


if u==1 % replace
  
  % Next state (with probability 1)
  x_next = 1;
  
  % Expected value
  ev = alpha*V_curr(x_next);
  
else % do not replace
  
  % Check that x~=n (if x=n, then u should not be 2)
  if x==N_state
    
    disp(' ');
    disp('Warning, x=N_state and u=2');
    
  end
  
  % All possible next states are: x and x+1
  x_next(1,1) = x;
  x_next(1,2) = x+1;
  
  
  % Corresponding probabilities
  p_x_next(1,1) = 1-p;
  p_x_next(1,2) = p;

  
  % Expected value
  % NB. Do not forget discount factor alpha
  ev = 0;
  for h=1:2
    ev = ev + alpha*p_x_next(h)*V_curr(x_next(h));
  end
  
  % NOTE TO ADVANCED USER
  % To avoid for loop, try
  %ev = alpha*p_x_next*V_curr(x_next);
  
end



%% Overall expected cost

% Overall expected cost is stage cost + expected cost-to-go
ec = esc + ev;
