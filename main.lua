Categories = {
   edge = 1,
   wall = 2,
   player = 3,
   bullet = 4
}

function love.load()
  world = love.physics.newWorld(0, 0, 5000, 5000) --create a world for the bodies to exist in with width and height of 650
  world:setGravity(0, 0) --the x component of the gravity will be 0, and the y component of the gravity will be 700
  world:setMeter(64) --the height of a meter in this world will be 64px
  world:setCallbacks(collisions.add, nil, nil, nil)


  objects = {} -- table to hold all our physical objects
  walls = make_walls(5000,5000)
  
  --let's create a ball
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 400, 300, 15, 15)
  objects.ball.shape = love.physics.newCircleShape(objects.ball.body, 0, 0, 20)

  objects.bullets = {}
  bullet_delay = 0

  for k = 1, 10 do
     objects[k] = make_obstacle()
  end

  --initial graphics setup
  love.graphics.setBackgroundColor(104, 136, 248)
  love.graphics.setMode(1000,700, false, true, 0)
end

collisions = {
   add = function(a,b,coll)
            if a then a.delete_me = true end
            if b then b.delete_me = true end
         end
}

function make_walls(width, height)
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

function love.update(dt)
  world:update(dt) --this puts the world into motion

  local l = love.keyboard.isDown("left")
  local r = love.keyboard.isDown("right")
  local u = love.keyboard.isDown("up")
  local d = love.keyboard.isDown("down")

  -- if r then
  --    objects.ball.body:applyForce(400, 0) end
  -- if l then
  --    objects.ball.body:applyForce(-400, 0) end
  -- if u then
  --    objects.ball.body:applyForce(0, -400) end
  -- if d then
  --    objects.ball.body:applyForce(0, 400) end

  -- if not (l or r or u or d) then
  --    objects.ball.body:setLinearDamping(10)
  -- else
  --    limit_speed(objects.ball.body, 600)
  -- end

  local ball = objects.ball.body

  if r then
     ball:applyTorque(1000) end
  if l then
     ball:applyTorque(-1000) end

  if u then
     ball:applyForce(0, -400) end
  if d then
     ball:applyForce(0, 400) end

  if not (l or r) then
     ball:setAngularDamping(10)
  end

  if not (u or d) then
     ball:setLinearDamping(10)
  else
     limit_speed(ball, 600)
  end

  if bullet_delay <= 0 then
     local bullet = nil

     if love.keyboard.isDown('a') then
        bullet = make_bullet(objects.ball.body:getX()-26,
                             objects.ball.body:getY(),
                             -1000, math.random(150)-75)
     end

     if love.keyboard.isDown('s') then
        bullet = make_bullet(objects.ball.body:getX(),
                             objects.ball.body:getY()+26,
                             math.random(150)-75, 1000 )
     end

     if love.keyboard.isDown('w') then
        bullet = make_bullet(objects.ball.body:getX(),
                             objects.ball.body:getY()-26,
                             math.random(150)-75, -1000 )
     end

     if love.keyboard.isDown('d') then
        bullet = make_bullet(objects.ball.body:getX()+26,
                             objects.ball.body:getY(),
                             1000, math.random(150)-75)
     end

     if bullet then
        table.insert(objects.bullets, bullet)
        bullet_delay = 0.2
     end
  else
     bullet_delay = bullet_delay - dt
  end

  local new_bullets = {}
  for _, b in ipairs(objects.bullets) do
     if b.delete_me then
        b.shape:destroy()
        b.body:destroy()
     else table.insert(new_bullets, b) end
  end
  objects.bullets = new_bullets
end

function make_bullet(x,y,xv,yv)
   local bullet = {}

   bullet.body = love.physics.newBody(world, x, y, 1, 0)
   bullet.shape = love.physics.newCircleShape(bullet.body, 0, 0, 5)

   bullet.body:setBullet(true)
   bullet.body:applyForce(xv,yv)
   bullet.shape:setData(bullet)
   bullet.shape:setCategory(Categories.bullet)
   bullet.shape:setMask(Categories.bullet)

   return bullet
end

function limit_speed(body, max_speed)
   local x, y = body:getLinearVelocity()
   if x*x + y*y > max_speed * max_speed then
      body:setLinearDamping(10)
   else
      body:setLinearDamping(0)
   end     
end

function love.draw()
   local sc_x = objects.ball.body:getX() - 400
   local sc_y = objects.ball.body:getY() - 300

   love.graphics.push()
   love.graphics.translate(-sc_x, -sc_y)

   love.graphics.setColor(72, 160, 14) -- set the drawing color to green for the ground
   for _, wall in pairs(walls) do
      love.graphics.polygon("fill", wall.shape:getPoints())
   end

   love.graphics.setColor(100, 100, 100) -- set the drawing color to green for the ground
   for k = 1, 10 do
      love.graphics.circle("fill",
                           objects[k].body:getX(),
                           objects[k].body:getY(),
                           objects[k].shape:getRadius(), 100)
   end

   love.graphics.setColor(220, 90, 90) --set the drawing color to red for the ball
   love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius(), 20) -- we want 20 line segments to form the "circle"

   love.graphics.setColor(220, 220, 90)
   love.graphics.line(objects.ball.body:getX(),
                      objects.ball.body:getY(),
                      objects.ball.body:getX() + 50 * math.cos(objects.ball.body:getAngle()),
                      objects.ball.body:getY() + 50 * math.sin(objects.ball.body:getAngle()))

   love.graphics.setColor(220, 220, 90) --set the drawing color yellow for the bullets
   for _, bullet in ipairs(objects.bullets) do
      love.graphics.circle("fill", bullet.body:getX(), bullet.body:getY(), bullet.shape:getRadius(), 10) -- we want 20 line segments to form the "circle"
   end

   love.graphics.pop()
   draw_minimap(0,0)
end

function draw_minimap(x,y)
   love.graphics.push()
   love.graphics.translate(x,y)

   love.graphics.setColor(122, 210, 64)
   love.graphics.rectangle('fill', 0, 0, 200, 200)

   love.graphics.setColor(220, 90, 90)
   love.graphics.circle('fill',
                        objects.ball.body:getX() / 25,
                        objects.ball.body:getY() / 25,
                        3, 6)

   love.graphics.setColor(100, 100, 100) -- set the drawing color to green for the ground
   for k = 1, 10 do
      love.graphics.circle('fill',
                           objects[k].body:getX() / 25,
                           objects[k].body:getY() / 25,
                           objects[k].shape:getRadius() / 25, 10)
   end      

   love.graphics.pop()
end