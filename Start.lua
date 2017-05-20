Start = {
    Credits = {},
    TitleButton = {},
    StartButton = {}
}


function Start:update(dt)
end                            
    
function Start:draw()
    Graphics:draw(menuBG, 0, 0, Graphics.NORMAL)
    Graphics:draw(self.TitleButton.IMAGE, self.TitleButton.X, self.TitleButton.X, Graphics.NORMAL)
    Graphics:draw(self.StartButton.IMAGE, self.StartButton.X, self.StartButton.Y, Graphics.NORMAL)
    Graphics:drawText(self.Credits.TEXT, self.Credits.X, self.Credits.Y, self.Credits.LIMIT, self.Credits.ALIGN, Graphics.NORMAL)
end

function Start:load()
    self.Credits.TEXT = "Made by: Trevin \"terb\" Wong, Alison \"arwu\" Wu, Sean \"sdace\" Allen and Ryan \"Rye\" Wirth"
    self.Credits.X = 5
    self.Credits.Y = height - 100
    self.Credits.LIMIT = width
    self.Credits.ALIGN = center
    
    self.TitleButton.IMAGE = love.graphics.newImage("Graphics/Menu/testTitle.png")
    self.TitleButton.X = width/6
    self.TitleButton.Y = height/4
    
    self.StartButton.IMAGE = love.graphics.newImage("Graphics/Menu/startButton.png")
    self.StartButton.X = width/3
    self.StartButton.Y = height/2   
end    

                    
function Start:mouseRelease(x, y, button, istouch)
  TEsound.play("Sounds/SFX/Click.mp3", "click")
    Fade:fadeToState(Instructions)
end    

function Start:mousePressed(x, y, button, istouch)    
end