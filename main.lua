require "TEsound"
require "Instructions"
require "Graphics"
require "Fade"
require "Start"
require "Game"
require "UI"
require "Math"
require "GameOver"
require "Scissors"

ScoreManager = require "ScoreManager"

    
function love.load()
    loadImages()
    loadGraphics()
    Start:load()
    Instructions:load()
    Game:load()
    GameOver:load()

    setState(Game)
        
	TEsound.play("Sounds/Music/Paper Cut Title.ogg", "menuTheme")
	TEsound.volume("menuTheme", 0.8)
	music = false
    canPlaySound = false
end

function loadImages()
    icon = love.graphics.newImage("Graphics/UI/Icon.png")
    menuBG = love.graphics.newImage("Graphics/Menu/Background.png")
    BG = love.graphics.newImage("Graphics/UI/Background.png")
    scale = love.graphics.newImage("Graphics/UI/Scale.png")
	textBubble = love.graphics.newImage("Graphics/UI/TextBubble.png")
  	combo = love.graphics.newImage("Graphics/UI/combo.png") 
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
end    

function love.update(dt)
    state:update(dt)
    Fade:update(dt)
end

function love.draw()
    state:draw()
    Fade:draw()
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
        setState(Start)
    end    
    
   if key == "escape" then
        love.event.push('quit')
    end   
end