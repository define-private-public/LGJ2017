# Game initilazeiont logic

import app


#proc init()                   # set initial state of game


proc init*(app: App) =
  echo "Set intial state."
  app.running = true

