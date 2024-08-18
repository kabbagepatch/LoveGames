Pillar = Class{}

function Pillar:init(x, y1, y2)
  self.x = x
  self.y1 = y1
  self.y2 = y2
  self.dX = -20
  self.w = 30
end

function Pillar:update(dT)
  if self.x + self.w < 0 then
    self.x = VIRTUAL_WIDTH
  else
    self.x = self.x + self.dX * dT
  end
end

function Pillar:render()
  love.graphics.rectangle('fill', self.x, 0, self.w, self.y1)
  love.graphics.rectangle('fill', self.x, self.y2, self.w, VIRTUAL_HEIGHT - self.y2)
end
