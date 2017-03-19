# Mean to be included by `game.nim`

proc load() =
  echo "Loading!"
  drawGeometry.load()

  var app = getApp()

  rimOutter = newCircle(point2D(0, 0), app.worldScale - 1)
  rimInner = newCircle(point2D(0, 0), app.worldScale - 1.25)


proc unload() =
  echo "Unloading!"
  drawGeometry.unload()

