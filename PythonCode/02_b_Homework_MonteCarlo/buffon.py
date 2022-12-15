import numpy as np
import math

N = [100, 1_000, 10_000, 1_000_000]                         # different number of simulations

for i in N:
    y0 = np.random.rand(i)                                  # y coordinate of the bottom left edge of the needle
    theta = math.pi * (2 * np.random.rand(i) - 1)           # angle of the needle

    y1 = y0 + np.cos(theta)                                 # y coordinate of the other edge of the needle

    crosses = np.sum(abs(np.floor(y0) - np.floor(y1)))      # number of needle crossing the line

    p_hat = float(crosses/i)                                # estimsate of the probability

    print(f'The estimate of p after {i} experiments is : {p_hat}')

print(f'The actual value of p is {2/math.pi}')