# App data structure and basic logic

import sdl2/sdl

type
  App* = ref AppObj
  AppObj = object
    window*: sdl.Window     # SDL Window ponter
    glCtx*: sdl.GLContext   # OpenGL Context
    running*: bool          # Is the app running?


# Make a new app object
proc newApp*(): App =
  result = App()
  result.running = false

