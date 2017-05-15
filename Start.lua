Start = {}
Credits = {}
TitleButton = {}
StartButton = {}

function Start:update(dt)
end                            
    
function Start:draw()  
    Graphics:draw(menuBG, 0, 0, Graphics.NORMAL)
    Graphics:draw(TitleButton.IMAGE, TitleButton.X, TitleButton.X, Graphics.NORMAL)
    Graphics:draw(StartButton.IMAGE, StartButton.X, StartButton.Y, Graphics.NORMAL)
    Graphics:drawText(Credits.TEXT, Credits.X, Credits.Y, Credits.LIMIT, Credits.ALIGN, Graphics.NORMAL)
end

function Start:load()
    Credits.TEXT = "Made by: Trevin \"terb\" Wong, Alison \"arwu\" Wu, Sean \"sdace\" Allen and Ryan \"PROWNE\" Wirth"
    Credits.X = 5
    Credits.Y = height - 80
    Credits.LIMIT = width
    Credits.ALIGN = center
    
    TitleButton.IMAGE = love.graphics.newImage("Graphics/Menu/testTitle.png")
    TitleButton.X = width/6
    TitleButton.Y = height/4
    
    StartButton.IMAGE = love.graphics.newImage("Graphics/Menu/startButton.png")
    StartButton.X = width/3
    StartButton.Y = height/2
end    

                    
function Start:mouseRelease(x, y, button, istouch)
  TEsound.play("Sounds/SFX/Click.mp3", "click")
    Fade:fadeToState(Instructions)
end    

function Start:mousePressed(x, y, button, istouch)    
end