require 'src/Dependencies'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  math.randomseed(os.time())
  love.window.setTitle('Breakout')

  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
  }
  love.graphics.setFont(gFonts['small'])

  gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['main'] = love.graphics.newImage('graphics/breakout.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png')
  }

  gFrames = {
    ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
    ['balls'] = GenerateQuadsBalls(gTextures['main']),
    ['bricks'] = GenerateQuadsBricks(gTextures['main']),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
  }

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  gSounds = {
    ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
    ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
    ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
    ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
    ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
  }

  gStateMachine = StateMachine {
    ['start'] = function() return StartState() end,
    ['serve'] = function() return ServeState() end,
    ['play'] = function() return PlayState() end,
    ['gameover'] = function() return GameOverState() end,
    ['highscores'] = function() return HighScoresState() end,
    ['enterhighscore'] = function() return EnterHighScoreState() end
  }
  gStateMachine:change('start', { highScores = loadHighScores() })

  gSounds['music']:play()
  gSounds['music']:setLooping(true)

  love.keyboard.keysPressed = {}
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  gStateMachine:update(dt)
  love.keyboard.keysPressed = {}
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key] or false
end

function love.draw()
  push:apply('start')

  local backgroundWidth = gTextures['background']:getWidth()
  local backgroundHeight = gTextures['background']:getHeight()

  love.graphics.draw(gTextures['background'], 0, 0, 0, VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

  gStateMachine:render()

  displayFPS()

  push:apply('end')
end

function renderLevel(level)
  love.graphics.setFont(gFonts['small'])
  love.graphics.print('Level ', VIRTUAL_WIDTH / 2 - 14, 5)
  love.graphics.print(tostring(level), VIRTUAL_WIDTH / 2 + 10, 5)
end

function renderHealth(health)
  local healthX = VIRTUAL_WIDTH - 100
  for i = 1, health do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
    healthX = healthX + 11
  end
  for i = 1, 3 - health do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
    healthX = healthX + 11
  end
end

function renderScore(score)
  love.graphics.setFont(gFonts['small'])
  love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
  love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

function displayFPS()
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end

function loadHighScores()
  love.filesystem.setIdentity('breakout')
  if not love.filesystem.getInfo('breakout.lst') then
    local scores = ''
    for i = 10, 1, -1 do
      scores = scores .. '---\n'
      scores = scores .. tostring(0) .. '\n'
    end

    love.filesystem.write('breakout.lst', scores)
  end

  local name = true
  local curName = nil
  local counter = 1
  local scores = {}
  
  for i = 1, 10 do
    scores[i] = {name = nil, score = nil}
  end

  for line in love.filesystem.lines('breakout.lst') do
    if name then
      scores[counter].name = string.sub(line, 1, 3)
    else
      scores[counter].score = tonumber(line)
      counter = counter + 1
    end
    name = not name
  end

  return scores
end
