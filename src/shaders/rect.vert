#version 300 es

// TODO the matrix from nim isn't properly being sent
// The world matrix, which is simply a width and a height modifier
//uniform mat2 world;
uniform vec2 world;

in vec2 pos;
out vec4 color;

void main() {
  gl_Position = vec4(world * pos, 0, 1);
  color = vec4(0, 0, 1, 1);
}

