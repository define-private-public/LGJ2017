# Mean to be imported by `data.nim`

#import app
#import update
#import draw
#import geometry
#import drawGeometry
import colors
import updateArguments
import drawArguments


type
  Arena* = ref ArenaObj
  ArenaObj = object of RootObj
    rimOutter*: Circle
    rimInner*: Circle




proc newArena*(): Arena =
  var app = getApp()

  result = new(Arena)
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

