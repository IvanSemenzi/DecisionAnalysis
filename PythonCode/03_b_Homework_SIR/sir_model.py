# SIR Epidemic Model

# Adapted from a code written by Arezou Keshavarz
# for the course:
#
# EE365 Stochastic Control
# Stanford University

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap


# parameters
# network of qxq agents, connected in a grid, each of those identified with a pair (i,j)
q = 30
T = 100

# possible states of an agent
# Susceptible   (S) -> 1
# Infected      (I) -> 2
# Removed       (R) -> 3
s = [1, 2, 3]

# transition probability matrix when at least one neighbour is I
pSI1 = 0.4          # transition probability S -> I

P1 = np.array([[1-pSI1, pSI1, 0],
               [0.2, 0.6, 0.2],
               [0, 0, 1]])

# transition probability matrix when non neighbours are I
P2 = np.array([[1, 0, 0],
               [0.2, 0.6, 0.2],
               [0, 0, 1]])

# initialization
# X(i,j,t) is the state of agent (i,j) at time t
X = np.ones((q, q, T+1))

# agents (2,2) and (q-1,q-1) are initially I, the others are S
# recall numpy indexing starts from 0 while matlab from 1
X[1, 1, 0] = 2
X[q-2, q-2, 0] = 2

# S is blue, I is red, and R is green
colors = np.array([[0, 0, 1],
                   [1, 0.3, 0.3],
                   [0, 1, 0]])
cmap = ListedColormap(colors)

# plot initial state of the network, use plt.pcolor
# ATTENTION: plt.pcolor doesn't discard last row/column as pcolor does in matlab
fig, ax = plt.subplots()
fig.suptitle('S (blue), I (red), R (green) at t = 0')
plt.pcolor(X[:, :, 0], cmap=cmap)
plt.show()

# simulate MC evolution
for t in range(T):                                  # time index
    for r in range(q):                              # row index
        for c in range(q):                          # column index
            # check if at least one neighbour is I
            ni = 0
            if r > 0:
                ni += (X[r-1, c, t] == 2)
            if r < q-1:
                ni += (X[r+1, c, t] == 2)
            if c > 0:
                ni += (X[r, c-1, t] == 2)
            if c < q-1:
                ni += (X[r, c+1, t] == 2)
            # select the right transition probability
            if ni > 0:
                P = P1
            else:
                P = P2
            # generate state for agent (i,j) at time t+1
            # according to the transition probability matrix P

            # select the right row from P
            ps = P[int(X[r, c, t]) - 1, :]

            # generate a sample for the next state
            X[r, c, t+1] = np.random.choice(s, size=1, replace=True, p=ps)

    # update figure
    if t == 0:
        fig, ax = plt.subplots()
        fig.suptitle(f'S (blue), I (red), R (green) at t = {t}')
        plt.pcolor(X[:, :, t], cmap=cmap)
        plt.pause(2)
    else:
        ax.clear()
        fig.suptitle(f'S (blue), I (red), R (green) at t = {t}')
        plt.pcolor(X[:, :, t], cmap=cmap)
        plt.pause(0.05)

# compute and display results
# show the fraction of  S/I/R agents vs. time
nS = []
nI = []
nR = []
for t in range(T+1):
    nS.append(np.sum(X[:, :, t] == 1) / q ** 2)
    nI.append(np.sum(X[:, :, t] == 2) / q ** 2)
    nR.append(np.sum(X[:, :, t] == 3) / q ** 2)

fig, ax = plt.subplots()
fig.suptitle('Fraction of S/I/R agents')
plt.stackplot(np.arange(T+1),
              [nS, nI, nR],
              labels=('S', 'I', 'R'),
              colors=colors)
ax.set(xlabel='Time')
ax.legend()
plt.show()
