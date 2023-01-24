from DP_IC_utils import *


# parameters and initialization
# time horizon
T = 100
# load parameters
pW, cost, C, W_max, W_set = DP_IC_setup()

# compute optimal policy (1 run)
U, V = DP_IC_optimal_policy(T)

# simulate optimal policy (1 run)
x0 = C      # initially full
x, u, gt, w = DP_IC_singlerun(T, U, x0)

# display results
print(f'Time horizon T: {T}')
print(f'Total cost = {np.sum(gt)}')
print(f'Expected total cost from x0 (value function V0(x0)) = {np.sum(V[-1, 1])}')
print(f'Average stage cost = {np.mean(gt)}')
print(f'First reorder time: {next((i for i, x in enumerate(u) if x), None)}')
print(f'Average reordering time: {np.mean(np.diff(np.array([i for i, x in enumerate(u) if x])))}')
print(f'Total number of orders: {np.count_nonzero(u)}')

# plot
fig, axs = plt.subplots(2, 2)
fig.suptitle('Simulation')

axs[0, 0].stairs(x, range(T + 2))
axs[0, 0].set_title('State (stock level)')

axs[0, 1].bar(range(T), u)
axs[0, 1].set_title('Input (ordered quantity)')

axs[1, 0].bar(range(T), gt)
axs[1, 0].set_title('Stage cost')

axs[1, 1].fill_between(range(T), np.cumsum(gt))
axs[1, 1].set_title('Total cost')

plt.show()
