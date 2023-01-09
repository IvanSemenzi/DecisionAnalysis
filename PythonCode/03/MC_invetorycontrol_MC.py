import numpy as np
from IC_singlerun_MC import IC_singlerun_MC
import matplotlib.pyplot as plt

N_run = 1000                        # number of simulations
T_max = 100                         # length of eah run

# run 1000 simulations over a horizon of 100
for r in range(N_run):
    if r == 0:
        x, u, gt = IC_singlerun_MC(T_max)
    else:
        _x, _u, _gt = IC_singlerun_MC(T_max)
        x = np.append(x, _x, axis=1)
        u = np.append(u, _u, axis=1)
        gt = np.append(gt, _gt, axis=1)

# total cost
J = np.sum(gt, axis=0)              # cost for each run (sum over the columns)
mJ = np.mean(J)                     # avg total cost

fig, ax = plt.subplots()
fig.suptitle('Total cost distribution')
z, _bins, _patches = ax.hist(J, bins=20, density=True, label='Histogram')     # pdf (bins and patches are returned but not used)
ax.plot([mJ, mJ], [0, np.amax(z)], 'r', label=f'Mean = {round(mJ)}')          # mean
ax.set(xlabel='Total cost', ylabel='Probability density')
ax.legend()
plt.show()

# stage cost std dev
mJs = np.mean(gt, axis=1)                                                   # mean along columns
stdJs = np.std(mJs)

fig, ax = plt.subplots()
fig.suptitle('Average stage cost')
ax.plot(mJs, 'b', label='Mean')
ax.plot(mJs + stdJs, '--r', label='+/- std')
ax.plot(mJs - stdJs, '--r')
ax.set(xlabel='Time', ylabel='Cost')
ax.legend()
plt.show()

# first order time histogram
Fo = np.empty((1, N_run), dtype=int)                                        # row vector
for h in range(N_run):
    Fo[0, h] = next((i for i, x in enumerate(u[:, h]) if x), None)          # vectors containing the time of the first order for each run

mFo = np.mean(Fo)

# relative frequencies
fig, ax = plt.subplots()
fig.suptitle('First order time distribution')
nFo, edges = np.histogram(Fo, density=True)
ax.stem(edges[:-1], nFo, linefmt='b', label='Relative frequencies')
ax.plot([mFo, mFo], [0, np.amax(nFo)], 'r', label=f'Mean value = {round(mFo, 3)}')
ax.set(xlabel='First order time', ylabel='Probability')
ax.legend()
plt.show()

# time between consecutive orders
To = np.array([], dtype=int)
for h in range(N_run):
    To_h = np.array([i for i, x in enumerate(u[:, h]) if x])                 # stores each time at which an order was placed
    To = np.append(To, np.diff(To_h))                                       # appends the 1-step differences

mTo = np.mean(To)

# time to reorder
fig, ax = plt.subplots()
fig.suptitle('Time between orders distribution')
nTo, edges = np.histogram(To, density=True)
ax.stem(edges[:-1], nTo, linefmt='b', label='Relative frequencies')
ax.plot([mTo, mTo], [0, np.amax(nTo)], 'r', label=f'Mean value = {round(mTo, 2)}')
ax.set(xlabel='Time between consecutive orders', ylabel='Probability')
ax.legend()
plt.show()

# state distribution
# C_max = 10
C_max = np.amax(x)
for t, row in enumerate(x):                                                 # row contains states of all the runs at time t
    nX, edges = np.histogram(row, bins=[i for i in range(C_max + 2)], density=True)
    if t == 0:
        fig, ax = plt.subplots()
        fig.suptitle(f'State distribution at t={t}')
        ax.stem(edges[:-1], nX, linefmt='b', label='Relative frequencies')
        ax.set(xlabel='Inventory level', ylabel='Probability')
        plt.axis([-1, C_max+1, 0, 1])
        plt.pause(2)
    else:
        ax.clear()
        fig.suptitle(f'State distribution at t={t}')
        ax.stem(edges[:-1], nX, linefmt='b', label='Relative frequencies')
        if t < 5:
            plt.pause(2)
        else:
            plt.pause(0.1)
