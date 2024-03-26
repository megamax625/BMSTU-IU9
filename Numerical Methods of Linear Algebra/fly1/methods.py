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
    def copy(self):
        res = [x for x in self.vec]
        return Vector(res)

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
    def copy(self):
        res = [x[:] for x in self.matrix]
        return Matrix(res)
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
