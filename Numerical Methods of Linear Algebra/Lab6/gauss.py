from methods import Matrix, Vector
import numpy as np

def Gauss(matr, b):
    vec = Vector.copy(b)
    mat = Matrix.copy(matr)
    if not len(mat) == len(vec):
        raise ValueError("Несоответствует размерность системы и вектора b")
    n = len(vec)
    # Прямой ход метода
    for k in range(n):
        diag = mat.matrix[k][k]
        for i in range(k + 1, n):
            div = mat.matrix[i][k] / diag
            for j in range(k, n):
                mat.matrix[i][j] -= div * mat.matrix[k][j]
            vec.vec[i] -= div * vec.vec[k]
    # Обратный ход метода
    x = [0.0] * n
    x[n - 1] = vec.vec[n - 1] / mat.matrix[n - 1][n - 1]
    for i in range(n - 2, -1, -1):
        sum = 0
        for j in range(i + 1, n):
            sum += mat.matrix[i][j] * x[j]
        x[i] = (vec.vec[i] - sum) / mat.matrix[i][i]
    return x
