import random

import glfw
from OpenGL.GL import *

movx = 0
movy = 0
movz = 0
rotX = 0
rotY = 0
rotZ = 0
pos1 = 0.4
vertexes = []  # вершины многоугольника
width = 640
height = 480
maxwidth, maxheight = 800, 600  # задаём предельные значения для размеров окна
minwidth, minheight = 200, 200
pixelBuffer = []  # выделяем буфер памяти и заполняем нулями
edgeStatus = False
clipping = False
intersections = [[] for _ in range(height)]
lines = []
clipLines = []
offsetX = 0.3
offsetY = 0.3
offsetZ = 0.3


def main():
    global lines

    if not glfw.init():  # инициализация glfw с проверкой
        raise Exception("Couldn't initialize glfw")
    window = glfw.create_window(width, height, "Lab5", None, None)  # создание окна
    glClearColor(1.0, 1.0, 1.0, 1.0)
    if not window:
        glfw.terminate()
        raise Exception("Couldn't create window")
    glfw.make_context_current(window)  # делает контекст текущим
    glfw.set_key_callback(window, key_callback)  # устанавливает реакцию на нажатие клавиш
    glfw.set_window_size_callback(window, window_size_callback)  # устанавливает реакцию на изменение размеров окна
    glEnable(GL_DEPTH_TEST)  # для правильной отрисовки трёхмерных объектов
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
    lines = makelines(5)
    while not glfw.window_should_close(window):  # отрисовка в цикле
        display(window)
        glfw.swap_buffers(window)  # меняет местами передний и задние буферы окна
        glfw.poll_events()  # реакция на полученные события
    glfw.destroy_window(window)  # закрытие окна и выключение glfw
    glfw.terminate()


def display(window):
    global width, height, lines, clipLines
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    glScalef(1, -1, 1)
    glMatrixMode(GL_MODELVIEW)
    glPushMatrix()
    # повороты объекта
    glRotated(rotX, 1, 0, 0)
    glRotated(rotY, 0, 1, 0)
    glRotated(rotZ, 0, 0, 1)

    glTranslated(movx, movy, movz)  # сдвиг объекта
    glClearColor(1.0, 1.0, 1.0, 1.0)

    displayCube()
    if clipping:
        if not clipLines:
            clipLines = clip_lines(lines)
        display_lines(clipLines)
    else:
        display_lines(lines)
    glPopMatrix()


def makelines(n):
    linearr = []
    for i in range(n):
        line = []
        for i in range(2):
            point = [random.random() / 2, random.random() / 2, random.random() / 2]
            endCode = get_endCode(point)
            point.append(endCode)
            line.append(point)
        linearr.append(line)
    return linearr


def get_endCode(point):
    endCode = 0x0
    if point[0] < -pos1 / 2:  # вычисление кода для x
        endCode = endCode or 0x000001
    elif point[0] > pos1 / 2:
        endCode = endCode or 0x000100
    if point[1] < -pos1 / 2:  # вычисление кода для y
        endCode = endCode or 0x001000
    elif point[1] > pos1 / 2:
        endCode = endCode or 0x000010
    if point[2] < -pos1 / 2:  # вычисление кода для z
        endCode = endCode or 0x010000
    elif point[2] > pos1 / 2:
        endCode = endCode or 0x100000
    return endCode


def clip_lines(ls):  # алгоритм Коэна - Сазерленда
    for i in range(len(ls)):
        line = clip_line(ls[i])
        clipLines.append(line)
    return clipLines


def clip_line(line):
    p1 = line[0]
    p2 = line[1]
    if p1[3] == 0 and p2[3] == 0:  # линию не нужно отсекать, 1 для того, чтобы отличить отсечённую линию
        return [p1, p2, 1]
    elif p1[3] and p2[3] == 0:  # линия не целиком вне окна
        if p1[3] != 0:
            p1 = find_intersection(p1, p2)
            endCode = get_endCode(p1)
            p1.append(endCode)
        else:  # p2[3] != 0
            p2 = find_intersection(p1, p2)
            endCode = get_endCode(p2)
            p2.append(endCode)
    clip_line([p1, p2])


def find_intersection(first, second):
    endCode = first[3]
    x, y, z = first[0], first[1], first[2]
    x1, y1, z1 = second[0], second[1], second[2]
    interx, intery, interz = 0, 0, 0
    if endCode and 0x000001 != 0:  # x < -pos1/2
        interx = -pos1 / 2
        yslope = (y1 - y) / (x1 - x)
        zslope = (z1 - z) / (x1 - x)
        intery = y + yslope * (interx - x)
        interz = z + zslope * (interx - x)
    elif endCode and 0x000010 != 0:  # y > pos1/2
        intery = pos1 / 2
        xslope = (x1 - x) / (y1 - y)
        zslope = (z1 - z) / (y1 - y)
        interx = x + xslope * (intery - y)
        interz = z + zslope * (intery - y)
    elif endCode and 0x000100 != 0:  # x > pos1/2
        interx = pos1 / 2
        yslope = (y1 - y) / (x1 - x)
        zslope = (z1 - z) / (x1 - x)
        intery = y + yslope * (interx - x)
        interz = z + zslope * (interx - x)
    elif endCode and 0x001000 != 0:  # y < -pos1/2
        intery = -pos1 / 2
        xslope = (x1 - x) / (y1 - y)
        zslope = (z1 - z) / (y1 - y)
        interx = x + xslope * (intery - y)
        interz = z + zslope * (intery - y)
    elif endCode and 0x010000 != 0:  # z < -pos1/2
        interz = -pos1 / 2
        xslope = (x1 - x) / (z1 - z)
        yslope = (y1 - y) / (z1 - z)
        interx = x + xslope * (interz - z)
        intery = y + yslope * (interz - z)
    elif endCode and 0x100000 != 0:  # z > pos/2
        interz = pos1 / 2
        xslope = (x1 - x) / (z1 - z)
        yslope = (y1 - y) / (z1 - z)
        interx = x + xslope * (interz - z)
        intery = y + yslope * (interz - z)

    return [interx, intery, interz]


def display_lines(ls):
    for n in range(len(ls)):
        glBegin(GL_LINES)
        if len(ls[n]) == 3:  # если в линии хранится 3 переменные, то на ней отработал алгоритм отсечения
            glColor3f(1.0, 0.2, 0.2)
        else:
            glColor3f(0.1 + n * 0.1, 0.1 + n * 0.1, 0.1 + n * 0.1)
            glColor3f(1.0, 0.2, 0.2)
        for i in range(2):
            glVertex3f(ls[n][i][0] - offsetX, ls[n][i][1] - offsetY, ls[n][i][2] - offsetZ)
        glEnd()


def key_callback(window, key, scancode, action, mods):  # установка реакции на нажатие клавиш
    global vertexes, edgeStatus, clipping
    global movx, movy, movz, rotX, rotY, rotZ
    if action == glfw.PRESS:
        if key == glfw.KEY_ENTER:  # очистка области вывода
            vertexes.clear()
        if key == glfw.KEY_LEFT_ALT:
            movx += 0.1
        if key == glfw.KEY_LEFT_CONTROL:
            movx -= 0.1
        if key == glfw.KEY_LEFT_SHIFT:
            movy += 0.1
        if key == glfw.KEY_RIGHT_ALT:
            movy -= 0.1
        if key == glfw.KEY_RIGHT_CONTROL:
            movz += 0.1
        if key == glfw.KEY_RIGHT_SHIFT:
            movz -= 0.1
        if key == glfw.KEY_S:
            rotX += 5
        if key == glfw.KEY_D:
            rotY += 5
        if key == glfw.KEY_F:
            rotZ += 5
        if key == glfw.KEY_C:
            clipping = True


def window_size_callback(window, widthnew, heightnew):  # реакция на изменение размеров окна
    global width, height, intersections
    width = widthnew
    height = heightnew
    if height < minheight:
        height = minheight
    elif height > maxheight:
        height = maxheight
    if width < minwidth:
        width = minwidth
    elif width > maxwidth:
        width = maxwidth
    if (width != widthnew) or (height != heightnew):
        glfw.set_window_size(window, width, height)
    glViewport(0, 0, width, height)
    intersections = [[] for _ in range(height)]  # при изменении размера окна вся введённая ранее информация удаляется
    vertexes.clear()


def displayCube():
    # отрисовка куба
    # передняя грань
    glBegin(GL_POLYGON)
    glColor3f(0.6, 0.6, 1.0)
    glVertex3f(pos1 / 2, -pos1 / 2, -pos1 / 2)
    glVertex3f(pos1 / 2, pos1 / 2, -pos1 / 2)
    glVertex3f(-pos1 / 2, pos1 / 2, -pos1 / 2)
    glVertex3f(-pos1 / 2, -pos1 / 2, -pos1 / 2)
    glEnd()

    # задняя грань
    glBegin(GL_POLYGON)
    glColor3f(1.0, 1.0, 0.6)
    glVertex3f(pos1 / 2, -pos1 / 2, pos1 / 2)
    glVertex3f(pos1 / 2, pos1 / 2, pos1 / 2)
    glVertex3f(-pos1 / 2, pos1 / 2, pos1 / 2)
    glVertex3f(-pos1 / 2, -pos1 / 2, pos1 / 2)
    glEnd()

    # верхняя грань
    glBegin(GL_POLYGON)
    glColor3f(1.0, 0.0, 0.6)
    glVertex3f(pos1 / 2, pos1 / 2, pos1 / 2)
    glVertex3f(pos1 / 2, pos1 / 2, -pos1 / 2)
    glVertex3f(-pos1 / 2, pos1 / 2, -pos1 / 2)
    glVertex3f(-pos1 / 2, pos1 / 2, pos1 / 2)
    glEnd()

    # нижняя грань
    glBegin(GL_POLYGON)
    glColor3f(0.6, 1.0, 0.0)
    glVertex3f(pos1 / 2, -pos1 / 2, -pos1 / 2)
    glVertex3f(pos1 / 2, -pos1 / 2, pos1 / 2)
    glVertex3f(-pos1 / 2, -pos1 / 2, pos1 / 2)
    glVertex3f(-pos1 / 2, -pos1 / 2, -pos1 / 2)
    glEnd()
    # правая грань
    glBegin(GL_POLYGON)
    glColor3f(1.0, 0.6, 1.0)
    glVertex3f(pos1 / 2, -pos1 / 2, -pos1 / 2)
    glVertex3f(pos1 / 2, pos1 / 2, -pos1 / 2)
    glVertex3f(pos1 / 2, pos1 / 2, pos1 / 2)
    glVertex3f(pos1 / 2, -pos1 / 2, pos1 / 2)
    glEnd()

    # левая грань
    glBegin(GL_POLYGON)
    glColor3f(0.0, 1.0, 0.0)
    glVertex3f(-pos1 / 2, -pos1 / 2, pos1 / 2)
    glVertex3f(-pos1 / 2, pos1 / 2, pos1 / 2)
    glVertex3f(-pos1 / 2, pos1 / 2, -pos1 / 2)
    glVertex3f(-pos1 / 2, -pos1 / 2, -pos1 / 2)
    glEnd()


main()
