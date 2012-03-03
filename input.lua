module('input', package.seeall)

local input_state = {
   mouse_down = false,
   save = false
}

local single_press

function read_keys()
   k = love.keyboard.isDown
   ms = love.mouse
   local keys = {}

   keys.turn_left, keys.turn_right = k('left'), k('right')
   keys.turn = keys.turn_left or keys.turn_right

   keys.forward, keys.reverse = k('up'), k('down')
   keys.strafe_left = false
   keys.strafe_right = false
   keys.move = (keys.forward or keys.reverse or
                keys.strafe_left or keys.strafe_right)

   keys.shoot = k(' ')

   keys.mouse = {
      x = ms.getX(),
      y = ms.getY(),
      -- 'click' if it's a new click, 'hold' if the mouse is still down from before
      click = single_press(ms.isDown('l'), 'mouse_down'),
      wheel_up = ms.isDown('wu'), -- These two don't seem to work... :(
      wheel_down = ms.isDown('wd')
   }

   keys.mouse.hold = input_state.mouse_down and not keys.mouse.click
   -- Any mouse input at all
   keys.mouse.any = (keys.mouse.click or 
                     keys.mouse.hold or
                     keys.mouse.wheel_up or
                     keys.mouse.wheel_down)

   return keys
end

function single_press(down, state_key)
   if down then
      if not input_state[state_key] then
         input_state[state_key] = true
         return true
      else
         return false
      end
   else
      input_state[state_key] = false
      return false
   end
end

function in_rad(x,y, cx, cy, rad)
   local dx, dy = x-cx, y-cy
   return (dx*dx+dy*dy) <= rad*rad
end