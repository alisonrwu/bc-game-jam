MainMenu = State:subclass("MainMenu")

function MainMenu:initialize(continueBGM)
  local start = function() 
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Options()
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
  
  self.startButton = TextOnImageButton("assets/graphics/misc/button_thin.png", start, nil, "Start")
  self.shopButton = TextOnImageButton("assets/graphics/misc/button_thin.png", shop, nil, "Shop")
  self.achievementsButton = TextOnImageButton("assets/graphics/misc/button_wide.png", achievements, nil, "Achievements")
  
  self.title = ImagePlaceable("assets/graphics/menu/logo_title.png")
  self.credits = TextPlaceable("Made by: Trevin Wong, Ryan Wirth", nil, "left", nil, 0.5)
  self.credits2 = TextPlaceable(", Alison Wu, Sean Allen", nil, "left", nil, 0.5)
  
--  self.startButton:setRight(self.shopButton, 20)
--  self.achievementsButton:setRight(self.startButton, 20)
  self.title:setCentreHorizontalScreen()
  self.credits2:setRight(self.credits)
  self.groupCredits = GroupPlaceable({self.credits, self.credits2})
  self.groupCredits:setBelow(self.title, 10)
  self.groupCredits:setCentreHorizontalScreen()
  self.startButton:setCentreHorizontal(self.title)
  self.shopButton:setBelow(self.startButton, 10)
  self.shopButton:setCentreHorizontal(self.startButton)
  self.achievementsButton:setBelow(self.shopButton, 10)
  self.achievementsButton:setCentreHorizontal(self.shopButton)
  self.buttons = GroupPlaceable({self.startButton, self.shopButton, self.achievementsButton})
  self.buttons:setCentreHorizontalScreen()
  self.buttons:setBelow(self.groupCredits, 10)
--  self.credits:setCentreHorizontalScreen()
--  self.credits:setBelow(self.startButton, rowHeight * 0.25)
  
  self.group = GroupPlaceable({self.buttons, self.title, self.groupCredits})
  self.group:setCentreVerticalScreen()
  self.group:setPosition(Point(self.group.position.x, self.group.position.y - 5))
 
  if not continueBGM then
    Sound:createAndPlay("assets/audio/music/bgm_mainmenu.ogg", "bgm", true, "stream")
    Sound:setVolume("bgm", 0.9)
  end
  
  self.group:convertWorldBoundsToScreen()
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