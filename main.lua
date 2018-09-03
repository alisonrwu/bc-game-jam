bitser = require "modules/bitser"
class = require "modules/middleclass"
require "src/mix-ins/Orientation"
require "src/mix-ins/Wait"
require "src/mix-ins/Observable"
require "src/mix-ins/Observer"

require "src/utilities/Graphics"
require "src/utilities/Math"
require "src/utilities/Sound"

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
require "src/components/PopUp"
require "src/states/game/Rating"
require "src/states/game/Speech"
require "src/states/game/Level"
require "src/states/game/Timer"
require "src/states/game/Grid"


require "src/states/game/problems/Shape"
require "src/states/game/problems/Rectangle"
require "src/states/game/problems/Oval"
require "src/states/game/problems/Triangle"
require "src/states/game/problems/Diamond"

require "src/states/GameOver"
require "src/states/Instructions"
require "src/states/MainMenu"

require "src/states/Shop"
require "src/states/shop/Effect"
require "src/states/shop/Item"

require "src/states/Details"

require "src/states/Achievements"
require "src/states/achievements/Achievement"

require "src/states/Options"

require "src/globals/User"
require "src/globals/Salary"
require "src/globals/HighScore"
require "src/globals/Scale"

require "scripts/load_effects"
require "scripts/load_items"
require "scripts/load_achievements"


function love.load(args)
  loadArgs(args)
  icon = love.image.newImageData("assets/graphics/icon.png")
  font = love.graphics.newImageFont("assets/graphics/font.png"," abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`'*#=[]\"")
  love.window.setIcon(icon)	
  love.graphics.setFont(font) 
  love.graphics.setLineWidth(3)
  baseRes = determineResolution()
  centre, rowHeight = Point(baseRes.width * 0.5, baseRes.height * 0.5), baseRes.height / 10
  scale = Scale(baseRes)
  effects = loadEffects()
  user = User()
  items = loadItems()
  salary = Salary()
  achievements = loadAchievements()
  highScore = HighScore()
  state = Game()
end  

function love.update(dt)
  state:update(dt)
  user:updatePopUps(dt)
end

function love.draw()
  scale:draw()
  state:draw()
  user:drawPopUps()
end 

function love.mousepressed(x, y, button, istouch)    
  state:mousePressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch) 
  state:mouseRelease(x, y, button, istouch)
end

function love.keypressed(key, u)
  if key == "b" then
    local achievement = user.achievements[1]
    achievement:addPopUp()
  end
  
  if key == "a" then
    state.level:addScore(10000)
  end
  
  if key == "rctrl" then
    salary:add(99000)
  end
  
  if key == "escape" then
    love.event.push('quit')
  end   
end

function loadArgs(args)
  for i = 1, #args do
    local arg = args[i]
    if arg == "debug" then
      require("mobdebug").start()
    elseif arg == "profile" then
      love.profiler = require('modules/profile') 
      love.profiler.hookall("Lua")
      love.profiler.start()
      love.graphics.setFont(love.graphics.newFont(12)) 
      love.frame = 0
      love.update = function(dt)
        state:update(dt)
        love.frame = love.frame + 1
        if love.frame%100 == 0 then
          love.report = love.profiler.report('time', 20)
          love.profiler.reset()
        end
      end
      love.draw = function()
        scale:draw()
        state:draw()
        Graphics:drawRect(0, 0, 640, 360, Graphics.BLACK)
        Graphics:drawText(love.report or "Please wait...", 0, 0, "left", Graphics.WHITE)
      end
    elseif arg == "printnow" then
      io.stdout:setvbuf("no")
    elseif arg == "perfectRectangle" then
      local perfectRectangle = require "PerfectRectangle"
      state.drawing.points = perfectRectangle
      state.mode = "score"
    elseif arg == "testDrawing" then
      local testDrawing = require "TestDrawing"
      state.drawing.points = testDrawing   
      state.mode = "score"
    elseif arg == "runTests" then
      require "src/utilities/UnitTests"
      runAllTests()
    end
  end
end

function determineResolution()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  local ratio = width / height
  local aspect = {}
  local _4x3 = {ratio = 4/3, resolution = {width = 640, height = 480, name = "4x3"}} -- 1.33
  local _3x2 = {ratio = 3/2, resolution = {width = 720, height = 480, name = "3x2"}} -- 1.5
  local _16x10 = {ratio = 16/10, resolution = {width = 768, height = 480, name = "16x10"}} -- -- 1.6
  local _5x3 = {ratio = 5/3, resolution = {width = 800, height = 480, name = "5x3"}} -- 1.67
  local _16x9 = {ratio = 16/9, resolution = {width = 640, height = 360, name = "16x9"}} -- 1.78
  local _2x1 = {ratio = 2/1, resolution = {width = 720, height = 360, name = "2x1"}} -- 2

  
  local aspects = {_4x3, _3x2, _16x10, _5x3, _16x9, _2x1}
  for i, curr in ipairs(aspects) do
    if ratio < curr.ratio then
      local smaller = aspects[i - 1]
      if smaller == nil then 
        aspect = curr
        break
      else
        local smallerDiff = ratio - smaller.ratio
        local currDiff = ratio - curr.ratio
        if math.abs(smallerDiff) < math.abs(currDiff) then aspect = smaller else aspect = curr end
        break
      end
    elseif ratio == curr.ratio then
      aspect = curr
      break
    end
  end
  if next(aspect) == nil then aspect = aspects[#aspects] end
  
  return aspect.resolution
end
 

