import numpy as np

radius = 1
N_s = 1000000       # Number pof points
N_c = 0             # Points inside the circle
points = 2 * np.random.random_sample((N_s, 2)) - 1

for i in range(N_s):
    if((np.sqrt(points[i, 0]**2 + points[i, 1]**2)) <= 1):
        N_c += 1

pi_est = N_c/N_s
print(4*pi_est)
