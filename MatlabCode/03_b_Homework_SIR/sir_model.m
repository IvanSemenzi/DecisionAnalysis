%% SIR Epidemic Model

% Adapted from a code written by Arezou Keshavarz 
% for the course:
%
% EE365 Stochastic Control
% Stanford University
%

close all;
clear all; 
clc



%% Parameters

% network of q x q agents
% agents are connected in a grid
% each agent is identified by a pair (i,j)
q = 30; 
T = 100; % final simulation time

% possible states of an agent
% 1 is S (susceptible), 2 is I (infected) and 3 is R (removed)
s=[1 2 3];

% transition probability matrix when at least one neighbor is I
pSI1 = 0.4; % probability S -> I

P1 = [1-pSI1 pSI1 0; 
      0.2 0.6 0.2; 
      0 0 1]; 

% transition probability matrix when none of the neighbors is I
P2 = [1 0 0; 
      0.2 0.6 0.2; 
      0 0 1]; 



%% Initialization

% X(i,j,t) is the state of agent (i,j) at time t. 

% Allocate matrix X to store the state evolution
X = ones(q,q,T+1); 

% agents (2,2) and (q-1,q-1) are initially I
% the others are all S
X(2,2,1) = 2; 
X(q-1,q-1,1) = 2;

% S is blue, I is red, and R is green.
cmap=[0 0 1; 1 0.3 0.3; 0 1 0];
colormap(cmap) % used by pcolor 

% plot initial state of the network, use pcolor
%
% ATTENTION
% pcolor discards last row/column, so add a fictitious row/column
figure(1)
pcolor([0.5:q+0.5],[0.5:q+0.5],[[X(:,:,1) 3*ones(q,1)]; ones(1,q+1)])
title('S (blue), I (red), R (green) at t = 0');
pause;

  
  
%% Simulate MC evolution
for t = 1:T  % time
  
  for i = 1:q  % row index
  
    for j = 1:q  % column index
      
      % check if at lest one neighbor is I
      ni = 0; 
      if (i > 1)
        ni = ni + (X(i-1,j,t) == 2); 
      end
      
      if i < q
        ni = ni+ (X(i+1,j,t) == 2); 
      end
      
      if (j > 1)
        ni = ni + (X(i,j-1,t) == 2); 
      end
      
      if (j < q)
        ni = ni + (X(i,j+1,t) == 2); 
      end
      
      % select the right transition probability matrix
      if ni > 0 
        P = P1; 
      else
        P = P2; 
      end
      
      % generate state for agent (i,j) at time t+1
      % according to transition probability matrix P
            
      % probability, slect the right row from P
      ps=P(X(i,j,t),:);
      
      % generate a sample for the next state
      X(i,j,t+1) = randsample(s,1,true,ps);
      
    end % for j
  end % for i
  

  % update figure
  figure(1)
  pcolor([0.5:q+0.5],[0.5:q+0.5],[[X(:,:,t+1) 3*ones(q,1)]; ones(1,q+1)])
  title(['S (blue), I (red), R (green) at t = ' num2str(t)]);
  pause(0.05);
  
end % for t



%% Compute and display results
% show the fraction of  S/I/R agents vs. time
for t = 1 : T+1
    nS(t) = sum(sum(X(:,:,t) == 1))/q^2; 
    nI(t) = sum(sum(X(:,:,t) == 2))/q^2; 
    nR(t) = sum(sum(X(:,:,t) == 3))/q^2; 
end

figure(2)
h2 = area(1:T+1,[nS; nI; nR]');
set(h2(1),'FaceColor',cmap(1,:));
set(h2(2),'FaceColor',cmap(2,:));
set(h2(3),'FaceColor',cmap(3,:));   
set(gca, 'YLim', [0 1]); 
legend('S','I','R');
title('Fraction of S/I/R agents')
xlabel('time');
