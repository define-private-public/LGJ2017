# Mean to be imported by `data.nim`

import basic2d
import colors
import stopwatch
import app
import geometry
import updateArguments
import drawArguments
import drawingMechanics


const
  normalColour = colWhite
  specialColour = colLightGreen

  specialColourTimeDuration = 2.0   # seconds


type
  Arena* = ref ArenaObj
  ArenaObj = object of RootObj
    center*: Point2D
    rimOutter*: Circle
    rimInner*: Circle

    rimColour: colors.Color
    specialColourTimer: Stopwatch

    knockOutNoise: mixer.Chunk




proc newArena*(): Arena =
  var app = getApp()

  result = new(Arena)
  result.center = point2d(0, 0)
  result.rimOutter = newCircle(point2D(0, 0), app.worldScale - 1)
  result.rimInner = newCircle(point2D(0, 0), app.worldScale - 1.25)

  result.rimColour = normalColour
  result.specialColourTimer = stopwatch(false)

  # TODO this needs to be cleaned up
  result.knockOutNoise = mixer.loadWAV("sounds/knockOut.wav")


proc init*(self: Arena) =
  self.rimColour = normalColour
  self.specialColourTimer.reset()


proc update*(
  self: Arena;
  app: App;
  ua: UpdateArguments
) =
  # okay, time to reset to normal
  if (self.specialColourTimer.secs > specialColourTimeDuration):
    self.rimColour = normalColour
    self.specialColourTimer.stop()


proc draw*(
  self: Arena;
  app: App;
  da: DrawArguments
) =
  self.rimOutter.draw(self.rimColour, Fill)
  self.rimInner.draw(colBlack, Fill)


# What happens when the ball goes out of the bounds!
proc onBallOutside*(self: Arena) =
  # Change the rim colour
  self.rimColour = specialColour
  self.specialColourTimer.restart()

  # Special noise
  discard mixer.haltChannel(-1)
  discard mixer.playChannel(-1, self.knockOutNoise, 0)
 

  getApp().numKnockOuts += 1


