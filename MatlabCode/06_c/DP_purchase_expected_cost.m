function [ec]=DP_purchase_expected_cost(x,u,V_next);

%% Expected cost

% (x(1),x(2),x(3)) = (i',j',k') is current state, u is current input,
% V_next(i,j,k) contains value function at next time for state (i,j,k)
% 
%
% ec is the expected value of stage cost + value function
%



%% Parameters

% Load setup data
[F,H,pF,pH,NF,NH,NK]=DP_purchase_setup();



%% Expected value of stage cost 

% Stage cost is deterministic
esc = DP_purchase_stage_cost(x,u,F,H);



%% Expected value of cost-to-go 

% Consider all possible next states
%
% If u=1 (wait), prob of next state being (i,j,k) is
%
%    P(i,j,k) = pF(i) * pH(j) if current state is (*,*,k)
%    P(i,j,k) = 0             if current state is (*,*,~=k)
%
% If u=2 (buy), prob of next state being (i,j,k) is
%
%    P(i,j,k) = pF(i) * pH(j) if k=2
%    P(i,j,k) = 0             if k=1
%


if u==1 % wait
  
  for i=1:NF
    for j=1:NH
      for k=1:NK
      
        % Probability of next state being (i,j,k)
        
        if k==x(3) % third component of current state

          % here k = k'
          P(i,j,k) = pF(i)*pH(j);
          
        else
          
          % here k ~= k'
          P(i,j,k) = 0;
          
        end
        
    
      end % k
    end % j
  end % i 
  
else % u=2, decide to buy
  
  % Probability of next state being (i,j,k)

  % k must be 2, so probability of (i,j,k) is 0 if k=1
  P(:,:,1) = zeros(NF,NH);

  for i=1:NF
    for j=1:NH
      
      P(i,j,2) = pF(i)*pH(j);

      
    end % j
  end % i
  
end


% Compute expected values: sum V_next at all possible next states
% (i,j,k), weighted by the corrsponding probability
ev=0;
for i=1:NF
  for j=1:NH
    for k=1:NK
       ev=ev+P(i,j,k)*V_next(i,j,k);
    end
  end
end



%% Note to adanced user

% If V(:,:,:,T+1) is initialized to a big, *BUT FINITE* value, then
% one can compute ev by element-by-element multipication of 3D arrays P
% and V_next, and then summing up
%
%ev=sum(sum(sum(P.*V_next)));



%% Expected cost

% Expected cost is expected stage cost + expected cost-to-go
ec = esc + ev;

