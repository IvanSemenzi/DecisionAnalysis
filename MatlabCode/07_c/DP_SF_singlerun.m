function [x, u, gt, T, max_it] = DP_SF_singlerun(U,x0,N_state,p);


%% Parameters and Initialization 

%
% Upper bound on the number of steps
% In any case terminate simulation when t=Tmax (even if no caught yet)
Tmax = 100;

% State (fly pos, spider pos) 
x=zeros(Tmax+1,2);

% Flag: xE=1 (caught)
xE=0;

% Stage cost
gt = zeros(Tmax,1);

% Input
u = zeros(Tmax,1);


%% Main loop 

% Initial state
x(1,:) = x0;

t=0;
while xE==0 && t<Tmax
  
  t=t+1;
    
  % Use policy stored in matrix U to select best input
  % U(i,j) is optimal input if state is (i,j)
  u(t) = U(x(t,1),x(t,2));
  
  % Generate next state
  
  % Fly position
  if x(t,1)==1 % first position
    
    pF = [1-2*p p zeros(1,N_state-3) p];
    x(t+1,1) = randsample([1:N_state],1,true,pF); 
    
  elseif x(t,1)==N_state % last position

    pF = [p zeros(1,N_state-3) p 1-2*p];
    x(t+1,1) = randsample([1:N_state],1,true,pF);
    
  else % all other positions
    
    pF = [zeros(1,x(t,1)-2) p 1-2*p p zeros(1,N_state-x(t,1)-1)];
    x(t+1,1) = randsample([1:N_state],1,true,pF);
    
  end

  % Spider position   
  x(t+1,2) = x(t,2) + u(t);
  
  if x(t+1,2)==0 % wrap around
    
    x(t+1,2)=N_state;
    
  elseif x(t+1,2)==N_state+1
    
    x(t+1,2)=1;
    
  end
  
  % Compute stage cost
  gt(t) = 1;

  % Check if the spider has caught the fly
  if x(t+1,1)==x(t+1,2)
    
    % Set flag to 1
    xE=1;
    
  end
  
  
end % while


% Check why we have exited while loop
if xE==1 % Caught!
  
  % Capture time
  T=t;
  max_it=0; % No max it reached
  
else % Not caught
  
  T=t;
  max_it=1; % Max it reached
  
end
