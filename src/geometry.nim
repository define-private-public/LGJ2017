# Geometry logic, all in 2D

import basic2d

type
  Shape2D* = ref Shape2DObj
  Shape2DObj = object of RootObj
    id*: int

  # A simple circle
  Circle* = ref CircleObj
  CircleObj = object of Shape2DObj
    center*: Point2D
    radius*: float      # Should always be positive

  # A Rectangle
  Rect* = ref RectObj
  RectObj = object of Shape2DObj
    center*: Point2D 
    width*, height*: float  # Should always be postive
    angle*: float           # Rotation, in radians, CCW


# TODO proper
#method getCenter(self: Shape2D): Point2D =


# TODO AABB of objects


