

type
  UpdateArguments* = object
    frameNumber*: int  # Which number frame this is
    deltaTime*: float  # Time (in seconds) since last frame
    totalTime*: float  # Time (in seconds) since the game has started
