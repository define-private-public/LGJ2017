# A ball data structre, it gets bounced around


import os
import math
import basic2d
import colors
import random
import stopwatch
import util
import updateArguments
import drawArguments
import collisions

const
  minRimBouncesTillReset = 4
  maxRimBouncesTillReset = 8

  minSpawnDistance = 7.0
  maxSpawnDistance = 8.0

  startVelocityMagnitude = 3.0
  maxVelocityMagnitude = 22.5

  requiredCollisionTimeSpacing = 0.1   # In seconds


type
  Ball* = ref BallObj
  BallObj = object of RootObj
    bounds*: Circle
    pos: Point2d      # position
    vel: Vector2d     # velocity
    bounceNoises: seq[mixer.Chunk]    # Bounce noises   # TODO these need to be cleaned up!

    # For reset the direction of velocity after there have been X bounces off of the rim
    numRimBounes: int       # Since the start of the sequence
    rimBouncesNeeded: int   # Num needed for the lap

    timeSinceLastCollision: Stopwatch   # Need to make sure we don't have four collsions in 1/30 of a second...



proc newBall*(): Ball =
  var app = getApp()

  result = new(Ball)
  result.bounds = newCircle(point2d(0, 0), app.worldScale * 0.035)
  result.pos = Point2D()
  result.vel = Vector2D()
  result.timeSinceLastCollision = stopwatch(false)

  # Load up the bounce noises
  result.bounceNoises = @[]
  for kind, path in walkDir("sounds/bounce/"):
    result.bounceNoises.add(mixer.loadWAV(path))
 
  result.numRimBounes = 0
  result.rimBouncesNeeded = random(minRimBouncesTillReset, maxRimBouncesTillReset).int


# Setup the ball for the game, will give it a random position
proc init*(self: Ball) =
  let
    dist = random(minSpawnDistance, maxSpawnDistance)
    angle = random(0, TAU)

  self.pos.x = dist * cos(angle)
  self.pos.y = dist * sin(angle)

  # Set the velcity to 2
  self.vel = polarVector2d(angle, -startVelocityMagnitude)

  # Reset the rim bounces
  self.numRimBounes = 0
  self.rimBouncesNeeded = random(minRimBouncesTillReset, maxRimBouncesTillReset).int

  self.timeSinceLastCollision.restart()


proc update*(
  self: Ball;
  app: App;
  ua: UpdateArguments
) =
  # Update ball position
  self.pos += self.vel * ua.deltaTime

  # Update bounds locations
  self.bounds.center = self.pos


proc draw*(
  self: Ball;
  app: App;
  da: DrawArguments
) =
  self.bounds.draw(colWhite, Fill)


# Will bounce the ball about the normal
# Will increase the speed
proc bounce(self: Ball; n: Vector2D) =
  # Don't do a bounce if it hasn't been long enough
  if (self.timeSinceLastCollision.secs < requiredCollisionTimeSpacing):
    return

  # Which way should the ball go?
  if self.numRimBounes >= self.rimBouncesNeeded:
    # Reset the rim bounce counter
    self.numRimBounes = 0
    self.rimBouncesNeeded = random(minRimBouncesTillReset, maxRimBouncesTillReset).int

    # Send to towards the goal
    var
      dir = vector2d(0 - self.pos.x, 0 - self.pos.y)
      mag = self.vel.len()
    dir.normalize()

    self.vel = polarVector2d(arctan2(dir.y, dir.x), mag)
  else:
    # Normal, Reverse the velocity
    self.vel = reflect(self.vel, n)

  # Get the polar stuff
  var
    rad = arctan2(self.vel.y, self.vel.x)
    mag = self.vel.len()

  # Alter the angle and magnatude
  rad += degToRad(random(-15, 15))
  mag += 0.15

  # Cap the magnitude 
  if mag > maxVelocityMagnitude:
    mag = maxVelocityMagnitude

  self.vel = polarVector2d(rad, mag)

  # Move the ball , should be back in the rim
  self.pos += self.vel * 0.05   # TODO, I don't think that this is a good modifier here...
 
  # Play a bounce noise
  discard mixer.playChannel(-1, random(self.bounceNoises), 0)

  # restart the collision timer
  self.timeSinceLastCollision.restart()



# What to do when there was a collision with the arena Rim
proc onHitsArenaRim*(
  self: Ball;
  arena: Arena
) =
  # Increment the rim bounce count
  self.numRimBounes += 1

  # Figure normal at collision
  var n = vector2d(arena.center.x - self.pos.x, arena.center.y - self.pos.y)
  n.normalize()
  self.bounce(n)

  getApp().numRimBounces += 1


# What to do when the ball is fully contained by the goal
proc onInsideGoal*(
  self: Ball;
  goal: Goal
) =
  # Notify of the game over... (sad)
  getApp().gameOver = true

  

proc onHitsShields*(
  self: Ball;
  shield: Shield
) =
  var app = getApp()

  # We can reset the rim bounce count
  self.numRimBounes = 0

  # Figure out the normal to reflect of off
  # Since we don't really have a proper collision library, we have to do this hacky ass shit:
  #   Compare the radiusLoc vs. the ball's radial position
  var
    n: Vector2D
    ballRadius = dist(self.pos, point2d(0, 0))

  if ballRadius <= shield.radiusLoc:
    # It hit the inner part of the shield
    n = vector2d(0 - self.pos.x, 0 - self.pos.y)
    app.numInnerShieldBounces += 1
  elif ballRadius > shield.radiusLoc:
    # It hit the outter part of the shield
    n = vector2d(0 + self.pos.x, 0 + self.pos.y)
    app.numOutterShieldBounces += 1
    
  n.normalize()
  self.bounce(n)


# This is for when the ball touches the goal, but is not in it
proc onTouchesGoal*(
  self: Ball;
  goal: Goal
) =
  # Reset rim bounce count
  self.numRimBounes = 0
  goal.touchedByBall()
  
