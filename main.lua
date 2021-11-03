Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

--[[
   Runs when the game first starts up, only once; used to initilize the game.
]]
function love.load()
  math.randomseed(os.time())

  -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
  -- and graphics; try removing this function to see the diffrence
  love.graphics.setDefaultFilter('nearest', 'nearest')

  love.window.setTitle('pong')

  -- more "retro-looking" font object we can use for any text
  smallFont = love.graphics.newFont('font.ttf', 8)

  scoreFont = love.graphics.newFont('font.ttf', 32)

  victoryFont = love.graphics.newFont('font.ttf', 24)

  sounds = {
    ['paddle_hit'] = love.audio.newSource('paddle_hit.wav', 'static'),
    ['point_scored'] = love.audio.newSource('point_scored.wav', 'static'),
    ['wall_hit'] = love.audio.newSource('wall_hit.wav', 'static')
  }

  -- initilize our virtual resolution, which will be rendered within our
  -- actual window no matter its dementions; replaces our love.window.setMode call
  -- from the last example
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    vsync = true,
    resizable = false
   })

  -- initilize score variables, used for rendering on the screen and keeping
  -- track of the winner
  player1Score = 0
  player2Score = 0

  servingPlayer = math.random(2) == 1 and 1 or 2

  winningPlayer = 0

  player1 = Paddle(10, 30, 5, 20)
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  if servingPlayer == 1 then
    ball.dx = 100
  else
    ball.dx = -100
  end


  gameState = 'start'
end

--[[
  Runs every frame, with the 'dt' passed in, our delta in seconds
  since the last frame, which LÃ–VE supplies us.
]]
function love.update(dt)
  if gameState == 'play' then

    if ball.x <= 0 then
      player2Score = player2Score + 1
      servingPlayer = 1
      sounds['point_scored']:play()
      ball:reset()
      ball.dx = 100

      if player2Score >= 10 then
        gameState = 'victory'
        winningPlayer = 2
      else
        gameState = 'serve'
      end
    end

    if ball.x >= VIRTUAL_WIDTH - 4 then
      player1Score = player1Score + 1
      servingPlayer = 2
      sounds['point_scored']:play()
      ball:reset()
      ball.dx = -100
      
      if player1Score >= 10 then
        gameState = 'victory'
        winningPlayer = 1
      else
        gameState = 'serve'
      end
    end

    if ball:collides(player1) then
      -- deflect ball to the right
      ball.dx = -ball.dx

      sounds['paddle_hit']:play()
    end

    if ball:collides(player2) then
      -- deflect ball to the left
      ball.dx = -ball.dx
      sounds['paddle_hit']:play()
    end

    if ball.y <= 0 then
      -- deflect the ball down
      ball.dy = -ball.dy
      ball.y = 0
      sounds['wall_hit']:play()
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.dy = -ball.dy
      ball.y = VIRTUAL_HEIGHT - 4
      sounds['wall_hit']:play()
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then

      -- add negitive paddle speed to curent Y scaled by deltaTime
      -- now, we clamp our position between the bounds of the screen
      -- math.max returns the greater of two values; 0 and player Y
      -- wil ensure we don't go above it
      player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then

      -- add positive speed to current Y scaled by deltaTime
      -- math.min returns the lesser of two values; bottom of the edge minius paddle height
      -- and player Y will ensure we don't go below it
      player1.dy = PADDLE_SPEED
    else
      player1.dy = 0
    end

    -- player 2 movment
    if love.keyboard.isDown('up') then

      player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then

      -- add positive paddle speed to current Y scaled by deltaTime
      player2.dy = PADDLE_SPEED
    else
      player2.dy = 0
    end

    if gameState == 'play' then
      ball:update(dt)
    end
    player1:update(dt)
    player2:update(dt)
  end
end


--[[
   Keyboard handling, called by LÃ–VE each frame;
   passes in the key we pressed so we can access.
]]
function love.keypressed(key)

  -- key can be accessed by string name
  if key == 'escape' then

    -- function  LÖVE gives us the terminate application
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'serve'
    elseif gameState == 'victory' then
      gameState = 'start'
      player1Score = 0
      player2Score = 0
    elseif gameState == 'serve' then
      gameState = 'play'
    end
  end
end

--[[
   Called after update by  LÖVE, used to draw anything to the screen, updated or ortherwise.
]]
function love.draw()

  -- begin rendering at virtual resolution
  push:apply('start')

  -- clear the screen with a specific colour; in this case, a colour similar
  -- to some versions of the original pong
  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

  -- condensed onto one line from last example
  -- note we are now using virtual width and height now for text placement
  love.graphics.setFont(smallFont)

  if gameState == 'start' then
    love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Play!", 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'serve' then
    love.graphics.setFont(smallFont)
    love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Enter to Serve!", 0, 20, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'victory' then
    -- draw a victory message
    love.graphics.setFont(victoryFont)
    love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf("Press Enter to Serve!", 0, 42, VIRTUAL_WIDTH, 'center')
  elseif gameState == 'play' then
    -- no message to display in play
  end

  -- draw score on the left and right center of the screen
  -- need to switch font to draw before actually printing
  love.graphics.setFont(scoreFont)
  love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

  displayScore()
  -- render first paddle(left side)
  player1:render()
  player2:render()

  -- render ball using it's class's render method
  ball:render()

  displayFPS()

  -- end rendering at virtual resolution
  push:apply('end')
end

function displayFPS()
  love.graphics.setColor(0, 1, 0, 1)
  love.graphics.setFont(smallFont)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20)
  love.graphics.setColor(1, 1, 1, 1)
end

function displayScore()
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end
