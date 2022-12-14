function [uu, vv, U_aux, V_aux] = DP_CR_optimal_policy()

%% Compute optimal policy

% Compute optimal policy uu over INFINITE HORIZON
% and value function vv 
% 
% uu is a column vector whose x-th component contains optimal input
% when in state x  
%
% vv is a column vector whose x-th component contains optimal value
% function when starting from state x
%
% Returns also U_aux and V_aux containing u and v at each iteration
%



%% Parameters and Initialization

% Load setup data: number of states (N_state), replacement cost (r),
% stage cost coefficient (c), probability of increasing wear (p),
% discount factor (alpha)
[N_state,r,c,p,alpha]=DP_CR_setup();

% Initialization of useful data structures

% Optimal policy 
% uu = optimal input when in state x  
uu=zeros(N_state,1);

% Value function when starting from x
vv=zeros(N_state,1);

% Auxiliary matrices to store all approximations of u and V
U_aux=zeros(N_state,1); % will grow dynamically at each iteration
V_aux=zeros(N_state,1); % will grow dynamically at each iteration

% Temporary vectors (rewritten at each iteration)
U_tmp=zeros(N_state,1);
V_tmp=zeros(N_state,1);

% Possible inputs
N_u=2; 

% Auxiliary cost vector
C_aux=zeros(1, N_u);



%% Value iteration algorithm

% Value iteration  START

% 1. Initialization
V_aux = zeros(N_state,1); 

% 2. Main recursion

% Desired accuracy (trial and error, depends on the magnitude of V())
epsilon = 1;

% When reached desired accuracy, done = 1;
done = 0;

% Iteration counter
i=0;

while ~done 

  % Used only to print approximation error at each iteration
  i = i + 1;
    
  for s=1:N_state
    
    % If in state N_state, u must be 1 (replace)
    if s==N_state
      
      % Store u and v for each state s
      u_star = 1;
      V_star = DP_CR_expected_cost(s,u_star,V_aux(:,end));
    
    else
    
      % For all other states, consider possible inputs u=1,2
      for u=1:N_u
        
        % Expected total cost if: start from s and apply u
        C_aux(u) = DP_CR_expected_cost(s,u,V_aux(:,end));
        
      end % u loop
      
      % Find best input, and new cost-to-go value
      [V_star, u_star] = min(C_aux);
      
    end
    
    % Store u and v for each state s
    U_tmp(s,1) = u_star;
    V_tmp(s,1) = V_star;
    
  end % s loop
  
  % Update auxiliary matrices: add a column at the end
  U_aux(:,end+1) = U_tmp;
  V_aux(:,end+1) = V_tmp;
  
  % Check convergence: ||V_{i+1}-V_{i}||_inf < epsilon*(1-alpha)/alpha
  err = max(abs(V_aux(:,end)-V_aux(:,end-1)));
  
  if err < epsilon*(1-alpha)/alpha
    
    % stop
    done =1;
    
  end
    
  disp(sprintf('Iteration #%.2d, err = %.6f, delta=%.6f', i, err,epsilon*(1-alpha)/alpha));
  
end % while
%
% DP algorithm END

% Output: last column of U_aux and V_aux
uu=U_aux(:,end);
vv=V_aux(:,end);
