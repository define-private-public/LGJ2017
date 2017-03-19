#version 300 es

// The world matrix, which is simply a width and a height modifier
//uniform mat2 world;
uniform vec2 world;

// Rectangle data
uniform vec2 center;
uniform float radius;

// Drawing data
uniform vec4 drawColor;


// Ohter
in vec2 vertex;
out vec4 color;

void main() {
  vec2 pos = vertex * radius;
  pos += center;

  gl_Position = vec4(world * pos, 0, 1);
  color = drawColor;
}

