require 'utils'

module('editor', package.seeall)

function new_wall_tool(self, x, y, mouse)
   if not mouse.click then return end
   local obstacle = {}
   obstacle.body = love.physics.newBody(world, x, y, 0, 0)
   obstacle.shape = love.physics.newCircleShape(obstacle.body, 0, 0, 200)

   table.insert(objects.walls, obstacle)
end

local start_x, start_y = nil, nil
local wall_start_x, wall_start_y = nil, nil

function move_wall_tool(self, x, y, mouse)
   if not GameState.current_wall then return end

   if mouse.click then
      start_x = x ; start_y = y
      wall_start_x = GameState.current_wall.body:getX()
      wall_start_y = GameState.current_wall.body:getY()
   else
      local dx, dy = x - start_x, y-start_y
      GameState.current_wall.body:setX(wall_start_x + dx)
      GameState.current_wall.body:setY(wall_start_y + dy)
   end
end

function resize_wall_tool(self, x, y, mouse)
   if not GameState.current_wall then return end

   local s = GameState.current_wall.shape
   local b = GameState.current_wall.body
   local rad = s:getRadius()

   rad = utils.distance(x,y,b:getX(),b:getY()) * 2

   if rad > 500 then
      rad = 500
   elseif rad < 10 then
      rad = 10
   end

   s:destroy()
   GameState.current_wall.shape =
      love.physics.newCircleShape(GameState.current_wall.body, 0, 0, rad)
end