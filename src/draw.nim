# Game drawing logic
#
# This is meant to be inclued by `game.nim`

import colors

import sdl2/sdl
import opengl

import app
import geometry
import drawGeometry
import collisions


type
  DrawArguments* = object
    deltaTime*: float  # Time (in seconds) since last frame
    totalTime*: float  # Time (in seconds) since the game has started

#proc draw(app: App, da: DrawArguments)        # Render function


proc draw*(app: App, da: DrawArguments) =
  glClear(GL_ColorBufferBit or GL_DepthBufferBit)

  # TODO, delet dis l8er
  c1.draw(colOrange)
  c2.draw()

  let c = c2.collidesWith(c1) 
  case c:
    of Intersects:
      r.draw(colRed, Fill)
    of Contains:
      r.draw(colGreen, Fill)
    of ContainedBy:
      r.draw(colBlue, Fill)
    else: discard

  sdl.glSwapWindow(app.window)

