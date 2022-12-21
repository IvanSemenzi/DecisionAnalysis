import numpy as np
from IC_singlerun import IC_singlerun
import matplotlib.pyplot as plt

T_max = 100                                     # time horizon

x, u, gt, W_real = IC_singlerun(T_max)   # runs a single simulation over time horizon

print(f'Time horizon T: {T_max}')
print()
print(f'Total cost : {int(np.sum(gt))}')
print(f'First reorder time: {next((i for i, x in enumerate(u[0]) if x), None)}')
print(f'Total number of orders: {int(np.sum(u))}')

# plot
fig, axs = plt.subplots(2, 2)
fig.suptitle('Simulation')

axs[0, 0].stairs(x[:, 0], range(T_max + 2))
axs[0, 0].set_title('State (stock level)')

axs[0, 1].bar(range(T_max), u[:, 0])
axs[0, 1].set_title('Input (ordered quantity)')

axs[1, 0].bar(range(T_max), gt[:, 0])
axs[1, 0].set_title('Stage cost')

axs[1, 1].fill_between(range(T_max), np.cumsum(gt[:, 0]))
axs[1, 1].set_title('Total cost')

plt.show()
