import math

import glfw
from OpenGL.GL import *

angle = 0.0
polygonMode = False
movx = 0
movy = 0
movz = 0
rotX = 0
rotY = 0
rotZ = 0
pos1 = 0.8
pos2 = 0.4
offsetx = 1.2
offsety = 0.3


def main():
    if not glfw.init():  # инициализация glfw с проверкой
        raise Exception("Couldn't initialize glfw")
    window = glfw.create_window(640, 640, "Lab3", None, None)  # создание окно
    if not window:
        glfw.terminate()
        raise Exception("Couldn't create window")
    glfw.make_context_current(window)  # делает контекст текущим
    glfw.set_key_callback(window, key_callback)  # устанавливает реакцию на нажатие клавиш
    glEnable(GL_DEPTH_TEST)  # для правильной отрисовки трёхмерных объектов
    while not glfw.window_should_close(window):  # отрисовка в цикле

        # переход между каркасным и твердотельным отображением модели
        if polygonMode:
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
        else:
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)

        display(window)
        displayStaticPrism(window)
        glfw.swap_buffers(window)  # меняет местами передний и задние буферы окна
        glfw.poll_events()  # реакция на полученные события
    glfw.destroy_window(window)  # закрытие окна и выключение glfw
    glfw.terminate()


def display(window):  # функция, осуществляющая отрисовку основной призмы
    global angle
    global movx, movy, movz, rotX, rotY, rotZ
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)  # очищает цветовой буфер и буфер глубины
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    # матрица горизонтальной изометрии
    alpha = 0.5
    m = [1, 0, 0, 0,
         0, 1, 0, 0,
         alpha, alpha, 1, 0,
         0, 0, 0, 1]
    glMultMatrixf(m)  # умножение на эту матрицу
    glMatrixMode(GL_MODELVIEW)
    glPushMatrix()
    # повороты объекта
    glRotated(rotX, 1, 0, 0)
    glRotated(rotY, 0, 1, 0)
    glRotated(rotZ, 0, 0, 1)

    glTranslated(movx, movy, movz)  # сдвиг объекта
    glClearColor(1.0, 1.0, 1.0, 1.0)

    # отрисовка призмы
    displayPrism()
    glPopMatrix()  # снимает верхнюю матрицу со стека


def displayPrism():
    # отрисовка основания
    r = pos1 / 2
    glBegin(GL_POLYGON)
    glColor3f(0.3, 0.8, 0.3)
    phi = 0
    basepoints = []  # координаты точек основания
    while phi < math.radians(360):
        basepoints.append([pos1 / 2 + r * math.cos(phi) / 2 - offsetx/2, pos1 / 2 + r * math.sin(phi) / 2 - offsety * 2, pos1 / 2])
        glVertex3f(pos1 / 2 + r * math.cos(phi) / 2 - offsetx/2, pos1 / 2 + r * math.sin(phi) / 2 - offsety * 2, pos1 / 2)
        phi += math.radians(52)  # 52 > 360/7
    glEnd()

    # задаём направляющий вектор
    vecrx = pos1 / 2
    vecry = pos1 / 2
    vecrz = pos1 / 2

    # отрисовка верхнего основания
    cappoints = []
    glBegin(GL_POLYGON)
    glColor3f(0.6, 0.3, 0.3)
    for base in basepoints:
        cappoints.append([base[0] + vecrx, base[1] + vecry, base[2] + vecrz])
        glVertex3f(base[0] + vecrx, base[1] + vecry, base[2] + vecrz)
    glEnd()

    # отрисовка боковых граней
    for n in range(len(basepoints)):
        glBegin(GL_POLYGON)
        glColor3f(0.1 + n * 0.1, 0.9 - n * 0.15, 0.5 + n * 0.05)
        if n < 6:
            glVertex3f(basepoints[n][0], basepoints[n][1], basepoints[n][2])
            glVertex3f(basepoints[n+1][0], basepoints[n+1][1], basepoints[n+1][2])
            glVertex3f(cappoints[n+1][0], cappoints[n+1][1], cappoints[n+1][2])
            glVertex3f(cappoints[n][0], cappoints[n][1], cappoints[n][2])
        else:
            glVertex3f(basepoints[n][0], basepoints[n][1], basepoints[n][2])
            glVertex3f(basepoints[0][0], basepoints[0][1], basepoints[0][2])
            glVertex3f(cappoints[0][0], cappoints[0][1], cappoints[0][2])
            glVertex3f(cappoints[n][0], cappoints[n][1], cappoints[n][2])
        glEnd()


def displayStaticPrism(window):  # отрисовка призмы, не меняющейся при модельно-видовых преобразованиях
    global offset
    glPushMatrix()
    # отрисовка основания
    r = pos2 / 2
    glBegin(GL_POLYGON)
    glColor3f(0.3, 0.8, 0.3)
    phi = 0
    basepoints = []  # координаты точек основания
    while phi < math.radians(360):
        basepoints.append([pos2 / 2 + r * math.cos(phi) / 2 - offsetx, pos2 / 2 + r * math.sin(phi) / 2 + offsety, pos2 / 2])
        glVertex3f(pos2 / 2 + r * math.cos(phi) / 2 - offsetx, pos2 / 2 + r * math.sin(phi) / 2 + offsety, pos2 / 2)
        phi += math.radians(52)  # 52 > 360/7
    glEnd()

    # задаём направляющий вектор
    vecrx = pos2 / 2
    vecry = pos2 / 2
    vecrz = pos2 / 2

    # отрисовка верхнего основания
    cappoints = []
    glBegin(GL_POLYGON)
    glColor3f(0.6, 0.3, 0.3)
    for base in basepoints:
        cappoints.append([base[0] + vecrx, base[1] + vecry, base[2] + vecrz])
        glVertex3f(base[0] + vecrx, base[1] + vecry, base[2] + vecrz)
    glEnd()

    # отрисовка боковых граней
    for n in range(len(basepoints)):
        glBegin(GL_POLYGON)
        glColor3f(0.1 + n * 0.1, 0.9 - n * 0.15, 0.5 + n * 0.05)
        if n < 6:
            glVertex3f(basepoints[n][0], basepoints[n][1], basepoints[n][2])
            glVertex3f(basepoints[n + 1][0], basepoints[n + 1][1], basepoints[n + 1][2])
            glVertex3f(cappoints[n + 1][0], cappoints[n + 1][1], cappoints[n + 1][2])
            glVertex3f(cappoints[n][0], cappoints[n][1], cappoints[n][2])
        else:
            glVertex3f(basepoints[n][0], basepoints[n][1], basepoints[n][2])
            glVertex3f(basepoints[0][0], basepoints[0][1], basepoints[0][2])
            glVertex3f(cappoints[0][0], cappoints[0][1], cappoints[0][2])
            glVertex3f(cappoints[n][0], cappoints[n][1], cappoints[n][2])
        glEnd()

    glPopMatrix()  # снимает верхнюю матрицу со стека


def key_callback(window, key, scancode, action, mods):  # установка реакции на нажатие клавиш
    global angle
    global polygonMode
    global movx, movy, movz, rotX, rotY, rotZ, pos1, pos2
    if action == glfw.PRESS:
        if key == glfw.KEY_ENTER:  # реакция на нажатие клавиши ENTER - переход между каркасным и твердотельным режимами
            polygonMode = not polygonMode
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
        if key == glfw.KEY_F1 and pos1 < 1.0:
            pos1 += 0.1
        if key == glfw.KEY_F2 and pos1 > 0.4:
            pos1 -= 0.1


main()
