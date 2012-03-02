module('editor', package.seeall)

function new_wall_tool(self, x, y, start)
   if not start then return end
   local obstacle = {}
   obstacle.body = love.physics.newBody(world, x, y, 0, 0)
   obstacle.shape = love.physics.newCircleShape(obstacle.body, 0, 0, 200)

   table.insert(objects.walls, obstacle)
end

local start_x, start_y = nil, nil
local wall_start_x, wall_start_y = nil, nil

function move_wall_tool(self, x, y, start)
   if not GameState.current_wall then return end

   if start then
      start_x = x ; start_y = y
      wall_start_x = GameState.current_wall.body:getX()
      wall_start_y = GameState.current_wall.body:getY()
   else
      local dx, dy = x - start_x, y-start_y
      GameState.current_wall.body:setX(wall_start_x + dx)
      GameState.current_wall.body:setY(wall_start_y + dy)
   end
end