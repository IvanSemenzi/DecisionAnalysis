"""
This file contains the python code for all the matlab functions
related to this exercise:

            DP_IC_f.m
            DP_IC_plot.m
            DP_IC_expected_cost.m
            DP_IC_stage_cost.m
            DP_IC_singlerun.m
            DP_IC_setup.m
            DP_IC_optimal_policy.m
"""

import numpy as np
import matplotlib.pyplot as plt


def DP_IC_setup():
    """

    :return:    (pW, cost, C, W_max, W_set)
                pW: row vector of demand probabilities ( possible values of demand are 0,...,length(pW)-1
                cost: [c1, c2], stage cost is gt = c1 + c2 * x_t
                C: maximum capacity
                W_max: maximum demand
                W_set: demand possible values
    """

    pW = np.array([0.2, 0.2, 0.3, 0.2, 0.1])    # pmf of demand values
    cost = np.array([10, 2], dtype=int)         # cost vector
    C = 10          # max capacity
    W_max = 4       # max demand
    W_set = np.arange(W_max+1, dtype=int)       # range of possible demand values (including W_max)

    return pW, cost, C, W_max, W_set


def DP_IC_f(s: int, u: int, w: int) -> int:
    """

    :param s:   current state
    :param u:   current input
    :param w:   current demand
    :return:    next state
    """

    return max(s + u - w, 0)


def DP_IC_stage_cost(s: int, u : int, cost: np.ndarray) -> int:
    """

    :param s:       current state
    :param u:       current input
    :param cost:    cost vector [c1, c2]
    :return:        stage cost at time t
    """

    if u == 0:      # no reordering, only storage cost
        g = cost[1] * s
    else:           # ordering cost + storage cost
        g = cost[0] + cost[1] * s

    return g


def DP_IC_singlerun(T: int, U: np.ndarray, x0: int):
    """

    :param T:       horizon for simulation
    :param U:       matrix U (n_state, T) stores the policy
    :param x0:      initial state
    :return:        x is the state trajectory over the simulation
                    u is the sequence of inputs chosen according to policy U
                    gt is the sequence of stage costs
                    W_real is a realization of the demand
    """

    # initialization
    pW, cost, C, W_max, W_set = DP_IC_setup()
    x = np.zeros(T+1, dtype=int)        # state
    gt = np.zeros(T, dtype=int)         # stage cost
    u = np.zeros(T, dtype=int)          # input

    # simulate stochastic demand
    W_real = np.random.choice(W_set, T, replace=True, p=pW)  # realizations of demand

    # main loop
    x[0] = x0
    for t in range(T):
        # use policy U to select the input
        # N.B. State x is in row x of matrix U (Python is great)
        u[t] = U[x[t], t]

        # next state (inventory level)
        x[t+1] = x[t] + u[t] - W_real[t]

        # compute stage cost
        gt[t] = DP_IC_stage_cost(x[t], u[t], cost)

    return x, u, gt, W_real


def DP_IC_expected_cost(s: int, u: int, V_next: np.ndarray) -> int:
    """

    :param s:           current state
    :param u:           current input
    :param V_next:      vector containing the optimal value function at next time for all possible states
    :return:            ec: expected cost=expected value of stage cost + cost-to-go
    """

    # initialization (W_max+1 is used as N_w)
    pW, cost, _, W_max, W_set = DP_IC_setup()

    # expected value of stage cost (deterministic => E[g]=g)
    esc = DP_IC_stage_cost(s, u, cost)

    # expected value of cost to go
    # compute all the possible next states and corresponding probabilities
    x_next = np.zeros(W_max+1, dtype=int)
    p_x_next = np.zeros(W_max+1, dtype=int)
    for l in range(W_max+1):
        # all possible next states
        x_next[l] = DP_IC_f(s, u, W_set[l])
        # corresponding probability
        p_x_next[l] = pW[l]

    # compute expected value
    ev = np.dot(p_x_next, V_next[x_next])
    for h in range(W_max+1):
        ev += p_x_next[h] * V_next[x_next[h]]

    # expected value of stage cost + cost-to-go
    ec = esc + ev

    return ec


def DP_IC_optimal_policy(T: int):
    """

    :param T:       time horizon for simulation
    :return:        U: matrix (n_state,T) storing the optimal policy (optimal input if at time t we are in state x)
                    V: matrix (n_state,T+1) storing the optimal cost-to-go if at time t we are in state x
    """

    # initialization
    _, _, C, W_max, _ = DP_IC_setup()

    N_state = C+1
    X_set = np.arange(N_state, dtype=int)           # possible states
    U_set = {}                                      # possible inputs

    # possible inputs depend on the current state
    # U_set[k] contains the possible input values when we are in state k
    for k in X_set:
        start = max(0, W_max - k)
        stop = C - k + 1
        U_set[k] = np.arange(start, stop, dtype=int)

    # optimal policy (optimal input at time t if in state x)
    U = np.zeros((N_state, T), dtype=int)
    # cost-to-go function
    V = np.zeros((N_state, T+1), dtype=int)

    # DP algorithm
    # 1. Initialization
    V[:, T] = np.zeros((N_state), dtype=int)         # no terminal cost

    # 2. Main Loop
    for t in range(T - 1, -1, -1):
        for k in range(N_state):
            # s is the current state
            s = X_set[k]
            # possible inputs for current state s
            U_aux = U_set[k]
            N_aux = len(U_aux)
            C_aux = np.zeros_like(U_aux)
            for h in range(N_aux):
                # u is the current input
                u = U_aux[h]
                # expected total cost if at time t and state s we apply input u
                C_aux[h] = DP_IC_expected_cost(s, u, V[:, t+1])
            # h_star is the index of the optimal input u_star
            # u_star will be U_aux(h_star)
            h_star = np.argmin(C_aux)
            u_star = U_aux[h_star]
            V_star = C_aux[h_star]
            # optimal input if in state x[k] at time t
            U[k, t] = u_star
            # cost-to-go if in state x[k] at time t
            V[k, t] = V_star

    return U, V


def DP_IC_plot(gt_star: np.ndarray, gt_h1: np.ndarray,
               gt_h2: np.ndarray, Nrun: int, T: int):
    """

    :param gt_star:     matrix (T, Nrun) with stage costs with optimal policy
    :param gt_h1:       matrix (T, Nrun) with stage cost with heuristic policy #1
    :param gt_h2:       matrix (T, Nrun) with stage cost with heuristic policy #2
    :param Nrun:        number of simulations
    :param T:           time horizon
    :return:            J_star: total cost for each run with optimal policy
                        J_h1: total cost for each run with heuristic #1
                        J_h2: total cost for each run with heuristic #2
    """

    # total costs for each run
    J_star = np.sum(gt_star, axis=0)
    J_h1 = np.sum(gt_h1, axis=0)
    J_h2 = np.sum(gt_h2, axis=0)

    # sample mean
    mJ_star = np.mean(J_star)
    mJ_h1 = np.mean(J_h1)
    mJ_h2 = np.mean(J_h2)

    # TOTAL COST OPTIMAL POLICY
    fig, ax = plt.subplots()
    fig.suptitle(f'Optimal policy - Total cost distribution from N={Nrun} simulation runs (T={T})')
    z_star, bins_star, _patches = ax.hist(J_star, bins=20, density=True, label='Histogram')
    ax.plot([mJ_star, mJ_star], [0, np.amax(z_star)], 'r', label=f'Mean = {round(mJ_star)}')
    ax.set(xlabel='Total cost', ylabel='Probability density')
    ax.legend()
    plt.grid()
    plt.show()

    # TOTAL COST HEURISTIC 1
    fig, ax = plt.subplots()
    fig.suptitle(f'Heuristic policy 1 - Total cost distribution from N={Nrun} simulation runs (T={T})')
    z_h1, bins_h1, _patches = ax.hist(J_h1, bins=20, density=True, label='Histogram')
    ax.plot([mJ_h1, mJ_h1], [0, np.amax(z_h1)], 'r', label=f'Mean = {round(mJ_h1)}')
    ax.set(xlabel='Total cost', ylabel='Probability density')
    ax.legend()
    plt.grid()
    plt.show()

    # TOTAL COST HEURISTIC 2
    fig, ax = plt.subplots()
    fig.suptitle(f'Heuristic policy 2 - Total cost distribution from N={Nrun} simulation runs (T={T})')
    z_h2, bins_h2, _patches = ax.hist(J_h2, bins=20, density=True, label='Histogram')
    ax.plot([mJ_h2, mJ_h2], [0, np.amax(z_h2)], 'r', label=f'Mean = {round(mJ_h2)}')
    ax.set(xlabel='Total cost', ylabel='Probability density')
    ax.legend()
    plt.grid()
    plt.show()

    # COMPARISON
    # compute the center of the bins
    bins_star = bins_star[:-1] + np.diff(bins_star)
    width_star = bins_star[1] - bins_star[0]
    bins_h1 = bins_h1[:-1] + np.diff(bins_h1)
    width_h1 = bins_h1[1] - bins_h1[0]
    bins_h2 = bins_h2[:-1] + np.diff(bins_h2)
    width_h2 = bins_h2[1] - bins_h2[0]

    fig, ax = plt.subplots()
    fig.suptitle(f'Total cost distribution from N={Nrun} simulation runs (T={T})', fontsize=13)
    ax.set(xlabel='Total cost', ylabel='Probability density')
    plt.bar(bins_h1, z_h1, color='blue', label='Heuristic 1')
    plt.bar(bins_h2, z_h2, color='green', label='Heuristic 2')
    plt.bar(bins_star, z_star, color='red', label='Optimal policy')
    ax.legend()
    plt.grid()
    plt.show()

    ax = plt.figure().add_subplot(projection='3d')
    ax.bar3d(bins_star, np.ones_like(bins_star), np.zeros_like(bins_star), width_star, 0.5, z_star, color='red')
    ax.bar3d(bins_h1, np.ones_like(bins_h1) * 2, np.zeros_like(bins_h1), width_h1, 0.5, z_h1, color='blue')
    ax.bar3d(bins_h2, np.ones_like(bins_h2) * 3, np.zeros_like(bins_h2), width_h2, 0.5, z_h2, color='green')
    ax.set_title('Total cost distribution: heuristic 1 (blue, heuristic 2 (green) and optimal (red)')
    ax.set_xlabel('Total cost')
    ax.set_ylabel('Policy')
    ax.set_zlabel('Probability density')
    ax.legend()
    plt.grid()
    plt.show()

    fig, ax = plt.subplots()
    fig.suptitle(f'Empirical cdf from N={Nrun} simulation runs (T={T})')
    ax.hist(J_star, bins=Nrun, density=True, cumulative=True, label='Optimal', histtype='step', color='red')
    ax.hist(J_h1, bins=Nrun, density=True, cumulative=True, label='Heuristic 1', histtype='step', color='blue')
    ax.hist(J_h2, bins=Nrun, density=True, cumulative=True, label='Heuristic 2', histtype='step', color='green')
    ax.set(xlabel='First order time', ylabel='Probability')
    ax.legend()
    plt.grid()
    plt.show()

    return J_star, J_h1, J_h2
