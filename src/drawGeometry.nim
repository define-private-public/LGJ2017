# Methods for drawing some geometric shapes in OpenGL

import math
import basic2d
import colors
import geometry
import opengl
import util
import app
import opengl_helpers
import drawingMechanics

export drawingMechanics

var
  # General stuff
  worldMat = IDMATRIX



# ==============
# Rectangle Crap
# ==============
let 
  rectVertexShaderSrc = readFile("shaders/rect.vert")
  rectFragmentShaderSrc = readFile("shaders/rect.frag")

var
  # Rectangle vertices
  rectVertices: array[8, Glfloat] = [
    -1'f32,  1'f32, 
    -1'f32, -1'f32, 
     1'f32, -1'f32, 
     1'f32,  1'f32 
  ]

  # Rectangle indeices (Triangle Fan order)
  rectIndices: array[4, GLushort] = [
    0'u16, 1'u16, 2'u16, 3'u16
  ]

  # Rect stuff
  rectVBO: GLuint
  rectVAO: GLuint
  rectVertexShader: GLuint
  rectFragmentShader: GLuint
  rectShaderProgram: GLuint

  # Shader locations
  rectWorldLoc: GLint
  rectDrawColorLoc: GLint
  rectCenterLoc: GLint
  rectWidthLoc: GLint
  rectHeightLoc: GLint


# Setup the OpenGL stuff for Rectangle rendering
proc loadRect(): bool =
  # Create a vbo
  glGenBuffers(1, rectVBO.addr)
  glBindBuffer(GL_ARRAY_BUFFER, rectVBO)
  glBufferData(GL_ARRAY_BUFFER, rectVertices.sizeof, rectVertices.unsafeAddr, GL_STATIC_DRAW)

  # The array object
  glGenVertexArrays(1, rectVAO.addr)
  glBindVertexArray(rectVAO)
  glBindBuffer(GL_ARRAY_BUFFER, rectVBO)
  glVertexAttribPointer(0, 2, cGL_FLOAT, GL_FALSE, 0, nil)
  glEnableVertexAttribArray(0)

  # Create the shaders & program
  rectVertexShader = makeShader(GL_VERTEX_SHADER, rectVertexShaderSrc)
  rectFragmentShader = makeShader(GL_FRAGMENT_SHADER, rectFragmentShaderSrc)
  rectShaderProgram = makeProgram(rectVertexShader, rectFragmentShader)

  # Get the world matrix location
  glUseProgram(rectShaderProgram)
  rectWorldLoc = glGetUniformLocation(rectShaderProgram, "world");
  rectDrawColorLoc = glGetUniformLocation(rectShaderProgram, "drawColor");
  rectCenterLoc = glGetUniformLocation(rectShaderProgram, "center");
  rectWidthLoc = glGetUniformLocation(rectShaderProgram, "width");
  rectHeightLoc = glGetUniformLocation(rectShaderProgram, "height");
  glUseProgram(0)

  return (rectVertexShader != 0) and (rectFragmentshader != 0) and (rectShaderProgram != 0)


proc unloadRect() =
  glDeleteProgram(rectShaderProgram)
  glDeleteShader(rectVertexShader)
  glDeleteShader(rectFragmentShader)
  glDeleteBuffers(1, rectVBO.addr)
  glDeleteVertexArrays(1, rectVAO.addr)


# Draws a rectangle
proc draw*(
  rect: Rect;
  clr: Color = colWhite;
  style: DrawingStyle = Outline
) =
  glUseProgram(rectShaderProgram)
  glBindVertexArray(rectVAO);

  # decide how to draw
  var mode: GLenum
  case style:
    of Outline: mode = GL_LINE_LOOP
    of Fill: mode = GL_TRIANGLE_FAN

  # The color to draw
  let drawClr = clr.toGLSLVec4()

  # Send data to the shader
  # TODO, use proer matrix sending
#  glUniformMatrix2fv(rectWorldLoc, 1.GLsizei, GL_FALSE, cast[ptr GLfloat](worldMat.addr))
  glUniform2f(rectWorldLoc, worldMat.ax, worldMat.by)
  glUniform2f(rectCenterLoc, rect.center.x, rect.center.y)
  glUniform1f(rectWidthLoc, rect.width)
  glUniform1f(rectHeightLoc, rect.height)
  glUniform4f(rectDrawColorLoc, drawClr.r, drawClr.g, drawClr.b, drawClr.a)

  # Draw it!
  glDrawElements(mode, rectIndices.len.GLsizei, GL_UNSIGNED_SHORT, rectIndices.addr)

  glBindVertexArray(0);
  glUseProgram(0)






# ===========
# Circle Crap
# ===========
let 
  circleVertexShaderSrc = readFile("shaders/circle.vert")
  circleFragmentShaderSrc = readFile("shaders/circle.frag")

var
  # Rectangle vertices
  circleVertices = newSeq[GLfloat]()
#  circleVertices: array[8, Glfloat] = [
#    -1'f32,  1'f32, 
#    -1'f32, -1'f32, 
#     1'f32, -1'f32, 
#     1'f32,  1'f32 
#  ]
  circleIndices = newSeq[GLushort]()

#  # Rectangle indeices (Triangle Fan order)
#  circleIndices: array[4, GLushort] = [
#    0'u16, 1'u16, 2'u16, 3'u16
#  ]

  # Rect stuff
  circleVBO: GLuint
  circleVAO: GLuint
  circleVertexShader: GLuint
  circleFragmentShader: GLuint
  circleShaderProgram: GLuint

  # Shader locations
  circleWorldLoc: GLint
  circleDrawColorLoc: GLint
  circleCenterLoc: GLint
  circleRadiusLoc: GLint


# Setup the OpenGL stuff for Circleangle rendering
proc loadCircle(): bool =
  # Create the vertex Data
  # Center point
  circleVertices.add(0)
  circleVertices.add(0)
  circleIndices.add(0)

  # The radius
  const resolution = 64
  for i in 0..resolution:
    let theta = map(i.float, 0.float, resolution.float, 0.float, TAU)
    circleVertices.add(cos(theta))
    circleVertices.add(sin(theta))
    circleIndices.add((i + 1).GLushort)

  # Create a vbo
  glGenBuffers(1, circleVBO.addr)
  glBindBuffer(GL_ARRAY_BUFFER, circleVBO)
  glBufferData(GL_ARRAY_BUFFER, len(circleVertices) * GLfloat.sizeof, circleVertices[0].unsafeAddr, GL_STATIC_DRAW)

  # The array object
  glGenVertexArrays(1, circleVAO.addr)
  glBindVertexArray(circleVAO)
  glBindBuffer(GL_ARRAY_BUFFER, circleVBO)
  glVertexAttribPointer(0, 2, cGL_FLOAT, GL_FALSE, 0, nil)
  glEnableVertexAttribArray(0)

  # Create the shaders & program
  circleVertexShader = makeShader(GL_VERTEX_SHADER, circleVertexShaderSrc)
  circleFragmentShader = makeShader(GL_FRAGMENT_SHADER, circleFragmentShaderSrc)
  circleShaderProgram = makeProgram(circleVertexShader, circleFragmentShader)

  # Get the world matrix location
  glUseProgram(circleShaderProgram)
  circleWorldLoc = glGetUniformLocation(circleShaderProgram, "world");
  circleDrawColorLoc = glGetUniformLocation(circleShaderProgram, "drawColor");
  circleCenterLoc = glGetUniformLocation(circleShaderProgram, "center");
  circleRadiusLoc = glGetUniformLocation(circleShaderProgram, "radius");
  glUseProgram(0)

  return (circleVertexShader != 0) and (circleFragmentshader != 0) and (circleShaderProgram != 0)


proc unloadCircle() =
  glDeleteProgram(circleShaderProgram)
  glDeleteShader(circleVertexShader)
  glDeleteShader(circleFragmentShader)
  glDeleteBuffers(1, circleVBO.addr)
  glDeleteVertexArrays(1, circleVAO.addr)


# Draws a circleangle
proc draw*(
  circle: Circle;
  clr: Color = colWhite;
  style: DrawingStyle = Outline
) =
  glUseProgram(circleShaderProgram)
  glBindVertexArray(circleVAO);

  # decide how to draw
  var
    mode: GLenum
    startIndex: int
    numToDraw = len(circleIndices)

  case style:
    of Outline:
      mode = GL_LINE_LOOP
      startIndex = 1
      numtoDraw -= 1

    of Fill:
      mode = GL_TRIANGLE_FAN
      startIndex = 0

  # The color to draw
  let drawClr = clr.toGLSLVec4()

  # Send data to the shader
  # TODO, use proer matrix sending
#  glUniformMatrix2fv(circleWorldLoc, 1.GLsizei, GL_FALSE, cast[ptr GLfloat](worldMat.addr))
  glUniform2f(circleWorldLoc, worldMat.ax, worldMat.by)
  glUniform2f(circleCenterLoc, circle.center.x, circle.center.y)
  glUniform1f(circleRadiusLoc, circle.radius)
  glUniform4f(circleDrawColorLoc, drawClr.r, drawClr.g, drawClr.b, drawClr.a)

  # Draw it!
  glDrawElements(mode, numToDraw.GLSizei, GL_UNSIGNED_SHORT, circleIndices[startIndex].unsafeAddr)

  glBindVertexArray(0);
  glUseProgram(0)





# Create a shaders & opengl programs for the geometry
proc load*() =
  assert(loadRect())
  assert(loadCircle())

  # Set the world matrix
  var app =  getApp()
  worldMat.ax = app.screenHeight.float / app.screenWidth.float / app.worldScale
  worldMat.by = 1.0 / app.worldScale
  echo worldMat


# Cleanup resources
proc unload*() =
  unloadRect()
  unloadCircle()
