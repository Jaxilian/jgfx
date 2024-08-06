#ifdef _JGFX_OPENGL
#include "jgfx.h"
#include <gl/GL.h>

void jgfx_init() {
    if (!gladLoadGL(glfwGetProcAddress)) {
        return -1;
    }

}





#endif