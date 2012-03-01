require 'setup'
require 'update'
require 'drawing'
require 'input'

Categories = {
   edge = 1,
   wall = 2,
   player = 3,
   bullet = 4
}

Images = {
   dirt = love.graphics.newImage('dirt.png'),
   rock = love.graphics.newImage('rock.png'),
   icons = love.graphics.newImage('icons.png')
}

Icons = {
   new = love.graphics.newQuad(0,0, 64,64, 256,256),
   move = love.graphics.newQuad(64,0, 64,64, 256,256)
}

Images.dirt:setWrap('repeat', 'repeat')
ground = love.graphics.newQuad(0, 0, 5000, 5000, 200, 200)
rock = love.graphics.newQuad(0, 0, 118, 118, 118, 118)


Constants = {
   -- Screen stuff
   screen_w = 1000,
   screen_h = 700,
   player_x = 500, -- x coord of player on screen
   player_y = 600, -- y coord of player on screen

   -- Bullet stuff
   bullet_delay = 0.05,
   bullet_radius = 5,
   bullet_start = 25, -- How far from the player do bullets start
   bullet_speed = 1000,
   bullet_spread = 10, -- deg

   -- Player body stuff
   mass = 5,
   radius = 20,
   turn_inertia = 15,
   turn_speed = 800,
   turn_deceleration = 10,
   acceleration = 300,
   deceleration = 6,
   max_speed = 600
}

GameState = {
   paused = false,
   bullet_timer = 0, -- Number of secs until gun can shoot again
   current_wall = nil -- Currently-highlighted wall
}