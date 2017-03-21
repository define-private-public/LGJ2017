# Game initilazeiont logic
#
# this is meant to be inclued by `game.nim`

import app


#proc init()                   # set initial state of game


proc init*(app: App) =
  app.running = true

  app.reset()
  
  innerShield.init()
  outterShield.init()
  ball.init()
  goal.init()

