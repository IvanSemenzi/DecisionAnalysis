function [U, V] = DP_IC_optimal_policy(T)

%% Compute optimal policy U (over t=1,...,T) 
%  and value function V (for t=1,...,T,T+1)
% 
% U has N_x rows and T columns, U(x,t) is optimal input
% when in state x at time t
%
% V has N_x rows and T+1 columns, V(x,t) is optimal
% cost-to-go if in state x at time t
%



%% Parameters and initialization

% Load some parameters defined in file DP_IC_setup.m:
%   max capcity (C), demand prob (pW), stage cost coeff. (cost), 
%   max demand (W_max) and possible demand values (W_set)
[~,~,C,W_max,~]=DP_IC_setup();

% Possible states
X_set = [0:C]';

% Number of states
N_state = length(X_set);

% Possible inputs depend on the current state
%
% U_set{k} = possible inputs when state is x=X_set(k)
for k=1:N_state
  U_set{k} = [max([W_max-X_set(k) 0]):C-X_set(k)];
end


% Initialization of useful data structures
%
% Optimal policy 
% U(x,t) = optimal input at time t when in state x  
U=zeros(N_state,T);
%
% Cost-to-go function
V=zeros(N_state,T+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% DP algorithm

% DP algorithm START

% 1. Initialization
V(:,T+1) = zeros(N_state,1); % no terminal cost

% 2. Main loop
for t=T:-1:1 % time index
  
  for k=1:N_state % state index
    
    % Current state{k}
    s=X_set(k);
    
    % Possible inputs for current state s
    U_aux = U_set{k};
    N_aux = length(U_aux);
    C_aux = zeros(1,N_aux);

    for h=1:N_aux % input index
      
      % Current input
      u=U_aux(h);
        
      % Expected total cost if: at time t, start from state s, 
      %                          and apply input u
      C_aux(h) = DP_IC_expected_cost(s,u,V(:,t+1));
      
    end % h loop
    
    % h_star is the index of the optimal input u_star
    % u_star will be U_aux(h_star)

    % Find best input, and new cost-to-go value
    % C is a row vector containing the costs associated to 
    % different possible inputs

    % Find best input, and new cost-to-go value
    [V_star, h_star] = min(C_aux);
    
    % Optimal input if in state s at time t
    U(k,t) = U_aux(h_star);
    
    % Cost-to-go if in state s at time t
    V(k,t) = V_star;

  end % k loop
  
  
end % t loop 
