function love.update(dt)
   if not GameState.paused then world:update(dt) end
   if love.keyboard.isDown('1') then GameState.paused = not GameState.paused end

   local keys = input.read_keys(love.keyboard)
   local ball = objects.ball.body

   if keys.click then
      GameState.tool_selected =
         input.in_rad(keys.mouse_x, keys.mouse_y, 50, 650, 32)
   end

   maneuver_player(ball, keys)
   handle_shooting(ball, keys, dt, GameState)
   GameState.current_wall = find_wall(keys.mouse_x, keys.mouse_y)
   objects.bullets = bullet_impacts(objects.bullets)
end

-- Finds and returns the (an) obstacle that x,y is within
function find_wall(mx,my)
   local x, y = screen_to_world(mx,my)

   local function within(x,y,w)
      local wx, wy = w.body:getX(), w.body:getY()
      local dx, dy = wx-x, wy-y
      return dx*dx+dy*dy < w.shape:getRadius()*w.shape:getRadius()
   end

   for _, wall in ipairs(objects.walls) do
      if within(x,y,wall) then return wall end
   end

   return nil
end

-- Returns the world coords for a given screen point
function screen_to_world(x,y)
   -- Where the mouse is on the screen, relative to the player
   local cursor_x, cursor_y = x-Constants.player_x, y-Constants.player_y
   -- Where the player is in the world
   local player_x, player_y = objects.ball.body:getX(), objects.ball.body:getY()
   local player_a = objects.ball.body:getAngle()

   -- Angle from the player to the mouse, from player's POV
   local cursor_angle = math.atan(cursor_y/cursor_x) + math.pi/2
   if cursor_x < 0 then cursor_angle = cursor_angle + math.pi end

   -- Distance from the player to the mouse
   local cursor_d = math.sqrt(cursor_x * cursor_x +
                              cursor_y * cursor_y)

   -- Angle in world-frame-of-reference from player to mouse
   local world_a = cursor_angle + player_a

   -- Add vectors. Easy.
   return cursor_d * math.cos(world_a) + player_x, cursor_d * math.sin(world_a) + player_y
end

function bullet_impacts(bullets)
   local new_bullets = {}
   for _, b in ipairs(bullets) do
      if b.delete_me then
         b.shape:destroy()
         b.body:destroy()
      else table.insert(new_bullets, b) end
   end
   return new_bullets
end

function handle_shooting(body, keys, dt, game_state)
   if game_state.bullet_timer <= 0 and keys.shoot then
      local spr = Constants.bullet_spread
      local offset_angle = math.rad(math.random(spr) - spr / 2)
      local bullet_angle = body:getAngle() + offset_angle
      local bxv = Constants.bullet_speed * math.cos(bullet_angle)
      local byv = Constants.bullet_speed * math.sin(bullet_angle)
      local bullet = make_bullet(body:getX() + math.cos(bullet_angle)*Constants.bullet_start,
                                 body:getY() + math.sin(bullet_angle)*Constants.bullet_start,
                                 bxv, byv)

      table.insert(objects.bullets, bullet)
      game_state.bullet_timer = Constants.bullet_delay
   else
      game_state.bullet_timer = game_state.bullet_timer - dt
   end
end

function maneuver_player(body, keys)
   local accel = Constants.acceleration

   -- Turning
   if keys.turn_right then body:applyTorque(Constants.turn_speed) end
   if keys.turn_left then body:applyTorque(-Constants.turn_speed) end

   -- Walking
   if keys.forward then
      body:applyForce(math.cos(body:getAngle()) * accel,
                      math.sin(body:getAngle()) * accel)
   end

   if keys.reverse then
      body:applyForce(math.cos(body:getAngle()) * -accel,
                      math.sin(body:getAngle()) * -accel)
   end

   if keys.strafe_left then
      body:applyForce(math.cos(body:getAngle() - math.pi/2) * accel,
                      math.sin(body:getAngle() - math.pi/2) * accel)
   end

   if keys.strafe_right then
      body:applyForce(math.cos(body:getAngle() + math.pi/2) * accel,
                      math.sin(body:getAngle() + math.pi/2) * accel)
   end

   -- Slowdown if no keys pressed
   if not keys.move then
      body:setLinearDamping(Constants.deceleration)
   else
      limit_speed(body, Constants.max_speed)
   end
end

function make_bullet(x,y,xv,yv)
   local bullet = {}

   bullet.body = love.physics.newBody(world, x, y, 1, 0)
   bullet.shape = love.physics.newCircleShape(bullet.body, 0, 0, 5)

   bullet.body:setLinearVelocity(xv,yv)
   bullet.shape:setData(bullet)
   bullet.body:setBullet(true)
   bullet.shape:setCategory(Categories.bullet)
   bullet.shape:setMask(Categories.bullet, Categories.player)

   return bullet
end

function limit_speed(body, max_speed)
   local x, y = body:getLinearVelocity()
   if x*x + y*y > max_speed * max_speed then
      -- TODO: make this just flat set the velocity
      body:setLinearDamping(Constants.deceleration * 2)
   else
      body:setLinearDamping(0)
   end     
end
