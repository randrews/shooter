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
   dirt = love.graphics.newImage('dirt.png')
}

Images.dirt:setWrap('repeat', 'repeat')
ground = love.graphics.newQuad(0, 0, 5000, 5000, 200, 200)

Constants = {
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
   bullet_timer = 0 -- Number of secs until gun can shoot again
}