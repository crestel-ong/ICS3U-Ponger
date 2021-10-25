WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

--[[
    Runs when the game first starts up, only once; used to initilize the game.
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
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
    push:apply('start')

    love.graphics.printf(
      "Hello, Pong!",           -- text to render
       0,                       -- starting X (0 since we're going to center it based on width)
       VIRTUAL_HEIGHT / 2 - 6,   -- starting Y (halfway down the screen)
       VIRTUAL_WIDTH,            -- number of pixels to center within (the entire screen here)
       'center')                -- alignment mode, can be 'center', 'left', or 'right'

    push:apply('end')
end
