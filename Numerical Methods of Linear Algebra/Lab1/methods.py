from math import sqrt
from matplotlib import pyplot as plt
import numpy as np # только для построения графика функции

# 1.Операции с векторами:
# вычисление скалярного произведения двух векторов,
# вычисление евклидовой нормы вектора

class Vector(object):
    def __init__(self, arg):
        self.vec = list(arg)
    def __len__(self):
        return len(self.vec)
    def scalar(self, vector):
        if len(self) != len(vector):
            raise ValueError("Несоответствующая размерность векторов при попытке скалярного произведения!")
        return sum((self.vec[i] * vector.vec[i]) for i in range(len(self)))
    def norm(self):
        return sqrt(sum(i * i for i in self.vec))
    def __str__(self):
        return str(self.vec)

print("Тестирование векторов:")
vec = Vector([1, 2, 3, 4, 5])
cev = Vector([5, 4, 3, 2, 1])
scalar = Vector.scalar(vec, cev)
norm = Vector.norm(vec)
## epicfail = Vector([1, 2])
## epicscalar = Vector.scalar(vec, epicfail) - ругаемся на несоответствие размерности векторов
print("vec =", vec)
print("cev =", cev)
print("scalar =", scalar)
print("Евклидова норма:", norm, "должна равняться квадратному корню из 55:", sqrt(55))
print()

# 2.Операции с матрицами:
# умножение матрицы на матрицу,
# умножение матрицу на вектор,
# транспонирование матрицы

class Matrix(object):
    def __init__(self, arg):
        first_row_len = len(arg[0]) if arg else None
        if all((type(row) is list) and (len(row) == first_row_len) for row in arg[1:]):
            self.matrix = arg
            self.height = len(arg)
            self.width = len(arg[0])
        else:
            raise ValueError("Создание не прямоугольной матрицы!")
    def create_empty(height, width):
        return Matrix([[0.0 for _ in range(width)] for _ in range(height)])
    # транспонирование
    def transpose(self):
        return Matrix(list(map(list, (zip(*self.matrix)))))
    def __str__(self):
        return ('\n'.join(['\t'.join([str(m) for m in row]) for row in self.matrix]))
    def __len__(self):
        return len(self.matrix)
    def __mul__(self, arg):
        # умножение матрицы на вектор
        if type(arg) == Vector:
            if len(arg) == self.width:
                res = [sum([self.matrix[i][j] * arg.vec[j] for j in range(self.width)]) for i in range(self.height)]
                return Vector(res)
            else:
                raise ValueError("Несоответствующая размерность при попытке перемножения матрицы и вектора!")
        # умножение матрицы на матрицу
        elif type(arg) == Matrix:
            if self.width == arg.height:
                res = Matrix.create_empty(self.height, arg.width)
                for i in range(res.height):
                    for j in range(res.width):
                        res.matrix[i][j] = Vector.scalar(Vector(self.matrix[i]), Vector(list(zip(*arg.matrix))[j]))
                return res
            else:
                raise ValueError("Несоответствие размерностей матриц при попытке перемножения!")
        else:
            raise ValueError("Использование некорректного типа при умножении матрицы")

print("Тестирование матриц:")
m1 = Matrix([[4, 2], [9, 0]])
m2 = Matrix([[3, 1], [-3, 4]])
t1 = Matrix.transpose(m1)
print("m1:")
print(m1)
print("t1:")
print(t1)
mul1 = m1 * m2
print("mul1:")
print(mul1)
m3 = Matrix([[2, 1], [-3, 0], [4, -1]])
m4 = Matrix([[5, -1, 6], [-3, 0, 7]])
t2 = Matrix.transpose(m4)
print("m4:")
print(m4)
print("t2:")
print(t2)
m5 = Matrix([[1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1], [1, 1, 1, 1, 1]])
# weirdm = Matrix([[1, 2], [3], [4, 5, 6]]) - ругаемся на непрямоугольную матрицу
mul2 = m3 * m4
print("mul2:")
print(mul2)
# wrongmul = m1 * m5 - ругаемся на несоответствие размерностей
vec = Vector([2, 2, 3])
mul3 = m4 * vec
print("mul3:")
print(mul3)

# 3.Метод построения графика произвольной функции от одной переменной
def plot(func, xl=-10, xr=10, yl=-10, yh=10):
    x = np.linspace(xl, xr, 1000)
    y = func(x)
    
    fig, ax = plt.subplots()
    ax.plot(x, y)
    ax.set_xlim(xl, xr)
    ax.set_ylim(yl, yh)
    ax.grid(True, which='both')
    ax.axhline(y=0, color='k')
    ax.axvline(x=0, color='k')
    plt.show()

def f(x):
    return x ** 2
def g(x):
    return 5 * np.sin(x)
plot(f, yl=0, yh = 100)
plot(g)
