function [U, V, C] = DP_purchase_optimal_policy(T)

%% Compute optimal policy U (over t=0,...,T-1) 
%  and value function V (for t=0,...,T)
% 
% U(i,j,k,t) is optimal input at time t, if state is (i,j,k):
%            i-th F value, j-th H value and k=1 (not purchased yet)
%            or k=2 (purchased already)
%
% V(i,j,k,t) is optimal value function at time t, if state is (i,j,k):
%            i-th F value, j-th H value and k=1 (not purchased yet)
%            or k=2 (purchased already)
%



%% Parameters and Initialization

% Load setup data
[F,H,pF,pH,NF,NH,NK]=DP_purchase_setup();

% Number of different inputs 
N_u=2;

% Initialization of useful data structures

% U(i,j,k,t) = optimal input at time t when in state (i,j,k)
U=zeros(NF,NH,NK,T); 

% Optimal value function (cost-to-go function)
V = zeros(NF,NH,NK,T+1);

% Aux cost vector
C=zeros(1,N_u); 



%% Main loop

% 1. Initialization
V(:,:,2,T+1) = zeros(NF,NH); 

% terminal cost if not purchased at the end 
% (assign a large *BUT FINITE* cost)
M=1e6;
V(:,:,1,T+1) = M * ones(NF,NH); 

% 2. Main recursion
for t=T:-1:1
  
  % All possible states
  for i=1:NF
    for j=1:NH
      for k=1:NK
                
        if k==2 
          
          % Already purchased, can only wait (u=1), with zero
          % expected cost-to-go
                 
          % Optimal input at time t, in state x
          u_star = 1;
          
          % Optimal value function at time t, in state x
          V_star = 0;
          
        else 
          
          % not purchased yet, consider all possible inputs

          for u=1:N_u
            
            % Expected total cost if: at time t, start from (i,j,k), apply u 
            C(u) = DP_purchase_expected_cost([i,j,k]',u,V(:,:,:,t+1));
            
          end % u loop
       
          % Find best input, and new cost-to-go value
          [V_star, u_star] = min(C);
                    
        end % if

        % Optimal input at time t, in state x
        U(i,j,k,t) = u_star;
          
        % Optimal value function at time t, in state x
        V(i,j,k,t) = V_star;

        
      end % k loop
    end % j loop
  end % i loop
  
      
end % t loop 
