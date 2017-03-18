#version 400

in vec2 pos;
out vec4 color;

void main() {
  gl_Position = vec4(pos, 0, 1);
  color = vec4(0, 0, 1, 1);
}

