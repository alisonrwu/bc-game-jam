GameOver = State:extend("GameOver", {PITCH = 0.9, CYCLE = 15})

function GameOver:init()
  love.mouse.setVisible(true)
  self.counter = 0
  
  self.gameOver = TextPlaceable("GAME OVER", nil, nil, nil, 1)
  self.gameOver.position.x = baseRes.width * 0.5 - self.gameOver.dimensions.width * 0.5
  self.gameOver.position.y = baseRes.height * 0.15
  
  HighScore:createScorePlaceables(self.gameOver.position.y + 60)
  
--  self.playAgain = FlashingTextPlaceable("Play Again?")
--  self.playAgain:setCentreHorizontal(self.gameOver)
--  self.playAgain:setBelow(self.gameOver, 20)
  
  Sound:setPitch("bgm", GameOver.PITCH)  
end

function GameOver:update(dt)
--  self.playAgain:update()
end                            

function GameOver:draw()  
  Graphics:drawRect(0, 0, baseRes.width, baseRes.height, Graphics.BLACK)
  self.gameOver:draw()
--  self.playAgain:draw()
  HighScore:draw()
end

function GameOver:mousePressed(x, y, button, isTouch)
end

function GameOver:mouseRelease(x, y, button, istouch)
  Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
  state = Game()
end    