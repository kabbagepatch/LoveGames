Bee = Class{}

local GRAVITY = 100

function Bee:init(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.dY = 0
end

function Bee:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2
end

function Bee:collidesWith(pillar)
  if self.x > pillar.x + pillar.w or pillar.x > self.x + self.w then
    return false
  end

  if self.y > pillar.y1 and self.y + self.h < pillar.y2 then
    return false
  end

  return true
end

function Bee:update(dT)
  if love.keyboard.wasPressed('space') then
      self.dY = -50
  end

  if self.y + self.h + self.dY * dT < VIRTUAL_HEIGHT then
    self.y = self.y + self.dY * dT
    self.dY = self.dY + GRAVITY * dT
  end
end

function Bee:render()
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end
