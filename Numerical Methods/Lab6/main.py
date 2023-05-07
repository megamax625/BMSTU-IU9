import math
import sympy as sp

# Вариант 12: f(X) = exp(5 / (x1 ** 2 + x2 ** 2 + 1)) + cos(0.1 * x1 + 0.2 * x2)   X0 = (0, 0)

eps = 0.001
X0 = (0, 0)
x1, x2 = sp.symbols('x1 x2')
f = sp.exp(5 / (x1 ** 2 + x2 ** 2 + 1)) + sp.cos(0.1 * x1 + 0.2 * x2)

dfdx1 = f.diff(x1)
dfdx2 = f.diff(x2)

dfdx1dx1 = dfdx1.diff(x1)
dfdx1dx2 = dfdx1.diff(x2)
dfdx2dx2 = dfdx2.diff(x2)

# print(dfdx1)
# print(dfdx1.subs(x1, X0[0]).subs(x2, X0[1]))
# print(dfdx2)
# print(dfdx2.subs(x1, X0[0]).subs(x2, X0[1]))

gr = math.inf
iter = 1
X_old = (X0[0], X0[1])

while (gr > eps):
    print(gr, "iteration №" + str(iter))
    iter += 1
    phi1 = (-(dfdx1 ** 2) - (dfdx2 ** 2))
    phi2 = (dfdx1dx1 * (dfdx1 ** 2) + 2 * dfdx1dx2 * dfdx1 * dfdx2 + dfdx2dx2 * (dfdx2 ** 2))
    # print(phi1, phi2)
    phi1 = phi1.subs(x1, X_old[0]).subs(x2, X_old[1])
    phi2 = phi2.subs(x1, X_old[0]).subs(x2, X_old[1])
    # print(phi1, phi2)
    t = -phi1 / phi2
    X_new = (X_old[0] - t * dfdx1.subs(x1, X_old[0]).subs(x2, X_old[1]), X_old[1] - t * dfdx2.subs(x1, X_old[0]).subs(x2, X_old[1]))
    print(t.evalf(), X_new[0], X_new[1], gr)
    gr = max(abs(dfdx1.subs(x1, X_new[0]).subs(x2, X_new[1])), abs(dfdx2.subs(x1, X_new[0]).subs(x2, X_new[1])))
    X_old = (X_new[0], X_new[1])
    print(t.evalf(), X_new[0], X_new[1], gr)
