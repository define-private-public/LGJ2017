# Collisions for the simple 2D objects

import math
import basic2d
import geometry


type
  CollisionType* = enum
    None, Intersects, Contains, ContainedBy


# Circle -> Circle collsions
proc collidesWith*(a, b: Circle): CollisionType =
  let d = dist(a.center, b.center)

  if d > (a.radius + b.radius):
    return None
  elif d < abs(a.radius - b.radius):
    # There is a containment
    if a.radius > b.radius:
      return Contains
    else:
      return ContainedBy
  else:
    return Intersects

