function [J_star, J_h1, J_h2]=DP_CR_plot(gt_star, gt_h1, gt_h2, Nrun, T)

%% Plot results

% gt_star is stage cost with optimal policy
%
% gt_h1 is stage cost with Greedy policy
%
% gt_h2 is stage cost with Heuristic policy
%



%% TOTAL COST Optimal policy 

% Total cost for each run
J_star=sum(gt_star,1);

% Sample mean
mJ1=mean(J_star);

figure
hold on
histogram(J_star,20,'Normalization','pdf','FaceColor','r');
[z_star,edges_star]=histcounts(J_star,20,'Normalization','pdf');
plot(mJ1*[1 1], [0 max(z_star)],'k','LineWidth',2);
legend('Histogram',['Mean value = ' num2str(mJ1)]);
xlabel('Total cost');
ylabel('Probability density');
title(['Optimal policy (Nrun=' num2str(Nrun) ', T=' num2str(T) ')']);
grid;



%% TOTAL COST Greedy policy

% Total cost for each run
J_h1=sum(gt_h1,1);

% Sample mean
mJ2=mean(J_h1);

figure
hold on
histogram(J_h1,20,'Normalization','pdf','FaceColor','b');
[z_h1,edges_h1]=histcounts(J_h1,20,'Normalization','pdf');
plot(mJ2*[1 1], [0 max(z_h1)],'k','LineWidth',2);
legend('Histogram',['Mean value = ' num2str(mJ2)]);
xlabel('Total cost');
ylabel('Probability density');
title(['Greedy policy (Nrun=' num2str(Nrun) ', T=' num2str(T) ')']);
grid;



%% TOTAL COST Heuristic policy  

% Total cost for each run
J_h2=sum(gt_h2,1);

% Sample mean
mJ3=mean(J_h2);

figure
hold on
histogram(J_h2,20,'Normalization','pdf','FaceColor','g');
[z_h2,edges_h2]=histcounts(J_h2,20,'Normalization','pdf');
plot(mJ3*[1 1], [0 max(z_h2)],'k','LineWidth',2);
legend('Histogram',['Mean value = ' num2str(mJ3)]);
xlabel('Total cost');
ylabel('Probability density');
title(['Heuristic policy (Nrun=' num2str(Nrun) ', T=' num2str(T) ')']);
grid;



%% Comparison 
figure
hold on

% Compute the center of the bins
bins_star=edges_star(1:end-1)+diff(edges_star);
bins_h1=edges_h1(1:end-1)+diff(edges_h1);
bins_h2=edges_h2(1:end-1)+diff(edges_h2);

bar(bins_h1,z_h1,'b');
bar(bins_h2,z_h2,'g');
bar(bins_star,z_star,'r');
legend('Greedy','Heuristic','Optimal')
xlabel('Total cost');
ylabel('Probability density');
title(['Total cost distribution (Nrun=' num2str(Nrun) ', T=' num2str(T) ')']);
grid;
