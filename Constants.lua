module('Constants', package.seeall)

-- Screen stuff
screen_w = 1000
screen_h = 700
player_x = 500 -- x coord of player on screen
player_y = 600 -- y coord of player on screen
world_h = 5000
world_w = 5000

-- Bullet stuff
bullet_delay = 0.05
bullet_radius = 5
bullet_start = 25 -- How far from the player do bullets start
bullet_speed = 1000
bullet_spread = 10 -- deg

-- Player body stuff
mass = 5
radius = 20
turn_inertia = 15
turn_speed = 800
turn_deceleration = 10
acceleration = 300
deceleration = 6
max_speed = 600
