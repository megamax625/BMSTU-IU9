from methods import Matrix, random_Matrix

def GGorin(mat):
    centres = [mat.matrix[i][i] for i in range(len(mat))]
    radii = [sum([mat.matrix[i][j] for j in range(len(mat.matrix[i])) if i != j]) for i in range(len(mat.matrix))]
    intervals = [(centres[i] - radii[i], centres[i] + radii[i]) for i in range(len(mat))]
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

def find_roots(GG_union, func, n, err):
    roots = []
    num = n ** 4
    for interval in GG_union:
        xi = interval[0]
        r_bound = interval[1]
        inter_len = r_bound - xi
        step = inter_len / num
        while xi + step < r_bound:
            if (func(xi) * func(xi + step / 2) < 0):
                root = find_root(xi, xi + step / 2, func, err)
                roots.append(root)
            elif (func(xi + step / 2) * func(xi + step) < 0):
                root = find_root(xi + step / 2, xi + step, func, err)
                roots.append(root)
            xi = xi + step
    return roots

def find_root(l, r, func, err):
    inter_len = r - l
    mid = l + inter_len / 2
    if inter_len * 2 < err:
        return mid
    else:
        if (func(l) * func(mid) < 0):
            return find_root(l, mid, func, err)
        elif (func(mid) * func(r) < 0):
            return find_root(mid, r, func, err)
        else:
            return None



def Danilevsky(n, a, b, err):
    matrix = random_Matrix(n, a, b)
    n = len(matrix)

    GG_Bounds, _ = GGorin(matrix)
    P, _ = Frobenius(matrix)
    A_char = polynomial_func(P)
    roots = find_roots(GG_Bounds, A_char, n, err)

    if len(roots) != n or None in roots:
        return Danilevsky(n, a, b, err=err)

    # print("Danilevsky roots:")
    # print(roots)

    return (matrix, roots)