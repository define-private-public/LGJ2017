# App data structure and basic logic
#
# This is meant to be a singleton

import sdl2/sdl
import stopwatch
import strfmt

type
  App* = ref AppObj
  AppObj = object
    window*: sdl.Window     # SDL Window ponter
    glCtx*: sdl.GLContext   # OpenGL Context
    running*: bool          # Is the app running?

    screenWidth*: int       # Width of the screen in pixels
    screenHeight*: int      # Height of the screen in pixels

    worldScale*: float

    # Game state stuff
    gameOver*: bool               # Is the game running or not?
    gameTime: Stopwatch           # How long the game has gone on for
    numRimBounces*: int           # Number of bounces of the ball had on the rim
    numOutterShieldBounces*: int  # Number of times the ball has hit the outter part of a shield
    numInnerShieldBounces*: int   # Nubmer of times the ball has hit the iiner part of a shield
    numSideSwipes*: int           # Number of times the ball has sideswiped the goal, but not gone in
    numKnockOuts*: int            # Number of times the ball was knocked out of the arena
    shownStatsOnGameOver: bool    # Have we shown the stats of the round or not?



# the single instance
var instance: App


# Make a new app object
proc newApp*(): App =
  assert(instance == nil)

  result = App()
  result.screenWidth = 800
  result.screenHeight = 800
  result.running = false

  result.worldScale = 10
  result.gameOver = false

  result.gameTime = stopwatch(false)
  result.shownStatsOnGameOver = false

  # Set the singleton
  instance = result


proc getApp*(): App =
  return instance


# This is used to reset the app to a state, where the game can be played
proc reset*(self: App) =
  self.gameOver = false
  self.gameTime.restart()

  self.numRimBounces = 0
  self.numOutterShieldBounces = 0
  self.numInnerShieldBounces = 0
  self.numSideSwipes = 0
  self.numKnockOuts = 0

  self.shownStatsOnGameOver = false


const
  rimBounceMultiplier = 1.0
  outterShieldBounceMultiplier = 1.1
  innerShieldBounceMultiplier = 1.5
  sideSwipeMultiplier = 2.5
  knockOutMultiplier = 500.0          # These rarely happen


# Will print the stats of the game once, and only once, until the
# `shownStatsOnGameOver` field is set to `false` again
proc printGameStatsOnce*(self: App) =
  # Once per game check
  if self.shownStatsOnGameOver:
    return

  let totalBounces = self.numRimBounces + self.numOutterShieldBounces + self.numInnerShieldBounces 

  echo "Game Over, stats:"
  echo "  Total Time: {0} secs".fmt(self.gameTime.secs.format("0.2f")
  echo "  Rim bounces [{0}x]: {1}".fmt(rimBounceMultiplier, self.numRimBounces)
  echo "  Outside part of shield bounces [{0}x]: {1}".fmt(outterShieldBounceMultiplier, self.numOutterShieldBounces)
  echo "  Inside part of shield bounces [{0}x]: {1}".fmt(innerShieldBounceMultiplier, self.numInnerShieldBounces)
  echo "    (That's {0} total bounces.)".fmt(totalBounces)
  echo "  Goal sideswipes [{0}x]: {1}".fmt(sideSwipeMultiplier, self.numSideSwipes)

  # Did they find the magic secret?
  if self.numKnockOuts > 0:
    # Holy crap they did it.
    echo "  Knockouts [{0}x]: {1}(!)".fmt(knockOutMultiplier, self.numKnockOuts)

  # Final score
  let finalScore = 
    (self.numRimBounces.float * rimBounceMultiplier) +
    (self.numOutterShieldBounces.float * outterShieldBounceMultiplier) +
    (self.numInnerShieldBounces.float * innerShieldBounceMultiplier) +
    (self.numSideSwipes.float * sideSwipeMultiplier) +
    (self.numKnockOuts.float * knockOutMultiplier)

  # Print it!
  echo ""
  echo "Final Score: {0} pts".fmt(finalScore)
  echo "----------------"
  echo ""

  # Make sure they aren't printed again
  self.shownStatsOnGameOver = true



