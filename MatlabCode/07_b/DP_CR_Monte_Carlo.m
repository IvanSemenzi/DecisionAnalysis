%% Component replacement problem (see [Bertsekas, Vol. II, Example 1.2.1])

clear all
close all;
clc;



%% Parameters and Initialization

% Number of simulation runs
Nrun=100; 

% Length of each run
T=100; 

% Initialization (to store Optimal policy results)
x_star=zeros(T+1,Nrun);
u_star=zeros(T,Nrun);
gt_star=zeros(T,Nrun);

% Initialization (to store Greedy policy results)
x_h1=zeros(T+1,Nrun);
u_h1=zeros(T,Nrun);
gt_h1=zeros(T,Nrun);

% Initialization (to store Heuristic policy results)
x_h2=zeros(T+1,Nrun);
u_h2=zeros(T,Nrun);
gt_h2=zeros(T,Nrun);


% Load setup data: number of states (N_state), replacement cost (r),
% stage cost coefficient (c), probability of increasing wear (p),
% discount factor (alpha)
[N_state,r,c,p,alpha]=DP_CR_setup();



%% Compute different policies 

% Optimal Policy over infinite horizon, with discounted cost
% By stationarity assumption, now uu and vv are coulumn vector
%
% Returns also U_aux and V_aux containing u and v at each iteration
%
[uu, vv, U_aux, V_aux] = DP_CR_optimal_policy();
%
% Optimal policy is stored into vector uu
U_star=uu;


% Greedy policy: replace only if cost of using current tool is larger
%                than replacement cost (minimize stage cost)
%
U_h1=2-double((c*[1:N_state].^2-r)>0)';


% Heuristic policy 1: replace when state is > 1
%
U_h2=[2 ones(1,N_state-1)]';



%% Monte Carlo Simulation 

% Initial state: new component
x0=1;

% Main loop
for k=1:Nrun
  % Optimal policy
  [x_star(:,k), u_star(:,k), gt_star(:,k)] = DP_CR_singlerun(T,U_star,x0); 
  
  % Greedy policy 
  [x_h1(:,k), u_h1(:,k), gt_h1(:,k)] = DP_CR_singlerun(T,U_h1,x0); 

  % Heuristic policy 
  [x_h2(:,k), u_h2(:,k), gt_h2(:,k)] = DP_CR_singlerun(T,U_h2,x0); 

end



%% Plot results 
[J_star, J_h1, J_h2] = DP_CR_plot(gt_star, gt_h1, gt_h2, Nrun, T);



%% Write some results
disp(' ');
disp(' ');
disp(['Length of simulation runs T = ' num2str(T) ]);
disp(['  Number of simulation runs = ' num2str(Nrun)])
disp(['       Initial condition x0 = ' num2str(x0)])
disp(['      Discount factor alpha = ' num2str(alpha,'%.3f')])
disp(' ');
disp(' ');
disp(['               State x = [' num2str([1:N_state],-4) ']' ])
disp(['------------------------------------------------------' ])
disp(['Optimal   policy mu(x) = [' num2str(uu') ']''']);
disp(['Greedy    policy mu(x) = [' num2str(U_h1') ']''']);
disp(['Heuristic policy mu(x) = [' num2str(U_h2') ']''']);
disp(' ');
disp(' ');
disp('********* Average total cost (discounted) ***********' )
disp(['Optimal   policy   = ' num2str(mean(J_star))]); 
disp(['Greedy    policy   = ' num2str(mean(J_h1))]); 
disp(['Heuristic policy   = ' num2str(mean(J_h2))]); 
disp(' ');
disp(['Expected optimal total cost from x0 (value function V(x0)) = ' num2str(sum(vv(x0))) ] );
