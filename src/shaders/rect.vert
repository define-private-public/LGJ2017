#version 300 es

// TODO the matrix from nim isn't properly being sent
// The world matrix, which is simply a width and a height modifier
//uniform mat2 world;
uniform vec2 world;

// TODO need to send it/s width, height & position
// Rectangle data
uniform vec2 center;
uniform float width;
uniform float height;

// Drawing data
uniform vec4 drawColor;


// Ohter
in vec2 vertex;
out vec4 color;

void main() {
  vec2 pos = vec2(vertex.x * width, vertex.y * height);
  pos += center;

  gl_Position = vec4(world * pos, 0, 1);
  color = drawColor;
}

