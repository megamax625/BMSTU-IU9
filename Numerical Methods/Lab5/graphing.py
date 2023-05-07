import operator
import matplotlib.pyplot as plt
import numpy as np
from functools import reduce

def countList(lst1, lst2):
    return reduce(operator.add, zip(lst1, lst2))

x = np.array([1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0])
y = np.array([0.31, 0.57, 1.67, 1.4, 1.18, 1.54, 1.55, 1.96, 2.42])
middleXs = np.array([1.25, 1.75, 2.25, 2.75, 3.25, 3.75, 4.25, 4.75])
middleYs = np.array([0.61222667, 1.1159644, 1.3545494, 1.4295509, 1.4425335, 1.4950662, 1.6887169, 2.1250486])
zs = np.array([0.22918646, 0.9035875, 1.2620529, 1.4061499, 1.4374461, 1.4575095, 1.5679035, 1.8701982, 2.4659634])

apprXs = np.append(countList(x, middleXs), x[-1])
apprYs = np.append(countList(zs, middleYs), zs[-1])

print(apprXs)
print(apprYs)

plt.plot(x, y, 'r')
plt.plot(apprXs, apprYs, 'b')

plt.show()