MainMenu = class("MainMenu", State)

function MainMenu:init()
  self.menuBG = ImagePlaceable("assets/graphics/menu/bg/bg_menu16x9.png")

  self.title = ImagePlaceable("assets/graphics/menu/logo_title.png")
  self.title:setCentreHorizontal(self.menuBG)
  self.title.position.y = baseRes.height * 0.1
  
  local start = function() 
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Instructions()
  end
  
  self.startButton = ImageButton("assets/graphics/menu/button_start.png", start)
  self.startButton:setCentreHorizontal(self.title)
  self.startButton:setBelow(self.title, 50)
  
  self.credits_1 = TextPlaceable("Made by:", nil, "center")
  self.credits_1:setBelow(self.startButton, 60)
    
  self.credits_2 = TextPlaceable("Trevin Wong   Ryan Wirth", nil, "center")
  self.credits_2:setBelow(self.credits_1)
  
  self.credits_3 = TextPlaceable("Alison Wu     Sean Allen", nil, "center")
  self.credits_3:setBelow(self.credits_2)
  
  Sound:createAndPlay("assets/audio/music/bgm_mainmenu.ogg", "bgm", true, "stream")
end

function MainMenu:update(dt)
end

function MainMenu:draw()
  self.menuBG:draw()
  self.title:draw()
  self.startButton:draw()
  --local dimensions = Dimensions.ofBounds(self.startButton.bounds)
  --Graphics:drawRect(self.startButton.bounds.minX, self.startButton.bounds.minY, dimensions.width, dimensions.height)
  self.credits_1:draw()
  self.credits_2:draw()
  self.credits_3:draw()
end

function MainMenu:mouseRelease(x, y, button, isTouch) 
  self.startButton:mouseRelease(x, y, button, isTouch)
end

function MainMenu:mousePressed(x, y, button, isTouch)
end