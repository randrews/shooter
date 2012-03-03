require 'Constants'

module('tool', package.seeall)

local instance = {class=tool,
                  selected = false,
                  icon=nil,
                  radius = 32,
                  x=Constants.screen_w/2,
                  y=Constants.screen_h-35,
                  use=function(self, world_x, world_y, start) end
               }

function new(tbl)
   return setmetatable(tbl or {}, {__index=instance})
end

function instance.hit(self, x, y)
   local dx, dy = x-self.x, y-self.y
   return (dx*dx+dy*dy) <= self.radius*self.radius
end

function instance.draw(self)
   local lg = love.graphics
   local r,g,b,a = lg.getColor()
   local lw = lg.getLineWidth()

   lg.setColor(90, 90, 90)
   lg.circle('fill', self.x, self.y, self.radius, 20)

   if self.selected then
      lg.setColor(220, 220, 90)
   else
      lg.setColor(120, 120, 120)
   end

   lg.setLineWidth(3)
   lg.circle('line', self.x, self.y, self.radius, 20)

   if self.icon then
      lg.setColor(255,255,255)
      lg.drawq(Images.icons, self.icon, self.x-32, self.y-32)
   end

   lg.setColor(r,g,b,a)
   lg.setLineWidth(lw)
end

function instance.click(self)
   self.selected = not self.selected
   if Tools then
      for _,t in pairs(Tools) do
         if t ~= self then t.selected = false end
      end
   end
end

function active_tool()
   if Tools then
      for _,t in pairs(Tools) do
         if t.selected then return t end
      end
   end
end

function hit_tool(x,y)
   if Tools then
      for _, t in pairs(Tools) do
         if t:hit(x,y) then return t end
      end
   end
end