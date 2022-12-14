function [x, u, gt] = DP_CR_singlerun(T,U,x0)

%% Parameters and Initialization

% Load setup data: number of states (N_state), replacement cost (r),
% stage cost coefficient (c), probability of increasing wear (p),
% discount factor (alpha)
[N_state,r,c,p,alpha]=DP_CR_setup();


% State 
x=zeros(T+1,1);

% Stage cost
gt = zeros(T,1);

% Input
u = zeros(T,1);



%% Main loop 


% Initial wear level
x(1) = x0;

for t=1:T
  
  % Use policy stored in vector U
  u(t) = U(x(t));
  
  % Generate next wear level
  x(t+1)=DP_CR_f(x(t),u(t),p,N_state);
  
  % Compute stage cost, discounted by alpha
  %
  % NB. t=0,1,... and alpha^t in the slides  
  %     t=1,2,... and alpha^(t-1) in Matlab
  %
  gt(t) = alpha^(t-1) * DP_CR_stage_cost(x(t), u(t), r, c);
  
end
