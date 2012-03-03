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