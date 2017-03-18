# Game drawing logic

import sdl2/sdl
import opengl

import app

type
  DrawArguments* = object
    deltaTime*: float  # Time (in seconds) since last frame
    totalTime*: float  # Time (in seconds) since the game has started

#proc draw(app: App, da: DrawArguments)        # Render function


proc draw*(app: App, da: DrawArguments) =
  glClear(GL_ColorBufferBit or GL_DepthBufferBit)

  # TODO replace with shaders!
  glBegin(GL_Quads)
  glVertex2f(-0.5, -0.5)
  glVertex2f( 0.5, -0.5)
  glVertex2f( 0.5,  0.5)
  glVertex2f(-0.5,  0.5)
  glEnd()

  sdl.glSwapWindow(app.window)

