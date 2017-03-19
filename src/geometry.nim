# Geometry logic, all in 2D

import basic2d
import strfmt

export Point2D
export Vector2D
export Matrix2D
export point2d
export vector2D
export matrix2d



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
    angle*: float           # Rotation, in radians, CCW, TODO implement this!


# the next available ID
var nextId = 1
proc getId(): int =
  result = nextId
  nextId += 1


method `$`*(self: Shape2D): string{.base.} =
  return "Shape2D [{0}]".fmt(self.id)


method `$`*(self: Circle): string =
  result  = "Circle [{0}]:".fmt(self.id)
  result &= "\n  center=" & $self.center
  result &= "\n  radius=" & $self.radius


method `$`*(self: Rect): string =
  result  = "Rect [{0}]:".fmt(self.id)
  result &= "\n  center=" & $self.center
  result &= "\n  width=" & $self.width
  result &= "\n  height=" & $self.height
  result &= "\n  angle=" & $self.angle # TODO put it in degrees (and add unit)


# Create a new Circle.
# c -- center point of the circle
# r -- radious of the circle, should be non-negative
proc newCircle*(c: Point2D = Point2D(); r: float = 0): Circle =
  assert(r >= 0)

  result = new(Circle)
  result.id = getId()
  result.center = c
  result.radius = r


# Create a new Circle.
# c -- center point of the circle
# w -- width of the rectangle, should be non-negative
# h -- height of the rectangle, should be non-negative
proc newRect*(c: Point2D = Point2D(); w, h: float = 0): Rect =
  assert(w >= 0)
  assert(h >= 0)

  result = new(Rect)
  result.id = getId()
  result.center = c
  result.width = w
  result.height = h


# TODO proper
#method getCenter(self: Shape2D): Point2D =


# TODO AABB of objects


