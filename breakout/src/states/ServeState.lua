ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.score = params.score
  self.highScores = params.highScores
  self.level = params.level

  self.ball = Ball()
end

function ServeState:update(dt)
  self.paddle:update(dt)
  self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
  self.ball.y = self.paddle.y - 8

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
    gStateMachine:change('play', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      score = self.score,
      highScores = self.highScores,
      ball = self.ball,
      level = self.level
    })
  end

  if love.keyboard.wasPressed('r') then
    gStateMachine:change('start', { highScores = self.highScores })
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function ServeState:render()
  self.paddle:render()
  self.ball:render()

  for k, brick in pairs(self.bricks) do
    brick:render()
  end

  renderLevel(self.level)
  renderScore(self.score)
  renderHealth(self.health)

  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('Level ' .. tostring(self.level), 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Press Space or Enter to serve!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end
