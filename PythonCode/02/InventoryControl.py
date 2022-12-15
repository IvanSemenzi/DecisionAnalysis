import numpy as np
from IC_singlerun import IC_singlerun

T_max = 100                                     # time horizon
C_max = 10                                      # maximum capacity

x, u, gt, W_real = IC_singlerun(T_max, C_max)   # runs a simulation over time horizon

print(f'Time horizon T: {T_max}')
print()
print(f'Total cost : {int(np.sum(gt))}')
print(f'First reorder time: {next((i for i, x in enumerate(u) if x), None)}')
print(f'Total number of orders: {int(np.sum(u))}')

