# Main runner for the game

import strfmt
import stopwatch


type
  UpdateArguments = object
    frameNumber: int  # Which number frame this is
    deltaTime: float  # Time (in seconds) since last frame
    totalTime: float  # Time (in seconds) since the game has started

  DrawArguments = object
    frameNumber: int  # Which number frame this is
    deltaTime: float  # Time (in seconds) since last frame
    totalTime: float  # Time (in seconds) since the game has started


# foward decls
proc load()     # load & create resources
proc unload()   # delete resources
proc init()     # set initial state of game
proc update(ua: UpdateArguments)    # Update function
proc draw(da: DrawArguments)        # Render function


proc load() =
  echo "Loading!"


proc unload() =
  echo "Unloading!"


proc init() =
  echo "Set intial state."


proc update(ua: UpdateArguments) =
  echo "Update #", ua.frameNumber


proc draw(da: DrawArguments) =
  echo "Draw, dt=", da.deltaTime
  


proc main() =

  # Setup
  load()

  var
    lastTimeReading = 0.0
    frameCount = 0
    ua = UpdateArguments()
    da = DrawArguments()
    sw = stopwatch()

  init()
  sw.start()
  var t = sw.secs
  while t <= 0.1:
    # get the delta
    let dt = t - lastTimeReading

    # Set the arguments
    ua.frameNumber = frameCount
    ua.deltaTime = dt
    ua.totalTime = t

    da.frameNumber = frameCount
    da.deltaTime = dt
    da.totalTime = t

    # Update and draw
    update(ua)
    draw(da)
   
    # Get the next time reading
    lastTimeReading = t
    t = sw.secs
    frameCount += 1

  unload()


# Run the game
main()

