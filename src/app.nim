# App data structure and basic logic
#
# This is meant to be a singleton

import sdl2/sdl

type
  App* = ref AppObj
  AppObj = object
    window*: sdl.Window     # SDL Window ponter
    glCtx*: sdl.GLContext   # OpenGL Context
    running*: bool          # Is the app running?

    screenWidth*: int       # Width of the screen in pixels
    screenHeight*: int      # Height of the screen in pixels

    worldScale*: float

    gameOver*: bool         # Is the game running or not?


# the single instance
var instance: App


# Make a new app object
proc newApp*(): App =
  assert(instance == nil)

  result = App()
  result.screenWidth = 800
  result.screenHeight = 800
  result.running = false

  result.worldScale = 10

  result.gameOver = true

  # Set the singleton
  instance = result


proc getApp*(): App =
  return instance





