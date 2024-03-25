import glfw
from OpenGL.GL import *
from OpenGL.GLE import *
from OpenGL.GLUT import *
import numpy


def main():
    # Initialize the library
    if not glfw.init():
        return
    # Create a windowed mode window and its OpenGL context
    window = glfw.create_window(640, 480, "Hello World", None, None)
    if not window:
        glfw.terminate()
        return

    # Make the window's context current
    glfw.make_context_current(window)

    triangle = [-1, -1, 0,
                1, -1, 0,
                0, 1, 0]
    triangle = numpy.array(triangle, dtype=numpy.float32)

    glClearColor(0.2, 0.3, 0.2, 0.5)
    # Loop until the user closes the window
    while not glfw.window_should_close(window):
        # Render here, e.g. using pyOpenGL

        # Swap front and back buffers
        glClear(GL_COLOR_BUFFER_BIT)
        glfw.swap_buffers(window)

        # Poll for and process events
        glfw.poll_events()

    glfw.terminate()


if __name__ == "__main__":
    main()
