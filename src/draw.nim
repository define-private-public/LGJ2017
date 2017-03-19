# Game drawing logic
#
# This is meant to be inclued by `game.nim`

import colors

import sdl2/sdl
import opengl

import app
import geometry
import drawGeometry

type
  DrawArguments* = object
    deltaTime*: float  # Time (in seconds) since last frame
    totalTime*: float  # Time (in seconds) since the game has started

#proc draw(app: App, da: DrawArguments)        # Render function


proc draw*(app: App, da: DrawArguments) =
  glClear(GL_ColorBufferBit or GL_DepthBufferBit)

  # TODO, delete dis
  r.draw(colDarkSlateBlue, Fill)

  sdl.glSwapWindow(app.window)

