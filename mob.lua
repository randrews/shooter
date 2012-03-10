require 'Constants'

module('mob', package.seeall)

local instance = {class = mob,
                  body = nil,
                  shape = nil,
                  x = Constants.world_w / 2,
                  y = Constants.world_h / 2,
                  angle = 0,
                  color = {110, 140, 190}
               }

function new(tbl)
   local m = setmetatable(tbl or {}, {__index=instance})
   return m:init()
end

function instance.init(self)
   if not self.world then
      error("World not specified")
      return nil
   end

   self.body = love.physics.newBody(self.world,
                                    self.x, self.y,
                                    Constants.mass,
                                    Constants.turn_inertia)

   self.shape = love.physics.newCircleShape(self.body, 0, 0, 20)

   return self
end

function instance.draw(self)
   local g = love.graphics
   local b = self.body
   local s = self.shape
   g.push()
   g.setColor(unpack(self.color))
   g.circle('fill', b:getX(), b:getY(), s:getRadius(), 20)

   g.setColor(220, 220, 90)
   g.line(b:getX(),b:getY(),
          b:getX() + 50 * math.cos(b:getAngle()),
          b:getY() + 50 * math.sin(b:getAngle()))

   g.pop()
end