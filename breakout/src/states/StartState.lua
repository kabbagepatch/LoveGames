StartState = Class{__includes = BaseState}

local highlighted = START

function StartState:enter(params)
  self.highScores = params.highScores
end

function StartState:update(dt)
  if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
    highlighted = (highlighted + 1) % 2
    gSounds['paddle-hit']:play()
  end

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gSounds['confirm']:play()

    if highlighted == START then
      gStateMachine:change('serve', {
        paddle = Paddle(1),
        bricks = Level.createLevel(1),
        health = 3,
        score = 0,
        highScores = self.highScores,
        level = 1
      })
    else
      gStateMachine:change('highscores', {
        highScores = self.highScores
      })
    end
  end

  if love.keyboard.wasPressed('escape') then
      love.event.quit()
  end
end

function StartState:render()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
  
  love.graphics.setFont(gFonts['medium'])
  if highlighted == START then
    love.graphics.setColor(103/255, 1, 1, 1)
  end
  love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

  love.graphics.setColor(1, 1, 1, 1)

  if highlighted == HIGH_SCORE then
      love.graphics.setColor(103/255, 1, 1, 1)
  end
  love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')

  love.graphics.setColor(1, 1, 1, 1)
end
