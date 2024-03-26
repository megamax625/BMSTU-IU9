from math import sqrt
from matplotlib import pyplot as plt
import numpy as np # только для построения графика функции
import random

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
    def __getitem__(self, index):
        return self.vec[index]
    def copy(self):
        res = [x for x in self.vec]
        return Vector(res)
    def __add__(self, arg):
        if type(arg) == Vector:
            if len(self) != len(arg):
                raise ValueError("Несоответствующая размерность векторов при попытке скалярного произведения!")
            res = [self.vec[i] + arg.vec[i] for i in range(len(self))]
            return Vector(res)
    def __sub__(self, arg):
        if type(arg) == Vector:
            if len(self) != len(arg):
                raise ValueError("Несоответствующая размерность векторов при попытке скалярного произведения!")
            res = [self.vec[i] - arg.vec[i] for i in range(len(self))]
            return Vector(res)
    def __mul__(self, arg):
        # умножение матрицы на число
        return Vector([self.vec[i] * arg for i in range(len(self))])

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
    def __setitem__(self, index, value):
        self.matrix[index] = value
    def __getitem__(self, index):
        if isinstance(index, tuple) and len(index) == 2 and all(isinstance(ind, slice) for ind in index):
            # print(index[0].start, index[0].stop, index[1].start, index[1].stop)
            return [self.matrix[i][index[1].start:index[1].stop] for i in range(index[0].start, index[0].stop)]
        elif isinstance(index, slice):
            return self.matrix[index]
        elif isinstance(index, int):
            return self.matrix[index]
    def copy(self):
        res = [x[:] for x in self.matrix]
        return Matrix(res)
    # вычитание матриц
    def __add__(self, arg):
        if type(arg) == type(self):
            return Matrix([[(self.matrix[i][j] + arg.matrix[i][j]) for j in range(self.width)] for i in range(self.height)])
    def __sub__(self, arg):
        if type(arg) == type(self):
            return Matrix([[(self.matrix[i][j] - arg.matrix[i][j]) for j in range(self.width)] for i in range(self.height)])
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
                        for k in range(self.width):
                            res[i][j] += self[i][k] * arg[k][j]
                return res
            else:
                raise ValueError("Несоответствие размерностей матриц при попытке перемножения!")
        elif isinstance(arg, (float, np.float64, np.float32, np.float16, int)):
            res = self
            for i in range(res.height):
                for j in range(res.width):
                    res.matrix[i][j] *= arg
            return res
        else:
            raise ValueError("Использование некорректного типа при умножении матрицы")

# 3.Метод построения графика произвольной функции от одной переменной
def plot(func, semilogy=False, xl=-10, xr=10, yl=-10, yh=10, pointNum=1000):
    x = np.linspace(xl, xr, pointNum)
    y = func(x)
    
    valid_indices = np.isfinite(y)
    x = x[valid_indices]
    y = y[valid_indices]

    fig, ax = plt.subplots()
    ax.plot(x, y)
    ax.set_xlim(xl, xr)
    ax.set_ylim(yl, yh)
    ax.grid(True, which='both')
    ax.axhline(y=0, color='k')
    ax.axvline(x=0, color='k')
    if semilogy:
        ax.set_yscale('symlog')
    plt.show()

# генерация случайных матриц и векторов
def random_Matrix_PosDef(n, a, b):
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
    return res * res.transpose()

def random_Matrix(n, a, b):
    res = Matrix.create_empty(n, n)
    for i in range(n):
        for j in range(n):
            res.matrix[i][j] = (random.random() + (a/b)) * b - random.random() * a
    return res

def random_Matrix_int(n, a, b):
    res = Matrix.create_empty(n, n)
    for i in range(n):
        for j in range(n):
            res.matrix[i][j] = random.randint(a, b)
    return res


def random_Vector(n, a, b):
    return Vector([(random.random() + (a/b)) * b - random.random() * a for _ in range(n)])

# норма матрицы
def get_Matrix_Norm(mat):
    # return max([sum([abs(mat[i][j]) if i != j else 0 for j in range(len(mat[i]))]) / abs(mat[i][i]) for i in range(len(mat))])
    return max([sum([abs(mat[i][j]) for j in range(len(mat[i]))]) for i in range(len(mat))])