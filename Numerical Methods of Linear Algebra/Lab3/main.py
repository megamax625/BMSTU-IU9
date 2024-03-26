from math import sqrt

import numpy as np
from methods import Matrix, Vector, get_dd_matrix, random_Vector
import matplotlib.pyplot as plt

err_val = 10e-6

def gauss(A, b, method = 'res_col'):
    A = Matrix.copy(A)
    b = Vector.copy(b)
    n = len(b)
    
    # forward
    for i in range(n):
        if 'r' in method and 'c' in method: # rowcol
            max_row_el = abs(A[i][i])
            max_col_el = abs(A[i][i])
            max_row = i
            max_col = i
            for j in range(i+1, n):
                if abs(A[j][i]) > max_row_el:
                    max_row_el = abs(A[j][i])
                    max_row = j
                if abs(A[i][j]) > max_col_el:
                    max_col_el = abs(A[i][j])
                    max_col = j
                    
            if max_row_el > max_col_el:
                temp = A[max_row]
                for j in range(n):
                    A[max_row][j] = A[i][j]
                    A[i][j] = temp[j]

                b[i], b[max_row] = b[max_row], b[i]
            else:
                for k in range(n):
                    A[k][i], A[k][max_col] = A[k][max_col], A[k][i]

        elif 'r' in method: # row
            max_row_el = abs(A[i][i])
            max_row = i
            for j in range(i+1, n):
                if abs(A[j][i]) > max_row_el:
                    max_row_el = abs(A[j][i])
                    max_row = j

            temp = A[max_row]
            for j in range(n):
                A[max_row][j] = A[i][j]
                A[i][j] = temp[j]

            b[i], b[max_row] = b[max_row], b[i]

        elif 'c' in method: # col
            max_col_el = abs(A[i][i])
            max_col = i
            for j in range(i+1, n):
                if abs(A[i][j]) > max_col_el:
                    max_col_el = abs(A[i][j])
                    max_col = j
            for k in range(n):
                A[k][i], A[k][max_col] = A[k][max_col], A[k][i]
        
        for k in range(i + 1, n):
            div = -A[k][i] / A[i][i]
            for j in range(i, n):
                if i == j:
                    A[k][j] = 0
                else:
                    A[k][j] += div * A[i][j]

            b[k] += div * b[i]
        
    # print(A)
    # print(b)
            
    # backward    
    x = [0.0] * n
    x[n - 1] = b[n - 1] / A[n - 1][n - 1]
    for i in range(n - 2, -1, -1):
        sum = 0
        for j in range(i + 1, n):
            sum += A[i][j] * x[j]
        x[i] = (b[i] - sum) / A[i][i]
    return x

def test(a = 1, b = 100, n = 3, dom = 3):
    results = []

    matrix = get_dd_matrix(n, a, b, dom)
    print(matrix)
    print()
    x = random_Vector(n, a, b)
    b = matrix * x

    # gauss classic
    res = gauss(matrix, b, '')
    results.append((Vector(res) - x).norm())

    # gauss row
    # res = gauss(matrix, b, 'r')
    # results.append((Vector(res) - x).norm())
    
    # gauss col
    # res = gauss(matrix, b, 'c')
    # results.append((Vector(res) - x).norm())

    # gauss row_col
    res = gauss(matrix, b, 'res_col')
    results.append((Vector(res) - x).norm())

    # numpy
    res = np.linalg.solve(matrix, b)
    results.append((Vector(res) - x).norm())


    # print(dom)
    for i in results:
        print(i)
    print()
    return results

# doms = list(range(-5, 10))
# res_classic = []
# res_row = []
# res_col = []
# res_rowcol = []
# res_numpy = []

# for d in doms:
#     res = test(-100, 100, 10, d)
#     res_classic.append(res[0])
#     res_row.append(res[1])
#     res_col.append(res[2])
#     res_rowcol.append(res[3])
#     res_numpy.append(res[4])

res_classic = []
res_rowcol = []

res = test(-100, 100, 8, 1.1)

res_classic.append(res[0])
res_rowcol.append(res[1])

print(f'Res classic:{res_classic}')
print(f'Res rowcol:{res_rowcol}')

# plt.plot(doms, res_classic, label = 'classic')
# plt.plot(doms, res_row, label = 'row')
# plt.plot(doms, res_col, label = 'col')
# plt.plot(doms, res_rowcol, label = 'rowcol')
# plt.plot(doms, res_numpy, label = 'numpy')
# plt.legend()
# plt.show()