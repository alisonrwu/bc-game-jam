GameOver = State:extend("GameOver", {PITCH = 0.9, CYCLE = 15})

function GameOver:init()
  self.counter = 0
  
  self.gameOver = TextPlaceable("GAME OVER")
  self.gameOver.position.x = baseRes.width * 0.5 - self.gameOver.dimensions.width * 0.5
  self.gameOver.position.y = baseRes.height * 0.4
  
  self.playAgain = FlashingTextPlaceable("Play Again?")
  self.playAgain:setCentreHorizontal(self.gameOver)
  self.playAgain:setBelow(self.gameOver, 20)
  
  love.mouse.setVisible(true)
  Sound:setPitch("gameTheme", GameOver.PITCH)  
end

function GameOver:update(dt)
  self.playAgain:update()
end                            
    
function GameOver:draw()  
  Graphics:drawRect(0, 0, baseRes.width, baseRes.height, Graphics.BLACK)
  self.gameOver:draw()
  self.playAgain:draw()
end

function GameOver:mousePressed(x, y, button, isTouch)
  Sound:play("Sounds/SFX/Click.mp3", "click")
  state = MainMenu()
end

function GameOver:mouseRelease(x, y, button, istouch)
end    