require "TEsound"
require "Instructions"
require "Graphics"
require "Fade"
require "Start"
require "Game"
require "UI"
require "Math"

ScoreManager = require "ScoreManager"
Scissors = require "Scissors"

currentScore = 0
scoreThreshold = 100
drawing = {}
player = {}
player.score = 0
toBeRemoved = {}
scoreTable = {}
icon = love.graphics.newImage("Graphics/UI/Icon.png")
	love.window.setIcon(icon:getData())	
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setPointSize( 5 )
	drawing = {}
	toBeRemoved = {}
	mouseX = 0
	mouseY = 0
    mouseDown = false
    mouseReleased = true
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	love.graphics.setLineWidth(3)
	angle = 0
	scale = love.graphics.newImage("Graphics/UI/Scale.png")
	textBubble = love.graphics.newImage("Graphics/UI/TextBubble.png")
	background = love.graphics.newImage("Graphics/UI/Background.png")
	menuBackground = love.graphics.newImage("Graphics/Menu/Background.png")
  	combo = love.graphics.newImage("Graphics/UI/combo.png")
	player = {}
	player.score = 0
	lastMouseX = 0
	lastMouseY = 0
	indexToRemoveTo = 0
	isDrawing = true
	scored = true
	scoreTable = {}
	generated = false
	rand1 = 0
	rand2 = 0
	currentScore = 0
	font = love.graphics.newImageFont("Graphics/UI/Imagefont.png",
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
		"123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font)
	isMenu = false
	isInstructions = false
	isPressed = false
	isTransitioningGame = false
	isTransitioningInstructions = false
	music = false
	timer = 0
	alpha = 0
	fadein  = 1
	display = 1.2
	fadeout = 2.5
	resetTime = 50
	scoreThreshold = 100
	extraScore = 0
	fadeout  = 1
	display = 1.1
	fadein = 1.5
	blinkingCounter = 0
	blinkingCounter2 = 0
	remainingTime = 50
    remainingTimeAtLastScoring = 60
	gameOver = false
	TEsound.play("Sounds/Music/Paper Cut Title.ogg", "menuTheme")
	TEsound.volume("menuTheme", 0.8)
	comboBonus = 1
	heartbeat = false
  canPlaySound = false

  targetUpOld = 0
  targetUp = 0
  addOvals = false
  pickOval = false
  pickRect = true

function love.load()
    setState(Start)
    loadImages()
    loadGraphics()
    loadGameSettings()
	
    width = love.graphics.getWidth()
	height = love.graphics.getHeight()   
    
	isDrawing = true
	scored = true
	generated = false

--	TEsound.play("Sounds/Music/Paper Cut Title.ogg", "menuTheme")
--	TEsound.volume("menuTheme", 0.8)

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
        
    font = love.graphics.newImageFont("Graphics/UI/Imagefont.png",
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
		"123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font)              
end      
    
function loadGameSettings()
    addOvals = false
    pickOval = false
    pickRect = true
    heartbeat = false
    comboBonus = 1
    targetUpOld = 0
    targetUp = 0
    timer = 0
	resetTime = 50
	scoreThreshold = 100
	extraScore = 0  
    currentScore = 0    
    remainingTime = 50    
end        

function setState(s)
    state = s
    state:load()
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

	if (gameOver) then
		love.load()
		ScoreManager.reset()
	end    
end

function love.mousereleased(x, y, button, istouch) 
	state:mouseRelease(x, y, button, istouch)
end

function love.keypressed(key, u)
   --Debug
   if key == "rctrl" then --set to whatever key you want to use
      debug.debug()
   end
end