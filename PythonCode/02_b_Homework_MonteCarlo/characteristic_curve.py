import numpy as np


def characteristic_curve(vh):
    vi = 3                  # cut-in speed
    vr = 15                 # rated speed
    vo = 25                 # cut-out speed
    E = 2000                # max generated energy [kWh]

    # energy during hour h (eh) for given wind speed (vh)
    if vh < vh:
        eh = 0
    elif vh < vr:
        eh = (E * (vh - vi)**3)/((vr - vi)**3)
    elif vh < vo:
        eh = E
    else:
        eh = 0

    eh = np.asarray(eh)
    return eh
