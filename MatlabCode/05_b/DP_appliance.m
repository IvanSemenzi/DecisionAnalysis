%% Dishwasher scheduler via deterministic DP

close all;
clear all;
clc;



%% Parameters and initialization

% State x represents the next cycle to run
%
% Possible states x = 1 , ... , N_state
%
%                 x = 1         --> program not started yet
%                 x = N_state   --> program complete

% 5 washing cycles per program + program complete
N_state=6;        
X_set=[1:N_state];

% Possible inputs: 0 = "wait", 1 = "run next washing cycle"
N_input=2; 
U_set=[0, N_input-1]; 

% Time horizon t = 1,... ,T,T+1
T=20; % Sampling time = 15 min (time horizon is 5 hour long)

% Power consumption profile (power required by each washing cycle, in kW)
% the last 0 is when program complete
power=[1 2.5 0.25 0.25 1.5 0]; 

% Generate random energy prices (just for convenience, it's unrealistic!)

% Uncomment the following line to set the seed of 
% the random generator for repeatability
randn('state',12321); 

% Contains the energy price at each time instant (in EUR/kWh)
price=0.2+0.05*randn(1,T); 

% Initializize some matrices to store results

% Matrix to store optimal policy 
% U(x,t) optimal input if in state x at time t
U=zeros(N_state,T);

% Optimal value functions (cost-to-go functions)
% V(x,t) cost-to-go if in state x at time t
V = zeros(N_state, T+1);



%% Compute optimal policy

% DP algorithm START

% 1. Initialization
for k=1:N_state
  V(k,T+1) = DP_appliance_terminal_cost(X_set(k),N_state);
end

% 2. Main loop
for t=T:-1:1 % time index
  
  for k=1:N_state % state index
    
     % Current state
     s=X_set(k);
      
     if s==N_state
       
       % h_star is the index of the optimal input u_star
       % u_star will be U_set(h_star), where U_set=[0, 1]
       
       % if program complete, then u must be always "wait" 
       %                      -> u_star=0 -> h_star=1
       h_star=1;
       
       % if program complete, cost-to-go is zero
       V_star=0;
       
     else
       
       % Eevaluate cost for all possible inputs
       for h=1:N_input  % input index  
         
         % Current input
         u=U_set(h);
         
         % Next state if in state s and apply u
         x_next = DP_appliance_f(s,u); 

         % Total cost if: at time t, start from s, apply u 
         C(h) = DP_appliance_stage_cost(s,u,t,price,power) + V(x_next,t+1);
       
       end % h loop

       % h_star is the index of the optimal input u_star
       % u_star will be U_set(h_star), where U_set=[0, 1]

       % Find best input, and new cost-to-go value
       % C is a row vector containing the costs associated to u=0 and u=1
       [V_star, h_star] = min(C);
        
     end  % if s==6
     
     % Optimal input if in state x(k) at time t
     U(k,t) = U_set(h_star);
     
     % Cost-to-go if in state x(k) at time t
     V(k,t) = V_star;
     
  end % k loop
  
  
end % t loop 

%
% DP algorithm END



%% Simulate optimal policy

% Initialize state trajectory
XX=zeros(1,T+1);

% Initialize total cost
J=0;

% Initial state: program not started yet
XX(1)=1; 

for t=1:T
  
  % Compute next state using optimal policy stored in matrix U
  % Input to apply at time t is U(XX(t),t)
  XX(t+1) = DP_appliance_f(XX(t),U(XX(t),t));
  
  % Update total cost
  J = J+DP_appliance_stage_cost(XX(t),U(XX(t),t),t,price,power);
  
end

% Add terminal cost
J=J+DP_appliance_terminal_cost(XX(T+1),N_state);

% Check total cost
disp(' ')
disp(['Total cost with optimal policy (simulation) ' num2str(J) ])
disp(['Total cost with optimal policy (cost-to-go function) ' num2str(V(XX(1),1)) ])



%% Plot results
DP_appliance_plot_results(U,XX,price,power)

