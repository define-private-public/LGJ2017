# Geometry logic, all in 2D

import basic2d

import strfmt



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


# the next available ID
var nextId = 1
proc getId(): int =
  result = nextId
  nextId += 1


method `$`*(self: Shape2D): string{.base.} =
  return "Shape2D [{0}]".fmt(self.id)


method `$`*(self: Circle): string =
  result  = "Circle [{0}]:".fmt(self.id)
  result &= "  center=" & $self.center
  result &= "  radius=" & $self.radius


method `$`*(self: Rect): string =
  result  = "Rect [{0}]:".fmt(self.id)
  result &= "  center=" & $self.center
  result &= "  width=" & $self.width
  result &= "  height=" & $self.height


# Create a new Circle.
# c -- center point of the circle
# r -- radious of the circle, should be non-negative
proc newCircle*(c: Point2D; r: float): Circle =
  assert(r >= 0)

  result = new(Circle)
  result.id = getId()
  result.center = c
  result.radius = r


# Create a new Circle.
# c -- center point of the circle
# w -- width of the rectangle, should be non-negative
# h -- height of the rectangle, should be non-negative
proc newRect*(c: Point2D; w, h: float): Rect =
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


