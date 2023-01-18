"""
This file contains the python code for all the matlab functions
related to this exercise:

            DP_appliance_f.m
            DP_appliance_plot_results.m
            DP_appliance_stage_cost.m
            DP_appliance_terminal_cost.m
"""
import numpy as np
import matplotlib.pyplot as plt


def DP_appliance_f(x: int, u: int) -> int:
    """

    :param x:       current state
    :param u:       current input
    :return:        next state

    input u can be:
        u=0 wait
        u=1 run next washing cycle
    """
    return x+u


def DP_appliance_plot_results(U: np.ndarray,
                              XX: np.ndarray,
                              price: np.ndarray,
                              power: np.ndarray):
    """

    :param U:       contains the optimal policy
    :param XX:      contains the state trajectory
    :param price:   contains the energy price at each time step
    :param power:   contains the power consumption of each cycle
    """
    # display optimal policy
    # each row is a state, each column is a time instant
    # N_state is #states, T is #time_instants
    N_state, T = U.shape

    # visualize matrix U
    fig, ax = plt.subplots()
    fig.suptitle(r'Optimal policy $\mu_t(s)$: 0 wait (purple), 1 run (yellow)', fontsize=13)
    ax.set(xlabel='Time [15min]', ylabel='State')
    plt.pcolor(U)
    plt.show()

    # compare with naive policy
    # optimal policy: find when we run, i.e. when the state changes
    # UU(t) = 0 wait at time t
    # UU(t) = 1 run at time t
    UU = np.diff(XX)

    # naive policy: run the 5 cycles during the 5 cheapest time slots
    sorted_index = np.argsort(price)        # returns the index in the order that sorts the array (ascending)

    # cost comparison
    naive_cost = np.dot(price[np.sort(sorted_index[: N_state - 1])], power[: N_state - 1]) / 4
    opt_cost = np.dot(price[np.nonzero(UU)], power[: N_state - 1]) / 4

    # relative gain
    rel_gain = (naive_cost - opt_cost)/naive_cost * 100

    # compare with naive policy: Display when we run
    fig, ax = plt.subplots()
    fig.suptitle(f'Naive cost = {naive_cost}\n Optimal cost = {opt_cost}\n Relative gain = {round(rel_gain, 2)}%', fontsize=13)
    ax.set(xlabel='Time [15min]', ylabel='Energy price [EUR/kWh]')
    # plot the prices at each time slot
    plt.bar(np.arange(len(price)), price, align='edge', label='Energy prices')
    # plot when we run according to naive policy (green slots)
    plt.bar(sorted_index[: N_state - 1], price[sorted_index[: N_state - 1]], align='edge', color='green', label='Naive policy')
    # plot when we run according to optimal policy (red slots)
    plt.bar(np.arange(len(UU)), 0.02 * UU, align='edge', color='red', label='Optimal policy')
    ax.legend()
    plt.show()


def DP_appliance_stage_cost(x: int, u: int, t: int,
                            price: np.ndarray, power: np.ndarray) -> int:
    """

    :param x:           current state
    :param u:           current input
    :param t:           current time
    :param price:       energy price vector
    :param power:       power consumption profile
    :return:            stage cost at time t

    input u can be:
        u=0 wait
        u=1 run next washing cycle
    """
    g = (price[t] * power[x] * u) / 4

    # N.B. Each washing cycle lasts 1 / 4 hour, price(t) is in EUR / kWh
    #      power(x) is in kW. So, 1 / 4 * power(x) is the amount of
    #      energy required by x-th washing cycle( in kWh)

    return g


def DP_appliance_terminal_cost(xT: int, N_state: int)-> int:
    """

    :param xT:          terminal state at final time T
    :param N_state:     objective state to reach within T
    :return:            terminal cost is set to inf to force the system to reach the target state
    """

    if xT == N_state - 1:
        gT = 0              # program completed
    else:
        gT = 1e+6           # theoretically should be +inf, set to this to avoid errors

    return gT
