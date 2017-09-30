StartState = {}


function StartState:update(dt)
end                            
  
function StartState:draw()
  Graphics:draw(menuBG, 0, 0, Graphics.NORMAL)
  Graphics:draw(titleButtonImage, titleButtonX, titleButtonY, Graphics.NORMAL)
  Graphics:draw(startButtonImage, startButtonX, startButtonY, Graphics.NORMAL)
  Graphics:drawText(creditsText, creditsX, creditsY, width, center, Graphics.NORMAL)
end

function StartState:load()
  creditsText = "Made by: Trevin \"terb\" Wong, Alison \"arwu\" Wu, Sean \"sdace\" Allen and Ryan \"Rye\" Wirth"
  creditsX = 5
  creditsY = height - 100
  
  titleButtonImage = love.graphics.newImage("Graphics/Menu/testTitle.png")
  titleButtonX = width/6
  titleButtonY = height/4
  
  startButtonImage = love.graphics.newImage("Graphics/Menu/startButton.png")
  startButtonX = width/3
  startButtonY = height/2
  
  SoundManager:playMusic("Sounds/Music/Paper Cut Title.ogg", "startTheme")
  TEsound.volume("menuTheme", 0.8)
end    


function StartState:mouseRelease(x, y, button, istouch)
  TEsound.play("Sounds/SFX/Click.mp3", "click")
  setState(InstructionState)
end    

function StartState:mousePressed(x, y, button, istouch)    
end