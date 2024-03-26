from methods import Matrix, Vector
import numpy as np

def Gauss(matr, b):
    vec = Vector.copy(b)
    mat = Matrix.copy(matr)
    n = len(vec)
    # Прямой ход метода
    for k in range(n):
        diag = mat[k][k]
        if diag != 0:
            for i in range(k + 1, n):
                div = mat[i][k] / diag
                for j in range(k, n):
                    mat[i][j] -= div * mat[k][j]
                vec.vec[i] -= div * vec.vec[k]
    # Обратный ход метода
    x = [0.0] * n
    x[n - 1] = vec.vec[n - 1] / mat[n - 1][n - 1]
    for i in range(n - 2, -1, -1):
        sum = 0
        for j in range(i + 1, n):
            sum += mat[i][j] * x[j]
        if mat[i][i] != 0:
            x[i] = (vec[i] - sum) / mat[i][i]
    return x


# old
A = Matrix([[1, -3, 1, 1],
            [1, 1, -3, 1],
            [1, 0, 0, -1],
            [0, 0, 0, 1]])
b = Vector([0, 0, 9, 0])

phi = Gauss(A, b)
print("Solution (old):")
print(phi)

# new
R12 = 1
R13 = 5
R23 = 1
R24 = 1
R34 = 1
xi = 9

A = Matrix([[1 / R12, -(1 / R12 + 1 / R23 + 1 / R24), 1 / R23, 1 / R24],
            [1 / R13, 1 / R23, -(1 / R13 + 1 / R23 + 1 / R34), 1 / R34],
            [1, 0, 0, -1],
            [0, 0, 0, 1]])
b = Vector([0, 0, xi, 0])
phi = Gauss(A, b)
print("Solution (new):")
print(phi)

# посчитаем токи
I12 = (phi[0] - phi[1]) / R12
I13 = (phi[0] - phi[2]) / R13
I23 = (phi[1] - phi[2]) / R23
I24 = (phi[1] - phi[3]) / R24
I34 = (phi[2] - phi[3]) / R34
print(f"Токи: I12 = {I12}, I13 = {I13}, I23 = {I23}, I24 = {I24}, I34 = {I34}")