from methods import Matrix, Vector
import random
import numpy as np # для тестирования

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

def random_Matrix_tridiag(n, a, b):
    res = Matrix.create_empty(n, n)
    for i in range(n):
        inc = 0
        for j in range(n):
            if j in (i-1, i, i+1):
                res.matrix[i][j] = (random.random() + (a/b)) * b - random.random() * a
                if i != j:
                    inc += abs(res.matrix[i][j])
        if res.matrix[i][i] < 0:
            res.matrix[i][i] -= inc
        else:
            res.matrix[i][i] += inc
    # print(res.matrix)
    return res

def random_Vector(n, a, b):
    return Vector([(random.random() + (a/b)) * b - random.random() * a for _ in range(n)])

def tridiag(mat, f):
        d = f.vec
        b = ([mat.matrix[i][i] for i in range(len(mat))])
        c = ([mat.matrix[i][i+1] for i in range(len(mat) - 1)])
        a = ([mat.matrix[i+1][i] for i in range(0, len(mat) - 1)])
        alpha = [0.0] * len(b)
        beta = [0.0] * len(b)
        x = [0.0] * len(b)
        alpha[0] = -c[0] / b[0]
        beta[0] = d[0] / b[0]
        for i in range(1, len(b)):
            if i == (len(b) - 1):
                alpha[i] = 0.0
                beta[i] = (d[i] - a[i - 1] * beta[i - 1]) / (a[i - 1] * alpha[i - 1] + b[i])
            else:
                alpha[i] = -c[i] / (a[i - 1] * alpha[i - 1] + b[i])
                beta[i] = (d[i] - a[i - 1] * beta[i - 1]) / (a[i - 1] * alpha[i - 1] + b[i])
        n = len(beta)
        x[n-1] = beta[n-1]
        for i in range(n - 2, -1, -1):
            x[i] = alpha[i] * x[i+1] + beta[i]
        return x

n = 100
mat = random_Matrix_tridiag(n, -5, 10)
vec = random_Vector(n, -5, 10)
# print(mat)
# print(vec)

f = mat * vec

gauss_sol = Vector(Gauss(mat, f))
tridiag_sol = Vector(tridiag(mat, f))
lib_sol = Vector(np.linalg.solve(np.array(mat.matrix), np.array(f.vec)))

# print(lib_sol)
# print(tridiag_sol)

g_error = Vector.norm(Vector([abs(vec.vec[i] - gauss_sol.vec[i]) for i in range(len(vec))])) / Vector.norm(vec)
tri_error = Vector.norm(Vector([abs(vec.vec[i] - tridiag_sol.vec[i]) for i in range(len(vec))])) / Vector.norm(vec)
lib_error = Vector.norm(Vector([abs(vec.vec[i] - lib_sol.vec[i]) for i in range(len(vec))])) / Vector.norm(vec)

print("Gauss:", g_error * 100, "%")
print("Tridiag:", tri_error * 100, "%")
print("Lib:", lib_error * 100, "%")
