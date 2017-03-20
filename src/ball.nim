# A ball data structre, it gets bounced around


import os
import math
import basic2d
import colors
import random
import util
import updateArguments
import drawArguments
import collisions


type
  Ball* = ref BallObj
  BallObj = object of RootObj
    bounds*: Circle
    pos: Point2d      # position
    vel: Vector2d     # velocity
    bounceNoises: seq[mixer.Chunk]    # Bounce noises



proc newBall*(): Ball =
  var app = getApp()

  result = new(Ball)
  result.bounds = newCircle(point2d(0, 0), app.worldScale * 0.035)
  result.pos = point2d(1, 1)      # TODO need a spawning point!
#  result.vel = vector2d(1.5, 1.5)
  result.vel = vector2d(2, 2)

  # Load up the bounce noises
  result.bounceNoises = @[]
  for kind, path in walkDir("sounds/bounce/"):
    result.bounceNoises.add(mixer.loadWAV(path))
  


proc update*(
  self: Ball;
  app: App;
  ua: UpdateArguments
) =
  # Update ball position
  self.pos += self.vel * ua.deltaTime


proc draw*(
  self: Ball;
  app: App;
  da: DrawArguments
) =
  # Update bounds locations
  self.bounds.center = self.pos

  self.bounds.draw(colWhite, Fill)


# Will bounce the ball about the normal
# Will increase the speed
proc bounce(self: Ball; n: Vector2D) =
  # Reverse the velocity, with a tiny increas
  self.vel = reflect(self.vel, n)

  # Get the polar stuff
  var
    rad = arctan2(self.vel.y, self.vel.x)
    mag = self.vel.len()

  # Alter the angle and magnatude
  rad += degToRad(random(-15, 15))
  mag += 0.15

  # Cap the magnitude 
  if mag > 20:
    mag = 20

  self.vel = polarVector2d(rad, mag)

  # Move the ball , should be back in the rim
  self.pos += self.vel * 0.05   # TODO, I don't think that this is a good modifier here...
 
  # Play a bounce noise
  discard mixer.playChannel(-1, random(self.bounceNoises), 0)



# What to do when there was a collision with the arena Rim
proc onHitsArenaRim*(
  self: Ball;
  arena: Arena
) =
  # Figure normal at collision
  var n = vector2d(arena.center.x - self.pos.x, arena.center.y - self.pos.y)
  n.normalize()

  self.bounce(n)


# What to do when the ball is fully contained by the goal
proc onInsideGoal*(
  self: Ball;
  goal: Goal
) =
  # TODO implement game over!
  discard


proc onHitsShields*(
  self: Ball;
  shield: Shield
) =
  # Figure out the normal to reflect of off
  # Since we don't really have a proper collision library, we have to do this hacky ass shit:
  #   Compare the radiusLoc vs. the ball's radial position
  var
    n: Vector2D
    ballRadius = dist(self.pos, point2d(0, 0))

  if ballRadius <= shield.radiusLoc:
    # It hit the inner part of the shield
    n = vector2d(0 - self.pos.x, 0 - self.pos.y)
  elif ballRadius > shield.radiusLoc:
    # It hit the outter part of the shield
    n = vector2d(0 + self.pos.x, 0 + self.pos.y)
    
  n.normalize()

  self.bounce(n)


