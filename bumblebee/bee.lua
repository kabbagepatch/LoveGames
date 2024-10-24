Bee = Class{}

local GRAVITY = 1

function Bee:init()
  self.image = love.graphics.newImage('bee.png')
  self.width = self.image:getWidth() / 3
  self.height = self.image:getHeight() / 3

  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
  self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

  self.dy = 0
end

function Bee:collides(pipe)
  if (self.x + 4) + (self.width - 8) >= pipe.x and (self.x + 4) <= pipe.x + pipe.width then
    if (self.y + 4) + (self.height - 8) >= pipe.y or (self.y + 4) <= pipe.y - PIPE_GAP then
      return true
    end
  end

  return false
end

function Bee:update(dt)
  if love.keyboard.wasPressed('space') then
    self.dy = -0.3
    sounds['jump']:play()
  end

  self.dy = self.dy + GRAVITY * dt

  self.y = self.y + self.dy
  if self.y + self.height > VIRTUAL_HEIGHT - 12 then
    self.y = VIRTUAL_HEIGHT - self.height - 12
    self.dy = -0.15
    sounds['jump']:play()
  elseif self.y < 0 then
    self.y = 0
  end
end

function Bee:render()
  love.graphics.draw(self.image, self.x, self.y, -0.2, 0.33, 0.33)
end
