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
width = 640
height = 480
maxwidth, maxheight = 800, 600  # задаём предельные значения для размеров окна
minwidth, minheight = 200, 200
clipping = False
lines = []
clipLines = []


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
    lines = makelines(7)
    while not glfw.window_should_close(window):  # отрисовка в цикле
        display(window)
        glfw.swap_buffers(window)  # меняет местами передний и задние буферы окна
        glfw.poll_events()  # реакция на полученные события
    glfw.destroy_window(window)  # закрытие окна и выключение glfw
    glfw.terminate()


def makelines(n):
    linearr = []
    for i in range(n):
        line = []
        for j in range(2):
            point = [random.uniform(-pos1, pos1), random.uniform(-pos1, pos1), random.uniform(-pos1, pos1)]
            endCode = get_endCode(point)
            point.append(endCode)
            line.append(point)
        linearr.append(line)
    return linearr


def get_endCode(point):
    endCode = 0b000000
    if point[0] < -pos1 / 2:  # вычисление кода для x
        endCode = endCode | 0b000001
    elif point[0] > pos1 / 2:
        endCode = endCode | 0b000100
    if point[1] < -pos1 / 2:  # вычисление кода для y
        endCode = endCode | 0b001000
    elif point[1] > pos1 / 2:
        endCode = endCode | 0b000010
    if point[2] < -pos1 / 2:  # вычисление кода для z
        endCode = endCode | 0b010000
    elif point[2] > pos1 / 2:
        endCode = endCode | 0b100000
    return endCode


def clip_lines(ls):  # алгоритм Коэна - Сазерленда
    global clipLines
    for i in range(len(ls)):
        line = clip_line(ls[i])
        clipLines.append(line)


def clip_line(line):
    p1 = line[0]
    p2 = line[1]
    if p1[3] == 0 and p2[3] == 0:  # линию не нужно отсекать, вносим 1 для того, чтобы отличить отсечённую линию
        return [p1, p2, 1]
    elif not ((p1[3] & p2[3]) != 0):  # линия не целиком вне окна
        newLine = find_intersection(p1, p2)
        newLine[0].append(get_endCode(newLine[0]))
        newLine[1].append(get_endCode(newLine[1]))
        return clip_line(newLine)
    else:
        return [0]  # линия целиком вне окна


def find_intersection(first, second):
    endCodes = [first[3], second[3]]
    xs = [first[0], second[0]]
    ys = [first[1], second[1]]
    zs = [first[2], second[2]]
    interx, intery, interz = 0, 0, 0
    a = (xs[1] - xs[0]) / (ys[1] - ys[0])
    b = (ys[1] - ys[0]) / (zs[1] - zs[0])
    for i in range(2):
        if (endCodes[i] & 0b000001) != 0:  # x < -pos1/2
            interx = -pos1 / 2
            ys[i] = (interx - xs[i]) / a + ys[i]
            zs[i] = (interx - xs[i]) / (a * b) + zs[i]
            xs[i] = interx
        elif (endCodes[i] & 0b000100) != 0:  # x > pos1/2
            interx = pos1 / 2
            ys[i] = (interx - xs[i]) / a + ys[i]
            zs[i] = (interx - xs[i]) / (a * b) + zs[i]
            xs[i] = interx
        if (endCodes[i] & 0b000010) != 0:  # y > pos1/2
            intery = pos1 / 2
            xs[i] = (intery - ys[i]) * a + xs[i]
            zs[i] = (intery - ys[i]) / b + zs[i]
            ys[i] = intery
        elif (endCodes[i] & 0b001000) != 0:  # y < -pos1/2
            intery = -pos1 / 2
            xs[i] = (intery - ys[i]) * a + xs[i]
            zs[i] = (intery - ys[i]) / b + zs[i]
            ys[i] = intery
        if (endCodes[i] & 0b010000) != 0:  # z < -pos1/2
            interz = -pos1 / 2
            xs[i] = (interz - zs[i]) * a * b + xs[i]
            ys[i] = (interz - zs[i]) * b + ys[i]
            zs[i] = interz
        elif (endCodes[i] & 0b100000) != 0:  # z > pos/2
            interz = pos1 / 2
            xs[i] = (interz - zs[i]) * a * b + xs[i]
            ys[i] = (interz - zs[i]) * b + ys[i]
            zs[i] = interz

    return [[xs[0], ys[0], zs[0]], [xs[1], ys[1], zs[1]]]


def display_lines(ls):
    for n in range(len(ls)):
        if ls[n] == [0]:
            continue
        glBegin(GL_LINES)
        if len(ls[n]) == 3:  # если в линии хранится 3 переменные, то на ней отработал алгоритм отсечения
            glColor3f(1.0, 0.2, 1.0)
        else:
            glColor3f(0.1 + n * 0.03, 0.5, 0.8)
        glVertex3f(ls[n][0][0], ls[n][0][1], ls[n][0][2])
        glVertex3f(ls[n][1][0], ls[n][1][1], ls[n][1][2])
        glEnd()


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
        display_lines(clipLines)
    else:
        display_lines(lines)
    glPopMatrix()


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


def key_callback(window, key, scancode, action, mods):  # установка реакции на нажатие клавиш
    global vertexes, edgeStatus, clipping, lines, clipLines
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
            if not clipLines:
                clip_lines(lines)
            clipping = not clipping


def window_size_callback(window, widthnew, heightnew):  # реакция на изменение размеров окна
    global width, height
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


main()
