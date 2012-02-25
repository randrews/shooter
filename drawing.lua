
function love.draw()
   local sc_x = objects.ball.body:getX() - 500
   local sc_y = objects.ball.body:getY() - 350

   love.graphics.push()
   love.graphics.translate(-sc_x, -sc_y)

   love.graphics.translate(objects.ball.body:getX(), objects.ball.body:getY())
   love.graphics.rotate(-objects.ball.body:getAngle() - math.pi/2)
   love.graphics.translate(-objects.ball.body:getX(), -objects.ball.body:getY())
 
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
