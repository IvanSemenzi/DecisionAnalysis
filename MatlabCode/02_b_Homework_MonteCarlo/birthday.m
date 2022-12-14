%% Clean workspace

close all;
clear all;
clc;



%% Parameters
   
% Number of people
n=20;

% Number of simulation runs
N=1e4;

% Number of days in a year
Nd=365;

% All possible days
days=[1:Nd];

% Uniform probabilities
probabilities=1/Nd*ones(1,Nd);



%% Simulate births and count same-day births

% counter of the simulation runs where 
% at least two people were born on the same day
sameday=0;

for k=1:N
   
    % simulate the brith of n people
    b=randsample(days,n,true,probabilities);
     
   % check if at least two births on the same day
   % unique(b) removes duplicates in vector b
   if length(b)>length(unique(b))
       sameday=sameday+1;
   end
    
end



%% Compute and display results

% True probability P("at least two people born the same day")
p=1-prod([365-n+1:365])/365^n;

% Estimated probability 
phat=sameday/N;

disp(['         Number of people: ' num2str(n)])
disp(['Number of simulation runs: ' num2str(N)])
disp(['         True probability: ' num2str(p)])
disp(['    Estimated probability: ' num2str(phat)])
