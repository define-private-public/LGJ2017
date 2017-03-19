# Update logic n' stuff
#
# this is meant to be included by `game.nim`

import sdl2/sdl

import app

type
  UpdateArguments* = object
    frameNumber*: int  # Which number frame this is
    deltaTime*: float  # Time (in seconds) since last frame
    totalTime*: float  # Time (in seconds) since the game has started


#proc update(app: App, ua: UpdateArguments)    # Update function


proc update*(app: App, ua: UpdateArguments) =
  # Poll for events
  var event: sdl.Event
  while sdl.pollEvent(event.addr) != 0:
    # Check for quit (ESC press or X-out of window)
    if event.kind == sdl.Quit:
      # X - Out
      app.running = false
    elif event.kind == sdl.KeyDown:
      let sym = event.key.keysym.sym
      if sym == sdl.K_Escape:
        # ESC Press
        app.running = false

      if sym == sdl.K_Up:
        r.center.y += 0.1

      if sym == sdl.K_Down:
        r.center.y -= 0.1

      if sym == sdl.K_Left:
        r.center.x -= 0.1

      if sym == sdl.K_Right:
        r.center.x += 0.1
      
