from math import sqrt

import numpy as np
from methods import Matrix, Vector, random_Matrix
from danilevsky import Danilevsky

err_val = 10e-6

def get_SVD(matrix, show_steps=False, debug=False, transposed=False):
    A = matrix.copy()
    m = len(A)
    n = len(A[0])
    A_transposed = A.transpose()
    if m > n:
        V, S, UT = get_SVD(A_transposed, show_steps=show_steps, debug=debug, transposed=True)
        return (UT.transpose(), S.transpose(), V.transpose())
    symm_factor = A.transpose() * A

    print('-' * 140)
    if transposed:
        print(f"Calculating for (transposed) Matrix A: (m = {m}, n = {n})")
    else:
        print(f"Calculating for Matrix A: (m = {m}, n = {n})")
    print(A, end='\n\n')
    if show_steps:
        print("Step 1: Computing Symmetric Factorization Matrix")
        if debug:
            print("A_transposed:")
            print(A_transposed, end='\n\n')
        print("Symmetric factorization matrix AtA:")
        print(symm_factor, end='\n\n')

    eigen_values, eigen_vectors = Danilevsky(symm_factor, err_val)
    eigens = sorted(list(zip(eigen_values, eigen_vectors)), key = lambda x: x[0], reverse=True)
    S = Matrix.create_empty(m, n)
    for i in range(m):
        S[i][i] = sqrt(eigens[i][0])
    S_inverse = Matrix.create_empty(m, n)
    for i in range(m):
        S_inverse[i][i] = 1.0 / S[i][i]
    if show_steps:
        print("Step 2: Computing Singular Values")
        print("Sorted eigenvalues:")
        for i in range(len(eigens)):
            print(f"eival{i+1} = {eigens[i][0]}", end='\n\n')
        print("Respective singular values:")
        for i in range(len(eigens)):
            print(f"s{i+1} = {sqrt(max(eigens[i][0], 0))}", end='\n\n')
        print("Respective eigenvectors for sorted eigenvalues:")
        for i in range(len(eigens)):
            print(f"eivec{i+1} = {eigens[i][1]}", end='\n\n')
        print("S:")
        print(S, end='\n\n')
        print("S_inverse:")
        print(S_inverse, end='\n\n')

    V = Matrix.create_empty(n, n)
    for i in range(len(eigens)):
        for j in range(len(eigens[i][1])):
            V[i][j] = eigens[i][1][j]
    V_transposed = V.transpose()
    if show_steps:
        print("Step 3: Computing Right Singular Vectors")
        print("V:")
        print(V, end='\n\n')
        print("V_transposed:")
        print(V_transposed, end='\n\n')

    if (n == m):
        U = A * V_transposed * S_inverse
        if show_steps:
            print("Step 4: Computing Left Singular Vectors")
            print("U:")
            print(U, end='\n\n')
    else:
        U = Matrix.create_empty(m, m)
        vm = Matrix(V[0:m][0:n])
        print(vm)
        for i in range(m):
            rev_singular = 1.0 / sqrt(eigens[i][0])
            vi = Vector(vm[i])
            AVi = A * vi
            U_col = AVi * rev_singular
            if show_steps:
                print(f"AV{i+1}:")
                print(AVi, end='\n\n')
                print(f"rev_singular{i+1}: {rev_singular}")
                print(f"U_col[{i+1}]:")
                print(U_col, end='\n\n')
            for j in range(m):
                U[j][i] = U_col[j]

    return (U, S, V)

def check_Correctness(matrix, U, S, VT, debug=False):
    mul = U * S * VT
    if debug:
        print("Mul matrix:")
        print(mul, end='\n\nEquals:\n')
        print(U, end='\n\t\t\t\t*')
        print(S, end='\n\t\t\t\t*')
        print(VT, end='\n\n')
    err_mat = np.linalg.norm(matrix - mul)
    print(f"Diff of result matrix' and input matrix': {err_mat}, < err_val? {err_mat < err_val}\n")

    U_lib, S_lib, V_lib = np.linalg.svd(matrix)
    err_S = np.linalg.norm(np.array(np.diag(S)) - S_lib) # S_lib is vector of len m
    print(f"Diff of method ({np.diag(np.array(S))}) and np S ({S_lib}): {err_S}, < err_val? {err_S < err_val}\nMethod U:")
    print(U, end='\n\nNumpy U:\n')
    print(U_lib, end='\n\nMethod V:\n')
    print(VT, end='\n\nNumpy V:\n')
    print(V_lib, end='\n\n')

    print(f"Checking orthogonality of U and V:")
    UTU = U.transpose() * U
    VTV = VT.transpose() * VT
    print(UTU)
    print()
    print(VTV)

example_Matrix = Matrix([[3, 1, 0],
                         [1, 2, 2],
                         [0, 1, 1]])
example_U, example_S, example_VT = get_SVD(example_Matrix, show_steps=True, debug=False)
check_Correctness(example_Matrix, example_U, example_S, example_VT, debug=False)

Lay_example = Matrix([[4, 11, 14],
                      [8, 7, -2]])
Lay_U, Lay_S, Lay_VT = get_SVD(Lay_example, show_steps=True, debug=False)
check_Correctness(Lay_example, Lay_U, Lay_S, Lay_VT, debug=False)

Lay_example_transposed = Lay_example.transpose()
Lay_U2, Lay_S2, Lay_VT2 = get_SVD(Lay_example_transposed, show_steps=True, debug=False)
check_Correctness(Lay_example_transposed, Lay_U2, Lay_S2, Lay_VT2, debug=False)

rand_matrix = random_Matrix(5, -10, 10)
rand_U, rand_S, rand_VT = get_SVD(rand_matrix, show_steps=False, debug=False)
check_Correctness(rand_matrix, rand_U, rand_S, rand_VT, debug=False)