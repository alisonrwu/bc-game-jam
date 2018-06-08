require "SoundManager"
require "StartState"
require "InstructionState"
require "GameState"
require "GameOverState"
require "Graphics"
require "Utilities"
scaleinator = require("scaleinator").create()

function love.load(arg)
  --if arg[#arg] == "-debug" then require("mobdebug").start() end
  loadScaling()
  loadImages()
  loadGraphics()
  setState(GameState)
end  

function love.update(dt)
  state:update(dt)
end

function love.draw()
  --love.graphics.translate(translationX, translationY)
  --love.graphics.scale(scaleX, scaleY)
  state:draw()
end    

function loadScaling()
  scaleinator:newmode("16:9", 853, 480)
	scaleinator:update(love.graphics.getWidth(), love.graphics.getHeight())
  scaleX = scaleinator:getFactor() 
  scaleY = scaleX -- scaleX == scaleY because we can't scale greater than the limiting dimension
  translationX, translationY = scaleinator:getTranslation() -- after scaling, x and y required to center screen
end

function loadImages()
  icon = love.image.newImageData("Graphics/UI/Icon.png")
  menuBG = love.graphics.newImage("Graphics/Menu/Background/Background16x9.png")
  combo = love.graphics.newImage("Graphics/UI/combo.png") 
  BG = love.graphics.newImage("Graphics/UI/Background/Background16x9.png")
  scale = love.graphics.newImage("Graphics/UI/Scale.png")
  speechBubble = love.graphics.newImage("Graphics/UI/TextBubble.png")
end

function loadGraphics()
  love.window.setIcon(icon)	
  love.graphics.setLineWidth(3)
  width = love.graphics.getWidth()
	height = love.graphics.getHeight()
  font = love.graphics.newImageFont("Graphics/UI/Imagefont.png",
	" abcdefghijklmnopqrstuvwxyz" ..
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
  "123456789.,!?-+/():;%&`'*#=[]\"")
  love.graphics.setFont(font)    
end    

function setState(s)
  state = s
  state:load()
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
  
  if key == "lctrl" then
    setState(StartState)
  end    
  
  if key == "t" then
    targetUpCounter = targetUpCounter + 1
  end
  
  if key == "escape" then
    love.event.push('quit')
  end   
end
 

