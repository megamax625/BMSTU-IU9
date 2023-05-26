import math
import sympy as sp

eps = 0.001
X0 = (0, 0)
x1, x2 = sp.symbols('x1 x2')
f = x1 ** 2 + 4 * x1 * x2 + 17 * x2 ** 2 + 5 * x2

dfdx1 = f.diff(x1)
dfdx2 = f.diff(x2)

dfdx1dx1 = dfdx1.diff(x1)
dfdx1dx2 = dfdx1.diff(x2)
dfdx2dx2 = dfdx2.diff(x2)

print("Symbolic derivatives:\ndfdx1 =", dfdx1)
print("dfdx2 = ", dfdx2)
print("dfdx2dx1 = ", dfdx1dx1)
print("dfdx1dx2 = ", dfdx1dx2)
print("dfdx2dx2 = ", dfdx2dx2)
print("\ndfx1(0,0) = ", dfdx1.subs(x1, X0[0]).subs(x2, X0[1]).evalf())
print("dfdx2(0,0) = ", dfdx2.subs(x1, X0[0]).subs(x2, X0[1]).evalf())
print("dfx1x1(0,0) = ", dfdx1dx1.subs(x1, X0[0]).subs(x2, X0[1]).evalf())
print("dfx1x2(0,0) = ", dfdx1dx2.subs(x1, X0[0]).subs(x2, X0[1]).evalf())
print("dfx2x2(0,0) = ", dfdx2dx2.subs(x1, X0[0]).subs(x2, X0[1]).evalf(), "\n")

gr = math.inf
iter = 1
X_old = (X0[0], X0[1])

while (gr > eps):
    print("iteration №" + str(iter))
    phi1 = -dfdx1.subs({x1: X_old[0], x2: X_old[1]}) ** 2 - dfdx2.subs({x1: X_old[0], x2: X_old[1]}) ** 2
    phi2 = (dfdx1dx1.subs({x1: X_old[0], x2: X_old[1]}) * dfdx1.subs({x1: X_old[0], x2: X_old[1]}) ** 2
            + 2 * dfdx1dx2.subs({x1: X_old[0], x2: X_old[1]}) * dfdx1.subs({x1: X_old[0], x2: X_old[1]}) * dfdx2.subs({x1: X_old[0], x2: X_old[1]})
            + dfdx2dx2.subs({x1: X_old[0], x2: X_old[1]}) * dfdx2.subs({x1: X_old[0], x2: X_old[1]}) ** 2)
    if phi1 != 0 and phi2 != 0:
        t = -phi1 / phi2
    else:
        t = sp.sympify(0.5)
    X_new = (X_old[0] - t * dfdx1.subs(x1, X_old[0]).subs(x2, X_old[1]), X_old[1] - t * dfdx2.subs(x1, X_old[0]).subs(x2, X_old[1]))
    #print("Values: ", phi1.evalf(), phi2.evalf(), t.evalf())
    #print(t.evalf(), X_new[0].evalf(), X_new[1].evalf(), gr)
    gr = max(abs(dfdx1.subs(x1, X_new[0]).subs(x2, X_new[1])), abs(dfdx2.subs(x1, X_new[0]).subs(x2, X_new[1])))
    X_old = (X_new[0], X_new[1])
    print("t =", t.evalf(), "x1(" + str(iter) + ") =", X_old[0].evalf(), "x2(" + str(iter) + ") =", X_old[1].evalf(), "grad =", gr.evalf())
    iter += 1
print("Resulting minimum: (" + str(X_new[0].evalf()) + ", " + str(X_new[1].evalf()) + ")")
# Аналитический минимум = (5/13, -5/26)
X_analytical = (5/13, -5/26)
print("Analytical result = (" + str(5/13) + ", " + str(-5/26) + ")")
print("Result error from analytical = (" + str(abs(X_analytical[0] - X_new[0])) + ", " + str(abs(X_analytical[1] - X_new[1])) + ")")