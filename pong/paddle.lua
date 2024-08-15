Paddle = Class{}

function Paddle:init(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.dY = 0
end

function Paddle:update(dT)
  if self.dY < 0 then
    self.y = math.max(0, self.y + self.dY * dT)
  else
    self.y = math.min(VIRTUAL_HEIGHT - self.h, self.y + self.dY * dT)
  end
end

function Paddle:render()
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end
