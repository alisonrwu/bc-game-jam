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
  
  self.credits = TextPlaceable("Made by: Trevin \"terb\" Wong, Alison \"arwu\" Wu, Sean \"sdace\" Allen and Ryan \"Rye\" Wirth")
  self.credits.position.x = 5
  self.credits:setBelow(self.startButton, 100)
  
  Sound:createAndPlay("assets/audio/music/bgm_mainmenu.ogg", "bgm", true, "stream")
end

function MainMenu:update(dt)
  self.startButton:update(dt)
end

function MainMenu:draw()
  self.menuBG:draw()
  self.title:draw()
  self.startButton:draw()
  --local dimensions = Dimensions.ofBounds(self.startButton.bounds)
  --Graphics:drawRect(self.startButton.bounds.minX, self.startButton.bounds.minY, dimensions.width, dimensions.height)
  self.credits:draw()      
end

function MainMenu:mouseRelease(x, y, button, isTouch) 
end

function MainMenu:mousePressed(x, y, button, isTouch)
end