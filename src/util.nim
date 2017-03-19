# Various utility functions

import random
import basic2d

randomize()


# maps one value from one range to another
proc map*(x, a, b, p, q: float): float {.inline.} =
  return (x - a) * (q - p) / (b - a) + p

# Procude a random value in the range of a to b
proc random*(min, max: float): float {.inline.} =
  return map(random(1.0), 0.0, 1.0, min, max)


# Reflect a vector around the normal `n` (make sure it's normalized)
proc reflect*(incident, n: Vector2d): Vector2d {.inline.} =
  return incident - (2 * dot(incident, n) * n)

