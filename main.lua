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

    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
    -- and graphics; try removing this function to see the diffrence
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- more "retro-looking" font object we can use for any text
    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 40

    -- initilize our virtual resolution, which will be rendered within our
    -- actual window no matter its dementions; replaces our love.window.setMode call
    -- from the last example
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1Y = player1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then
        player2Y = player2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

--[[
    Keyboard handling, called by LÖVE each frame;
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
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
    love.graphics.printf(
      "Hello, Pong!",           -- text to render
       0,                       -- starting X (0 since we're going to center it based on width)
       20,
       VIRTUAL_WIDTH,            -- number of pixels to center within (the entire screen here)
       'center')                -- alignment mode, can be 'center', 'left', or 'right'

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

        -- render ball (center)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- render first paddle(left side)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- render second paddle(right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- end rendering at virtual resolution
    push:apply('end')
end
