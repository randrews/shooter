module('editor', package.seeall)

function new_wall_tool(self, x, y)
   local obstacle = {}
   obstacle.body = love.physics.newBody(world, x, y, 0, 0)
   obstacle.shape = love.physics.newCircleShape(obstacle.body, 0, 0, 200)

   table.insert(objects.walls, obstacle)
end