# A goal data structre, it shouldn't get touched


import colors
import updateArguments
import drawArguments
import stopwatch


const
  normalColor = colDimGray
  warningColor = colSalmon
  gameOverColor = colDarkRed

  warningDuration = 1.5   # in seconds


type
  Goal* = ref GoalObj
  GoalObj = object of RootObj
    bounds*: Circle
    color: colors.Color
    colorResetStopwatch: Stopwatch

    # Sound effects
    # TODO these need to be cleaned up properly!
    ballTouchGoalNoise: mixer.Chunk
    gameOverNoise: mixer.Chunk

    inWarningMode: bool
    inGameOverMode: bool



proc newGoal*(): Goal =
  var app = getApp()

  result = new(Goal)
  result.bounds = newCircle(point2d(0, 0), app.worldScale * 0.15)
  result.color = colDimGray
  result.colorResetStopwatch = stopwatch(false)

  # Load up the goal noises
  result.ballTouchGoalNoise = mixer.loadWAV("sounds/goalTouch.wav")
  result.gameOverNoise = mixer.loadWAV("sounds/goalIn.wav")

  # the states
  result.inWarningMode = false
  result.inGameOverMode = false


# Set the goal to the intial state
proc init*(self: Goal) =
  self.color = colDimGray
  self.colorResetStopwatch.reset()

  self.inWarningMode = false
  self.inGameOverMode = false


proc update*(
  self: Goal;
  app: App;
  ua: UpdateArguments
) =
  # Check to reset the the state
  if self.inWarningMode and not self.inGameOverMode and (self.colorResetStopwatch.secs > warningDuration):
    self.color = normalColor
    self.inWarningMode = false



proc draw*(
  self: Goal;
  app: App;
  da: DrawArguments
) =
  self.bounds.draw(self.color, Fill)


# Will show the warning color and play a noise
# This is not considered a score
proc touchedByBall*(self: Goal) =
  # If in warning already, stop it
  if self.inWarningMode:
    return

  # Play the touch noise
  discard mixer.playChannel(-1, self.ballTouchGoalNoise, 0)

  # Set the color
  self.color = warningColor
  self.colorResetStopwatch.restart()

  self.inWarningMode = true


# when the ball is completeley inside the goal
proc containsBall*(self: Goal) =
  # Return early if the game over has already started
  if self.inGameOverMode:
    return

  # Play the "inside" noise (stop any others)
  discard mixer.haltChannel(-1)
  discard mixer.playChannel(-1, self.gameOverNoise, 0)
 
  # Set the color
  self.color = gameOverColor

  self.inGameOverMode = true
