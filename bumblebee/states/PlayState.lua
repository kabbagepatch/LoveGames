PlayState = Class{__includes = BaseState}

function PlayState:init()
  self.bee = Bee()
  self.pipes = {Pipe()}
  self.pipeSpawnTimer = 0
  self.score = 0
  self.gameOver = false
end

function PlayState:update(dt)
  self.pipeSpawnTimer = self.pipeSpawnTimer + dt
  if self.pipeSpawnTimer > 2 then
    table.insert(self.pipes, Pipe())
    self.pipeSpawnTimer = 0
  end
  
  self.bee:update(dt)

  for k, pipe in pairs(self.pipes) do
    pipe:update(dt)

    if self.bee:collides(pipe) then
      scrolling = false
      self.gameOver = true
      sounds['dead']:play()
    end

    if not pipe.marked and (pipe.x + pipe.width) < self.bee.x then
      pipe.marked = true
      self.score = self.score + 1
      sounds['score']:play()

      GROUND_SCROLL_SPEED = GROUND_SCROLL_SPEED + (self.score / 3)
    end
  end


  for k, pipe in pairs(self.pipes) do
    if pipe.x < -pipe.width then
        table.remove(self.pipes, k)
    end
  end
end

function PlayState:render()
  self.bee:render()

  for k, pipe in pairs(self.pipes) do
    pipe:render()
  end

  if self.gameOver then
    love.graphics.setFont(bumbleFont)
    love.graphics.printf('Game Over', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 96, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press R to Restart', 0, 150, VIRTUAL_WIDTH, 'center')
  else
    love.graphics.setFont(mediumFont)
    love.graphics.print('Score: ' .. tostring(self.score), 10, 8)
    love.graphics.setFont(smallFont)
    love.graphics.print('Press Space to Jump', 10, 25)
    love.graphics.print('Press R to Restart', 10, 35)
  end
end
