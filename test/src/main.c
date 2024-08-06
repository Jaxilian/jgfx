#include "jgfx/jgfx.h"
#include <GLFW/glfw3.h>

int main() {
	glfwInit();

	GLFWwindow* window = glfwCreateWindow(800, 600, "test", NULL, NULL);

	while (!glfwWindowShouldClose(window)) {
		glfwPollEvents();
	}

	glfwDestroyWindow(window);
	glfwTerminate();
	return 0;
}