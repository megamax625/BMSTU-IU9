import math

from timeit import default_timer as timer
import numpy as np
from PIL import Image
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
acceleration = 0.000005
velocity = 0.0
fall = False
textured = False
texLoaded = False
fallpos = 0.0
basepoints = []  # координаты точек основания
cappoints = []  # координаты точек нижнего основания
maxtime, mintime = 0, 100000.0


def main():
    global maxtime, mintime
    if not glfw.init():  # инициализация glfw с проверкой
        raise Exception("Couldn't initialize glfw")
    window = glfw.create_window(640, 640, "Lab6", None, None)  # создание окно
    if not window:
        glfw.terminate()
        raise Exception("Couldn't create window")
    glfw.make_context_current(window)  # делает контекст текущим
    glfw.set_key_callback(window, key_callback)  # устанавливает реакцию на нажатие клавиш

    # задание параметров модели освещения
    light_ambient = [0.0, 0.0, 0.0, 1.0]
    light_diffuse = [1.0, 1.0, 1.0, 1.0]
    light_specular = [1.0, 1.0, 1.0, 1.0]
    light_position = [1.0, 1.0, 1.0, 0.0]

    glLightfv(GL_LIGHT0, GL_AMBIENT, light_ambient)
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light_diffuse)
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular)
    glLightfv(GL_LIGHT0, GL_POSITION, light_position)

    glLightfv(GL_LIGHT0, GL_AMBIENT, light_position)
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light_position)
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_position)

    glLightfv(GL_LIGHT0, GL_POSITION, light_position)
    glLightfv(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 2.0)
    glLightfv(GL_LIGHT0, GL_LINEAR_ATTENUATION, 1.0)
    glLightfv(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, 0.5)

    glEnable(GL_DEPTH_TEST)  # для правильной отрисовки трёхмерных объектов
    glEnable(GL_LIGHTING)
    glEnable(GL_LIGHT0)
    glEnable(GL_NORMALIZE)
    glShadeModel(GL_FLAT | GL_SMOOTH)
    generateTexture()
    while not glfw.window_should_close(window):  # отрисовка в цикле
        # замер времени для оценки производительности
        start = timer()
        # переход между каркасным и твердотельным отображением модели
        if polygonMode:
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
        else:
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
        if textured:
            glEnable(GL_TEXTURE_2D)
        else:
            glDisable(GL_TEXTURE_2D)

        display(window)
        glfw.swap_buffers(window)  # меняет местами передний и задние буферы окна
        glfw.poll_events()  # реакция на полученные события
        # конец замера времени для оценки производительности
        end = timer()
        test = ((end - start) * 1000.0) # время в ms
        if test > maxtime:
            maxtime = test
        if test < mintime:
            mintime = test
    glfw.destroy_window(window)  # закрытие окна и выключение glfw
    glfw.terminate()


def display(window):  # функция, осуществляющая отрисовку основной призмы
    global angle
    global movx, movy, movz, rotX, rotY, rotZ
    global basepoints, cappoints, fallpos, acceleration, velocity, fall
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
    if not fall:
        glRotated(rotX, 1, 0, 0)
        glRotated(rotY, 0, 1, 0)
        glRotated(rotZ, 0, 0, 1)
    else:
        rotX, rotY, rotZ = 0, 0, 0
    glTranslated(movx, movy, movz)  # сдвиг объекта

    # моделирование равноускоренного падения
    if fall:
        glPushMatrix()
        minPointY = 1.0
        for base in basepoints:
            if base[1] + fallpos + movy <= minPointY:
                minPointY = base[1] + fallpos + movy
        for cap in cappoints:
            if cap[1] + fallpos + movy <= minPointY:
                minPointY = cap[1] + fallpos + movy
        fallpos += velocity
        velocity += acceleration
        if minPointY <= -1 + velocity + 0.4:
            velocity = -1 * velocity
            fallpos += velocity
        glTranslated(0, fallpos, 0)  # сдвиг объекта
        glPopMatrix()

    glClearColor(1.0, 1.0, 1.0, 1.0)

    light_position = [1.0 + movx, 1.0 + movy, 1.0 + movz, 0.0]
    glLightfv(GL_LIGHT0, GL_POSITION, light_position)
    # отрисовка призмы
    displayPrism()
    glPopMatrix()  # снимает верхнюю матрицу со стека


def generateTexture():  # загрузка и задание параметров текстуры
    global texLoaded
    texture = glGenTextures(1)
    glBindTexture(GL_TEXTURE_2D, texture)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    image = Image.open("something.jpg")
    img_data = np.array(list(image.getdata()), np.uint8)
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, image.width, image.height, 0, GL_RGB, GL_UNSIGNED_BYTE, img_data)
    glGenerateMipmap(GL_TEXTURE_2D)
    glEnable(GL_TEXTURE_2D)
    glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL)


def cross(a, b):        # нахождение векторного произведения
    c = [a[1] * b[2] - a[2] * b[1],
         a[2] * b[0] - a[0] * b[2],
         a[0] * b[1] - a[1] * b[0]]

    return c


def displayPrism():
    global fallpos, velocity, acceleration
    global basepoints, cappoints
    minPointY = 1.0
    # отрисовка основания
    r = pos1 / 2
    phi = 0
    basepoints = []  # координаты точек основания
    while phi < math.radians(360):
        basepoints.append(
            [pos1 / 2 + r * math.cos(phi) / 2 - offsetx / 2, pos1 / 2 + r * math.sin(phi) / 2 - offsety * 2 - fallpos,
             pos1 / 2])
        phi += math.radians(52)  # 52 > 360/7

    # задаём направляющий вектор
    vecrx = pos1 / 2
    vecry = pos1 / 2
    vecrz = pos1 / 2

    # отрисовка верхнего и нижнего основания
    cappoints = []

    normVBase = [[] for i in range(7)]
    normVCap = [[] for i in range(7)]
    for i in range(7):
        cappoints.append([basepoints[i][0] + vecrx, basepoints[i][1] + vecry - fallpos, basepoints[i][2] + vecrz])
    for i in range(7):
        v1 = basepoints[i]
        if i == 6:
            v2 = basepoints[0]
            v3 = basepoints[1]
        elif i == 5:
            v2 = basepoints[i + 1]
            v3 = basepoints[0]
        else:
            v2 = basepoints[i + 1]
            v3 = basepoints[i + 2]
        norm = getNorm([v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]],
                       [v2[0] - v1[0], v2[1] - v1[1], v2[2] - v1[2]],
                       [v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2]])
        normVBase[i].append(list(norm))

        v1 = cappoints[i]
        if i == 6:
            v2 = cappoints[0]
            v3 = cappoints[1]
        elif i == 5:
            v2 = cappoints[i + 1]
            v3 = cappoints[0]
        else:
            v2 = cappoints[i + 1]
            v3 = cappoints[i + 2]
        norm = getNorm([v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]],
                       [v2[0] - v1[0], v2[1] - v1[1], v2[2] - v1[2]],
                       [v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2]])
        normVCap[i].append(list(norm))

        v1 = basepoints[i]
        v2 = cappoints[i]
        if i == 6:
            v3 = basepoints[0]
        else:
            v3 = basepoints[i + 1]
        norm = getNorm([v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]],
                       [v2[0] - v1[0], v2[1] - v1[1], v2[2] - v1[2]],
                       [v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2]])
        normVBase[i].append(list(norm))

        v1 = basepoints[i]
        v2 = cappoints[i]
        if i == 0:
            v3 = basepoints[6]
        else:
            v3 = basepoints[i - 1]
        norm = getNorm([v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]],
                       [v2[0] - v1[0], v2[1] - v1[1], v2[2] - v1[2]],
                       [v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2]])
        normVBase[i].append(list(norm))

        v1 = cappoints[i]
        v2 = basepoints[i]
        if i == 6:
            v3 = cappoints[0]
        else:
            v3 = cappoints[i + 1]
        norm = getNorm([v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]],
                       [v2[0] - v1[0], v2[1] - v1[1], v2[2] - v1[2]],
                       [v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2]])
        normVCap[i].append(list(norm))

        v1 = cappoints[i]
        v2 = basepoints[i]
        if i == 0:
            v3 = cappoints[6]
        else:
            v3 = cappoints[i - 1]
        norm = getNorm([v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]],
                       [v2[0] - v1[0], v2[1] - v1[1], v2[2] - v1[2]],
                       [v3[0] - v1[0], v3[1] - v1[1], v3[2] - v1[2]])
        normVCap[i].append(list(norm))

        normVBase[i] = getAvgVecsFromList(normVBase[i])
        normVCap[i] = getAvgVecsFromList(normVCap[i])

    glBegin(GL_POLYGON)
    glColor(0.3, 0.8, 0.3)
    for i in range(7):
        glTexCoord2f((math.cos(math.radians(52 * i)) + 1.0) / 2, (math.sin(math.radians(52 * i)) + 1.0) / 2)
        glVertex3f(basepoints[i][0], basepoints[i][1], basepoints[i][2])
        glNormal3fv(normVBase[i])
    glEnd()
    glBegin(GL_POLYGON)
    glColor3f(0.6, 0.3, 0.3)
    for i in range(7):
        glTexCoord2f((math.cos(math.radians(52 * i)) + 1.0) / 2, (math.sin(math.radians(52 * i)) + 1.0) / 2)
        glVertex3f(cappoints[i][0], cappoints[i][1], cappoints[i][2])
        glNormal3fv(normVCap[i])
    glEnd()

    # отрисовка боковых граней
    for n in range(len(basepoints)):
        glBegin(GL_POLYGON)
        glColor3f(0.1 + n * 0.1, 0.9 - n * 0.15, 0.5 + n * 0.05)
        if n < 6:
            glTexCoord2f(0.0, 0.0)
            glVertex3f(basepoints[n][0], basepoints[n][1], basepoints[n][2])
            glNormal3fv(normVBase[n])
            glTexCoord2f(1.0, 0.0)
            glVertex3f(basepoints[n + 1][0], basepoints[n + 1][1], basepoints[n + 1][2])
            glNormal3fv(normVBase[n + 1])
            glTexCoord2f(1.0, 1.0)
            glVertex3f(cappoints[n + 1][0], cappoints[n + 1][1], cappoints[n + 1][2])
            glNormal3fv(normVCap[n + 1])
            glTexCoord2f(0.0, 1.0)
            glVertex3f(cappoints[n][0], cappoints[n][1], cappoints[n][2])
            glNormal3fv(normVCap[n])
        else:
            glTexCoord2f(0.0, 0.0)
            glVertex3f(basepoints[n][0], basepoints[n][1], basepoints[n][2])
            glNormal3fv(normVBase[n])
            glTexCoord2f(1.0, 0.0)
            glVertex3f(basepoints[0][0], basepoints[0][1], basepoints[0][2])
            glNormal3fv(normVBase[0])
            glTexCoord2f(1.0, 1.0)
            glVertex3f(cappoints[0][0], cappoints[0][1], cappoints[0][2])
            glNormal3fv(normVCap[0])
            glTexCoord2f(0.0, 1.0)
            glVertex3f(cappoints[n][0], cappoints[n][1], cappoints[n][2])
            glNormal3fv(normVCap[n])
        glEnd()


def getNorm(v1, v2, v3):        # получение нормированного [v1 - v2] x [v2 - v3]
    crossvec = cross([v1[0] - v2[0], v1[1] - v2[1], v1[2] - v2[2]],
                     [v2[0] - v3[0], v2[1] - v3[1], v2[2] - v3[2]])
    norm = [(float(i) - min(crossvec)) / (max(crossvec) - min(crossvec)) for i in crossvec]
    return norm


def getAvgVecsFromList(vs):     # получение усреднённого вектора из списка векторов
    res = []
    sumx = 0
    sumy = 0
    sumz = 0
    len = 0
    for vec in vs:
        sumx += vec[0]
        sumy += vec[1]
        sumz += vec[2]
        len += 1
    res.append([sumx / len, sumy / len, sumz / len])
    return res


def key_callback(window, key, scancode, action, mods):  # установка реакции на нажатие клавиш
    global angle
    global polygonMode
    global movx, movy, movz, rotX, rotY, rotZ, pos1, pos2, acceleration, velocity, fall, textured
    global maxtime, mintime
    if action == glfw.PRESS:
        print("Max time: ", "{:.2f}".format(maxtime), "\nMin time: ", "{:.2f}".format(mintime))
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
        if key == glfw.KEY_L:
            velocity = 0
            fall = not fall
        if key == glfw.KEY_K:
            textured = not textured


main()
