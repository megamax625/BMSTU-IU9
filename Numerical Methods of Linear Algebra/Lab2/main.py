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

def test(mat, x):
    print("A:")
    print(mat)
    print("x:")
    print(x)
    b = mat * x
    print("b:")
    print(b)
    A = np.array(Matrix.copy(mat).matrix)
    bp = np.array(Vector.copy(b).vec)

    x_chisl = Gauss(Matrix.copy(mat), Vector.copy(b))
    print("Численное решение:")
    print(x_chisl)

    x_lib = np.linalg.solve(A, bp)
    print("Библиотечное решение:")
    print(x_lib)

    return (Vector(x_chisl), Vector(x_lib))

def random_Matrix(n, a, b):
    res = Matrix.create_empty(n, n)
    for i in range(n):
        inc = 0
        for j in range(n):
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

def input_Matrix():
    n = int(input("Размерность матрицы:"))
    res = [[]] * n
    for i in range(n):
        res[i] = (list(input().split(' ')))
    return Matrix(res)

n = 5
a = -5
b = 10
# inp_Mat = input_Matrix()
rand_Mat = random_Matrix(n, a, b)
rand_Vec = random_Vector(n, a, b)
# test(inp_Mat, rand_Vec(len(inp_Mat), a, b))
(x_ch, x_lib) = test(rand_Mat, Vector.copy(rand_Vec))
print("Сравнение:")
print("x - x_ch:", Vector.norm(Vector([abs(rand_Vec.vec[i] - x_ch.vec[i]) for i in range(len(rand_Vec))])))
print("x - x_lib:", Vector.norm(Vector([abs(rand_Vec.vec[i] - x_lib.vec[i]) for i in range(len(rand_Vec))])))