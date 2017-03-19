# Mean to be imported by `data.nim`

#import app
#import update
#import draw
#import geometry
#import drawGeometry
import basic2d
import colors
import app
import geometry
import updateArguments
import drawArguments
import drawingMechanics


type
  Arena* = ref ArenaObj
  ArenaObj = object of RootObj
    center*: Point2D
    rimOutter*: Circle
    rimInner*: Circle




proc newArena*(): Arena =
  var app = getApp()

  result = new(Arena)
  result.center = point2d(0, 0)
  result.rimOutter = newCircle(point2D(0, 0), app.worldScale - 1)
  result.rimInner = newCircle(point2D(0, 0), app.worldScale - 1.25)

  


proc update*(
  self: Arena;
  app: App;
  ua: UpdateArguments
) =
  discard


proc draw*(
  self: Arena;
  app: App;
  da: DrawArguments
) =
  
  self.rimOutter.draw(colWhite, Fill)
  self.rimInner.draw(colBlack, Fill)

