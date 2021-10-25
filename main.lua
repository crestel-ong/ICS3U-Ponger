WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

push = require 'push'

--[[
   Runs when the game first starts up, only once; used to initilize the game.
]]
function love.load()
  math.randomseed(os.time())

  -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
  -- and graphics; try removing this function to see the diffrence
  love.graphics.setDefaultFilter('nearest', 'nearest')

  -- more "retro-looking" font object we can use for any text
  smallFont = love.graphics.newFont('font.ttf', 8)

  scoreFont = love.graphics.newFont('font.ttf', 32)

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

  -- paddle positions on the Y axis (they can only move up or down)
  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50

  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  ballDX = math.random(2) == 1 and -100 or 100
  ballDY = math.random(-50, 50)

  gameState = 'start'
end

--[[
  Runs every frame, with the 'dt' passed in, our delta in seconds
  since the last frame, which LÖVE supplies us.
]]
function love.update(dt)

  -- player 1 movement
  if love.keyboard.isDown('w') then

    -- add negitive paddle speed to curent Y scaled by deltaTime
    player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('s') then

    -- add positive speed to current Y scaled by deltaTime
    player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
  end

  -- player 2 movment
  if love.keyboard.isDown('up') then

    -- add negitive paddle speed to current Y scaled by deltaTime
    player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
  elseif love.keyboard.isDown('down') then

    -- add positive paddle speed to current Y scaled by deltaTime
    player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
  end

  if gameState == 'play' then
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt
  end
end

--[[
   Keyboard handling, called by LÖVE each frame;
   passes in the key we pressed so we can access.
]]
function love.keypressed(key)

  -- key can be accessed by string name
  if key == 'escape' then

    -- function LÖVE gives us the terminate application
    love.event.quit()
  elseif key == 'enter' or key == 'return' then
    if gameState == 'start' then
      gameState = 'play'
    elseif gameState == 'play' then
      gameState = 'start'

      ballX = VIRTUAL_WIDTH / 2 - 2
      ballY = VIRTUAL_HEIGHT / 2 - 2

      ballDX = math.random(2) == 1 and -100 or 100
      ballDY = math.random(-50, 50)
    end
  end
end
--[[
   Called after update by LÖVE, used to draw anything to the screen, updated or ortherwise.
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
    love.graphics.printf(
      "Hello Start State!",           -- text to render
      0,                       -- starting X (0 since we're going to center it based on width)
      20,
      VIRTUAL_WIDTH,            -- number of pixels to center within (the entire screen here)
      'center')                -- alignment mode, can be 'center', 'left', or 'right'
  elseif gameState == 'play' then
    love.graphics.printf("Hello Play State!", 0, 20, VIRTUAL_WIDTH, 'center')
  end

  -- draw score on the left and right center of the screen
  -- need to switch font to draw before actually printing
  love.graphics.setFont(scoreFont)
  love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
  love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

  -- render ball (center)
  love.graphics.rectangle('fill',  ballX, ballY, 4, 4)

  -- render first paddle(left side)
  love.graphics.rectangle('fill', 10, player1Y, 5, 20)

  -- render second paddle(right side)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

  -- end rendering at virtual resolution
  push:apply('end')
end
