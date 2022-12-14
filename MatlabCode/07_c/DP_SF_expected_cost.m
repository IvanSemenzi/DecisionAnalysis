function [ec]=DP_SF_expected_cost(ii,jj,u,V_curr,N_state,p);

%% Compute expected cost

% (ii,jj) is current state, u is current input, V_curr is a N_state x N_state
% matrix containing current approximation of value function 
%
% Assumption: ii~=jj (not caught yet)
%
% ec is the expected value of stage cost + value function

if ii==jj % should never occur
  
  disp('Warning: called expected_cost with ii=jj')
  
end



%% Expected value of stage cost 

% Stage cost is deterministic
esc = 1;



%% Expected value of cost-to-go

% Fly position: all possible next positions
if ii==1 % first pos 

  % Possible next pos
  x1_next(1,1) = N_state;
  x1_next(2,1) = 1;
  x1_next(3,1) = 2;
  
elseif ii==N_state % last pos
  
  % Possible next pos
  x1_next(1,1) = N_state-1;
  x1_next(2,1) = N_state;
  x1_next(3,1) = 1;
  
else % all other pos

  % Possible next pos
  x1_next(1,1) = ii-1;
  x1_next(2,1) = ii;
  x1_next(3,1) = ii+1;

end

% Corresponding probabilities
p_x1_next(1,1) = p;
p_x1_next(1,2) = 1-2*p;
p_x1_next(1,3) = p;

% Spider position   
x2_next = jj + u;
  
if x2_next==0 % wrap around
  
  x2_next=N_state;
  
elseif x2_next==N_state+1
  
  x2_next=1;
  
end


% Expected value
ev = 0;
for h=1:3
  ev = ev + p_x1_next(h)*V_curr(x1_next(h),x2_next);
end
  
% To avoid for loop, try
%ev = p_x1_next*V_curr(x1_next,x2_next);



%% Overall expected cost 

% Expected total cost is stage cost + expected cost-to-go
ec = esc + ev;
