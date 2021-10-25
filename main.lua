WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

--[[
    Runs when the game first starts up, only once; used to initilize the game.
]]
function love.load()

    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text
    -- and graphics; try removing this function to see the diffrence
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)
    love.graphics.setFont(smallFont)

    -- initilize our virtual resolution, which will be rendered within our
    -- actual window no matter its dementions; replaces our love.window.setMode call
    -- from the last example
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

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

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    love.graphics.rectangle('fill', 5, 20, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)

    -- condensed onto one line from last example
    -- note we are now using virtual width and height now for text placement
    love.graphics.printf(
      "Hello, Pong!",           -- text to render
       0,                       -- starting X (0 since we're going to center it based on width)
       20,
       VIRTUAL_WIDTH,            -- number of pixels to center within (the entire screen here)
       'center')                -- alignment mode, can be 'center', 'left', or 'right'

    -- end rendering at virtual resolution
    push:apply('end')
end
