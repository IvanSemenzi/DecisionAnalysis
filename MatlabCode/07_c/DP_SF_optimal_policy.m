function [uu, vv, U_aux, V_aux] = DP_SF_optimal_policy(N_state,p)
%
% Compute optimal policy uu over INFINITE HORIZON
% and value function vv 
% 
% uu(i,j) is optimal input when in state (i,j)
%
% vv(i,j) is optimal value function when starting from state (i,j)
%
% Returns also U_aux and V_aux, 3D matrices containing u and v at each iteration
%



%% Parameters and Initialization

% Initialization of useful data structures
%
% Optimal policy 
% uu = optimal input when in state x  
uu=zeros(N_state,N_state);
%
% Value function when starting from x
vv=zeros(N_state,N_state);
%
% Auxiliary matrices to trace convergence of uu and vv
U_aux=zeros(N_state,N_state); % will grow dynamically at each iteration
V_aux=zeros(N_state,N_state); % will grow dynamically at each iteration

% Possible inputs
U_set = [-1 0 1];
N_u=length(U_set); 

% Auxiliary cost vector
C_aux=zeros(1, N_u);



%% Value iteration algorithm

% DP algorithm: Value iteration  START
%
% 1. Initialization
V_aux = zeros(N_state,N_state); 

% 2. Main recursion
%
% Stopping criterion
delta = 0.001;

% When reached desired accuracy, done = 1;
done = 0;
h=0;
while ~done % TO DO: it is wise to add also a max number of iterations
  
  h=h+1;
       
  for i=1:N_state
    for j=1:N_state
      
      if i==j % Caught! 
        
        % Input must be 0=U_set(2);
        u_star=2;
        
        % Value function is 0
        V_star=0;
        
      else
      
        % For all other states, consider possible inputs u=1,2
        for u=1:N_u
          
          % Expected total cost if: start from s and apply u
          C_aux(u) = DP_SF_expected_cost(i,j,U_set(u),V_aux(:,:,end),N_state,p);
          
        end % u loop
        
        
        % Find best input, and new cost-to-go value
        [V_star, u_star] = min(C_aux);
        
      end % if
    
      % Store u and v for each state s
      U_tmp(i,j) = U_set(u_star);
      V_tmp(i,j) = V_star;
      
    end % j loop
    
  end % i loop
  
  % Update auxiliary 3D array: add a matrix at the end
  U_aux(:,:,end+1) = U_tmp;
  V_aux(:,:,end+1) = V_tmp;

  
  % Check convergence: ||V_{i+1}-V_{i}||_inf < epsilon
  err = max(max(abs(V_aux(:,:,end)-V_aux(:,:,end-1))));
  
  if err < delta
    
    % stop
    done =1;
    
  end
  
  disp(sprintf('Iteration #%.2d, err = %.6f', h, err));
  
end % while
%
% DP algorithm END


% Output: last 2D matrix of U_aux and V_aux
uu=U_aux(:,:,end);
vv=V_aux(:,:,end);
