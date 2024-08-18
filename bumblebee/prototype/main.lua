push = require 'push'
Class = require 'class'

require 'Bee'
require 'Pillar'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

BALL_SIZE = 16

function love.load()
  love.window.setTitle('Bumble Bee')
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.keyboard.keysPressed = {}

  largeFont = love.graphics.newFont('font.ttf', 16)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  gameState = "start"

  pillar1 = Pillar(300, 100, 150)
  pillar2 = Pillar(370, 70, 130)
  pillar3 = Pillar(440, 90, 150)
  pillar4 = Pillar(510, 120, 170)
  pillar5 = Pillar(580, 50, 120)
  pillar6 = Pillar(650, 160, 220)
  bee = Bee((VIRTUAL_WIDTH - BALL_SIZE) / 2, (VIRTUAL_HEIGHT - BALL_SIZE) / 2, BALL_SIZE, BALL_SIZE)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
  
  if key == 'escape' then
    love.event.quit()
  elseif key == "enter" or key == 'return' then
    gameState = "play"
  end
end

function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
      return true
  else
      return false
  end
end

function love.update(dT)
  if gameState == "play" then
    bee:update(dT)
    pillar1:update(dT)
    pillar2:update(dT)
    pillar3:update(dT)
    pillar4:update(dT)
    pillar5:update(dT)
    pillar6:update(dT)
  end

  if bee:collidesWith(pillar3) then
    gameState = "end"
  end

  love.keyboard.keysPressed = {}
end

function love.draw()
  push:apply('start')
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  bee:render()

  love.graphics.setColor(0, 255/255, 0, 255/255)
  pillar1:render()
  pillar2:render()
  pillar3:render()
  pillar4:render()
  pillar5:render()
  pillar6:render()

  if gameState == 'end' then
    love.graphics.setColor(255/255, 0, 0, 255/255)
    love.graphics.setFont(largeFont)
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
  end

  push:apply('end')
end