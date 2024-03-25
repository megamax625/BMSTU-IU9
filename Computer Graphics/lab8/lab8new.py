import glfw
from PIL import Image
import numpy as np
import math

from OpenGL.GL import *

velocity = [0.24, 0.2, 0.17]
dir0 = [0, 0, 1]
up0 = [0, 1, 0]
rotDelta = 0.05
scaleDelta = 10
window = None
mode = GL_LINE
texture = True

program = 0
projection_matrix = 0
view_matrix = 0
uMVMatrix = 0
uPMatrix = 0
uNMatrix = 0
aVertex = 0
aNormal = 0
aTexCoord = 0

vertex_shader_source = """
    #version 400

    uniform mat4 uMVMatrix;
    uniform mat4 uPMatrix;
    uniform mat3 uNMatrix;

    in vec3 aVertex;
    in vec3 aNormal;
    in vec2 aTexCoord;

    out vec2 vTexCoord; 
    out vec3 LightIntensity;

    void main(){
        vTexCoord = aTexCoord;
        vec4 LightPosition = vec4(-3, 3, 3, 1); // Light position in eye coords. 
        vec3 Kd = vec3(0.9, 0.9, 0.9); // Difuse reflectivity
        vec3 Ld = vec3(1, 1, 1); // Light source intensity

        vec3 tnorm = normalize(uNMatrix * aNormal);
        vec4 eyeCoords = uMVMatrix * vec4(aVertex, 1.0);
        vec3 s = normalize(vec3(LightPosition - eyeCoords));

        LightIntensity = Ld * Kd * max(dot(s, tnorm), 0.0);
        gl_Position = (uPMatrix * uMVMatrix)  * vec4(aVertex, 1.0);
    }
    """

fragment_shader_source = """
    #version 150

    uniform sampler2D sTexture;

    in vec2 vTexCoord;
    in vec3 LightIntensity;

    void main(){
         gl_FragColor = texture2D(sTexture, vTexCoord) * vec4(LightIntensity, 1.0);
    }
    """


def load_program(vertex_source, fragment_source):
    vertex_shader = load_shader(GL_VERTEX_SHADER, vertex_source)
    if vertex_shader == 0:
        return 0

    fragment_shader = load_shader(GL_FRAGMENT_SHADER, fragment_source)
    if fragment_shader == 0:
        return 0

    program = glCreateProgram()

    if program == 0:
        return 0

    glAttachShader(program, vertex_shader)
    glAttachShader(program, fragment_shader)

    glLinkProgram(program)

    if glGetProgramiv(program, GL_LINK_STATUS, None) == GL_FALSE:
        glDeleteProgram(program)
        return 0

    return program


def load_shader(shader_type, source):
    shader = glCreateShader(shader_type)

    if shader == 0:
        return 0

    glShaderSource(shader, source)
    glCompileShader(shader)

    if glGetShaderiv(shader, GL_COMPILE_STATUS, None) == GL_FALSE:
        info_log = glGetShaderInfoLog(shader)
        print(info_log)
        glDeleteProgram(shader)
        return 0

    return shader


def load_texture(filename):
    img = Image.open(filename)
    imgData = np.array(img, dtype=np.uint8)

    textID = glGenTextures(1)
    glBindTexture(GL_TEXTURE_2D, textID)

    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)

    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, img.size[0], img.size[1], 0, GL_RGBA, GL_UNSIGNED_BYTE, imgData)
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE)

    return textID


def isometria(angleA, angleB):
    cosA = math.cos(angleA * math.pi / 180)
    sinA = math.sin(angleA * math.pi / 180)
    cosB = math.cos(angleB * math.pi / 180)
    sinB = math.sin(angleB * math.pi / 180)
    return np.array([[cosA, 0, sinA, 0],
                     [sinA * sinB, cosB, -cosA * sinB, 0],
                     [sinA * cosB, -sinB, -cosA * cosB, 0],
                     [0, 0, 0, 1]])


def rotate(prism):
    prismside = prism.calcSideVec()
    return np.array([[prismside[0], prismside[1], prismside[2], 0],
                     [prism.up[0], prism.up[1], prism.up[2], 0],
                     [prism.dir[0], prism.dir[1], prism.dir[2], 0],
                     [0, 0, 0, 1]])


def translate(obj):
    return np.array([[1, 0, 0, 0],
                     [0, 1, 0, 0],
                     [0, 0, 1, 0],
                     [obj.x, obj.y, obj.z, 1]])


def mulMatrix(matrix, vec):
    newVec = [0, 0, 0]
    newVec[0] = vec[0] * matrix[0] + vec[1] * matrix[1] + vec[2] * matrix[2]
    newVec[1] = vec[0] * matrix[3] + vec[1] * matrix[4] + vec[2] * matrix[5]
    newVec[2] = vec[0] * matrix[6] + vec[1] * matrix[7] + vec[2] * matrix[8]
    return newVec


def mulAndNorm(matrix, vec):
    newVec = mulMatrix(matrix, vec)
    d = math.sqrt(newVec[0] * newVec[0] + newVec[1] * newVec[1] + newVec[2] * newVec[2])
    newVec[0] /= d
    newVec[1] /= d
    newVec[2] /= d
    return newVec


class Box:
    def __init__(self, x, y, z, size):
        self.x = x
        self.y = y
        self.z = z
        self.size = size

    def initBuffers(self):
        self.vbo = glGenBuffers(1)
        self.findVertsAndTexVertsAndNorm()
        self.vao = glGenVertexArrays(1)
        glBindVertexArray(self.vao)
        glBindBuffer(GL_ARRAY_BUFFER, self.vbo)
        glEnableVertexAttribArray(aVertex)
        glEnableVertexAttribArray(aNormal)
        glVertexAttribPointer(aVertex, 3, GL_FLOAT, GL_FALSE, 0, None)
        glVertexAttribPointer(aNormal, 3, GL_FLOAT, GL_FALSE, 0, GLvoidp(3 * self.numVerts * self.vbo.itemsize))
        glBindVertexArray(0)

    def findVertsAndTexVertsAndNorm(self):
        vertices = [
            [-self.size, -self.size, self.size], [-self.size, self.size, self.size],
            [self.size, self.size, self.size], [self.size, -self.size, self.size],
            [-self.size, -self.size, -self.size], [-self.size, self.size, -self.size],
            [self.size, self.size, -self.size], [self.size, -self.size, -self.size],
            [self.size, -self.size, -self.size], [self.size, -self.size, self.size],
            [self.size, self.size, self.size], [self.size, self.size, -self.size],
            [-self.size, -self.size, -self.size], [-self.size, -self.size, self.size],
            [-self.size, self.size, self.size], [-self.size, self.size, -self.size],
            [-self.size, self.size, -self.size], [-self.size, self.size, self.size],
            [self.size, self.size, self.size], [self.size, self.size, -self.size],
            [-self.size, -self.size, -self.size], [-self.size, -self.size, self.size],
            [self.size, -self.size, self.size], [self.size, -self.size, -self.size]]
        self.numVerts = len(vertices)
        vertices.extend([
            [0, 0, -1], [0, 0, -1], [0, 0, -1], [0, 0, -1],
            [0, 0, 1], [0, 0, 1], [0, 0, 1], [0, 0, 1],
            [-1, 0, 0], [-1, 0, 0], [-1, 0, 0], [-1, 0, 0],
            [1, 0, 0], [1, 0, 0], [1, 0, 0], [1, 0, 0],
            [0, -1, 0], [0, -1, 0], [0, -1, 0], [0, -1, 0],
            [0, 1, 0], [0, 1, 0], [0, 1, 0], [0, 1, 0]])

        glBindBuffer(GL_ARRAY_BUFFER, self.vbo)
        glBufferData(GL_ARRAY_BUFFER, np.array(vertices, dtype='float32').tobytes(), GL_STATIC_DRAW)

    def draw(self):
        model_matrix = translate(self)

        glBindVertexArray(self.vao)

        mv_matrix = np.dot(model_matrix, view_matrix)
        normal_matrix = [[mv_matrix[0][0], mv_matrix[0][1], mv_matrix[0][2]],
                         [mv_matrix[1][0], mv_matrix[1][1], mv_matrix[1][2]],
                         [mv_matrix[2][0], mv_matrix[2][1], mv_matrix[2][2]]]
        normal_matrix = np.transpose(np.linalg.inv(normal_matrix))
        glUniformMatrix4fv(uMVMatrix, 1, GL_FALSE, mv_matrix)
        glUniformMatrix4fv(uPMatrix, 1, GL_FALSE, projection_matrix)
        glUniformMatrix3fv(uNMatrix, 1, GL_FALSE, normal_matrix)

        glPolygonMode(GL_FRONT_AND_BACK, GL_LINE)
        glDrawArrays(GL_QUADS, 0, self.numVerts)
        glPolygonMode(GL_FRONT_AND_BACK, mode)


class prism:
    def __init__(self, stackCount, sectorCount, x, y, z, radius, dir, up):
        self.stackCount = stackCount
        self.sectorCount = sectorCount
        self.x = x
        self.y = y
        self.z = z
        self.radius = radius
        self.dir = dir
        self.up = up

    def initBuffers(self):
        self.vbo = glGenBuffers(1)
        self.findVertsAndTexVertsAndNorm()
        self.vao = glGenVertexArrays(1)
        glBindVertexArray(self.vao)
        glBindBuffer(GL_ARRAY_BUFFER, self.vbo)
        glEnableVertexAttribArray(aVertex)
        glEnableVertexAttribArray(aNormal)
        glEnableVertexAttribArray(aTexCoord)
        glVertexAttribPointer(aVertex, 3, GL_FLOAT, GL_FALSE, 5 * self.vbo.itemsize, None)
        glVertexAttribPointer(aNormal, 3, GL_FLOAT, GL_FALSE, 5 * self.vbo.itemsize, None)
        glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE, 5 * self.vbo.itemsize, GLvoidp(3 * self.vbo.itemsize))
        glBindVertexArray(0)

    def findVertsAndTexVertsAndNorm(self):
        vertices = np.array([])

        sectorStep = 2 * math.pi / self.sectorCount
        stackStep = math.pi / self.stackCount

        prevVertices = [[0, 0, self.radius]] * (self.sectorCount + 1)

        for i in range(1, self.stackCount + 1):
            stackAngle = math.pi / 2 - i * stackStep
            xy = self.radius * math.cos(stackAngle)
            z = self.radius * math.sin(stackAngle)

            prevVert = [xy, 0, z]
            for j in range(1, self.sectorCount + 1):
                sectorAngle = j * sectorStep

                x = xy * math.cos(sectorAngle)
                y = xy * math.sin(sectorAngle)

                vertices = np.append(vertices, [prevVertices[j - 1][0],
                                                prevVertices[j - 1][1],
                                                prevVertices[j - 1][2]])
                vertices = np.append(vertices, [(j - 1) / self.sectorCount, (i - 1) / self.stackCount])
                vertices = np.append(vertices, [prevVertices[j][0],
                                                prevVertices[j][1],
                                                prevVertices[j][2]])
                vertices = np.append(vertices, [(j) / self.sectorCount, (i - 1) / self.stackCount])
                vertices = np.append(vertices, [x,
                                                y,
                                                z])
                vertices = np.append(vertices, [(j) / self.sectorCount, (i) / self.stackCount])
                vertices = np.append(vertices, [prevVert[0],
                                                prevVert[1],
                                                prevVert[2]])
                vertices = np.append(vertices, [(j - 1) / self.sectorCount, (i) / self.stackCount])

                prevVertices[j - 1] = prevVert
                prevVert = [x, y, z]

            prevVertices[j] = prevVert

        self.numVerts = 4 * self.stackCount * self.sectorCount
        glBindBuffer(GL_ARRAY_BUFFER, self.vbo)
        glBufferData(GL_ARRAY_BUFFER, np.array(vertices, dtype='float32').tobytes(), GL_STATIC_DRAW)

    def draw(self):
        model_matrix = rotate(self)
        model_matrix = np.dot(model_matrix, translate(self))

        glBindVertexArray(self.vao)

        mv_matrix = np.dot(model_matrix, view_matrix)
        normal_matrix = [[mv_matrix[0][0], mv_matrix[0][1], mv_matrix[0][2]],
                         [mv_matrix[1][0], mv_matrix[1][1], mv_matrix[1][2]],
                         [mv_matrix[2][0], mv_matrix[2][1], mv_matrix[2][2]]]
        normal_matrix = np.transpose(np.linalg.inv(normal_matrix))
        glUniformMatrix4fv(uMVMatrix, 1, GL_FALSE, mv_matrix)
        glUniformMatrix4fv(uPMatrix, 1, GL_FALSE, projection_matrix)
        glUniformMatrix3fv(uNMatrix, 1, GL_FALSE, normal_matrix)

        glDrawArrays(GL_QUADS, 0, self.numVerts)

        glBindVertexArray(0)

    def rotate(self, vec):
        x = -vec[0]  #
        y = -vec[1]  #
        z = -vec[2]  #
        v = math.sqrt(x * x + y * y + z * z)
        cosa = math.cos(rotDelta)
        sina = math.sin(rotDelta)
        matrix = [1 + ((-y * y - z * z) * (1 - cosa)) / v / v, (x * y * (1 - cosa) / v + z * sina) / v,
                  (x * z * (1 - cosa) / v - y * sina) / v,
                  (x * z * (1 - cosa) / v - z * sina) / v, 1 + ((-y * y - z * z) * (1 - cosa)) / v / v,
                  (y * z * (1 - cosa) / v + x * sina) / v,
                  (x * z * (1 - cosa) / v + y * sina) / v, (y * z * (1 - cosa) / v - x * sina) / v,
                  1 + ((-y * y - z * z) * (1 - cosa)) / v / v]
        self.dir = mulAndNorm(matrix, self.dir)
        self.up = mulAndNorm(matrix, self.up)

    def calcSideVec(self):
        return [-self.dir[1] * self.up[2] + self.dir[2] * self.up[1],
                -self.dir[2] * self.up[0] + self.dir[0] * self.up[2],
                -self.dir[0] * self.up[1] + self.dir[1] * self.up[0]]


prism = prism(10, 10, 0, 0, 0, 0.2, dir0, up0)
box = Box(0, 0, 0, 0.58)

oldTime = 0


def main():
    global window, oldTime, program
    global projection_matrix, view_matrix, uMVMatrix, uPMatrix, uNMatrix
    global aVertex, aNormal, aTexCoord

    width, height = 900, 900

    if not glfw.init():
        return
    window = glfw.create_window(width, height, "lab8", None, None)
    if not window:
        glfw.terminate()
        return
    glfw.make_context_current(window)

    glfw.set_key_callback(window, key_callback)
    glfw.set_scroll_callback(window, scroll_callback)

    glEnable(GL_DEPTH_TEST)
    glPolygonMode(GL_FRONT_AND_BACK, mode)

    #
    projection_matrix = isometria(45, 35.25)
    view_matrix = np.identity(4, dtype=np.float32)

    program = load_program(vertex_shader_source, fragment_shader_source)

    uMVMatrix = glGetUniformLocation(program, "uMVMatrix")
    uPMatrix = glGetUniformLocation(program, "uPMatrix")
    uNMatrix = glGetUniformLocation(program, "uNMatrix")
    sTexture = glGetUniformLocation(program, "sTexture")

    aVertex = glGetAttribLocation(program, "aVertex")
    aNormal = glGetAttribLocation(program, "aNormal")
    aTexCoord = glGetAttribLocation(program, "aTexCoord")

    glUseProgram(program)

    prism.initBuffers()
    box.initBuffers()

    texture = load_texture("something.jpg")

    glActiveTexture(GL_TEXTURE0)
    glBindTexture(GL_TEXTURE_2D, texture)
    glUniform1i(sTexture, 0)

    oldTime = glfw.get_time()
    while not glfw.window_should_close(window):
        display()
    glfw.destroy_window(window)
    glfw.terminate()


def key_callback(window, key, scancode, action, mods):
    global mode, texture
    rotVector = [0, 0, 0]

    if glfw.get_key(window, glfw.KEY_Q) == glfw.PRESS:
        rotVector[0] = 1
    if glfw.get_key(window, glfw.KEY_A) == glfw.PRESS:
        rotVector[0] = -1
    if glfw.get_key(window, glfw.KEY_W) == glfw.PRESS:
        rotVector[1] = 1
    if glfw.get_key(window, glfw.KEY_S) == glfw.PRESS:
        rotVector[1] = -1
    if glfw.get_key(window, glfw.KEY_E) == glfw.PRESS:
        rotVector[2] = 1
    if glfw.get_key(window, glfw.KEY_D) == glfw.PRESS:
        rotVector[2] = -1
    if rotVector != [0, 0, 0]:
        prism.rotate(rotVector)

    if action == glfw.PRESS:
        if key == glfw.KEY_TAB:
            if mode == GL_LINE:
                mode = GL_FILL
            else:
                mode = GL_LINE
            glPolygonMode(GL_FRONT_AND_BACK, mode)
        if key == glfw.KEY_CAPS_LOCK:
            if texture:
                glBindVertexArray(prism.vao)
                glDisableVertexAttribArray(aTexCoord)
                glBindVertexArray(0)
            else:
                glBindVertexArray(prism.vao)
                glEnableVertexAttribArray(aTexCoord)
                glBindVertexArray(0)
            texture = not texture
        if key == glfw.KEY_Z:
            prism.stackCount -= 1
            prism.findVertsAndTexVertsAndNorm()
        if key == glfw.KEY_X:
            prism.stackCount += 1
            prism.findVertsAndTexVertsAndNorm()
        if key == glfw.KEY_C:
            prism.sectorCount -= 1
            prism.findVertsAndTexVertsAndNorm()
        if key == glfw.KEY_V:
            prism.sectorCount += 1
            prism.findVertsAndTexVertsAndNorm()


def scroll_callback(window, xoffset, yoffset):
    if xoffset > 0:
        prism.radius -= yoffset / scaleDelta
    else:
        prism.radius += yoffset / scaleDelta
    prism.findVertsAndTexVertsAndNorm()


def display():
    global oldTime, velocity
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
    glClearColor(0.83, 0.19, 0.81, 1.0)

    time = glfw.get_time()
    deltaTime = time - oldTime
    oldTime = time
    prism.x += deltaTime * velocity[0]
    prism.y += deltaTime * velocity[1]
    prism.z += deltaTime * velocity[2]

    if not (box.x - box.size + prism.radius < prism.x < box.x + box.size - prism.radius):
        velocity[0] = -velocity[0]
    if not (box.y - box.size + prism.radius < prism.y < box.y + box.size - prism.radius):
        velocity[1] = -velocity[1]
    if not (box.z - box.size + prism.radius < prism.z < box.z + box.size - prism.radius):
        velocity[2] = -velocity[2]

    prism.draw()
    box.draw()

    glfw.swap_buffers(window)
    glfw.poll_events()


main()