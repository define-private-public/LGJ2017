# Various utility functions

# maps one value from one range to another
proc map*(x, a, b, p, q: float): float {.inline.} =
  return (x - a) * (q - p) / (b - a) + p

