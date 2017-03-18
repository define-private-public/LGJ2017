# App data structure and basic logic
#
# This is meant to be included by `game.nim`

import sdl2/sdl

type
  App* = ref AppObj
  AppObj = object
    window*: sdl.Window     # SDL Window ponter
    glCtx*: sdl.GLContext   # OpenGL Context
    running*: bool          # Is the app running?
    screenWidth: int        # Width of the screen in pixels
    screenHeight: int       # Height of the screen in pixels



# Make a new app object
proc newApp*(): App =
  result = App()
  result.screenWidth = 960
  result.screenHeight = 540
  result.running = false

