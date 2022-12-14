%% Clean workspace

close all;
clear all;
clc;



%% Parameters
% number of points in the square
Ns=1e3;



%% Simulate points

% generate Ns points uniformly distributed in the square
x=2*rand(Ns,1)-1;
y=2*rand(Ns,1)-1;



%% Compute and display results

% distance from the origin of all the points
d=sqrt(x.^2+y.^2);

% index and number of points in the circle
Ic=(d<=1);
Nc=sum(Ic);    

% approximation of pi
pihat=4*Nc/Ns;

disp(['Number of points in the square: ' num2str(Ns)])
disp(['            "True" value of pi: ' num2str(pi)])
disp(['      Approximated value of pi: ' num2str(pihat)])

% Just a figure...
figure,
hold on
% Square
square_x=[-1 -1 1  1 -1];
square_y=[-1  1 1 -1 -1];
plot(square_x,square_y,'b','LineWidth',2);

% Circle
theta=[-pi:0.01:pi];
circle_x=cos(theta);
circle_y=sin(theta);
plot(circle_x,circle_y,'r','LineWidth',2);

% Points
plot(x,y,'ob');
plot(x(Ic),y(Ic),'xr');

% Axis
axis([-1.1 1.1 -1.1 1.1])
axis equal
title(['N_s = ' num2str(Ns) ', N_c = ' num2str(Nc) ', (4\rho = ' num2str(pihat) ')'] )
