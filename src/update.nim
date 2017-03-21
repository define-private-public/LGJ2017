# Update logic n' stuff
#
# this is meant to be included by `game.nim`

import sdl2/sdl

import app
import updateArguments
import collisions


#proc update(app: App, ua: UpdateArguments)    # Update function


proc update*(app: App; ua: var UpdateArguments) =
  var resetGameRequested = false

  # Poll for events
  var event: sdl.Event
  while sdl.pollEvent(event.addr) != 0:
    # Check for quit (ESC press or X-out of window)
    if event.kind == sdl.Quit:
      # X - Out
      app.running = false
    elif event.kind == sdl.KeyDown:
      let sym = event.key.keysym.sym
      case sym:
        of sdl.K_Escape:
          # Quit
          app.running = false

        # move the shields
        of sdl.K_Q:
          # Move outter CCW
          ua.moveOutterShieldCCW = true
        of sdl.K_W:
          # Move outter CW
          ua.moveOutterShieldCW = true
        of sdl.K_O:
          # Move inner CCW
          ua.moveInnerShieldCCW = true
        of sdl.K_P:
          # Move inner CW
          ua.moveInnerShieldCW = true

        # check for reset on game over
        of sdl.K_R:
          resetGameRequested = true
        
        # Forgot the rest
        else: discard
    elif event.kind == sdl.KeyUp:
      let sym = event.key.keysym.sym
      case sym:

        # move the shields
        of sdl.K_Q:
          # Move outter CCW
          ua.moveOutterShieldCCW = false
        of sdl.K_W:
          # Move outter CW
          ua.moveOutterShieldCW = false
        of sdl.K_O:
          # Move inner CCW
          ua.moveInnerShieldCCW = false
        of sdl.K_P:
          # Move inner CW
          ua.moveInnerShieldCW = false
        
        # Forgot the rest
        else: discard

  
  if not app.gameOver:
    # Only update the game when it's not over
    arena.update(app, ua)
    goal.update(app, ua)
    innerShield.update(app, ua)
    outterShield.update(app, ua)
    ball.update(app, ua)
  
    # Check for collisons
    # Ball should always be inside the arena
    let ballVsArenaRim = ball.bounds.collidesWith(arena.rimInner)
    case ballVsArenaRim:
      of Intersects:
        # A standard bounce
        ball.onHitsArenaRim(arena)

      of None:
        # Well damn, it went out
        arena.onBallOutside()

        # have to reset the ball, lol
        ball.init()
      else: discard
  
    # Ball on the shields?
    if ball.bounds.collidesWith(outterShield):
      ball.onHitsShields(outterShield)
    if ball.bounds.collidesWith(innerShield):
      ball.onHitsShields(innerShield)
  
    let ballVsGoal = ball.bounds.collidesWith(goal.bounds)
    case ballVsGoal:
      of Intersects:
        ball.onTouchesGoal(goal)
        goal.touchedByBall()
      of ContainedBy:
        # This is the gameover situation here
        ball.onInsideGoal(goal)
        goal.containsBall()
      else: discard
  else:
    # Must be game over
    app.printGameStatsOnce()
    if resetGameRequested:
      # Restart the game!
      app.reset()
      init(app)


      
