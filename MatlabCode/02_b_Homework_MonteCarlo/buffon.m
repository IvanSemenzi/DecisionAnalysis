%% Clean workspace

close all;
clear all;
clc;



%% Parameters
% number of throws
N=1e4;

% 1D problem:
%   needle position in [0, 1] (one extremum of the needle)
%   needle angle in [-pi, pi]
%   lines at position ..., 0, 1,...



%% Simulate random throws

% simulate N positions and N angles
x=rand(N,1);
theta=pi*(2*rand(N,1)-1);   



%% Check intersection: 
%    "is there is a line between the two extrema of the needle?"
%
% one extremum is at x
%    the other is at x+cos(theta);
ext=x+cos(theta);

% counter of the simulation runs where the needle crosses a line
cross=0;

for k=1:N

        % intersection if: ext(k)>=1 or ext(k) <= 0
        if ext(k)>= 1 | ext(k)<=0 
            cross=cross+1;
        end
        
end



%% Compute and display results
% true probability 
p=2/pi;

% estimated probability
phat=cross/N;

disp(['         Number of throws: ' num2str(N)])
disp(['         True probability: ' num2str(p)])
disp([' Approximated probability: ' num2str(phat)])



%% NOTE TO ADVANCED USERS 
%
% If you exploit the Matlab vector capability, you can replace 
% the whole for loop by the following line (just one line!)

%cross2=sum(ext>=1 | ext<=0);

% Check it out that cross2 = cross
%
%cross2-cross