require "TEsound"
require "SoundManager"

require "StartState"
require "InstructionState"
require "GameState"
require "GameOverState"

require "Graphics"

function love.load()
  loadImages()
  loadGraphics()
  setState(GameState)
end  

function love.update(dt)
  state:update(dt)
end

function love.draw()
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
  
  if key == "lctrl" then
    setState(StartState)
  end    
  
  if key == "escape" then
    love.event.push('quit')
  end   
end

function loadImages()
  icon = love.graphics.newImage("Graphics/UI/Icon.png")
  menuBG = love.graphics.newImage("Graphics/Menu/Background.png")
  combo = love.graphics.newImage("Graphics/UI/combo.png") 
  BG = love.graphics.newImage("Graphics/UI/Background.png")
  scale = love.graphics.newImage("Graphics/UI/Scale.png")
  speechBubble = love.graphics.newImage("Graphics/UI/TextBubble.png")
end

function loadGraphics()
  love.window.setIcon(icon:getData())	
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setPointSize(5)
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

