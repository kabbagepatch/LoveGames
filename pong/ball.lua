Ball = Class{}

function Ball:init(x, y, w, h)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.dX = 0
  self.dY = 0
end

function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2
  self.dX = math.random(2) == 1 and -100 or 100
  self.dY = math.random(-50, 50) * 1.5
end

function Ball:collidesWith(paddle)
  if self.x > paddle.x + paddle.w or paddle.x > self.x + self.w then
    return false
  end

  if self.y > paddle.y + paddle.h or paddle.y > self.y + self.h then
    return false
  end

  return true
end

function Ball:update(dT)
  if self.dX < -400 then
    self.dX = -400
  elseif self.dX > 400 then
    self.dX = 400
  end

  self.x = self.x + self.dX * dT
  self.y = self.y + self.dY * dT
end

function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end
