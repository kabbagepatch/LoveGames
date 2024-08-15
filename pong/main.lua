push = require 'push'
Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

P1_UP_KEY = 'w'
P1_DOWN_KEY = 's'
P2_UP_KEY = 'up'
P2_DOWN_KEY = 'down'

PADDLE_SPEED = 200
PADDLE_HEIGHT = 20
BALL_SIZE = 4

function backToStart()
  gameState = 'start'
  ball:reset()
  nTurns = nTurns + 1
  paddle1.y = 20
  paddle2.y = VIRTUAL_HEIGHT - 30
end

function resetGame()
  nTurns = 0
  p1Score = 0
  p2Score = 0
  backToStart()
end

function love.load()
  math.randomseed(os.time())

  love.window.setTitle('Pong')
  love.graphics.setDefaultFilter('nearest', 'nearest')

  smallFont = love.graphics.newFont('font.ttf', 8)
  largeFont = love.graphics.newFont('font.ttf', 16)
  scoreFont = love.graphics.newFont('font.ttf', 32)
  love.graphics.setFont(smallFont)

  sounds = {
    ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
  }

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  paddle1 = Paddle(5, 30, 5, PADDLE_HEIGHT)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, PADDLE_HEIGHT)
  ball = Ball((VIRTUAL_WIDTH - BALL_SIZE) / 2, (VIRTUAL_HEIGHT - BALL_SIZE) / 2, BALL_SIZE, BALL_SIZE)

  resetGame()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    elseif gameState == 'end' then
      resetGame()
    end
  end
end

function love.update(dT)
  if gameState == 'play' then
    if love.keyboard.isDown(P1_UP_KEY) then
      paddle1.dY = -PADDLE_SPEED
    elseif love.keyboard.isDown(P1_DOWN_KEY) then
      paddle1.dY = PADDLE_SPEED
    else
      paddle1.dY = 0
    end

    if love.keyboard.isDown(P2_UP_KEY) then
      paddle2.dY = -PADDLE_SPEED
    elseif love.keyboard.isDown(P2_DOWN_KEY) then
      paddle2.dY = PADDLE_SPEED
    else
      paddle2.dY = 0
    end

    paddle1:update(dT)
    paddle2:update(dT)

    if ball:collidesWith(paddle1) then
      ball.dX = -ball.dX * 1.1
      ball.x = paddle1.x + 5
      if ball.dY < 0 then
        ball.dY = -math.random(10, 150)
      else
        ball.dY = math.random(10, 150)
      end
      sounds['paddle_hit']:play()
    end

    if ball:collidesWith(paddle2) then
      ball.dX = -ball.dX * 1.1
      ball.x = paddle2.x - 5
      if ball.dY < 0 then
        ball.dY = -math.random(10, 150)
      else
        ball.dY = math.random(10, 150)
      end
      sounds['paddle_hit']:play()
    end

    ball:update(dT)

    if ball.x <= 0 then
      backToStart()
      p2Score = p2Score + 1
      sounds['score']:play()
    elseif ball.x >= VIRTUAL_WIDTH - BALL_SIZE then
      backToStart()
      p1Score = p1Score + 1
      sounds['score']:play()
    end

    if ball.y <= 0 then
      ball.y = 0
      ball.dY = -ball.dY
      sounds['wall_hit']:play()
    elseif ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.y = VIRTUAL_HEIGHT - 4
      ball.dY = -ball.dY
      sounds['wall_hit']:play()
    end

    if p1Score == 10 or p2Score == 10 then
      gameState = 'end'
    end
  end
end

function love.draw()
  push:apply('start')

  love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  if gameState == 'start' or gameState == 'end' then
    love.graphics.setFont(smallFont)
    love.graphics.printf('Flow is Goofy', 0, 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to Play', 0, 40, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(p1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(p2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
  end

  if gameState == 'end' then
    love.graphics.setFont(largeFont)
    if p1Score == 10 then
      love.graphics.printf('Player 1 wins', 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')
    else
      love.graphics.printf('Player 2 wins', 0, VIRTUAL_HEIGHT / 2 + 20, VIRTUAL_WIDTH, 'center')
    end
  end

  paddle1:render()
  paddle2:render()
  ball:render()

  if gameState == 'start' or gameState == 'end' then
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 5)
  end

  push:apply('end')
end
