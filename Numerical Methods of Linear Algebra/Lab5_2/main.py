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

def Jacobi(mat, vec, x_real, initial):
    n = len(mat)
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
            print(f'count of iterations in Jacobi method: {counter + 1}')
            # print(f'x_res: {x_next}')
            return Vector(x_next)
        else:
            x = [x_next[i] for i in range(n)]
            x_next = [0.0 for _ in range(n)]
            counter += 1
            #print(f'x{counter}: {x}')

def Seidel(mat, vec, x_real, initial):
    n = len(mat)
    x_next = [0.0 for _ in range(n)]
    x = [initial[i] for i in range(n)]
    counter = 0
    # print(f'x{counter}: {x}')
    while True:
        for i in range(n):
            x_next[i] = vec.vec[i]
            for j in range(i):
                x_next[i] -= mat.matrix[i][j] * x_next[j]
            for j in range(i, n):
                if i != j:
                    x_next[i] -= mat.matrix[i][j] * x[j]
            x_next[i] /= mat.matrix[i][i]
        xn = Vector.norm(Vector([abs(x_next[i] - x_real.vec[i]) for i in range(n)]))
        if xn <= err:
            print(f'count of iterations in Seidel method: {counter + 1}')
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
print("\nTesting for 4x4 matrix")
A = random_Matrix(4, -5, 10)
x_real = random_Vector(4, -5, 10)
f = A * x_real
check_Diagonal_Dominance(A)
print(f'Matrix norm: {get_Norm(A)}, condition: < 1 = {check_Norm_condition(A)}')
print("A:")
print(A)
print()

initial = [random.random() * 5 for i in range(len(f))]
xj = Jacobi(Matrix.copy(A), Vector.copy(f), x_real, initial)
xs = Seidel(Matrix.copy(A), Vector.copy(f), x_real, initial)

print()
print(f'x_real: {x_real}')
print(f'x_Jacobi: {xj}')
print(f'x_Seidel: {xs}')
print()
compare_methods_results("Jacobi", xj, x_real)
compare_methods_results("Seidel", xs, x_real)

print("\nTesting for 30x30 matrix")
A = random_Matrix(30, -5, 10)
x_real = random_Vector(30, -5, 10)
f = A * x_real
check_Diagonal_Dominance(A)
print(f'Matrix norm: {get_Norm(A)}, condition: < 1 = {check_Norm_condition(A)}')

initial = [random.random() * 5 for i in range(len(f))]
xj = Jacobi(Matrix.copy(A), Vector.copy(f), x_real, initial)
xs = Seidel(Matrix.copy(A), Vector.copy(f), x_real, initial)

compare_methods_results("Jacobi", xj, x_real)
compare_methods_results("Seidel", xs, x_real)

print("\nTesting for 100x100 matrix")
A = random_Matrix(100, -5, 10)
x_real = random_Vector(100, -5, 10)
f = A * x_real
check_Diagonal_Dominance(A)
print(f'Matrix norm: {get_Norm(A)}, condition: < 1 = {check_Norm_condition(A)}')
print()

initial = [random.random() * 5 for i in range(len(f))]
xj = Jacobi(Matrix.copy(A), Vector.copy(f), x_real, initial)
xs = Seidel(Matrix.copy(A), Vector.copy(f), x_real, initial)

compare_methods_results("Jacobi", xj, x_real)
compare_methods_results("Seidel", xs, x_real)

print("\nTesting for 1000x1000 matrix")
A = random_Matrix(1000, -5, 10)
x_real = random_Vector(1000, -5, 10)
f = A * x_real
check_Diagonal_Dominance(A)
print(f'Matrix norm: {get_Norm(A)}, condition: < 1 = {check_Norm_condition(A)}')
print()

initial = [random.random() * 5 for i in range(len(f))]
xj = Jacobi(Matrix.copy(A), Vector.copy(f), x_real, initial)
xs = Seidel(Matrix.copy(A), Vector.copy(f), x_real, initial)

compare_methods_results("Jacobi", xj, x_real)
compare_methods_results("Seidel", xs, x_real)

print("\nTesting for 1000x1000 matrix")
A = random_Matrix(1000, -50, 100)
x_real = random_Vector(1000, -50, 100)
f = A * x_real
check_Diagonal_Dominance(A)
print(f'Matrix norm: {get_Norm(A)}, condition: < 1 = {check_Norm_condition(A)}')
print()

initial = [random.random() * 5 for i in range(len(f))]
xj = Jacobi(Matrix.copy(A), Vector.copy(f), x_real, initial)
xs = Seidel(Matrix.copy(A), Vector.copy(f), x_real, initial)

compare_methods_results("Jacobi", xj, x_real)
compare_methods_results("Seidel", xs, x_real)