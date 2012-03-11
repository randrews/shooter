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
                  wake_distance = 1000, -- Wake if the player is this close
                  max_distance = 225, -- Seeking will try to stay closer than this
                  min_distance = 175, -- And farther than this
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

function instance.turn_toward_player(self, player)
   local ta = self:angle_to_player(player) - math.pi / 2
   local a = self.body:getAngle()
   local ccw = (a - ta) % (math.pi * 2)
   local cw = (math.pi * 2) - ccw
   local thresh = math.pi / 180 -- one degree

   if cw < thresh or ccw < thresh then
      self.body:setAngularVelocity(0)
   elseif cw < ccw then
      self.body:applyTorque(Constants.turn_speed)
   else
      self.body:applyTorque(-Constants.turn_speed)
   end
end

function seek_player(self, player)
   local dist = self:distance_to_player(player)
   local accel = Constants.acceleration

   if dist <= self.wake_distance then
      self:turn_toward_player(player)
      if dist > self.max_distance then
         self.body:applyForce(math.cos(self.body:getAngle()) * accel,
                              math.sin(self.body:getAngle()) * accel)

         utils.limit_speed(self.body, Constants.max_speed)
      elseif dist < self.min_distance then
         self.body:applyForce(math.cos(self.body:getAngle()) * -accel,
                              math.sin(self.body:getAngle()) * -accel)

         utils.limit_speed(self.body, Constants.max_speed)
      else
         self.body:setLinearDamping(Constants.deceleration)
      end
   end
end
