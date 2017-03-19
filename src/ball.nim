# A ball data structre, it gets bounced around


import colors
import updateArguments
import drawArguments


type
  Ball* = ref BallObj
  BallObj = object of RootObj
    bounds*: Circle



proc newBall*(): Ball =
  var app = getApp()

  result = new(Ball)
  result.bounds = newCircle(point2d(0, 0), app.worldScale * 0.035)

  


proc update*(
  self: Ball;
  app: App;
  ua: UpdateArguments
) =
  discard


proc draw*(
  self: Ball;
  app: App;
  da: DrawArguments
) =
  self.bounds.draw(colWhite, Fill)

