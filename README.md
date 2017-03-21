Pucker Up (Linux Game Jam 2017)
===============================

Pucker Up is a game made I made for the [Linux Game Jam
2017](https://itch.io/jam/linux-jam-2017) which was hosted by [The Linux
Gamer](https://www.youtube.com/channel/UCv1Kcz-CuGM6mxzL3B1_Eiw).  All of the
development and testing was done on a Ubuntu 16.04 machine, so best of luck if
you want to build/run it on something else. :]

![Pucker Up
Screenshot](https://gitlab.com/define-private-public/LGJ2017/raw/stable/screenshots/pucker_up.png)

The license for this game is GPLv3, which the details of that can be found in
the files `LICENSE.txt`


Needed to Run
-------------
 
 - Some machine that can handle OpenGL
 - A monitor that has at least 800x800 pixels (sorry, that screen size is hard
   coded in, my bad)
 - Some sort of audio device
 - `SDL2` and `SDL2_Mixer` runtime libraries installed


How To Play
-----------
The goal of the game is simple.  Make sure that little white puck that is
bouncing around doesn't get into the goal at the center.  You have two shields
that you can bounce the puck off of.  Your score at the end of the game will
appear in the terminal window.

Controls:
 - `Q` -- Move outter shield counter clock wise
 - `W` -- Move outter shield clock wise
 - `O` -- Move inner shield counter clock wise
 - `P` -- Move inner shield clock wise
 - `Esc` -- Quit the game
 - `R` -- Reset the game

(I'm sorry for the QWOP control sceheme...  It happened by accident, I swear.)

Your score will be displayed on the terminal window at the end of the game.


How To Build
------------

This game was made using `v0.16.x` of the fantastic but young [Nim Programming
Langauge](https://nim-lang.org/).  You should check it out if you haven't.
You'll definately need that.

You'll need the development headers and libraries for `SDL2`, `SDL2_Mixer`, and
some way of accessing the OpenGL headers/libraries on your system.

Don't forget to grab the packages that are listed in `LGL2017.nimble`; they're
required.

To actually build the game.  Change into the `src/` directory and type `nim c
game`.  It should compile to a binary called `game`.  Go head and run it and
have fun.


How it was made
---------------

I decided I wanted to do some game development in Nim, and do it a bit more
"Hard Core," so I decided to forego using a well known game library and build my
own.  Since Nim is still quite in its infancy, there was a lot more work cut out
for me.

In the end, I decided to just use the Circle drawing and collision stuff to game
the game.  I had to scale back on my original ideas, as I spent way more time on
infrastructure work rather than the actual game logic.  It was stuff fun and I'm
somewhat satisfied with what I made.

"I'm going to write my own game engine from scratch during this game jam, it
will be fun!"  Things I'll never ever say again...


Special Thanks:
---------------
 - The guys who work on Nim
 - [jsfxr](http://github.grumdrig.com/jsfxr/)


Find Me Online:
---------------
 - [My Website: 16BPP.net](https://16bpp.net).  I talk about many things there.
   Check the contact page for an email address
 - [My Twitter](https://twitter.com/DefPriPub)

