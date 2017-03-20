# Update logic n' stuff
#
# this is meant to be included by `game.nim`

import sdl2/sdl

import app
import updateArguments
import collisions


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

  arena.update(app, ua)
  goal.update(app, ua)
  innerShield.update(app, ua)
  outterShield.update(app, ua)
  ball.update(app, ua)

  # Check for collisons
  # Ball should always be inside the arena
  let ballVsArenaRim = ball.bounds.collidesWith(arena.rimInner)
  case ballVsArenaRim:
    of None:
      discard # TODO some special "Win" notification
    of Intersects:
      ball.onHitsArenaRim(arena)
    else:
      discard

  # TODO noises on just an intersect
  let ballVsGoal = ball.bounds.collidesWith(goal.bounds)
  if ballVsGoal == ContainedBy:
    ball.onInsideGoal(goal)

      
