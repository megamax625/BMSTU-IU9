from methods import Matrix, Vector
import random

def random_Matrix(n, a, b):
    res = Matrix.create_empty(n, n)
    for i in range(n):
        inc = 0
        for j in range(n):
            res.matrix[i][j] = (random.random() + (a/b)) * b - random.random() * a
            if i != j:
                inc += abs(res.matrix[i][j])
        if res.matrix[i][i] < 0:
            res.matrix[i][i] -= 3 * inc
        else:
            res.matrix[i][i] += 3 * inc
    # print(res.matrix)
    return res

def check_Diagonal_Dominance(mat):
    ok = True
    for i in range(len(mat)):
        if abs(mat.matrix[i][i]) < sum([mat.matrix[i][j] if i != j else 0 for j in range(len(mat.matrix[i]))]):
            ok = False
            print(f'Diagonal dominance of matrix failed at {i}-th row')
    if ok:
        print(f'Diagonal Dominance of matrix confirmed')
    return ok

def random_Vector(n, a, b):
    return Vector([(random.random() + (a/b)) * b - random.random() * a for _ in range(n)])

def get_Norm(mat):
    return max([sum([abs(mat.matrix[i][j]) if i != j else 0 for j in range(len(mat.matrix[i]))]) / abs(mat.matrix[i][i]) for i in range(len(mat))])

def check_Norm_condition(mat):
    return get_Norm(mat) < 1

def get_Uniform_Norm(vec):
    return max(abs(vec.vec[i]) for i in range(len(vec)))

def get_P(A):
    n = len(A)
    P = Matrix.create_empty(n, n)
    for i in range(n):
        for j in range(n):
            if i == j:
                P.matrix[i][j] = 0
            else:
                P.matrix[i][j] = -A.matrix[i][j] / A.matrix[i][i]
    return P

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
    return Vector(x)

def Jacobi(mat, vec, x_real):
    n = len(mat)
    initial = [random.random() * 5 for i in range(n)]
    x_next = [0.0 for _ in range(n)]
    x = [initial[i] for i in range(n)]
    counter = 0
    # print(f'x{counter}: {x}')
    while True:
        for i in range(n):
            x_next[i] = vec.vec[i]
            for j in range(n):
                if i != j:
                    x_next[i] -= mat.matrix[i][j] * x[j]
            x_next[i] /= mat.matrix[i][i]
        xn = Vector.norm(Vector([abs(x_next[i] - x_real.vec[i]) for i in range(n)]))
        if xn <= err:
            print(f'count of iterations: {counter + 1}')
            # print(f'x_res: {x_next}')
            return Vector(x_next)
        else:
            x = [x_next[i] for i in range(n)]
            x_next = [0.0 for _ in range(n)]
            counter += 1
            #print(f'x{counter}: {x}')

def compare_methods_results(name, xj, xr):
    diff = Vector.norm(Vector([abs(xj.vec[i] - xr.vec[i]) for i in range(len(xj))]))
    print(f'Diff between {name} method and real: {diff}, < err? {diff < err}')

err = 10e-8
print("Testing for 4x4 matrix")
A = random_Matrix(4, -5, 10)
x_real = random_Vector(4, -5, 10)
f = A * x_real
check_Diagonal_Dominance(A)
print(f'Matrix norm: {get_Norm(A)}, condition: < 1 = {check_Norm_condition(A)}')
print("A:")
print(A)
print()

x = Jacobi(Matrix.copy(A), Vector.copy(f), x_real)

x_G = Gauss(Matrix.copy(A), Vector.copy(f))

print()
print(f'x_real: {x_real}')
print(f'x: {x}')
print(f'x_G: {x_G}')
print()
compare_methods_results("Jacobi", x, x_real)
compare_methods_results("Gauss", x_G, x_real)

print("Testing for 30x30 matrix")
A = random_Matrix(30, -5, 10)
x_real = random_Vector(30, -5, 10)
f = A * x_real
check_Diagonal_Dominance(A)
print(f'Matrix norm: {get_Norm(A)}, condition: < 1 = {check_Norm_condition(A)}')

x = Jacobi(Matrix.copy(A), Vector.copy(f), x_real)

x_G = Gauss(Matrix.copy(A), Vector.copy(f))

print()
print(f'x_real: {x_real}')
print(f'x: {x}')
print(f'x_G: {x_G}')
print()
compare_methods_results("Jacobi", x, x_real)
compare_methods_results("Gauss", x_G, x_real)

print("Testing for 100x100 matrix")
A = random_Matrix(100, -5, 10)
x_real = random_Vector(100, -5, 10)
f = A * x_real
check_Diagonal_Dominance(A)
print(f'Matrix norm: {get_Norm(A)}, condition: < 1 = {check_Norm_condition(A)}')

x = Jacobi(Matrix.copy(A), Vector.copy(f), x_real)

x_G = Gauss(Matrix.copy(A), Vector.copy(f))

# print()
# print(f'x_real: {x_real}')
# print(f'x: {x}')
# print(f'x_G: {x_G}')
# print()
compare_methods_results("Jacobi", x, x_real)
compare_methods_results("Gauss", x_G, x_real)