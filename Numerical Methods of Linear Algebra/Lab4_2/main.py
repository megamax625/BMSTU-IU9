from methods import Matrix, Vector, plot
import random
import numpy as np # для тестирования

def random_Matrix(n, a, b):
    res = Matrix.create_empty(n, n)
    for i in range(n):
        for j in range(i, n):
            randv = random.random() * a + random.random() * b
            res.matrix[i][j] = randv
            res.matrix[j][i] = randv
    # print(res.matrix)
    return res

def Viet_Check(lambdas, mat):
    diff = abs(sum(lambdas) - sum([mat.matrix[i][i] for i in range(len(mat))]))
    # print("Diff of lambdas' sum and matrix's trace:", diff, " diff < err?", diff < err_viet)
    return diff

def orthonormality_Check(vecs):
    ok = True
    for i in range(len(vecs)):
        for j in range(i + 1, len(vecs)):
            scalar = Vector.scalar(vecs[i], vecs[j])
            if abs(scalar) >= err_orth:
                print(f'Scalar of vectors {vecs[i]}, {vecs[j]}: {scalar}, < err? {abs(scalar) < err_orth}')
                ok = False
        self_scalar = Vector.scalar(vecs[i], vecs[i])
        if abs(self_scalar - 1) >= err_orth:
            print(f'Self-scalar for vector {vecs[i]}: {self_scalar}, < err? {abs(self_scalar - 1) < err_orth}')
            ok = False
    if ok:
        print("Orthonormality confirmed")


def GGorin(mat):
    centres = [mat.matrix[i][i] for i in range(len(mat))]
    radii = [sum([mat.matrix[i][j] for j in range(len(mat.matrix[i])) if i != j]) for i in range(len(mat.matrix))]
    intervals = [(centres[i] - radii[i], centres[i] + radii[i]) for i in range(len(mat))]
    # print(centres)
    # print(radii)
    # for i in intervals:
    #     print(i[0], i[1])
    counts = []
    counts.append(1)

    intervals.sort(key=lambda i: i[0])
    unified_intervals = [intervals[0]]
    for interval in intervals[1:]:
        rightmost_interval = unified_intervals[-1]
        if interval[0] <= rightmost_interval[1]:
            unified_intervals[-1] = (rightmost_interval[0], max(rightmost_interval[1], interval[1]))
            counts[-1] += 1
        else:
            unified_intervals.append(interval)
            counts.append(1)

    return unified_intervals, counts

def Frobenius(mat):
    A = Matrix.copy(mat)
    n = len(A)
    Bs = []
    Brs = []
    Ds = []
    for k in range(n - 1):
        Bs.append(Matrix.create_empty(n, n))
        Brs.append(Matrix.create_empty(n, n))

        for i in range(n):
            if i != n - k - 2:
                for j in range(n):
                    if i == j:
                        Bs[k].matrix[i][j] = 1
                        Brs[k].matrix[i][j] = 1
                    else:
                        Bs[k].matrix[i][j] = 0
                        Brs[k].matrix[i][j] = 0
            else:
                if k == 0:
                    for j in range(n):
                        if i == j:
                            Bs[k].matrix[i][j] = 1 / A.matrix[n - k - 1][n - k - 2]
                        else:
                            Bs[k].matrix[i][j] = -A.matrix[n - k - 1][j] / A.matrix[n - k - 1][n - k - 2]
                        Brs[k].matrix[i][j] = A.matrix[n - k - 1][j]           
                else:
                    for j in range(n):
                        if i == j:
                            Bs[k].matrix[i][j] = 1 / Ds[k - 1].matrix[n - k - 1][n - k - 2]
                        else:
                            Bs[k].matrix[i][j] = -Ds[k - 1].matrix[n - k - 1][j] / Ds[k - 1].matrix[n - k - 1][n - k - 2]
                        Brs[k].matrix[i][j] = Ds[k - 1].matrix[n - k - 1][j]
        if k == 0:
            Ds.append(Brs[k] * A * Bs[k])
        else:
            Ds.append(Brs[k] * Ds[k - 1] * Bs[k])
        # print(f'B{k+1}:')
        # print(Bs[k])
        # print()
        # print(f'Br{k+1}:')
        # print(Brs[k])
        # print()
        # print(f'D{k+1}:')
        # print(Ds[k])
        # print()
    B = Bs[0]
    for i in range(1, len(Bs)):
        B = B * Bs[i]
    return Ds[-1].matrix[0], B

def polynomial_func(P):
    def polynom(x):
        res = x ** len(P)
        for i, val in enumerate(P):
            res -= val * x ** (len(P) - i - 1)
        return res
    return polynom

def find_roots(GG_union, func, n):
    roots = []
    num = n ** 4
    for interval in GG_union:
        xi = interval[0]
        r_bound = interval[1]
        inter_len = r_bound - xi
        step = inter_len / num
        while xi + step < r_bound:
            if (func(xi) * func(xi + step / 2) < 0):
                root = find_root(xi, xi + step / 2, func)
                roots.append(root)
            elif (func(xi + step / 2) * func(xi + step) < 0):
                root = find_root(xi + step / 2, xi + step, func)
                roots.append(root)
            xi = xi + step
    return roots

def find_root(l, r, func):
    inter_len = r - l
    mid = l + inter_len / 2
    if inter_len * 2 < err_val:
        return mid
    else:
        if (func(l) * func(mid) < 0):
            return find_root(l, mid, func)
        elif (func(mid) * func(r) < 0):
            return find_root(mid, r, func)
        else:
            return None

def check_GGorin_interval_counts(roots, intervals, counts):
    ok = True
    for i in range(len(intervals)):
        count = 0
        for root in roots:
            if (intervals[i][0] <= root <= intervals[i][1]):
                count += 1
        if count != counts[i]:
            # print(f'Mismatch of root count for interval [{intervals[i][0]} - {intervals[i][1]}], required={counts[i]}, actual={count}')
            ok = False
    # if ok:
        # print("GGorin condition satisfied")
    return ok

def Danilevsky(matrix, mode, semilogy=False, xl=-10, xr=10, yl=-10, yh=10, pointNum=1000):
    n = len(matrix)

    GG_Bounds, counts = GGorin(matrix)

    P, B = Frobenius(matrix)


    A_char = polynomial_func(P)


    roots = find_roots(GG_Bounds, A_char, n)

    Viet_Check(roots, matrix)
    if not check_GGorin_interval_counts(roots, GG_Bounds, counts):
        return Danilevsky(random_Matrix(len(matrix), -15, 15), mode)

    # print("Union of GGorin intervals:", GG_Bounds)
    # print("Counts in respective intervals:", counts)

    print("Danilevsky roots:")
    print(roots)

    if not mode:
        plot(A_char, semilogy=semilogy, xl=xl, xr=xr, yl=yl, yh=yh, pointNum=pointNum)
    else:
        plot(A_char, semilogy=True, xl=-30, xr=30, yl=-10000000000, yh=10000000000, pointNum=1000000)

    ys = []
    for i in range(n):
        ys.append([])
        for j in range(n):
            ys[i].append(roots[i] ** (n - j - 1))
        # print(f'y{i}:', Vector(ys[i]))

    # print("Danilevsky E-vectors")
    xs = []
    for i in range(n):
        xs.append(B * Vector(ys[i]))
        # print(xs[i])

    nv = []
    print("Danilevsky normalized vectors:")
    for v in xs:
        newv = Vector([v.vec[i] / v.norm() for i in range(len(v))])
        nv.append(newv)
        print(f'{newv.vec}, norm = {newv.norm()}')

    orthonormality_Check(nv)
    print()
    return (matrix, nv)

def Krylov(matrix):
    n = len(matrix)
    ys = []
    y0 = [1]
    for _ in range(n - 1):
        y0.append(0)
    y0 = Vector(y0)
    ys.append(y0)
    for _ in range(n):
        ys.append(matrix * ys[-1])
    for i, y in enumerate(ys):
        print(f'y{i} = {y}')
    print()

    b = ys[-1]
    A = Matrix([[ys[j].vec[i] if j >= 0 else 0 for j in range(n - 1, -1, -1)] for i in range(n)])
    print("A:")
    print(A)
    print("b:")
    print(b)
    print()

    GG_Bounds, _ = GGorin(matrix)
    P = np.linalg.solve(A.matrix, b.vec)
    A_char = polynomial_func(P)

    roots = find_roots(GG_Bounds, A_char, n)
    print("Krylov roots:")
    print(roots)

    xs = []
    for i in range(len(roots)):
        qs = []
        qs.append(1)
        for j in range(n - 1):
            qs.append(roots[i] * qs[-1] - P[j])
        # print(f'q{i} = {qs}')
        x = ys[0] * qs[-1]
        # print(f'x = {x}, ys[0] = {ys[0]}, qs[-1] = {qs[-1]}, type of qs[-1]: {type(qs[-1])}')
        for j in range(1, n):
            x = x + (ys[j] * qs[n - 1 - j])
            # print(f'x changed by {ys[j]} * {qs[n - 1 - j]}, i = {j}, n - 1 - i = {n - 1 - j}')
        xs.append(x)
        # print(f'x{i} = {xs[i]}')
    
    print("Krylov E-vectors")
    for i in range(n):
        print(xs[i])
    print()

    nv = []
    print("Krylov normalized vectors:")
    for v in xs:
        newv = Vector([v.vec[i] / v.norm() for i in range(len(v))])
        nv.append(newv)
        print(f'{newv.vec}, norm = {newv.norm()}')
    
    orthonormality_Check(nv)
    print()
    return (matrix, nv)

def compare_methods_results(nvs1, nvs2):
    diff = max([Vector.norm(Vector([abs(nvs1[i].vec[j]) - abs(nvs2[i].vec[j]) for j in range(len(nvs1))])) for i in range(len(nvs1))])
    print(f'max diff of nvs1 and nvs2: {diff}, < err? {diff < err_orth}')
    print()

err_val = 10e-3
err_viet = 10e-2
err_orth = 10e-1

A = Matrix([[2.2, 1, 0.5, 2],
            [1, 1.3, 2, 1],
            [0.5, 2, 0.5, 1.6],
            [2, 1, 1.6, 2]])

_, Dan_nv_1 = Danilevsky(A, False, semilogy=False, yl=-100, yh=100)
_, Krylov_nv_1 = Krylov(A)
compare_methods_results(Dan_nv_1, Krylov_nv_1)

mat8 = random_Matrix(8, -15, 15)
mat8, Dan_nv_2 = Danilevsky(mat8, True, semilogy=True, xl=-30, xr=30, yl=-10000000000, yh=10000000000, pointNum=1000000)
mat8, Krylov_nv_2 = Krylov(mat8)
compare_methods_results(Dan_nv_2, Krylov_nv_2)