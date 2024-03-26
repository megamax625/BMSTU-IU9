from math import sqrt
# 4.Оценка погрешности вычисления объёма шара зажатого цилиндром

# приближения вычисления квадратного корня из двух
estimation1 = 7/5
estimation2 = 17/12

del1 = abs(sqrt(2) - estimation1)
del2 = abs(sqrt(2) - estimation2)
print("x1 = 7/5, Δx1 <=", del1)
print("x2 = 17/12, Δx2 <=", del2)

# три способа вычисления S
def S1(est):
    return (est - 1) ** 6
def S2(est):
    return (3 - 2 * est) ** 3
def S3(est):
    return 99 - 70 * est

# производные от них
def S1_deriv(est, delta):
    return abs(6 * (sqrt(2) - 1) ** 5) * delta / abs(S1(sqrt(2)))
def S2_deriv(est, delta):
    return abs(-6 * (3 - 2 * sqrt(2)) ** 2) * delta / abs(S2(sqrt(2)))
def S3_deriv(est, delta):
    return abs(-70) * delta / abs(S3(sqrt(2)))

print("Табличка значений S при различных способах вычисления и приближениях значения квадратного корня из двух")
print("√2\t (√2 - 1)^6\t (3 - 2√2)^3\t 99 - 70√2")
print("7/5\t", "{:.10f}".format(S1(estimation1)), "\t", "{:.10f}".format(S2(estimation1)), "\t", "{:.10f}".format(S3(estimation1)))
print("17/12\t", "{:.10f}".format(S1(estimation2)), "\t", "{:.10f}".format(S2(estimation2)), "\t", "{:.10f}".format(S3(estimation2)))

print("Оценка относительных погрешностей:")
print("√2\t (√2 - 1)^6\t (3 - 2√2)^3\t 99 - 70√2")
print("7/5\t", "{:.10f}".format(S1_deriv(estimation1, del1)), "\t", "{:.10f}".format(S2_deriv(estimation1, del1)), "\t", "{:.10f}".format(S3_deriv(estimation1, del1)))
print("17/12\t", "{:.10f}".format(S1_deriv(estimation2, del2)), "\t", "{:.10f}".format(S2_deriv(estimation2, del2)), "\t", "{:.10f}".format(S3_deriv(estimation2, del2)))