MainMenu = State:subclass("MainMenu")

function MainMenu:initialize()
  local start = function() 
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Instructions()
  end
  
  local shop = function() 
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Shop()
  end
  
  local achievements = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Achievements()
  end
  
  self.startButton = ImageButton("assets/graphics/menu/button_start.png", start)
  
  self.startButton = TextOnImageButton("assets/graphics/gameover/button_thin.png", start, nil, "Start")
  self.shopButton = TextOnImageButton("assets/graphics/gameover/button_thin.png", shop, nil, "Shop")
  self.achievementsButton = TextOnImageButton("assets/graphics/gameover/button_thin.png", achievements, nil, "Awards")
  
  self.title = ImagePlaceable("assets/graphics/menu/logo_title.png")
  self.credits = TextPlaceable("Made by:\nTrevin Wong   Ryan Wirth\nAlison Wu     Sean Allen", nil, "center", nil)
  
  self.shopButton:setRight(self.startButton, 20)
  self.achievementsButton:setRight(self.shopButton, 20)
  self.title:setCentreHorizontalScreen()
  self.buttons = GroupPlaceable({self.startButton, self.shopButton, self.achievementsButton})
  self.buttons:setCentreHorizontalScreen()
  self.title:setAbove(self.startButton, rowHeight * 0.25)
  self.credits:setBelow(self.startButton)
  
  self.group = GroupPlaceable({self.buttons, self.title, self.credits})
  self.group:setCentreVerticalScreen()
  self.group:setPosition(Point(self.group.position.x, self.group.position.y - 45))
 
  Sound:createAndPlay("assets/audio/music/bgm_mainmenu.ogg", "bgm", true, "stream")
end

function MainMenu:update(dt)
  salary:update(dt)
end

function MainMenu:draw()
  self.group:draw()
  salary:draw()
end

function MainMenu:mouseRelease(x, y, button, isTouch) 
  self.group:mouseRelease(x, y, button, isTouch)
end

function MainMenu:mousePressed(x, y, button, isTouch)
end

function MainMenu:__tostring()
  return "MainMenu"
end