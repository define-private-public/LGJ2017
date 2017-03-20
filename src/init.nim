# Game initilazeiont logic
#
# this is meant to be inclued by `game.nim`

import app


#proc init()                   # set initial state of game


proc init*(app: App) =
  echo "Set intial state."
  app.running = true

  innerShield.init()
  outterShield.init()
  ball.init()

