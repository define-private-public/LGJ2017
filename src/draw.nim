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
import drawArguments

#proc draw(app: App, da: DrawArguments)        # Render function


proc draw*(app: App, da: DrawArguments) =
  glClear(GL_ColorBufferBit or GL_DepthBufferBit)

  
  arena.draw(app, da)
  goal.draw(app, da)
  innerShield.draw(app, da)
  outterShield.draw(app, da)
  ball.draw(app, da)
  

  sdl.glSwapWindow(app.window)

