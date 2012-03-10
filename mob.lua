require 'Constants'
require 'utils'

module('mob', package.seeall)

local instance = {class = mob,
                  body = nil,
                  shape = nil,
                  x = Constants.world_w / 2,
                  y = Constants.world_h / 2,
                  angle = 0,
                  color = {110, 140, 190},
                  act = function(self, player) end
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
   self.body:setAngle(self.angle)
   self.body:setAngularDamping(Constants.turn_deceleration)

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

function instance.distance_to_player(self, player)
   return utils.distance(self.body:getX(), self.body:getY(),
                         player.body:getX(), player.body:getY())
end

function instance.angle_to_player(self, player)
   return utils.angle_to(self.body:getX(), self.body:getY(),
                         player.body:getX(), player.body:getY())
end

function seek_player(self, player)
   if self:distance_to_player(player) <= 500 then
      local ta = self:angle_to_player(player) - math.pi / 2
      local a = self.body:getAngle()
      local ccw = (a - ta) % (math.pi * 2)
      local cw = (math.pi * 2) - ccw

      if cw < math.pi / 12 or ccw < math.pi / 36 then
         self.body:setAngularVelocity(0)
      elseif cw < ccw then
         self.body:applyTorque(Constants.turn_speed)
      else
         self.body:applyTorque(-Constants.turn_speed)
      end
   end
end