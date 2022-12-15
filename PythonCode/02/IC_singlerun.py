"""
The function takes the time horizon T_max and the max capacity C_max

returns the simulated states x, orders u, costs gt and demands W_real
"""

import numpy as np

def IC_singlerun(T_max:int, C_max:int) -> (int, int, int, int):

    W_max = 4                                           # max demand
    pW = np.array([0.2, 0.2, 0.3, 0.2, 0.1])            # vector of  probabilities
    x_min = 4                                           # minimum number of elements in stock before reordering
    c1 = 10                                             # fixed cost for reordering
    c2 = 2                                              # unitary stage cost

    # preallocating vectors
    x = np.zeros(T_max + 1)                             # state (elements in stock)
    gt = np.zeros(T_max)                                # stage cost
    u = np.zeros(T_max)                                 # input (elements ordered)

    W_real = np.random.choice(np.arange(W_max + 1), T_max, replace=True, p=pW)  # realizations of demand

    x[0] = C_max                                        # initial condizion

    for t,w in enumerate(W_real):
        if x[t] < x_min:                                # reorder
            u[t] = C_max - x[t]                         # number of elements to reorder
            gt[t] = c1 + c2*x[t]                        # cost of the order + stocking
        else:                                           # no reorder
            u[t] = 0
            gt[t] = c2*x[t]
        x[t+1] = x[t] + u[t] - w                        # state update

    return x, u, gt, W_real