# A ball data structre, it gets bounced around


import basic2d
import colors
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
  result.pos = point2d(5, 5)
  result.vel = vector2d(1, 1)

  


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

