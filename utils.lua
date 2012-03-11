require 'Constants'

module('utils', package.seeall)

function center_tools(...)
   local tools = {...}

   local total_width = reduce(function(l,t) return l+t.radius*2+4 end,
                              0, tools)

   local current_x = Constants.screen_w/2 - total_width/2 + tools[1].radius

   for _, t in ipairs(tools) do
      t.x = current_x
      current_x = current_x + t.radius*2 + 4
   end
end

function reduce(fn, init, t)
   for _, e in ipairs(t) do
      init = fn(init, e)
   end
   return init
end

function distance(x1, y1, x2, y2)
   local dx, dy = x2-x1, y2-y1
   return math.sqrt(dx*dx+dy*dy)
end

-- Returns the angle from point 1 to point 2, in radians. Straight up is 0.
function angle_to(x1, y1, x2, y2)
   local dx, dy = x2-x1, y2-y1
   local angle = math.atan(dy/dx) + math.pi/2
   if dx < 0 then angle = angle + math.pi end
   return angle
end

function distance(x1, y1, x2, y2)
   local dx, dy = x2-x1, y2-y1
   return math.sqrt(dx * dx + dy * dy)
end

-- Returns the world coords for a given screen point
function screen_to_world(x,y)
   -- Where the mouse is on the screen, relative to the player
   local cursor_x, cursor_y = x-Constants.player_x, y-Constants.player_y
   -- Where the player is in the world
   local player_x, player_y = objects.ball.body:getX(), objects.ball.body:getY()
   local player_a = objects.ball.body:getAngle()

   -- Angle from the player to the mouse, from player's POV
   local cursor_angle = angle_to(Constants.player_x, Constants.player_y, x, y)

   -- Distance from the player to the mouse
   local cursor_d = distance(Constants.player_x, Constants.player_y, x, y)

   -- Angle in world-frame-of-reference from player to mouse
   local world_a = cursor_angle + player_a

   -- Add vectors. Easy.
   return cursor_d * math.cos(world_a) + player_x, cursor_d * math.sin(world_a) + player_y
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
