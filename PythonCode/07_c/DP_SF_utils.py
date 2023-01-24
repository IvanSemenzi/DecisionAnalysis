"""
This file contains the python code for all the matlab functions
related to this exercise:

            DP_SF_plot_circle.m
            DP_SF_expected_cost.m
            DP_SF_singlerun.m
            DP_SF_animation.m
            DP_SF_optimal_policy.m
"""

import numpy as np
import matplotlib.pyplot as plt
import math


def DP_SF_plot_circle(center: np.ndarray, r: int, N_points: int, color: str) -> plt.Polygon:
    """

    :param center:      center of the circle (center=[xc, yc])
    :param r:           radius of the circle
    :param N:           number of points used to draw the circle
    :param color:       color of the circle
    :return:            the circle (plt.Polygon object)
    """

    theta = np.linspace(0, 2*math.pi, num=N_points)
    x = r * np.cos(theta) + center[0]
    y = r * np.sin(theta) + center[1]
    h = plt.fill(x, y, color=color)
    plt.axis('equal')

    return h


def DP_SF_animation(x: np.ndarray, N_state: int, centers: np.ndarray, r: int, R: int, N_points: int, T: int):
    """

    :param x:           state ([position of fly @t, position of spider @t])
    :param N_state:     number of states
    :param centers:     centers of each little circle (one for each column)
    :param r:           radius of each little circle
    :param R:           radius of the big circle
    :param N_points:    number of points for drawing each little circle
    :param T:           time needed to catch the fly (in this simulation)
    :return:
    """

    # single run results
    # animation
    fig, ax = plt.subplots()

    # initialize
    hh = []
    for k in range(N_state):
        center = centers[:, k]
        hh.append(DP_SF_plot_circle(center, r, N_points, color='white'))
        plt.text(center[0] - r, center[1] - r, str(k))

    ax.set(ylim=(-1.2 * R, 1.2 * R), aspect='equal')

    for t in range(T):
        fig.suptitle(f'Fly (green) and spider (magenta) at time t={t}', fontsize='12')
        # draw fly
        plt.setp(hh[x[t, 0]], color='g')
        # draw spider
        plt.setp(hh[x[t, 1]], color='m')

        if t == 0:
            plt.pause()
        else:
            plt.pause(1)
        # delete fly
        plt.setp(hh[x[t, 0]], color='w')
        # delete spider
        plt.setp(hh[x[t, 1]], color='w')

    fig.suptitle(f'Caught at time t={t}', fontsize='12')
    plt.setp(hh[x[t, 0]], color='k')


def DP_SF_expected_cost(ii: int, jj: int, u: int, V_curr: np.ndarray, N_state: int, p: int) -> float:
    """

    :param ii:          current position of the fly
    :param jj:          current position of the spider ([ii, jj] is the current state of the system)
    :param u:           current input
    :param V_curr:      matrix (N_state x N_state) containing the current approximation of the value function
    :param N_state:     number of states
    :param p:           the fly moves clockwise (p), counterclockwise (p) or stands in place (1 - 2p)
    :return:            ec: expected cost = expected value of stage cost + value function
    """

    # expected value of  stage cost
    esc = 1

    # expected value of cost to go
    # fly position: all possible next positions
    x1_next = np.zeros(3, dtype=int)
    if ii == 0:                         # first position
        # possible next position
        x1_next[0] = N_state - 1        # moves counterclockwise
        x1_next[1] = 0                  # stands still
        x1_next[2] = 1                  # moves clockwise
    elif ii == N_state - 1:             # last position
        # possible next position
        x1_next[0] = N_state - 2        # moves counterclockwise
        x1_next[1] = N_state - 1        # stands still
        x1_next[2] = 0                  # moves clockwise
    else:                               # all other positions
        # possible next position
        x1_next[0] = ii - 1             # moves counterclockwise
        x1_next[1] = ii                 # stands still
        x1_next[2] = ii + 1             # moves clockwise

    # corresponding probabilities
    p_x1_next = np.array([p, 1-2*p, p])

    # spider position
    x2_next = jj + u
    if x2_next == 0:                    # wrap around
        x2_next = N_state - 1
    elif x2_next == N_state - 1:
        x2_next = 0

    # expected value
    ev = np.dot(p_x1_next, V_curr[x1_next, x2_next])
    ec = esc + ev

    return ec


def DP_SF_optimal_policy(N_state: int, p: int):
    """

    :param N_state:     number of states
    :param p:           the fly moves clockwise (p), counterclockwise (p) or stands in place (1 - 2p)
    :return:            uu:     uu(i,j) is the optimal input when in state (i,j)
                        vv:     vv(i,j) is optimal value function when starting from state (i,j)
                        U_aux:  3d matrix, stores uu at each iteration
                        V_aux:  3d matrix, stores vv at each iteration
    """

    # parameters and initialization
    # optimal policy: uu = optimal input when in state x
    uu = np.zeros((N_state, N_state), dtype=int)
    # value function when starting from x
    vv = np.zeros((N_state, N_state), dtype=float)

    # auxiliary matrices to trace convergence of uu and vv
    U_aux = np.zeros((N_state, N_state))        # will grow dynamically at each iteration
    V_aux = np.zeros((N_state, N_state))        # will grow dynamically at each iteration

    # possible inputs
    U_set = np.array([-1, 0, 1], dtype=int)
    N_u = len(U_set)

    # auxiliary cost vector
    C_aux = np.zeros(N_u)

    # value iteration algorithm
    # DP algorithm: Value iteration START
    # 1. Initialization (V_aux already initialized)
    # 2. Main Loop
    # stopping citerion
    delta = 0.001
    h = 0
    while True:
        h += 1
        for i in range(N_state):
            for j in range(N_state):
                if i == j:      # caught
                    # input must be U_set[1] = 0
                    u_star = 1
                    # value function is zero
                    V_star = 0
                else:
                    # for all states, consider possible inputs u
