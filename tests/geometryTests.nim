# Tests for geometry.nim

import unittest
import basic2d
import ../src/geometry

# Visual test for output
let
  c = newCircle(Point2D(x: 5, y: 6), 4)
  r = newRect()

echo c
echo r

