# Project 3

A game similar to Space Invaders created in Elm.

## Instructions

1. ssh into mac1xa3.ca server in terminal.
2. cd into CS1XA3 repository.
3. cd into Project3.
4. cd into python_env.
5. activate the virtual environment by doing "source bin/activate".
6. cd into Project3.
7. cd into django_project.
8. run the server using, "python manage.py runserver localhost:10044".
9. when you are done, close the server by doing, Ctrl + C.
10. once you are finished, close the virtual environment by typing "deactivate", and exit if you wish to do so.

## Features

### Server-side

1. usersystem app, for signup, login, and logout.
2. json encoder and decoder.

### Client-side

1. notifyMouseButtonDown, for mouse clicks
2. keyboard input for moving ship
3. randomly generating numbers for aliens
4. collage for graphics

### Errors

1. when trying to run "python manage.py runserver localhost:10044" and going to mac1xa3.ca/e/nafeesa, there is an error, which I was unable to fix.
2. buttons for my login and signup do not work, again unable to fix as I do not know why they dont work in the first place.
3. because of these errors you are unable to play the game, if you want to play the game, make sure to set gameDisplay = Game, in the init
