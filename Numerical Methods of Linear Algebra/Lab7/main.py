from methods import Matrix, Vector, get_Matrix_Norm, random_Matrix
from math import sqrt
from sys import argv

err_val = 10e-10

def verify_results(method_name, A_experimental, A):
    error = abs(get_Matrix_Norm(A) - get_Matrix_Norm(A_experimental))
    if error <= err_val:
        print(f'{method_name} verified to provide satisfying error of {error}')
        print()
    else:
        print(f'Too big error in {method_name}: {error}')
        if "--debug" in argv and len(A) < 10:
            print(A)
            print()
            print(A_experimental)
            print()

def Cholesky(mat):
    A = Matrix.copy(mat)
    n = len(A)
    L = Matrix.create_empty(n, n)
    
    L[0][0] = sqrt(A[0][0])
    for j in range(1, n):
        L[j][0] = A[j][0] / L[0][0]
    for j in range(1, n):
        L[j][j] = sqrt(A[j][j] - sum([L[j][p] ** 2 for p in range(j)]))
        for i in range(j + 1, n):
            L[i][j] = (A[i][j] - sum([L[i][p] * L[j][p] for p in range(i)])) / L[j][j]

    if n < 10:
        print("Cholesky L:")
        print(L)
        print()

    A_experimental = L * Matrix.transpose(L)
    verify_results("Cholesky", A_experimental, A)

    return L

def LU(mat):
    A = Matrix.copy(mat)
    n = len(A)
    L = Matrix.create_empty(n, n)
    U = Matrix.create_empty(n, n)

    for i in range(0, n):
        L[i][i] = 1
        for j in range(0, n):
            if i <= j:
                U[i][j] = A[i][j] - sum([L[i][k] * U[k][j] for k in range(i)])
            if i > j:
                L[i][j] = (A[i][j] - sum(L[i][k] * U[k][j] for k in range(j))) / U[j][j]

    if n < 10:
        print("L:")
        print(L)
        print()
        print("U:")
        print(U)
        print()

    A_experimental = L * U
    verify_results("LU", A_experimental, A)

    return L, U


def test(n, a, b):
    print('-' * 120)
    print(f"Running test for matrix size {n}x{n}")
    A = random_Matrix(n, a, b)
    if "--debug" in argv and n < 10:
        print(A)
        print()
    if "--debug" in argv and n > 10:
        print("Matrix generated successfully")
        print()

    _ = Cholesky(A)
    _, _ = LU(A)

test(5, -10, 10)
test(10, -10, 10)
test(100, -10, 10)
# test(300, -10, 10)