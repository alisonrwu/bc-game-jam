Instructions = State:extend("Instructions", {CYCLE = 15})

function Instructions:init()
  self.menuBG = ImagePlaceable("assets/graphics/menu/bg/bg_menu16x9.png")
  
  self.instructions_1 = TextPlaceable("The boss wants you to cut some paper...", "center")
  self.instructions_1:setCentreHorizontal(self.menuBG)
  self.instructions_1.position.y = baseRes.height * 0.1
  
  self.instructions_2 = TextPlaceable("Better do what he says, fast!", nil, "center", Graphics.RED)
  self.instructions_2:setBelow(self.instructions_1, 50)
  
  self.instructions_3 = TextPlaceable("Use the left mouse button to cut the proper size sheets of paper.", nil, "center")
  self.instructions_3:setBelow(self.instructions_2, 50)
  
  self.clickToStart = FlashingTextPlaceable("Click to Start!", nil, "center")
  self.clickToStart:setBelow(self.instructions_3, 100)
end

function Instructions:update(dt)
  self.clickToStart:update()
end                            
  
function Instructions:draw()  
  self.menuBG:draw()
  self.instructions_1:draw()
  self.instructions_2:draw()
  self.instructions_3:draw()
  self.clickToStart:draw()
end

function Instructions:mousePressed(x, y, button, isTouch)
end

function Instructions:mouseRelease(x, y, button, istouch)
  Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
  state = Game()
end    