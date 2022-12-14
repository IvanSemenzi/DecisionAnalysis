function [x, u, gt] = DP_purchase_singlerun(T,U,x0)

%% Parameters and Initialization

% Load setup data
[F,H,pF,pH,NF,NH,~]=DP_purchase_setup();

% State x(:,t)=(i,j,k), i=1:NF, j=1:NH, k=1:NK
x=zeros(3,T+1); 

% Stage cost
gt = zeros(1,T);

% Input
u = zeros(1,T);


%% Main loop 

% Initial state
x(:,1) = x0;

for t=1:T
  
  % Use policy stored in 4D array U to select best input
  % U(i,j,k,t) is optimal input if state is (i,j,k) at time t
  u(t) = U(x(1,t),x(2,t),x(3,t),t);
  
  % Generate next state (flight ticket and hotel room prices)
  x(1,t+1) = randsample([1:NF],1,true,pF);
  x(2,t+1) = randsample([1:NH],1,true,pH);

  if u(t)==1 % if wait, third component of the state is unchanged
    
    x(3,t+1) = x(3,t);
    
  else % if buy, third component of the state becomes 2
    
    x(3,t+1) = 2;
    
  end
 
  % Compute stage cost
  gt(t) = DP_purchase_stage_cost(x(:,t),u(t),F,H);
  
end
