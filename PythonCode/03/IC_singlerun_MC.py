"""
The function takes the time horizon T_max and the max capacity C_max

returns the simulated states x, orders u, stage costs gt and demands W_real
DATA ARE RETURNED AS COLUMN VECTORS
"""

import numpy as np

def IC_singlerun_MC(T_max:int):

    C_max = 10                                          # max capacity of the storage
    W_max = 4                                           # max demand
    pW = np.array([0.2, 0.2, 0.3, 0.2, 0.1])            # vector of  probabilities
    x_min = 4                                           # minimum number of elements in stock before reordering
    c1 = 10                                             # fixed cost for reordering
    c2 = 2                                              # unitary stage cost

    # transition probability matrix
    pWf = np.flip(pW)                                   # flips the probability vector
    P = np.zeros((C_max + 1, C_max + 1))                # initialize the transition probability matrix
    for i in range(C_max + 1):
        if i < x_min:
            P[i, 6:] = pWf
        else:
            P[i, i-4:i+1] = pWf                         # for readability (i-4 results from i-x_min
                                                        # and i+1 from i-x_min+len(pWf)
    # preallocating vectors
    x = np.zeros(T_max + 1, dtype=int)                  # state (elements in stock)
    gt = np.zeros(T_max, dtype=int)                     # stage cost
    u = np.zeros(T_max, dtype=int)                      # input (elements ordered)

    x[0] = C_max                                        # initial condition

    for t in range(T_max):
        if x[t] < x_min:                                # reorder
            u[t] = C_max - x[t]                         # number of elements to reorder
            gt[t] = c1 + c2*x[t]                        # cost of the order + stocking
        else:                                           # no reorder
            u[t] = 0
            gt[t] = c2*x[t]

        # select the pmf of the next state
        # ATTENTION:    x(t) = 0,1,2,...,C_max
        #               index of matrix P = 0,1,2,...,C_max
        #               if x(t)=i -> take row i of matrix P
        r = P[x[t], :]

        # sample next state
        x[t+1] = np.random.choice(np.arange(C_max + 1, dtype=int), 1, replace=True, p=r)

    # returned as row vectors
    return x.reshape((-1, 1)), u.reshape((-1, 1)), gt.reshape((-1, 1))
