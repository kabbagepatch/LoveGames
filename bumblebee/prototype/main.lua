push = require 'push'
Class = require 'class'

require 'Bee'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

BALL_SIZE = 16

function love.load()
  love.window.setTitle('Bumble Bee')
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.keyboard.keysPressed = {}

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = false,
    vsync = true
  })

  bee = Bee((VIRTUAL_WIDTH - BALL_SIZE) / 2, (VIRTUAL_HEIGHT - BALL_SIZE) / 2, BALL_SIZE, BALL_SIZE)
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
  
  if key == 'escape' then
      love.event.quit()
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
  bee:update(dT)

  love.keyboard.keysPressed = {}
end

function love.draw()
  push:apply('start')
  love.graphics.clear(40/255, 45/255, 52/255, 255/255)

  bee:render()

  push:apply('end')
end