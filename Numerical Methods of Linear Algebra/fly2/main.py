from methods import Matrix, Vector, plot
import random
import numpy as np # для тестирования

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

err = 0.001

#mat2 = random_Matrix(2, -5, 10)
mat2 = Matrix([[2.2, 1], [1, 1.3]])
#mat3 = random_Matrix(3, -5, 10)
mat3 = Matrix([[2.2, 1, 0.5], [1, 1.3, 2], [0.5, 2, 0.5]])
print("A2:")
print(mat2)
print("A3:")
print(mat3)
print()

# Для 2x2
B1 = Matrix.create_empty(2, 2)
B1.matrix[0][0] = 1 / mat2.matrix[1][0]
B1.matrix[0][1] = -mat2.matrix[1][1] / mat2.matrix[1][0]
B1.matrix[1] = [0, 1]

print("B1:")
print(B1)
print()

B1r = Matrix.create_empty(2, 2)
B1r.matrix[0][0] = mat2.matrix[1][0]
B1r.matrix[0][1] = mat2.matrix[1][1]
B1r.matrix[1] = [0, 1]

print("B1r:")
print(B1r)
print()

D1 = (B1r * mat2) * B1

print("D1:")
print(D1)
print()

P1 = D1.matrix[0]
def func2(λ):
    return λ ** 2 - P1[0] * λ - P1[1] 

plot(func2)

roots = []

i = -10
while i < 10:
    if func2(i) * func2(i + err) < 0:
        roots.append((i + i + err) / 2)
    i += err 

print("Корни(2):")
print(roots)

y = []
y.append(Vector([roots[0], 1]))
y.append(Vector([roots[1], 1]))

print("Собственные значения:")
for v in y:
    print(v.vec)

B = B1

x = []
x.append(B * y[0])
x.append(B * y[1])

print("Собственные векторы X:")
for v in x:
    print(v.vec)

print("Normalized X")
nv = []
for v in x:
    newv = Vector([v.vec[i] / v.norm() for i in range(len(v))])
    nv.append(newv)
    print(newv.vec, newv.norm())
print("Proof of orthonormality:")
for v1 in nv:
    for v2 in nv:
        if v1 != v2:
            print("Scalar: ", v1, v2, Vector.scalar(v1, v2), " < err?", abs(Vector.scalar(v1, v2)) < err)
        else:
            print("Scalar (self)", v1, v2, Vector.scalar(v1, v2), "~=1?", abs(Vector.scalar(v1, v2) - 1) < err)

# Для 3х3
B1 = Matrix.create_empty(3, 3)
B1.matrix[0] = [1, 0, 0]
B1.matrix[2] = [0, 0, 1]
B1.matrix[1][0] = -mat3.matrix[2][0] / mat3.matrix[2][1]
B1.matrix[1][1] = 1 / mat3.matrix[2][1]
B1.matrix[1][2] = -mat3.matrix[2][2] / mat3.matrix[2][1]

print("B1:")
print(B1)
print()

B1r = Matrix.create_empty(3, 3)
B1r.matrix[0] = [1, 0, 0]
B1r.matrix[2] = [0, 0, 1]
B1r.matrix[1][0] = mat3.matrix[2][0]
B1r.matrix[1][1] = mat3.matrix[2][1]
B1r.matrix[1][2] = mat3.matrix[2][2]

print("B1r:")
print(B1r)
print()

D1 = (B1r * mat3) * B1

print("D1:")
print(D1)
print()

B2 = Matrix.create_empty(3, 3)
B2.matrix[1] = [0, 1, 0]
B2.matrix[2] = [0, 0, 1]
B2.matrix[0][0] = 1 / D1.matrix[1][0]
B2.matrix[0][1] = -D1.matrix[1][1] / D1.matrix[1][0]
B2.matrix[0][2] = -D1.matrix[1][2] / D1.matrix[1][0]

print("B2:")
print(B2)
print()

B2r = Matrix.create_empty(3, 3)
B2r.matrix[1] = [0, 1, 0]
B2r.matrix[2] = [0, 0, 1]
B2r.matrix[0][0] = D1.matrix[1][0]
B2r.matrix[0][1] = D1.matrix[1][1]
B2r.matrix[0][2] = D1.matrix[1][2]

print("B2r:")
print(B2r)
print()

D2 = (B2r * D1) * B2
print("D2:")
print(D2)
print()

P1 = D2.matrix[0]
def func3(λ):
    return λ ** 3 - P1[0] * λ ** 2 - P1[1] * λ - P1[2]

plot(func3)

roots = []

i = -10
while i < 10:
    if func3(i) * func3(i + err) < 0:
        roots.append((i + i + err) / 2)
    i += err 

print("Корни(3):")
print(roots)

y = []
y.append(Vector([roots[0] ** 2, roots[0], 1]))
y.append(Vector([roots[1] ** 2, roots[1], 1]))
y.append(Vector([roots[2] ** 2, roots[2], 1]))

print("Собственные значения:")
for v in y:
    print(v.vec)

B = B1 * B2

x = []
x.append(B * y[0])
x.append(B * y[1])
x.append(B * y[2])

print("Собственные векторы X:")
for v in x:
    print(v.vec)

nv = []
print("Normalized X:")
for v in x:
    newv = Vector([v.vec[i] / v.norm() for i in range(len(v))])
    nv.append(newv)
    print(newv.vec, newv.norm())
print("Proof of orthonormality:")
for v1 in nv:
    for v2 in nv:
        if v1 != v2:
            print("Scalar: ", v1, v2, Vector.scalar(v1, v2), " < err?", abs(Vector.scalar(v1, v2)) < err)
        else:
            print("Scalar (self)", v1, v2, Vector.scalar(v1, v2), "~=1?", abs(Vector.scalar(v1, v2) - 1) < err )