# Projects


## Casse Briques
Learn Godot basics with a project similar to PONG.
Let the students setup the scenes.
They will have to create a scene for 
- the paddle
- the ball
- the bricks

In each scene, they will set
The physics body with a collider shape
paddle and ball are kinematic
brick is static

They will setup collision events
When the brick detect a collision with the ball it gets destroyed and decrease a global counter by one
When the counter reach zero, the player win


## Snake
Implement the snake game using two different approach
Tile based (add Game&Watch LCD effect?)
Analogic based (check for collision with a raycast)
In both case we need to keep track of the positions occupied
So that the tail follow closely the path of the head


## Watermelon Game
Reproduce Suika game using godot physics engine.
This time we use RigidBodies
Again on collision events check if two fruits can combine
Have a trigger area for detecting when a fruit is out of the flask
Add a normal map to the fruit to add lighting effect?


## Tanks
Recreation of WiiPlay's tank game
2D or 3D ?


## Cosmo War
First 3D project
Provide the wire frame models
(use retro_vector project for the shader)
Spatial escarmouche
Teach students about 3D transformations quaternions
Provide a mesh with 3D axis for understanding 3D transformations


## Pakku Man
Implement Pac-Man using a tilemap
Provide a tileset with autotiling
Provide an engine which handle motion following a grid
Let student implement the motion of the ghosts


## Visual effects
Teach about shader
Hologram shader
Outline shader
Fur shader
Toon shader
CRT shader
Pixelated shader


## Super Plumber
Platformer
Proper jump calculation physics
Provide script for jump trajectories
Provide first level of super mario bros
Provide script for activating enemies when player is in view
Let student implement interactions between player and enemies


## Adventure
Most complex because of the amount of interactions and systems
Implement a Zelda like
Implement scene transition
Implement Inventory UI
Implement interactions


