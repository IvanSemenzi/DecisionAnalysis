from DP_appliance_utils import *


# parameters and initialization
# State x represents the NEXT cycle to run
# possible states x = 0,1,...,N_state-1(=5)
#                 x = 0         --> program not started yet
#                 x = N_state-1 --> program completed

# 5 washing cycles per program + program complete
N_state = 6
X_set = np.arange(N_state)

# possible inputs: 0 = 'wait', 1 = 'run next cycle'
N_input = 2
U_set = np.array([0, 1], dtype=int)

# time horizon t = 0,1,...,T
T = 20      # sampling time = 15 min (5 hours time horizon)

# power consumption profile (power required by each washing cycle, [kW])
power = np.array([1, 2.5, 0.25, 0.25, 1.5, 0])

# generate random energy prices
np.random.seed(123)     # for reproducibility
# contains the energy price at each time instant (in EUR/kWh)
price = 0.2 + 0.05 * np.random.randn(T)

# initialize matrices to store the results
# U(x,t) is the optimal input if at time t we are in state x
U = np.zeros((N_state, T), dtype=int)

# optimal value functions (cost-to-go functions)
# V(x,t) cost-to-go if at time t we are in state x
V = np.zeros((N_state, T+1))

# compute the optimal policy
# DP algorithm START
# 1. Init
for k in range(N_state):
    V[k, T] = DP_appliance_terminal_cost(X_set[k], N_state)

# 2. Main Loop
for t in range(T-1, -1, -1):
    for s in X_set:
        # s is the current state
        if s == N_state - 1:
            # if program completes, then u must be always 'wait' (0)
            # -> u_star = 0
            u_star = 0
            # if program complete, cost-to-go is 0
            V_star = 0
        else:
            # evaluate cost for all possible inputs
            C = np.zeros(N_input)
            for u in U_set:
                # u is the current input
                # next state if in state s we apply u
                x_next = DP_appliance_f(s, u)
                # total cost if at time t, state s, apply u
                C[u] = DP_appliance_stage_cost(s, u, t, price, power) + V[x_next, t+1]
            # find best input (u_star) and new cost-to-go value (V_star)
            # C is a row vector containing the costs associated to each input (0,1)
            u_star = np.argmin(C)
            V_star = C[u_star]
        # optimal input if in state x[k] at time t
        U[s, t] = u_star
        # cost-to-go if in state x[k] at time t
        V[s, t] = V_star

# simulate optimal policy
# initialize state trajectory
XX = np.zeros(T+1, dtype=int)
# initialize total cost
J = 0

for t in range(T):
    # compute next state using optimal policy stored in matrix U
    # input to apply at time t is U[XX[0, t], t]
    XX[t + 1] = DP_appliance_f(XX[t], U[XX[t], t])
    # update total cost
    J += DP_appliance_stage_cost(XX[t], U[XX[t], t], t, price, power)
# add terminal cost
J += DP_appliance_terminal_cost(XX[T], N_state)

# check total cost
print(f'Total cost with optimal policy (simulation): {J}')
print(f'Total cost with optimal policy (cost-to-go function): {V[XX[0], 0]}')

# plot results
DP_appliance_plot_results(U, XX, price, power)
