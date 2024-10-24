CountdownState = Class{__includes = BaseState}

COUNTDOWN_TIME = 0.75

function CountdownState:init()
  self.count = 3
  self.timer = 0
  sounds['count']:play()
end

function CountdownState:update(dt)
  self.timer = self.timer + dt

  if self.timer > COUNTDOWN_TIME then
    self.timer = self.timer % COUNTDOWN_TIME
    self.count = self.count - 1
    sounds['count']:play()

    if self.count == 0 then
      gStateMachine:change('play')
    end
  end
end

function CountdownState:render()
  love.graphics.setFont(hugeFont)
  love.graphics.printf(tostring(self.count), 0, 50, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(mediumFont)
  love.graphics.printf('Press Space to Jump', 0, 130, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Press R to Restart', 0, 150, VIRTUAL_WIDTH, 'center')
end
