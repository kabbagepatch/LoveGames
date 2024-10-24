TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('countdown')
  end
end

function TitleScreenState:render()
  love.graphics.setFont(bumbleFont)
  love.graphics.printf('Bumble Bee', 0, 64, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(mediumFont)
  love.graphics.printf('Press Enter to Start', 0, 100, VIRTUAL_WIDTH, 'center')
  love.graphics.printf('Press Space to Jump', 0, 130, VIRTUAL_WIDTH, 'center')
end
