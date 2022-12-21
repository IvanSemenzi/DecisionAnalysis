"""
The function takes the time horizon T_max and the max capacity C_max

returns the simulated states x, orders u, stage costs gt and demands W_real
DATA ARE RETURNED AS COLUMN VECTORS
"""

import numpy as np

def IC_singlerun(T_max:int) -> (int, int, int, int):

    C_max = 10                                          # max capacity of the storage
    W_max = 4                                           # max demand
    pW = np.array([0.2, 0.2, 0.3, 0.2, 0.1])            # vector of  probabilities
    x_min = 4                                           # minimum number of elements in stock before reordering
    c1 = 10                                             # fixed cost for reordering
    c2 = 2                                              # unitary stage cost

    # preallocating vectors
    x = np.zeros(T_max + 1, dtype=int)                  # state (elements in stock)
    gt = np.zeros(T_max, dtype=int)                     # stage cost
    u = np.zeros(T_max, dtype=int)                      # input (elements ordered)

    W_real = np.random.choice(np.arange(W_max + 1, dtype=int), T_max, replace=True, p=pW)  # realizations of demand

    x[0] = C_max                                        # initial condition

    for t,w in enumerate(W_real):
        if x[t] < x_min:                                # reorder
            u[t] = C_max - x[t]                         # number of elements to reorder
            gt[t] = c1 + c2*x[t]                        # cost of the order + stocking
        else:                                           # no reorder
            u[t] = 0
            gt[t] = c2*x[t]
        x[t+1] = x[t] + u[t] - w                        # state update

    # returned as row vectors
    return x.reshape((-1, 1)), u.reshape((-1, 1)), gt.reshape((-1, 1)), W_real.reshape((-1, 1))
