from methods import Matrix, Vector, plot, random_Matrix, random_Vector, get_Matrix_Norm
from matplotlib import pyplot as plt
import numpy as np # для тестирования
from danilevsky import Danilevsky
from gauss import Gauss

def single_Parameterized(A, f, tau, lambdas, x_real, err, toprint=False):
    n = len(f)
    mat = A.copy()
    b = f.copy()

    E = Matrix.create_empty(n, n)
    for i in range(n):
        E.matrix[i][i] = 1.0
    
    P = E - (mat * tau)
    g = b * tau

    if toprint:
        print("Matrix P:")
        print(P)
        print(f'Norm of P: {get_Matrix_Norm(P)}')
        print()
        print(f'g: {g}\n')

    mus = [abs(1 - tau * lambdas[i]) for i in range(len(lambdas))]
    mus_max = max(mus)
    # print(f'current tau: {tau}, mus: {mus}, Max mu: {mus_max}, Max mu <= 1? {abs(mus_max) < 1}')
    print(f'current tau: {tau}, Max mu: {mus_max}, Max mu <= 1? {abs(mus_max) < 1}')

    #try:
    #    assert(get_Matrix_Norm(P) < 1)
    #except AssertionError:
    #    print(f"assertion for matrix norm failed: ||P|| = {get_Matrix_Norm(P)}")
    #    return (0, np.inf)
    try:
        assert(abs(mus_max) < 1)
    except AssertionError:
        print(f"assertion for max mu failed: max|mu| = {abs(mus_max)}")
        return (0, np.inf)

    counter = 0
    initial = random_Vector(n, -1, 1)
    x_prev = initial.copy()
    fail = False
    while True:
        x_next = P * x_prev + g
        xn = Vector.norm(Vector([abs(x_next.vec[i] - x_real[i]) for i in range(n)]))
        xnpr = Vector.norm(Vector([abs(x_prev.vec[i] - x_real[i]) for i in range(n)]))
        if not fail and xn ** 2 > mus_max ** 2 * xnpr ** 2 + err:
            print(f'Method convergence condition failed for tau = {tau}: ||rx||^2 = {xn ** 2} > {mus_max ** 2} * ||rx-1||^2 = {xnpr ** 2}')
            fail = True
        if xn <= err:
            if toprint:
                print(f'count of iterations for tau = {tau} is {counter + 1}')
            return (x_next, counter)
        else:
            x_prev = Vector([x_next.vec[i] for i in range(n)])
            x_next = [0.0 for _ in range(n)]
            counter += 1
            # print(f"Xn: {xn}, counter: {counter}")


err_val = 10e-10

def main(n, a, b):
    f = random_Vector(n, a, b)

    A, roots = Danilevsky(n, a, b, err_val)
    print(roots)
    l_max = max(roots)
    l_min = min(roots)

    tau_opt = 2 / (l_min + l_max)
    tau_right = 2 / l_max
        
    print("Matrix A:")
    print(A)
    print()
    print(f'f: {f}')
    
    x_real = Gauss(A, f)
    print(f'Gauss solution: {x_real}\n')
    print(f'Lambdas: {roots}')
    print(f'Min lambda: {l_min}, Max lambda: {l_max}')
    print(f'Optimal tau: {tau_opt}, rightmost tau: {tau_right}')

    taus = np.linspace(0, tau_right, 100)[1:-1]
    iters = []

    # for tau_opt
    _, opt_count = single_Parameterized(A, f, tau_opt, roots, x_real, err_val, toprint=True)

    for tau in taus:
        _, count = single_Parameterized(A, f, tau, roots, x_real, err_val, toprint=False)
        iters.append(count)

    iters = np.array(iters)
    valid_indices = np.isfinite(iters)
    taus = taus[valid_indices]
    iters = iters[valid_indices]
    
    print(f'Optimal tau experimental: {taus[np.argmin(iters)]} with count of iterations = {iters.min()}')
    print(f'Diff between experimental and optimal tau: {abs(taus[np.argmin(iters)] - tau_opt)}')

    # plot graph(custom)
    fig, ax = plt.subplots()
    ax.plot(taus, iters, label='experiment plot')
    ax.plot(tau_opt, opt_count, c='red', marker='o', label='optimal')
    ax.plot(taus[np.argmin(iters)], iters.min(), c='orange', marker='o', label='experimental optimal')
    ax.grid(True, which='both')
    ax.set_xlim(0, tau_right)
    ax.set_ylim(0, max(iters))
    ax.legend()
    plt.show()


main(8, -10, 10)