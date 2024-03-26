import numpy as np
from methods import Matrix, get_Matrix_Norm, random_Matrix
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

def find_Inverse_LU(L, U):
    n = len(L)
    X = Matrix.create_empty(n, n)

    for i in range(n - 1, -1, -1):
        for j in range(i, -1, -1):
            if j == i:
                if "--debug" in argv and n < 5:
                    print(f"d: {i}, {j}")
                X[i][i] = (1 - sum(U[i][k] * X[k][i] for k in range(i + 1, n))) / U[i][i]
            else:   # i > j, switching order => j > i --- fill column i
                if "--debug" in argv and n < 5:
                    print(f"u: {j}, {i}")
                X[j][i] = -sum(U[j][k] * X[k][i] for k in range(j + 1, n)) / U[j][j]
        for j in range(i, -1, -1): # i > j  --- fill row i
            if i != j:
                if "--debug" in argv and n < 5:
                    print(f"l: {i}, {j}")
                X[i][j] = -sum(X[i][k] * L[k][j] for k in range(j + 1, n))
    return X

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

    L, U = LU(A)
    Inv = find_Inverse_LU(L, U)
    Inv_lib = np.linalg.inv(A).tolist()
    if "--debug" in argv and n < 10:
        print("Inv:")
        print(Inv)
        print("\nInv_lib:")
        print(Inv_lib)
        print()
    error = np.linalg.norm(Inv - Matrix(Inv_lib))
    print(f"error for inverse matrix: {error}, error < err_val? {error < err_val}")

test(5, -10, 10)
test(10, -10, 10)
test(100, -10, 10)
# test(300, -10, 10)