import glfw
from OpenGL.GL import *

vertexes = []  # вершины многоугольника
width = 300
height = 300
maxwidth, maxheight = 800, 600  # задаём предельные значения для размеров окна
minwidth, minheight = 200, 200
pixelBuffer = []  # выделяем буфер памяти и заполняем нулями
edgeStatus = False
intersections = [[] for _ in range(height)]


class Pixel:  # создаём класс точки и конструктор
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.linked = []  # две вершины, связанные рёбрами


for i in range(width * height * 3):
    pixelBuffer.append(0)


def main():
    if not glfw.init():  # инициализация glfw с проверкой
        raise Exception("Couldn't initialize glfw")
    window = glfw.create_window(width, height, "Lab4", None, None)  # создание окна
    glClearColor(0, 0, 0, 0)
    if not window:
        glfw.terminate()
        raise Exception("Couldn't create window")
    glfw.make_context_current(window)  # делает контекст текущим
    glfw.set_key_callback(window, key_callback)  # устанавливает реакцию на нажатие клавиш
    glfw.set_mouse_button_callback(window, mouse_button_callback)  # устанавливает реакцию на нажатие мыши
    glfw.set_window_size_callback(window, window_size_callback)  # устанавливает реакцию на изменение размеров окна
    while not glfw.window_should_close(window):  # отрисовка в цикле
        display(window)
        glfw.swap_buffers(window)  # меняет местами передний и задние буферы окна
        glfw.poll_events()  # реакция на полученные события
    glfw.destroy_window(window)  # закрытие окна и выключение glfw
    glfw.terminate()


def clear_buffer(): # зануление буфера
    global pixelBuffer, width, height
    pixelBuffer = []
    for i in range(width * height * 3):
        pixelBuffer.append(0)


def display(window):
    global pixelBuffer, width, height
    glClear(GL_COLOR_BUFFER_BIT)
    glLoadIdentity()
    glPushMatrix()
    glScalef(1, -1, 1)
    glClear(GL_COLOR_BUFFER_BIT)
    glDrawPixels(width, height, GL_RGB, GL_FLOAT, pixelBuffer)
    glPopMatrix()


def make_pixel(x, y, r, g, b):
    global width, height
    if (0 <= x) and (x < width) and (0 <= y) and (y < height):
        pos = int((x + y * width) * 3)
        pixelBuffer[pos] = r
        pixelBuffer[pos + 1] = g
        pixelBuffer[pos + 2] = b


def Bresenham_smoothing(x1, y1, x2, y2):
    I = 8
    k = 0.1
    dx, dy = x2 - x1, y2 - y1
    if (abs(dx) == abs(dy)) or (dx == 0) or (dy == 0):
        Bresenham(x1, y1, x2, y2)
        return
    tg = abs(dy / dx)
    m = I * tg
    if abs(dy) > abs(dx):
        m = I * abs(dx / dy)
    e = m / 2
    de = m
    w = abs(I - m)
    sign_x = sign(dx)
    sign_y = sign(dy)
    make_pixel(x1, y1, 0, 1, 0)  # !?
    while abs(x1) != abs(x2):
        if tg < 1:
            x1 += sign_x
        else:
            y1 += sign_y
        if e >= w:
            if tg < 1:
                y1 += sign_y
            else:
                x1 += sign_x
            e -= w
            if dx * dy > 0:
                make_pixel(x1 - sign_x, y1, 1, 1, 1)
            else:
                make_pixel(x1, y1 - sign_y, 1, 1, 1)
        elif e < w:
            e += de
        if (tg < 1 and dx * dy > 0) or (tg > 1 and dx * dy < 0):
            if k * e < 1:
                if k * e > 0:
                    color = 1 - k * e
                else:
                    color = 1.0
            else:
                color = 0.1
        else:
            if k * e > 0:
                if k * e < 1:
                    color = k * e
                else:
                    color = 1
            else:
                color = 0.1
        make_pixel(x1, y1, color, color, color)


def Bresenham(x1, y1, x2, y2):
    global pixelBuffer, vertexes
    dx = abs(x2 - x1)
    dy = abs(y2 - y1)
    sign_x = sign(x2 - x1)
    sign_y = sign(y2 - y1)
    e = 2 * dy - dx
    x, y = x1, y1
    if dy == 0:
        i = x1
        while abs(x2 - i) > 0:
            make_pixel(i, y, 1.0, 1.0, 1.0)
            i += sign_x
        return
    if dx == 0:
        i = y1
        while abs(y2 - i) > 0:
            make_pixel(x, i, 1.0, 1.0, 1.0)
            i += sign_y
        return
    flag = False
    if dy >= dx:
        dx, dy = dy, dx
        flag = True
    i = 0
    cond = True
    while cond:
        make_pixel(x, y, 1.0, 1.0, 1.0)
        if e < dx:
            if flag:
                y += sign_y
            else:
                x += sign_x
            e += 2 * dy
        else:
            if flag:
                x += sign_x
            else:
                y += sign_y
            e -= 2 * dx
        i += 1
        if i > dx + dy:
            make_pixel(x, y, 1.0, 1.0, 1.0)
            cond = False


def draw_polygon():     # отрисовка рёбер многоугольника
    global vertexes
    if len(vertexes) == 2:
        Bresenham_smoothing(vertexes[0].x, vertexes[0].y, vertexes[1].x, vertexes[1].y)
    elif len(vertexes) > 2:
        for i in range(len(vertexes) - 1):
            Bresenham_smoothing(vertexes[i].x, vertexes[i].y, vertexes[i + 1].x, vertexes[i + 1].y)
        Bresenham_smoothing(vertexes[len(vertexes) - 1].x, vertexes[len(vertexes) - 1].y, vertexes[0].x, vertexes[0].y)


def fill_polygon():     # заливка области внутри многоугольника
    global width, height, vertexes, intersections
    for y in range(height):
        below = [ver for ver in vertexes if ver.y < y]
        higher = [ver for ver in vertexes if ver.y > y]
        very = [ver for ver in vertexes if ver.y == y]
        intery = []
        for x in range(width):
            for j in range(len(very)):
                if x == very[j].x:
                    if ext_check(very[j]):
                        intersections[y].append(x)
                    intersections[y].append(x)
            for ver in range(len(below)):
                for i in range(2):
                    chver = vertexes[below[ver].linked[i]]
                    if not chver.y < y:
                        if abs(((x - below[ver].x) / (chver.x - below[ver].x)) - ((y - below[ver].y) / (chver.y - below[ver].y))) < 0.2:
                            intersections[y].append(x)
        if len(intersections[y]) > 1:
            for x in range(intersections[y][0], intersections[y][-1]):
                make_pixel(x, y, 1.0, 1.0, 1.0)


def sign(x):    # знак числа х
    return 0 if x == 0 else (1 if x > 0 else -1)


def ext_check(v):   # проверка, являтся ли вершина экстремумом (при сканировании учитывается дважды)
    global vertexes
    vy = v.y
    y1, y2 = v.linked[0], v.linked[1]
    return (y1 > vy and y2 > vy) or (y1 < vy and y2 < vy)


def key_callback(window, key, scancode, action, mods):  # установка реакции на нажатие клавиш
    global vertexes, edgeStatus
    if action == glfw.PRESS:
        if key == glfw.KEY_ENTER:  # очистка области вывода
            clear_buffer()
            vertexes.clear()
        if key == glfw.KEY_F:  # построение рёбер многоугольника
            if not edgeStatus:
                draw_polygon()
                edgeStatus = True
        if key == glfw.KEY_R and len(vertexes) > 0:  # закрашивание области внутри многоугольника
            fill_polygon()


def mouse_button_callback(window, button, action, mods):
    global vertexes
    if (action == glfw.PRESS) and (button == glfw.MOUSE_BUTTON_LEFT):
        x, y = glfw.get_cursor_pos(window)
        y = height - y
        pixel = Pixel(x, y)
        if len(vertexes) > 1:
            pixel.linked = [0, len(vertexes) - 1]  # связали с предыдущей и первой вершиной
            if len(vertexes) > 2:
                vertexes[0].linked = [1, len(vertexes)]  # связали первую вершину с новой, оборвали старую связь
                for i in range(1, len(vertexes)):
                    vertexes[i].linked = [i - 1, i + 1]
        vertexes.append(pixel)
        if edgeStatus:
            clear_buffer()
            draw_polygon()
        make_pixel(x, y, 1.0, 1.0, 1.0)


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
    intersections = [[] for _ in range(height)]    # при изменении размера окна вся введённая ранее информация удаляется
    clear_buffer()
    vertexes.clear()


main()
