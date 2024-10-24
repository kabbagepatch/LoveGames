Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
local PIPE_SCROLL = -60
PIPE_GAP = 70

function Pipe:init()
  self.x = VIRTUAL_WIDTH
  self.y = math.random(VIRTUAL_HEIGHT / 3, VIRTUAL_HEIGHT - 30)
  self.width = PIPE_IMAGE:getWidth() / 2
end

function Pipe:update(dt)
  self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
  love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y), 0, 0.5, 1)
  love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y) - PIPE_GAP, 0, 0.5, -1)
end