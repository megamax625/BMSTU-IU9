import numpy as np
import matplotlib.pyplot as plt
import math

N = 128
r = 7 # т.к. 2 ** 7 = 128
def func(x):
    return abs(math.cos(2 * math.pi * x))

def binary_decomposition(x):
    b = bin(x)
    ds = [int(d) for d in str(b)[str(b).find('b')+1:]]    # отрезаем 0b от строки и в массив
    res = ds[::-1] + [0] * (r - len(ds))
        # print(b, r, len(ds), i, res)
    return tuple(res)

memoized_As = {}

def A0(qs, js):
    sum = 0
    for i in range (r, 0, -1):
        sum += js[i - 1] * 2 ** (r - i)
    memoized_As[(tuple(qs), tuple(js))] = fs[sum]
    return fs[sum]

def Am(qs, js, m):
    if (tuple(qs), tuple(js)) in memoized_As:
        return memoized_As[(tuple(qs), tuple(js))]
    if m == 0:
        return A0(qs, js)
    sum = 0
    sum += 1/2 * np.exp(0) * Am(qs[:-1], [0] + js, m - 1)
    tail_sum = 0
    for i in range(1, m + 1):
        tail_sum += qs[i - 1] * 2 ** (i - 1)
    sum += 1/2 * np.exp(-2 * math.pi * 1j * 2 ** (-m) * tail_sum) * \
        Am(qs[:-1], [1] + js, m - 1)
    memoized_As[(tuple(qs), tuple(js))] = sum
    return sum.real

def Aq(qs):
    return Am(qs, [], r)

def approx_f(x):
    sum = 0
    for q in range(-int(N/2), int(N/2)):
        sum += Aq(binary_decomposition(q)) * np.exp(2 * math.pi * 1j * q * x)
    return sum.real

xs = np.array([j / N for j in range(N)])
fs = np.array([func(xs[j]) for j in range(N)])
appr_fs = np.array([approx_f(xs[j]) for j in range(N)])

max_abs_diff = np.max(abs(fs - appr_fs))
print(xs)
print(appr_fs)
print()
print("Δ = ", max_abs_diff)

plt.plot(xs, fs, 'r')
plt.plot(xs, appr_fs, 'b')
plt.show()

mid_xs = np.array([0.5 + j/N for j in range (N)])
mid_fs = np.array([func(mid_xs[j]) for j in range(N)])
mid_appr_fs = np.array([approx_f(mid_xs[j]) for j in range(N)])
max_mid_abs_diff = np.max(abs(mid_fs - mid_appr_fs))

print(mid_xs)
print(mid_appr_fs)
print()
print("Δmid = ", max_mid_abs_diff)

plt.plot(mid_xs, mid_fs, 'r')
plt.plot(mid_xs, mid_appr_fs, 'b')
plt.show()
