from DP_IC_Infinite_Horizon_utils import *


# parameters
Nrun = 1000     # number of simulations
T = 100         # time horizon of each simulation

# load parameters
pW, cost, C, W_max, W_set, _, _ = DP_IC_setup()
N_state = C + 1

# init
x_star = np.zeros((T+1, Nrun), dtype=int)
u_star = np.zeros((T, Nrun), dtype=int)
gt_star = np.zeros((T, Nrun), dtype=int)
w_star = np.zeros((T, Nrun), dtype=int)

x_h1 = np.zeros((T+1, Nrun), dtype=int)
u_h1 = np.zeros((T, Nrun), dtype=int)
gt_h1 = np.zeros((T, Nrun), dtype=int)
w_h1 = np.zeros((T, Nrun), dtype=int)

x_h2 = np.zeros((T+1, Nrun), dtype=int)
u_h2 = np.zeros((T, Nrun), dtype=int)
gt_h2 = np.zeros((T, Nrun), dtype=int)
w_h2 = np.zeros((T, Nrun), dtype=int)

# compute different policies
# optimal policy
U_star, V, iter = DP_IC_optimal_policy()

# heuristic policy #1: when level below max demand, refill
# U_h1 = [10, 9, 8, 7, 0, ..., 0]
U_h1 = np.array([10, 9, 8, 7, 0, 0, 0, 0, 0, 0, 0], dtype=int)

# heuristic policy #2: when level below max demand, order minimum quantity to ensure fulfillment of demand
# U_h2 = [ 4,  3,  2,  1, 0, ...,  0]
U_h2 = np.array([4, 3, 2, 1, 0, 0, 0, 0, 0, 0, 0], dtype=int)

# main loop
x0 = C

for k in range(Nrun):
    # optimal policy
    x_star[:, k], u_star[:, k], gt_star[:, k], w_star[:, k] = DP_IC_singlerun(T, U_star, x0)
    # heuristic 1
    x_h1[:, k], u_h1[:, k], gt_h1[:, k], w_h1[:, k] = DP_IC_singlerun(T, U_h1, x0)
    # heuristic 2
    x_h2[:, k], u_h2[:, k], gt_h2[:, k], w_h2[:, k] = DP_IC_singlerun(T, U_h2, x0)

# plot and write results
J_star, J_h1, J_h2 = DP_IC_plot(gt_star, gt_h1, gt_h2, Nrun, T)

print(f'Time horizon T = {T}')
print(f'Number of simulation runs = {Nrun}')
print(f'Initial condition x0 = {x0}')
print('')
print(f'Optimal policy mu(x) = {U_star}')
print('')
print('-'*10 + 'Average Total Cost' + '-'*10)
print(f'Optimal policy: {np.mean(J_star)}')
print(f'Heuristic policy #1:  {np.mean(J_h1)}')
print(f'Heuristic policy #2:  {np.mean(J_h2)}')
