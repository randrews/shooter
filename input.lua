function read_keys(kbd)
   kbd = kbd or love.keyboard
   local keys = {}

   keys.turn_left = kbd.isDown('left')
   keys.turn_right = kbd.isDown('right')
   keys.turn = keys.turn_left or keys.turn_right

   keys.forward = kbd.isDown('up')
   keys.reverse = kbd.isDown('down')
   keys.strafe_left = false
   keys.strafe_right = false
   keys.move = (keys.forward or keys.reverse or
                keys.strafe_left or keys.strafe_right)

   keys.shoot = kbd.isDown(' ')

   return keys
end