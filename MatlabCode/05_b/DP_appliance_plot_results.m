function DP_appliance_plot_results(U,XX,price,power)

%% DP_appliance_plot_results(U,XX,c,p)
%
% Plot some results and comparison
% 
% U       contains the optimal policy
% XX      contains the state trajectory
% price   contains the energy price at each time step
% power   contains the power consumption of each cycle
%



%% Display optimal policy

% Each row is a state, each column is a time instant
% N_state is #states, T is #time instants
[N_state, T] = size(U); 

figure(1)

% Visualize matrix U
xindex=[0.5:T+0.5];
yindex=[0.5:N_state+0.5];

% pcolor discards the last row and column (help pcolor)
% --> add a fictitious row and column to matrix U
U_augmented = [ [U zeros(N_state,1)]; zeros(1,T+1) ];

pcolor(xindex,yindex,U_augmented);

% Set axis and labels 
xlabel('time [15 min]');
ylabel('state');
title('Optimal policy \mu_t(s): 0 wait (blue), 1 run (yellow)');
axis(0.5+[0 T 0 N_state]);

% Increase fontsize
set(gca,'FontSize',13)



%% Compare with naive policy: Compute results

% Optimal policy: find when we run, i.e. when the state changes
%
% UU(t)=0 wait at time t
% UU(t)=1 run  at time t
UU=diff(XX);  

% Naive policy: run the 5 cycles during 
%               the 5 cheapest time slots
[sorted_price, sorted_index]=sort(price);


% Cost comparison: optimal policy vs. naive policy ("minimum price slots") 
naive_cost = 1/4*price(sort(sorted_index(1:N_state-1)))*power(1:N_state-1)';
opt_cost = 1/4*price(logical(UU))*power(1:N_state-1)';

% Relative gain
rel_gain = (naive_cost-opt_cost)/naive_cost*100;



%% Compare with naive policy: Write results

% Write comparison results in Matlab window
disp(' ')
disp(['Naive policy: ' num2str(naive_cost)])
disp(['Optimal policy: ' num2str(opt_cost)])
disp(['Relative gain: ' num2str(rel_gain) ' %'])



%% Compare with naive policy: Display when we run 


figure(2)
hold on;

% Plot prices at all time slots
bar(price);

% Plot when we run according to naive policy (green slots)
bar(sorted_index(1:N_state-1),price(sorted_index(1:N_state-1)),'g'); 

% Plot when we run according to optimal policy (red slots)
bar(0.02*UU,'r');

% Set labels and legend
%legend('energy price',[num2str(N_state-1) ' smallest prices'] ,'optimal policy run periods')
legend('energy prices','naive policy' ,'optimal policy')
xlabel('time [15 min]')
ylabel('energy price [EUR/kWh]')
title(['J_{green}=' num2str(naive_cost,3) '  J_{red}=' num2str(opt_cost,3) ' rel. gain= ' num2str(rel_gain,3) ' %'])

% Increase fontsize
set(gca,'FontSize',13)



