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
offset = 0.8


def main():
    if not glfw.init():  # инициализация glfw с проверкой
        raise Exception("Couldn't initialize glfw")
    window = glfw.create_window(640, 640, "Lab2", None, None)  # создание окно
    if not window:
        glfw.terminate()
        raise Exception("Couldn't create window")
    glfw.make_context_current(window)  # делает контекст текущим
    glfw.set_key_callback(window, key_callback)  # устанавливает реакцию на нажатие клавиш
    glEnable(GL_DEPTH_TEST)                      # для правильной отрисовки трёхмерных объектов
    while not glfw.window_should_close(window):  # отрисовка в цикле

        # переход между каркасным и твердотельным отображением модели
        if polygonMode:
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL)
        else:
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)

        display(window)
        displayStaticCube(window)
        glfw.swap_buffers(window)  # меняет местами передний и задние буферы окна
        glfw.poll_events()  # реакция на полученные события
    glfw.destroy_window(window)  # закрытие окна и выключение glfw
    glfw.terminate()


def display(window):  # функция, осуществляющая отрисовку основного куба
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
    glMultMatrixf(m)    # умножение на эту матрицу
    glMatrixMode(GL_MODELVIEW)
    glPushMatrix()
    # повороты объекта
    glRotated(rotX, 1, 0, 0)
    glRotated(rotY, 0, 1, 0)
    glRotated(rotZ, 0, 0, 1)

    glTranslated(movx, movy, movz)  # сдвиг объекта
    glClearColor(1.0, 1.0, 1.0, 1.0)

    # отрисовка куба
    displayCube()
    glPopMatrix()  # снимает верхнюю матрицу со стека


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


def displayStaticCube(window):  # отрисовка куба, не меняющегося при модельно-видовых преобразованиях
    global offset
    glPushMatrix()
    # отрисовка куба
    # передняя грань
    glBegin(GL_POLYGON)
    glColor3f(0.6, 0.6, 1.0)
    glVertex3f(pos2 / 4 - offset, -pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(pos2 / 4 - offset, pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, -pos2 / 4 + offset, -pos2 / 4)
    glEnd()

    # задняя грань
    glBegin(GL_POLYGON)
    glColor3f(1.0, 1.0, 0.6)
    glVertex3f(pos2 / 4 - offset, -pos2 / 4 + offset, pos2 / 4)
    glVertex3f(pos2 / 4 - offset, pos2 / 4 + offset, pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, pos2 / 4 + offset, pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, -pos2 / 4 + offset, pos2 / 4)
    glEnd()

    # верхняя грань
    glBegin(GL_POLYGON)
    glColor3f(1.0, 0.0, 0.6)
    glVertex3f(pos2 / 4 - offset, pos2 / 4 + offset, pos2 / 4)
    glVertex3f(pos2 / 4 - offset, pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, pos2 / 4 + offset, pos2 / 4)
    glEnd()

    # нижняя грань
    glBegin(GL_POLYGON)
    glColor3f(0.6, 1.0, 0.0)
    glVertex3f(pos2 / 4 - offset, -pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(pos2 / 4 - offset, -pos2 / 4 + offset, pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, -pos2 / 4 + offset, pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, -pos2 / 4 + offset, -pos2 / 4)
    glEnd()
    # правая грань
    glBegin(GL_POLYGON)
    glColor3f(1.0, 0.6, 1.0)
    glVertex3f(pos2 / 4 - offset, -pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(pos2 / 4 - offset, pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(pos2 / 4 - offset, pos2 / 4 + offset, pos2 / 4)
    glVertex3f(pos2 / 4 - offset, -pos2 / 4 + offset, pos2 / 4)
    glEnd()

    # левая грань
    glBegin(GL_POLYGON)
    glColor3f(0.0, 1.0, 0.0)
    glVertex3f(-pos2 / 4 - offset, -pos2 / 4 + offset, pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, pos2 / 4 + offset, pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, pos2 / 4 + offset, -pos2 / 4)
    glVertex3f(-pos2 / 4 - offset, -pos2 / 4 + offset, -pos2 / 4)
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
