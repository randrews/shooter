function love.draw()
   draw_main(objects.ball.body)
   draw_minimap(0,0)
end

function draw_main(player)

   love.graphics.push()
   transform_coords(player)

   love.graphics.drawq(Images.dirt, ground, 0, 0)

   --draw_walls()
   draw_obstacles()
   draw_bullets()
   draw_player(player)

   love.graphics.pop()
end

function transform_coords(player)
   local x = player:getX()
   local y = player:getY()
   local a = player:getAngle()

   love.graphics.translate(-(x - Constants.screen_w/2),
                        -(y - Constants.screen_h/2))
   love.graphics.translate(x, y)
   love.graphics.rotate(-a - math.pi/2)
   love.graphics.translate(-x, -y)
end

function draw_walls()
   love.graphics.setColor(72, 160, 14)
   for _, wall in pairs(walls) do
      love.graphics.polygon("fill", wall.shape:getPoints())
   end
end

function draw_bullets()
   love.graphics.setColor(220, 220, 90)
   for _, bullet in ipairs(objects.bullets) do
      love.graphics.circle("fill",
                           bullet.body:getX(), bullet.body:getY(),
                           bullet.shape:getRadius(), 10)
   end
end

function draw_player(player)
   local x = player:getX()
   local y = player:getY()
   local a = player:getAngle()

   love.graphics.setColor(220, 90, 90)
   love.graphics.circle("fill", x, y, Constants.radius, 20)

   love.graphics.setColor(220, 220, 90)
   love.graphics.line(x,y,x + 50 * math.cos(a),y + 50 * math.sin(a))
end

function draw_obstacles()
   love.graphics.setColor(100, 100, 100)
   for k = 1, 10 do
      love.graphics.circle("fill",
                           objects[k].body:getX(),
                           objects[k].body:getY(),
                           objects[k].shape:getRadius(), 100)
   end
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

   love.graphics.setColor(100, 100, 100)
   for k = 1, 10 do
      love.graphics.circle('fill',
                           objects[k].body:getX() / 25,
                           objects[k].body:getY() / 25,
                           objects[k].shape:getRadius() / 25, 10)
   end      

   love.graphics.setColor(220, 220, 90)
   love.graphics.line(objects.ball.body:getX()/25,
                      objects.ball.body:getY()/25,
                      objects.ball.body:getX()/25 + 20 * math.cos(objects.ball.body:getAngle() - math.pi / 4),
                      objects.ball.body:getY()/25 + 20 * math.sin(objects.ball.body:getAngle() - math.pi / 4))

   love.graphics.line(objects.ball.body:getX()/25,
                      objects.ball.body:getY()/25,
                      objects.ball.body:getX()/25 + 20 * math.cos(objects.ball.body:getAngle() + math.pi / 4),
                      objects.ball.body:getY()/25 + 20 * math.sin(objects.ball.body:getAngle() + math.pi / 4))

   love.graphics.pop()
end
