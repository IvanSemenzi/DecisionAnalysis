%% Clean workspace
close all;
clear all;
clc;



%% Parameters

% Number of days to simulate
N=365;

% Number of samples per day
Ns=24; % sampling time = 1 hour



%% Simulate wind speed measurements

% Use Weibull(lambda,kappa)
lambda=8;
kappa=1.6;
v=wblrnd(lambda,kappa,N*Ns,1);



%% Simulate energy generation

% Allocate vector to store energy
e=zeros(N*Ns,1);

% Simulate generated energy [kWh]
for k=1:N*Ns
    e(k)=characteristic_curve(v(k));
end

% Convert energy to [MWh] (for readability)
e=e/1000;



%% Compute and display results

% Arrange energy in days
% Each row of matrix "energy" is a day
% Each column of matrix "energy" is an hour
energy=reshape(e,Ns,N)';

% Compute daily generated energy
% Each component of vector G is a day of generated energy
G=sum(energy,2);

% mean
Gm=mean(G);

% std dec
Gs=std(G);

% plot input data
figure
ax1=subplot(2,1,1);
plot(e,'r')
grid on
xlabel('time [hours]')
ylabel('energy [MWh]')
title('Generated energy')
ax2=subplot(2,1,2);
plot(v)
grid on
xlabel('time [hours]')
ylabel('wind speed [m/s]')
title('Wind speed')
% link x-axis of two subplots, useful when zooming
linkaxes([ax1,ax2],'x');

% pdf 
figure
histogram(G,'Normalization','pdf')
grid on
xlabel('Daily energy [MWh]')
ylabel('pdf')
title('Histogram')


% cdf
[F, x]=ecdf(G);
figure
plot(x,F)
grid on
xlabel('Daily energy [MWh]')
ylabel('cdf')
title('Empirical cdf')

% exceedance probabilities
%
% P90:   P(G>=P90) = 0.9
%  ->  1-P(G>=P90) = 0.1
%  ->    P(G< P90) = 0.1
%
% Hence, P90 is the 10-th percentile
%
P90 = prctile(G,10);
P75 = prctile(G,25);
P50 = prctile(G,50);


% write some results
disp(['    Number of days: ' num2str(N)])
disp(['Number samples/day:  ' num2str(Ns)])
disp(' ')
disp('    Daily energy G   [MWh]')
disp('  -----------------------------')
disp(['              mean: ' num2str(Gm)])
disp(['           std dev: ' num2str(Gs)])
disp(' ')
disp(['               P90: ' num2str(P90)])
disp(['               P75: ' num2str(P75)])
disp(['               P50: ' num2str(P50)])
