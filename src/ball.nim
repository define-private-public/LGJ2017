# A ball data structre, it gets bounced around


import math
import basic2d
import colors
import util
import updateArguments
import drawArguments


type
  Ball* = ref BallObj
  BallObj = object of RootObj
    bounds*: Circle
    pos: Point2d      # position
    vel: Vector2d     # velocity



proc newBall*(): Ball =
  var app = getApp()

  result = new(Ball)
  result.bounds = newCircle(point2d(0, 0), app.worldScale * 0.035)
  result.pos = point2d(1, 1)      # TODO need a spawning point!
#  result.vel = vector2d(1.5, 1.5)
  result.vel = vector2d(2, 2)
  


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


# What to do when there was a collision with the arena Rim?
proc onHitsArenaRim*(
  self: Ball;
  arena: Arena
) =
  # Figure normal at collision
  var n = vector2d(arena.center.x - self.pos.x, arena.center.y - self.pos.y)
  n.normalize()

  # Reverse the velocity, with a tiny increas
  self.vel = (reflect(self.vel, n) * 1.05)

  # Get the polar stuff
  var
    rad = arctan2(self.vel.y, self.vel.x)
    mag = self.vel.len()

  # Alter the angle and magnatude
  rad += degToRad(random(-22.5, 22.5))
  mag += 0.15

  self.vel = polarVector2d(rad, mag)

  # Move the ball , should be back in the rim
  self.pos += self.vel * 0.05   # TODO, I don't think that this is a good modifier here...


# What to do when the ball is fully contained by the goal
proc onInsideGoal*(
  self: Ball;
  goal: Goal
) =
  echo "GOAL"
  discard
