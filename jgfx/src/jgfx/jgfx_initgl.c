#if defined(_JGFX_OPENGL) || defined(_JGFX_GLES2)

#include "jgfx.h"
#include "backends/gl3/glad/gl.h"

void jgfx_init() {

	gladLoaderLoadGL();
}





#endif