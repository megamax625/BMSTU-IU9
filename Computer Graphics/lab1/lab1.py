import glfw
from OpenGL.GL import *

angle = 0.0
posx = 0.0
posy = 0.0
mov = 0.0001     # стандартная скорость движения фигуры


def main():
    if not glfw.init():  # инициализация glfw с проверкой
        raise Exception("Couldn't initialize glfw")
    window = glfw.create_window(640, 640, "Lab1", None, None)  # создание окно
    if not window:
        glfw.terminate()
        raise Exception("Couldn't create window")
    glfw.make_context_current(window)               # делает контекст текущим
    glfw.set_key_callback(window, key_callback)     # устанавливает реакцию на нажатие клавиш
    while not glfw.window_should_close(window):     # отрисовка в цикле
        display(window)
    glfw.destroy_window(window)                     # закрытие окна и выключение glfw
    glfw.terminate()


def display(window):    # функция, осуществляющая отрисовку изображения
    global angle
    global posx
    global posy

    # если фигура вышла за пределы окна - отправляет её в противоположный конец окна
    if posx >= 1.0:
        posx = -1.0
    elif posx <= -1.0:
        posx = 1.0
    if posy >= 1.0:
        posy = -1.0
    elif posy <= -1.0:
        posy = 1.0
    # движение фигуры
    posx += mov
    posy -= mov

    glClear(GL_COLOR_BUFFER_BIT)    # очищает цветовой буфер
    glLoadIdentity()                # загружает единичную матрицу на место текущей
    glClearColor(1.0, 1.0, 1.0, 1.0)
    glPushMatrix()                  # отправляет текущую матрицу на вершину стека
    glRotatef(angle, 0, 0, 1)       # поворот картинки с помощью умножения текущей матрицы на матрицу поворота

    # отрисовка трёх фигур - двух квадратов и треугольника, обладающих разными цветами
    glBegin(GL_POLYGON)         # указание на тип фигуры, описываемой до вызова glEnd()
    glColor3f(0.2, 0.3, 0.2)    # указание цвета фигуры
    glVertex2f(posx, posy)      # указание координат точки
    glVertex2f(posx + 0.2, posy)
    glVertex2f(posx + 0.2, posy + 0.2)
    glVertex2f(posx, posy + 0.2)
    glEnd()
    glBegin(GL_TRIANGLES)
    glColor3f(0.3, 0.1, 0.1)
    glVertex2f(posx + 0.2, posy)
    glVertex2f(posx + 0.4, posy)
    glVertex2f(posx + 0.4, posy + 0.2)
    glEnd()
    glBegin(GL_POLYGON)
    glColor3f(0.3, 0.3, 0.1)
    glVertex2f(posx + 0.4, posy + 0.2)
    glVertex2f(posx + 0.4, posy + 0.4)
    glVertex2f(posx + 0.2, posy + 0.4)
    glVertex2f(posx + 0.2, posy + 0.2)
    glEnd()
    glPopMatrix()               # снимает верхнюю матрицу со стека
    glfw.swap_buffers(window)   # меняет местами передний и задние буферы окна
    glfw.poll_events()          # реакция на полученные события


def key_callback(window, key, scancode, action, mods):  # установка реакции на нажатие клавиш
    global angle
    global mov
    if action == glfw.PRESS:
        if key == glfw.KEY_ENTER:   # реакция на нажатие клавиши ENTER - поворот картинки на 90 градусов
            angle -= 90
        # реакция на нажатие клавиши правой стрелки - ускорение движения,
        # аналогично с левой стрелкой, но в обратную сторону
        if key == glfw.KEY_RIGHT:
            mov = 0.0005
        if key == 263:  # glfw.KEY_LEFT
            mov = -0.0005


main()
