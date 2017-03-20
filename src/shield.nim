# One of the shields, made out of spheres


import math
import basic2d
import colors
import util
import updateArguments
import drawArguments


type
  Shield* = ref ShieldObj
  ShieldObj = object of RootObj
    bounds*: seq[Circle]
    radiusLoc*: float     # How far from the center this shield is located




proc newShield*(loc: float): Shield =
  var app = getApp()

  result = new(Shield)
  result.bounds = @[]
  result.radiusLoc = loc

  # Add the circles
  const
    resolution = 64
    shieldSize = 0.333333 * TAU
  for i in 0..<resolution:
    let
      theta = map(i.float, 0.float, resolution.float, 0.float, shieldSize)
      x = result.radiusLoc * cos(theta)
      y = result.radiusLoc * sin(theta)
    result.bounds.add(newCircle(point2d(x, y), 0.2))
  


proc update*(
  self: Shield;
  app: App;
  ua: UpdateArguments
) =
  discard

proc draw*(
  self: Shield;
  app: App;
  da: DrawArguments
) =
  for b in self.bounds:
    b.draw(colLightBlue, Fill)

