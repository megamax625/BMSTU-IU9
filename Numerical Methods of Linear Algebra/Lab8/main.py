import math
from multiprocessing.pool import ThreadPool
import time
from methods import Matrix, random_Matrix, get_Matrix_Norm
from matplotlib import pyplot as plt

two_powers = [2 ** i for i in range(16)]
n_min = 64

def extend_Matrix(matrix, size):
    if size > len(matrix) or size > len(matrix[0]):
        res = Matrix.create_empty(size, size)
        for i in range(len(matrix)):
            for j in range(len(matrix[0])):
                res[i][j] = matrix[i][j]
        return res
    else:
        # print(f"Matrix already fits size {size}x{size}")
        return matrix

def shrink_Matrix(matrix, origin_size_w, origin_size_h):
    if origin_size_w > len(matrix) or origin_size_h > len(matrix[0]):
        print(f"Can't shrink matrix to a bigger size")
        return -1
    else:
        return Matrix(matrix[0:origin_size_w, 0:origin_size_h])

def subdivide_Matrix(matrix):
    n = len(matrix)
    m = math.floor(n / 2)
    A11 = matrix[0:m, 0:m]
    A12 = matrix[0:m, m:n]
    A21 = matrix[m:n, 0:m]
    A22 = matrix[m:n, m:n]
    return (Matrix(A11), Matrix(A12), Matrix(A21), Matrix(A22))

def Strassen(A, B, n_min):
    n = len(A)
    if len(B) != n:
        print(f"Lengths of matrixes don't match! {n} vs {len(B)}")
        return -1
    if n <= n_min:
        return A * B
    
    A11, A12, A21, A22 = subdivide_Matrix(A)
    B11, B12, B21, B22 = subdivide_Matrix(B)

    P1 = Strassen(A11 + A22, B11 + B22, n_min=n_min)
    P2 = Strassen(A21 + A22, B11, n_min=n_min)
    P3 = Strassen(A11, B12 - B22, n_min=n_min)
    P4 = Strassen(A22, B21 - B11, n_min=n_min)
    P5 = Strassen(A11 + A12, B22, n_min=n_min)
    P6 = Strassen(A21 - A11, B11 + B12, n_min=n_min)
    P7 = Strassen(A12 - A22, B21 + B22, n_min=n_min)

    C11 = P1 + P4 - P5 + P7
    C12 = P3 + P5
    C21 = P2 + P4
    C22 = P1 + P3 - P2 + P6

    m = math.floor(n / 2)
    C = Matrix.create_empty(n, n)
    for i in range(m):
        for j in range(m):
            C[i][j] = C11[i][j]
        for j in range(n - m):
            C[i][j + m] = C12[i][j]
    for i in range(m):
        for j in range(m):
            C[i + m][j] = C21[i][j]
        for j in range(n - m):
            C[i + m][j + m] = C22[i][j]
    return C

def Strassen_Start(A, B, n_min):
    start = time.time()
    powers_greater = [p >= len(A) for p in two_powers]
    for i in range(len(powers_greater)):
        if powers_greater[i]:
            upsize = two_powers[i]
            break
    C = shrink_Matrix(Strassen(extend_Matrix(A, upsize), extend_Matrix(B, upsize), n_min=n_min), len(A), len(B))
    end = time.time()
    return (C, end - start)

def Strassen_parallel(A, B, n_min):
    n = len(A)
    if len(B) != n:
        print(f"Lengths of matrixes don't match! {n} vs {len(B)}")
        return -1
    if n <= n_min:
        return A * B

    A11, A12, A21, A22 = subdivide_Matrix(A)
    B11, B12, B21, B22 = subdivide_Matrix(B)

    TPool = ThreadPool(processes=7)

    P1 = TPool.apply_async(Strassen_parallel, (A11 + A22, B11 + B22, n_min)).get()
    P2 = TPool.apply_async(Strassen_parallel, (A21 + A22, B11, n_min)).get()
    P3 = TPool.apply_async(Strassen_parallel, (A11, B12 - B22, n_min)).get()
    P4 = TPool.apply_async(Strassen_parallel, (A22, B21 - B11, n_min)).get()
    P5 = TPool.apply_async(Strassen_parallel, (A11 + A12, B22, n_min)).get()
    P6 = TPool.apply_async(Strassen_parallel, (A21 - A11, B11 + B12, n_min)).get()
    P7 = TPool.apply_async(Strassen_parallel, (A12 - A22, B21 + B22, n_min)).get()

    C11 = P1 + P4 - P5 + P7
    C12 = P3 + P5
    C21 = P2 + P4
    C22 = P1 + P3 - P2 + P6

    m = math.floor(n / 2)
    C = Matrix.create_empty(n, n)
    for i in range(m):
        for j in range(m):
            C[i][j] = C11[i][j]
        for j in range(n - m):
            C[i][j + m] = C12[i][j]
    for i in range(m):
        for j in range(m):
            C[i + m][j] = C21[i][j]
        for j in range(n - m):
            C[i + m][j + m] = C22[i][j]
    return C

def Strassen_parallel_Start(A, B, n_min):
    start = time.time()
    powers_greater = [p >= len(A) for p in two_powers]
    for i in range(len(powers_greater)):
        if powers_greater[i]:
            upsize = two_powers[i]
            break
    C = shrink_Matrix(Strassen_parallel(extend_Matrix(A, upsize), extend_Matrix(B, upsize), n_min=n_min), len(A), len(B))
    end = time.time()
    return (C, end - start)

def Classical_Start(A, B):
    start = time.time()
    C = A * B
    end = time.time()
    return (C, end - start)

def test(start, finish, a, b):
    n = start
    ns = []
    times_classical = []
    times_Strassen = []
    times_Strassen_parallel = []

    index_power_passed = -1
    for p in two_powers:
        if start > p:
            index_power_passed += 1
        else:
            break

    while n <= finish:
        ns.append(n)
        A = random_Matrix(n, a, b)
        B = random_Matrix(n, a, b)

        C_classical, time_classical = Classical_Start(A, B)
        C_Strassen, time_Strassen = Strassen_Start(A, B, n_min=n_min)
        C_Strassen_parallel, time_Strassen_parallel = Strassen_parallel_Start(A, B, n_min=n_min)

        times_classical.append(time_classical)
        times_Strassen.append(time_Strassen)
        times_Strassen_parallel.append(time_Strassen_parallel)

        if n > n_min:
            print(f"Accuracy calculation for {n}x{n} matrix:")
            print(f"Strassen norm of subtraction: {get_Matrix_Norm(C_classical - C_Strassen)}")
            print(f"Strassen_parallel norm of subtraction: {get_Matrix_Norm(C_classical - C_Strassen_parallel)}")

        if n in two_powers:
            index_power_passed += 1
            n += 1
        else:
            inc = max(math.floor(n / 2), 2)
            n += inc
        if n > two_powers[index_power_passed + 1] and not (two_powers[index_power_passed + 1] in ns):
            n = two_powers[index_power_passed + 1]
        elif n > finish and not (finish in ns):
            n = finish
        print(f"Current n: {n}, next power: {two_powers[index_power_passed + 1]}")
    
    plt.plot(ns, times_classical, label="Classical")
    plt.plot(ns, times_Strassen, label="Strassen")
    plt.plot(ns, times_Strassen_parallel, label="Strassen parallel")
    plt.xlabel("N")
    plt.ylabel("Time (sec)")
    plt.legend(loc='upper left')
    plt.show()

test(4, 128, -10, 10)

A = random_Matrix(1000, -10, 10)
B = random_Matrix(1000, -10, 10)

C_classical, time_classical = Classical_Start(A, B)
print(f"Time spent for classical: {time_classical}")
C_Strassen, time_Strassen = Strassen_Start(A, B, n_min=n_min)
print(f"Time spent for Strassen: {time_Strassen}")
C_Strassen_parallel, time_Strassen_parallel = Strassen_parallel_Start(A, B, n_min=n_min)
print(f"Time spent for Strassen parallel: {time_Strassen_parallel}")

print(f"Accuracy calculation for {1000}x{1000} matrix:")
print(f"Strassen norm of subtraction: {get_Matrix_Norm(C_classical - C_Strassen)}")
print(f"Strassen_parallel norm of subtraction: {get_Matrix_Norm(C_classical - C_Strassen_parallel)}")