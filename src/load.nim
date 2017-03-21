# Mean to be included by `game.nim`

proc load() =
  drawGeometry.load()

  var app = getApp()
  
  arena = newArena()
  ball = newBall()
  goal = newGoal()
  innerShield = newShield(2, Inner)
  outterShield = newShield(4, Outter)



proc unload() =
  drawGeometry.unload()

