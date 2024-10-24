push = require 'push'
Class = require 'class'

require 'bee'
require 'pipe'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/CountdownState'
require 'states/TitleState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 413
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0
GROUND_SCROLL_SPEED = 60

scrolling = true

function love.load()
  love.window.setTitle('Bumble Bee')
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.keyboard.keysPressed = {}
  pipeSpawnTimer = 2
  math.randomseed(os.time())

  smallFont = love.graphics.newFont('font.ttf', 8)
  mediumFont = love.graphics.newFont('bumble.ttf', 14)
  bumbleFont = love.graphics.newFont('bumble.ttf', 28)
  hugeFont = love.graphics.newFont('bumble.ttf', 56)
  love.graphics.setFont(bumbleFont)

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  sounds = {
    ['dead'] = love.audio.newSource('sounds/dead.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['count'] = love.audio.newSource('sounds/count.wav', 'static')
  }

  gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['countdown'] = function() return CountdownState() end,
    ['play'] = function() return PlayState() end,
  }
  gStateMachine:change('title')
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
  
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'r' or key == 'R' then
    gStateMachine:change('countdown')
    scrolling = true
  end
end

function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
      return true
  else
      return false
  end
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  if scrolling then
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    
    gStateMachine:update(dt)
  end

  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()

  love.graphics.draw(background, -backgroundScroll, 0)
  love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

  gStateMachine:render()

  push:finish()
end
