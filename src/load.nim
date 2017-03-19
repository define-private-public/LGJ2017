# Mean to be included by `game.nim`

proc load() =
  echo "Loading!"
  drawGeometry.load()

  var app = getApp()
  
  arena = newArena()
  ball = newBall()
  goal = newGoal()



proc unload() =
  echo "Unloading!"
  drawGeometry.unload()

