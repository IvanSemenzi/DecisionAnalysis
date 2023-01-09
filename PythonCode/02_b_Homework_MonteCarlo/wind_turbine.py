import numpy as np
from characteristic_curve import characteristic_curve
import matplotlib.pyplot as plt

N = 365                 # number of days to simulate
Ns = 24                 # samples per day (1/hour)

# simulate wind speed measurements
l = 8                   # lambda parameter
k = 1.6                 # kappa parameter

v = np.random.weibull(k, size=(N*Ns))*l

# simulate energy generation
e = np.array([])
for vh in v:
    e = np.append(e, characteristic_curve(vh))

# convert energy to [MWh]
e /= 1000

# display results
# each row of matrix energy is a day, each column is an hour
energy = np.reshape(e, (N, Ns))

# compute daily generated energy (sum along rows)
G = np.sum(energy, axis=1)

# mean and std
Gm = np.mean(G)
Gs = np.std(G)

# plot input data
fig = plt.figure(figsize=(5, 10))
subfig = fig.add_subplot(2, 1, 1)
subfig.set_title('Generated energy')
subfig.set(xlabel='Time [hours]', ylabel='Energy[MWh]')
plt.plot(e, 'r')
plt.grid()
subfig = fig.add_subplot(2, 1, 2)
subfig.set_title('Wind speed')
subfig.set(xlabel='Time [hours]', ylabel='Wind speed [m/s]')
plt.plot(v)
plt.grid()
plt.show()

# pdf
fig, ax = plt.subplots()
fig.suptitle('Histogram')
ax.set(xlabel='Daily energy [MWh]', ylabel='pdf')
plt.hist(G, bins='auto', density=True)
plt.grid()
plt.show()

# cdf
fig, ax = plt.subplots()
fig.suptitle('Empirical cdf')
ax.set(xlabel='Daily energy [MWh]', ylabel='cdf')
plt.hist(G, bins='auto', density=True, cumulative=True)
plt.grid()
plt.show()

# exceedance probabilities
#
# P90:   P(G>=P90) = 0.9
#  ->  1-P(G>=P90) = 0.1
#  ->    P(G< P90) = 0.1
#
# percentiles stores respectively the 10-25-50 percentile
# P90 is the 10th percentile

percentiles = np.percentile(G, [10., 25., 50.])

# write some results
print(f'Number of days: {N}')
print(f'Samples/day: {Ns}')
print('Daily Energy [MWh]')
print('-'*20)
print(f'Mean: {Gm}')
print(f'std dev: {Gs}')
print()
print(f'P90: {percentiles[0]}')
print(f'P75: {percentiles[1]}')
print(f'P50: {percentiles[2]}')
