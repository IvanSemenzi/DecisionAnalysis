""" ORIGINAL MATLAB CODE
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
"""

import numpy as np
import matplotlib.pyplot as plt
import time

N_s = 100        # Number pof points in the space
N_c = 0             # Points inside the circle

points = 2 * np.random.random_sample((N_s, 2)) - 1  # generate N_s points uniformly distributed in the square

# theta goes from 0 to 2pi
theta = np.linspace(0, 2*np.pi, 100)

# the radius of the circle
r = np.sqrt(1)

# compute x1 and x2
x1 = r*np.cos(theta)
x2 = r*np.sin(theta)

# create the figure
fig, ax = plt.subplots(1)
ax.plot(x1, x2)                                     # plot circle
ax.plot([-1, 1, 1, -1, -1], [-1, -1, 1, 1, -1])     # plot square
plt.xlim(-1.1, 1.1)
plt.ylim(-1.1, 1.1)
ax.set_aspect(1)


# for cycle to count how many points are inside the unit circle and draw them
for i in range(N_s):
    if np.sqrt(points[i, 0]**2 + points[i, 1]**2) <= 1:
        plt.scatter(points[i,0], points[i, 1], color='b')
        N_c += 1
    else:
        plt.scatter(points[i,0], points[i, 1], color='r')

pi_est = 4*N_c/N_s

ax.set_title(f'$N_{{s}} = {N_s} \quad \hat{{\pi}} = {pi_est}$')

plt.show()
