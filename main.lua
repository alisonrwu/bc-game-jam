require "modules/30log-global"
require "src/utilities/Graphics"
require "src/utilities/Math"
require "src/utilities/Scale"
require "src/utilities/Sound"
require "src/utilities/UnitTests"

require "src/mix-ins/Orientation"

require "src/components/Point"
require "src/components/Dimensions"
require "src/components/Bounds"
require "src/components/Button"
require "src/components/Line"
require "src/components/Placeable"

require "src/states/State"
require "src/states/Game"

require "src/states/game/Combo"
require "src/states/game/Cursor"
require "src/states/game/Polygon"
require "src/states/game/PopUp"
require "src/states/game/Rating"
require "src/states/game/Speech"
require "src/states/game/Timer"
require "src/states/game/Level"

require "src/states/game/problems/Shape"
require "src/states/game/problems/Rectangle"

require "src/states/GameOver"
require "src/states/Instructions"
require "src/states/MainMenu"

-- Later:
-- optimize by using locals for all utilities
-- optimize by using local for 30log

function love.load(arg)
  --if arg[#arg] == "-debug" then require("mobdebug").start() end
  -- io.stdout:setvbuf("no")
  icon = love.image.newImageData("assets/graphics/icon.png")
  love.window.setIcon(icon)	
  font = love.graphics.newImageFont("assets/graphics/font.png",
  " abcdefghijklmnopqrstuvwxyz" ..
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
  "123456789.,!?-+/():;%&`'*#=[]\"")
  love.graphics.setFont(font)  
  love.graphics.setLineWidth(3)
  baseRes = Dimensions(853, 480) -- the original resolution of the game, before scaling
  state = Game()
  --runAllTests()
end  

function love.update(dt)
  state:update(dt)
end

function love.draw()
  Scale:draw()
  state:draw()
end 

function love.mousepressed(x, y, button, istouch)    
  state:mousePressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch) 
  state:mouseRelease(x, y, button, istouch)
end

function love.keypressed(key, u)
  if key == "rctrl" then
    debug.debug()
  end
  
  if key == "escape" then
    love.event.push('quit')
  end   
end
 

