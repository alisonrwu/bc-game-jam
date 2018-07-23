GameOver = State:extend("GameOver", {PITCH = 0.9})

function GameOver:init()
  love.mouse.setVisible(true)
  
  local gameOver = TextPlaceable("GAME OVER", nil, nil, nil, 1)
  gameOver.position.x = baseRes.width * 0.5 - gameOver.dimensions.width * 0.5
  gameOver.position.y = baseRes.height * 0.09
  
  HighScore:createScorePlaceables(gameOver.position.y + 45)
  
  local onClickRetry = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Game()
  end
  
  local onClickMenu = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = MainMenu()
  end
  
  local retry = TextOnImageButton("assets/graphics/gameover/button_thin.png", onClickRetry, nil, "Retry")
  retry:setPosition(Point(baseRes.width * 0.35 - retry.dimensions.width * 0.5, HighScore:endY() + 45))

  local menu = TextOnImageButton("assets/graphics/gameover/button_thin.png", onClickMenu, nil, "Menu")
  menu:setPosition(Point(baseRes.width * 0.65 - retry.dimensions.width * 0.5, HighScore:endY() + 45))

  self.placeables = {gameOver, retry, menu}
  self.buttons = {retry, menu}
  Sound:setPitch("bgm", GameOver.PITCH)  
end

function GameOver:update(dt)
end                            

function GameOver:draw()  
  HighScore:draw()
  for _, v in ipairs(self.placeables) do
    v:draw()
  end
end

function GameOver:mousePressed(x, y, button, isTouch)
end

function GameOver:mouseRelease(x, y, button, isTouch)
  for _, v in ipairs(self.buttons) do
    v:mouseRelease(x, y, button, isTouch)
  end  
end    