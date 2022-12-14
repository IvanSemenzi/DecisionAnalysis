%% File name: MC_inventorycontrol.m

%% Clean workspace

clear all
close all;
clc;



%% Parameters

% Number of simulation runs
Nrun=1000; 

% Length of each run
T_max=100; 



%% Initialization

% Inizialize matrices to store results of simulation runs
% Not necessary, but improves efficiency
x=zeros(T_max+1,Nrun);
u=zeros(T_max,Nrun);
gt=zeros(T_max,Nrun);
w=zeros(T_max,Nrun);



%% Main loop

for h=1:Nrun

    % Dynamic system representation
    [x(:,h), u(:,h), gt(:,h), w(:,h)] = IC_singlerun(T_max); 

end



%% Figure 1: Total cost histogram

%%%%%%%%%%%%%%%%%%% TOTAL COST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total cost for each run
J=sum(gt,1);


% Sample mean
mJ=mean(J);

% Histogram of the total cost
figure
hold on
histogram(J,20,'Normalization','pdf');
[z,edges]=histcounts(J,20,'Normalization','pdf');
plot(mJ*[1 1], [0 max(z)],'r','LineWidth',2);
legend('Histogram',['Mean = ' num2str(mJ,4)]);
xlabel('Total cost');
ylabel('Probability density');
title(['Total cost distribution']);
grid;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Figure 2: Stage cost (mean +/- std dev)

%%%%%%%%%%%%%%%%%%% STAGE COST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Average stage cost (vs. time)
mJs = mean(gt,2);   % sample mean
stdJs = std(gt')';  % sample standard deviation

figure
hold on
plot(mJs,'b','LineWidth',2);
plot(mJs+stdJs,'--r');
plot(mJs-stdJs,'--r');
legend('Mean','+/- 1-std');
xlabel('Time');
ylabel('Cost');
title(['Average stage cost' ]);
grid;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Figure 3: First order time histogram

%%%%%%%%%%%%%%%%%%% FIRST ORDER TIME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First order time for each run
for h=1:Nrun
    
    % NB. u(k,h) is actually the value of the input at time k-1
    %            during simularion run h
    Fo(h)=find(u(:,h),1)-1; 

end

% Sample mean
mFo=mean(Fo);

% Relative frequencies
figure
hold on
[nFo,edges]=histcounts(Fo,'Normalization','probability','BinMethod','integers');
stem(edges(1:end-1)+0.5,nFo);
plot(mFo*[1 1], [0 max(nFo)],'r','LineWidth',2);
legend('Relative frequencies',['Mean value = ' num2str(mFo)]);
xlabel('First order time');
ylabel('Probability');
title(['First order time distribution']);
grid;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Figure 4: Time between orders histogram


%%%%%%%%%%%%%%%%%%% TIME BETWEEN CONSECUTIVE ORDERS %%%%%%%%%%%%%%%%%%%%%%%%%
% Time between consecutive orders for each run
To=[];
for h=1:Nrun
  To=[To; diff(find(u(:,h)))]; % stack all time between orders of all runs in a single vector
end


% Sample mean
mTo=mean(To);

% Relative frequencies
figure
hold on
[nTo,edges]=histcounts(To,'Normalization','probability','BinMethod','integers');
stem(edges(1:end-1)+0.5,nTo);
plot(mTo*[1 1], [0 max(nTo)],'r','LineWidth',2);
legend('Relative frequencies',['Mean value = ' num2str(mTo)]);
xlabel('Time between consecutive orders');
ylabel('Probability');
title(['Time between orders distribution']);
grid;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Figure 5: State distribution

%%%%%%%%%%%%%%%%%%% STATE DISTRIBUTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State distribution
C=max(max(x));
L=[0:C]; % possible levels

for t=1:T_max+1
  
  nX = histcounts(x(t,:),[-0.5:C+0.5],'Normalization','probability');
  
    if t==1
      figure(5)
      bb=stem(L,nX);
      xlabel('Inventory level');
      ylabel('Probability');
      tt=title(['State distribution at t=' num2str(t-1)]); 
      axis([-1 C+1 0 1]);
      grid;
      pause(2)
    else
      figure(5)
      set(bb,'YData',nX);
      set(tt,'String', ['State distribution at t=' num2str(t-1) ]);
      
      if t<5 
        pause(2)
      else
        pause(0.1)
      end
      
      
    end
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
