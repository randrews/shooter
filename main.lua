require 'Constants'
require 'setup'
require 'update'
require 'drawing'
require 'input'
require 'tool'
require 'editor'
require 'utils'

Categories = {
   edge = 1,
   wall = 2,
   player = 3,
   bullet = 4
}

Images = {
   dirt = love.graphics.newImage('dirt.png'),
   rock = love.graphics.newImage('rock.png'),
   icons = love.graphics.newImage('icons.png')
}

Icons = {
   new = love.graphics.newQuad(0,0, 64,64, 256,256),
   move = love.graphics.newQuad(64,0, 64,64, 256,256),
   resize = love.graphics.newQuad(192,0, 64,64, 256,256),
   save = love.graphics.newQuad(192,0, 64,64, 256,256) -- Not done yet
}

Tools = {
   new = tool.new{icon=Icons.new,
                  use=editor.new_wall_tool},

   move = tool.new{icon=Icons.move,
                   use=editor.move_wall_tool},

   resize = tool.new{icon=Icons.resize,
                     use=editor.resize_wall_tool}
}

utils.center_tools(Tools.new, Tools.move, Tools.resize)

Images.dirt:setWrap('repeat', 'repeat')
ground = love.graphics.newQuad(0, 0, 5000, 5000, 200, 200)
rock = love.graphics.newQuad(0, 0, 118, 118, 118, 118)

GameState = {
   paused = false,
   bullet_timer = 0, -- Number of secs until gun can shoot again
   current_wall = nil -- Currently-highlighted wall
}