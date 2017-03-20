# One of the shields, made out of spheres


import math
import basic2d
import colors
import util
import updateArguments
import drawArguments
import collisions


type
  Kind* = enum
    Inner, Outter

  Shield* = ref ShieldObj
  ShieldObj = object of RootObj
    kind*: Kind           # Is this the inner or outter shield?
    bounds*: seq[Circle]
    radiusLoc*: float     # How far from the center this shield is located




proc newShield*(loc: float; kind: Kind): Shield =
  var app = getApp()

  result = new(Shield)
  result.kind = kind
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
  var angleVel = degToRad(180.0)
  let
    moveInner = (ua.moveInnerShieldCCW or ua.moveInnerShieldCW) and (self.kind == Inner)
    moveOutter = (ua.moveOutterShieldCCW or ua.moveOutterShieldCW) and (self.kind == Outter)
    move = moveInner or moveOutter

  # Move the shields
  if (self.kind == Inner) and moveInner:
    # Reverse direction?
    if ua.moveInnerShieldCW:
      angleVel *= -1
  elif (self.kind == Outter) and moveOutter:
    if ua.moveOutterShieldCW:
      angleVel *= -1

  
  # Move at all?
  if move:
    # Move each of the bounds
    for b in self.bounds:
      # Get the polar stuff
      var rad = arctan2(b.center.y, b.center.x)
      rad += angleVel * ua.deltaTime
  
      let v = polarVector2d(rad, self.radiusLoc)
      b.center = point2d(v.x, v.y)


proc draw*(
  self: Shield;
  app: App;
  da: DrawArguments
) =
  for b in self.bounds:
    b.draw(colLightBlue, Fill)


# TODO this is highly ineffcient, maybe fix
# See if a circle collides with this shield
proc collidesWith*(c: Circle; shield: Shield): bool =
  for b in shield.bounds:
    if c.collidesWith(b) != None:
      return true

  return false


