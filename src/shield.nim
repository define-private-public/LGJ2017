# One of the shields, made out of spheres


import math
import basic2d
import colors
import util
import updateArguments
import drawArguments
import collisions


const
  shieldAngularVelocity = 215.0   # In degrees
  shieldPartSize = 0.2
  shieldResolution = 64
  shieldSize = 0.1666666 * TAU


type
  Kind* = enum
    Inner, Outter

  Shield* = ref ShieldObj
  ShieldObj = object of RootObj
    kind*: Kind           # Is this the inner or outter shield?
    bounds*: seq[Circle]
    radiusLoc*: float     # How far from the center this shield is located
    angularCenter*: float # Center of the shield, it's angle in relation to the goal (in radians)


# Set the position of a shield part
# c -- the circle part
# angle -- which angle (in relation to the goal) it should be placed at, in radians
proc setShieldPartPos(
  self: Shield;
  part: Circle;
  angle: float 
) =
  part.center.x = self.radiusLoc * cos(angle + self.angularCenter - (shieldSize / 2))
  part.center.y = self.radiusLoc * sin(angle + self.angularCenter - (shieldSize / 2))
  


proc newShield*(loc: float; kind: Kind): Shield =
  var app = getApp()

  result = new(Shield)
  result.kind = kind
  result.bounds = @[]
  result.radiusLoc = loc
  result.angularCenter = 0.0

  # Add the circles
  for i in 0..<shieldResolution:
    let theta = map(i.float, 0.float, shieldResolution.float, 0.float, shieldSize)
    var c = newCircle(Point2D(), shieldPartSize)
    result.setShieldPartPos(c, theta)
    result.bounds.add(c)


# init the position of the shield
proc init*(self: Shield) =
  # Set the intial position of each part, depending upon if we're the inner or outter shield
  for i, part in self.bounds:
    let theta = map(i.float, 0.float, shieldResolution.float, 0.float, shieldSize)

    case self.kind:
      of Inner:
        self.setShieldPartPos(part, theta + (3 * PI / 2))
      of Outter:
        self.setShieldPartPos(part, theta + (PI / 2))
        
  

proc update*(
  self: Shield;
  app: App;
  ua: UpdateArguments
) =
  var angleVel = degToRad(shieldAngularVelocity)
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


