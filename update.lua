function love.update(dt)
   if not GameState.paused then world:update(dt) end
   if love.keyboard.isDown('1') then GameState.paused = not GameState.paused end

   local keys = read_keys(love.keyboard)
   local ball = objects.ball.body

   maneuver_player(ball, keys)
   handle_shooting(ball, keys, dt, GameState)
   objects.bullets = bullet_impacts(objects.bullets)
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
