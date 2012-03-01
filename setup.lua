collisions = {
   add = function(a,b,coll)
            if a then a.delete_me = true end
            if b then b.delete_me = true end
         end
}

function love.load()
  world = love.physics.newWorld(0, 0, 5000, 5000) --create a world for the bodies to exist in with width and height of 650
  world:setGravity(0, 0) --the x component of the gravity will be 0, and the y component of the gravity will be 700
  world:setMeter(64) --the height of a meter in this world will be 64px
  world:setCallbacks(collisions.add, nil, nil, nil)


  objects = {} -- table to hold all our physical objects
  edges = make_edges(5000,5000)
  
  --let's create a ball
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 400, 300,
                                           Constants.mass,
                                           Constants.turn_inertia)
  objects.ball.body:setAngularDamping(Constants.turn_deceleration)
  objects.ball.shape = love.physics.newCircleShape(objects.ball.body, 0, 0, 20)
  objects.ball.shape:setCategory(Categories.player)
  objects.ball.shape:setMask(Categories.bullet)

  objects.bullets = {}
  bullet_delay = 0

  objects.walls = {}
  for k = 1, 10 do
     objects.walls[k] = make_obstacle()
  end

  --initial graphics setup
  love.graphics.setBackgroundColor(0,0,0)
  love.graphics.setMode(Constants.screen_w, Constants.screen_h, false, true, 0)
end

function make_edges(width, height)
   local walls = {}

   walls.south = {}
   walls.south.body = love.physics.newBody(world, width/2, height-5, 0, 0)
   walls.south.shape = love.physics.newRectangleShape(walls.south.body, 0, 0, width, 10, 0)

   walls.north = {}
   walls.north.body = love.physics.newBody(world, width/2, 5, 0, 0)
   walls.north.shape = love.physics.newRectangleShape(walls.north.body, 0, 0, width, 10, 0)

   walls.east = {}
   walls.east.body = love.physics.newBody(world, width-5, height/2, 0, 0)
   walls.east.shape = love.physics.newRectangleShape(walls.east.body, 0, 0, 10, height, 0)

   walls.west = {}
   walls.west.body = love.physics.newBody(world, 5, height/2, 0, 0)
   walls.west.shape = love.physics.newRectangleShape(walls.west.body, 0, 0, 10, height, 0)

   return walls
end

function make_obstacle()
   local obstacle = {}
   obstacle.body = love.physics.newBody(world, math.random(4000)+500, math.random(4000)+500, 0, 0)
   obstacle.shape = love.physics.newCircleShape(obstacle.body, 0, 0, 200)
   return obstacle
end
