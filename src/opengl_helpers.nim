# A bunch of code for writing OpenGL shader stuff much easily
import colors
import opengl
import util


proc `$`*(shaderType: GLenum): string=
  case shaderType:
  of GL_VERTEX_SHADER: return "vertex"
  of GL_FRAGMENT_SHADER: return "fragment"
  else : return "unkown"


## Success on non-zero return.  You will need to cleanup the shader
## yourself if so.
proc makeShader*(shaderType: GLenum; source: string): GLuint=
  # Setup the shader source
  let shaderSrcArray = allocCstringArray([source])
  defer:
    deallocCStringArray(shaderSrcArray)

  var
    shaderID: GLuint
    isCompiled: GLint

  # Compile the shader
  shaderID = glCreateShader(shaderType)
  glShaderSource(shaderID, 1, shaderSrcArray, nil)
  glCompileShader(shaderID)
  glGetShaderiv(shaderID, GL_COMPILE_STATUS, isCompiled.addr)

  # Error checking
  if isCompiled == 0:
    stderr.writeLine("Error: ", shaderType, " shader wasn't compiled.  Reason:")

    # Get the log size
    var logSize: GLint
    glGetShaderiv(shaderID, GL_INFO_LOG_LENGTH, logSize.addr)

    # Get log data
    var
      logStr = cast[ptr GLchar](alloc(logSize))
      logLen: GLsizei
    glGetShaderInfoLog(shaderID, logSize.GLsizei, logLen.addr, logStr)
    defer: dealloc(logStr)

    # Print the log
    stderr.writeLine(logStr)

    # Delete the shader
    glDeleteShader(shaderID)
    shaderID = 0
  
  return shaderID
  

## Makes an OpenGL program out of a vertex and fragment shader.  upon success
## will return non-zero.  You'll have to cleanup the stuff if so.
##
## Will also bind the attrib locations
proc makeProgram*(vertexShader, fragmentShader: GLuint): GLuint=
  # Make and attach
  var programID = glCreateProgram()
  glAttachShader(programID, vertexShader)
  glAttachShader(programID, fragmentShader)

  # Add locations
  glBindAttribLocation(programID, 0, "vertexPos")

  # Link
  glLinkProgram(programID)

  # Check for errors
  var isLinked: GLint
  glGetProgramiv(programID, GL_LINK_STATUS, isLinked.addr)
  if isLinked == 0:
    stderr.writeLine("Shader program linking failed.  Reason:")

    # Get the log size
    var logSize: GLint
    glGetProgramiv(programID, GL_INFO_LOG_LENGTH, logSize.addr)

    # Get log data
    var
      logStr = cast[ptr GLchar](alloc(logSize))
      logLen: GLsizei
    glGetProgramInfoLog(programID, logSize.GLsizei, logLen.addr, logStr)
    defer: dealloc(logStr)

    # Print the log
    stderr.writeLine(logStr)

    # Delete the program
    glDeleteProgram(programID)
    programID = 0

  return programID


# Convert a color into a GLSL friendly color
# TODO this needs to handle alpha in a better manor
proc toGLSLVec4*(clr: Color): tuple[r, g, b, a: float] =
  let
    comp = extractRGB(clr)
    r = map(comp.r.float, 0.0, 255.0, 0.0, 1.0)
    g = map(comp.g.float, 0.0, 255.0, 0.0, 1.0)
    b = map(comp.b.float, 0.0, 255.0, 0.0, 1.0)
    a = 1.0
  
  return (r, g, b, a)

