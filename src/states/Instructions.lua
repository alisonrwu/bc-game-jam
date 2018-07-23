Instructions = State:extend("Instructions")

function Instructions:init()
  self.menuBG = ImagePlaceable("assets/graphics/menu/bg/bg_menu16x9.png")
  self.placeables = {}
  self.onMouseRelease = function() end
  self:setUpScreen1()
end

function Instructions:update(dt)
  for _, v in ipairs(self.placeables) do
    v:update()
  end
end                            
  
function Instructions:draw()  
  self.menuBG:draw()
  for _, v in ipairs(self.placeables) do
    v:draw()
  end
end

function Instructions:setUpScreen1()
  local i1 = TextPlaceable("The boss wants you to cut some paper...", nil, "center", Graphics.NORMAL, 1)
  i1.position.y = baseRes.height * 0.09
  
  local speechBubble = ImagePlaceable("assets/graphics/game/hud/hud_speechbubble.png")
  speechBubble:setCentreHorizontal(self.menuBG)
  speechBubble:setBelow(i1, 60)
  
  local example = TextPlaceable("I want a 3W x 2L Rectangle!")
  example:setCentreHorizontal(self.menuBG)
  example:setCentreVertical(speechBubble)
  
  local i2 = TextPlaceable("W = width   L = length", nil, "center")
  i2:setBelow(example, 20)
  
  local mouseRelease = function()
    self:setUpScreen2()
  end
  
  local i6 = FlashingTextPlaceable("Press to continue!", nil, "center")
  i6:setBelow(i2, 65)
  
  self.placeables = {i1, i2, speechBubble, example, i6}
  self.onMouseRelease = mouseRelease
end

function Instructions:setUpScreen2()
  local i3 = TextPlaceable("The closer you are, the more points you get!", nil, "center")
  i3.position.y = baseRes.height * 0.09

  local i4 = TextPlaceable("Collect points to gain more time!", nil, "center")
  i4:setBelow(i3, 70)
  
  local i5 = TextPlaceable("If you run out of time, you're fired!", nil, "center", Graphics.RED)
  i5:setBelow(i4, 30)
  
  local i6 = FlashingTextPlaceable("Press to start!", nil, "center")
  i6:setBelow(i5, 65)
  
  local mouseRelease = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Game()
  end
  
  self.placeables = { i3, i4, i5, i6}
  self.onMouseRelease = mouseRelease
end

function Instructions:mousePressed(x, y, button, isTouch)
end

function Instructions:mouseRelease(x, y, button, istouch)
  self:onMouseRelease()
end    