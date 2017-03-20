# Mean to be included by `game.nim`

proc load() =
  echo "Loading!"
  drawGeometry.load()

  var app = getApp()
  
  arena = newArena()
  ball = newBall()
  goal = newGoal()
  innerShield = newShield(2)
  outterShield = newShield(4)



proc unload() =
  echo "Unloading!"
  drawGeometry.unload()

