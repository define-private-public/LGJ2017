# Main runner for the game

import strfmt
import stopwatch
import
  sdl2/sdl,
  sdl2/sdl_image as img,
  sdl2/sdl_ttf as ttf,
  sdl2/sdl_mixer as mixer
import opengl


type
  UpdateArguments = object
    frameNumber: int  # Which number frame this is
    deltaTime: float  # Time (in seconds) since last frame
    totalTime: float  # Time (in seconds) since the game has started

  DrawArguments = object
    frameNumber: int  # Which number frame this is
    deltaTime: float  # Time (in seconds) since last frame
    totalTime: float  # Time (in seconds) since the game has started

  App = ref AppObj
  AppObj = object
    window*: sdl.Window     # SDL Window ponter
    glCtx*: sdl.GLContext   # OpenGL Context
    running*: bool          # Is the app running?


proc newApp(): App =
  result = App()
  result.running = false


# foward decls
proc initSDL(app: App): bool  # Initlize the SDL2 backend & OpenGL ES 2.0
proc shutdownSDL(app: App)    # Gracefully shutdown SDL2 and OpenGL
proc load()                   # load & create resources
proc unload()                 # delete resources
proc init()                   # set initial state of game
proc update(app: App, ua: UpdateArguments)    # Update function
proc draw(app: App, da: DrawArguments)        # Render function


proc initSDL(app: App): bool =
  result = true

  # init libSDL and it's subsystems
  if sdl.init(sdl.InitEverything) != 0:
    echo "Error setting up SDL:"
    echo sdl.getError()
    return false

  # SDL_image
  if img.init(img.InitPng) == 0:
    echo "Error setting up SDL_image:"
    echo img.geterror()
    return false

  # SDL_ttf
  if ttf.init() != 0:
    echo "Error setting up SDL_ttf:"
    echo ttf.geterror()
    return false

  # SDL_mixer
  if mixer.init(mixer.InitMod or mixer.InitMp3 or mixer.InitOgg) == 0:
    echo "Error setting up SDL_mixer:"
    echo mixer.geterror()
    return false

  # Setup the mixer
  if mixer.openAudio(mixer.DefaultFrequency, mixer.Defaultformat, mixer.DefaultChannels, 1024) != 0:
    echo "Error setting up the mixer:"
    echo mixer.getError()
    return false

  # Set opengl version to ES 2.0
  # TODO correct this to use OpenGL ES
#  discard sdl.glSetAttribute(sdl.GLContextProfileMask, sdl.GLContextProfileEs)
  discard sdl.glSetAttribute(sdl.GLContextMajorVersion, 4)
  discard sdl.glSetAttribute(sdl.GLContextMajorVersion, 0)

  # Create the window
  app.window = sdl.createWindow(
    "LGJ 2017 (w/ OpenGL ES 2.0)",
    sdl.WindowPosUndefined,
    sdl.WindowPosUndefined,
    960,
    540,
    sdl.WindowOpenGL
  )
  if app.window == nil:
    echo "Couldn't setup SDL Window, reason:"
    echo sdl.getError()
    return false

  # Setup OpenGL
  app.glCtx = glCreateContext(app.window)
  if app.glCtx == nil:
    echo "Couldn't setup OpenGL ES 2.0 context, reason:"
    echo sdl.getError()
    return false

  loadExtensions()

  # Try to use V-Sync
  if sdl.glSetSwapInterval(1) < 0:
    echo "Warning: couldn't setup V-Sync, reason:"
    echo sdl.getError()

  # Set clear color
  glClearColor(0, 0, 0, 1)

  # Check for error
  if glGetError() != GL_NoError:
    echo "There was some issue with OpenGL setup."
    return false


proc shutdownSDL(app: App) =
  # OpenGL
  sdl.glDeleteContext(app.glCtx)

  # Window
  app.window.destroyWindow()

  # SDL & Libraries
  mixer.quit()
  ttf.quit()
  img.quit()
  sdl.quit()


proc load() =
  echo "Loading!"


proc unload() =
  echo "Unloading!"


proc init() =
  echo "Set intial state."


proc update(app: App, ua: UpdateArguments) =
  # Poll for events
  var event: sdl.Event
  while sdl.pollEvent(event.addr) != 0:
    # Check for quit (ESC press or X-out of window)
    if event.kind == sdl.Quit:
      # X - Out
      app.running = false
    elif event.kind == sdl.KeyDown:
      if event.key.keysym.sym == sdl.K_Escape:
        # ESC Press
        app.running = false


proc draw(app: App, da: DrawArguments) =
  glClear(GL_ColorBufferBit or GL_DepthBufferBit)

  # TODO replace with shaders!
  glBegin(GL_Quads)
  glVertex2f(-0.5, -0.5)
  glVertex2f( 0.5, -0.5)
  glVertex2f( 0.5,  0.5)
  glVertex2f(-0.5,  0.5)
  glEnd()

  sdl.glSwapWindow(app.window)


proc main() =
  # Setup
  var app = newApp()
  if not initSDL(app):
    return

  # Get assets
  load()

  # TODO put these in app?
  var
    lastTimeReading = 0.0
    frameCount = 0
    ua = UpdateArguments()
    da = DrawArguments()
    sw = stopwatch()

  # Start
  app.running = true
  init()
  sw.start()
  var t = sw.secs
  while app.running:
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
    update(app, ua)
    draw(app, da)
   
    # Get the next time reading
    lastTimeReading = t
    t = sw.secs
    frameCount += 1

  unload()

  shutdownSDL(app)


# Run the game
main()

