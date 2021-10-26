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

  paddle1 = Paddle(5, 20, 5, 20)
  paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
  ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

  gameState = 'start'
end

--[[
  Runs every frame, with the 'dt' passed in, our delta in seconds
  since the last frame, which LÖVE supplies us.
]]
function love.update(dt)

  paddle1:update(dt)
  paddle2:update(dt)

  -- player 1 movement
  if love.keyboard.isDown('w') then

    -- add negitive paddle speed to curent Y scaled by deltaTime
    -- now, we clamp our position between the bounds of the screen
    -- math.max returns the greater of two values; 0 and player Y
    -- wil ensure we don't go above it
    paddle1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('s') then

    -- add positive speed to current Y scaled by deltaTime
    -- math.min returns the lesser of two values; bottom of the edge minius paddle height
    -- and player Y will ensure we don't go below it
    paddle1.dy = PADDLE_SPEED
  else
    paddle1.dy = 0
  end

  -- player 2 movment
  if love.keyboard.isDown('up') then

    paddle2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown('down') then

    -- add positive paddle speed to current Y scaled by deltaTime
    paddle2.dy = PADDLE_SPEED
  else
    paddle2.dy = 0
  end

  if gameState == 'play' then
    ball:update(dt)
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
      ball:reset()
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

  -- render first paddle(left side)
  paddle1:render()
  paddle2:render()

  ball:render()

  -- end rendering at virtual resolution
  push:apply('end')
end
 
