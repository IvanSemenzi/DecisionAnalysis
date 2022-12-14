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
line1, = ax.plot(x1, x2)                                     # plot circle
ax.plot([-1, 1, 1, -1, -1], [-1, -1, 1, 1, -1])     # plot square
plt.xlim(-1.1, 1.1)
plt.ylim(-1.1, 1.1)
ax.set_aspect(1)


# for cycle to count how many points are inside the unit circle and draw them
for i in range(N_s):
    if((np.sqrt(points[i, 0]**2 + points[i, 1]**2)) <= 1):
        plt.scatter(points[i,0], points[i, 1], color = 'b')
        N_c += 1
    else:
        plt.scatter(points[i,0], points[i, 1], color = 'r')

pi_est = 4*N_c/N_s

ax.set_title(f'$N_{{s}} = {N_s} \quad \hat{{\pi}} = {pi_est}$')

plt.show()
