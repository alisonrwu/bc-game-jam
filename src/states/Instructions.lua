Instructions = State:subclass("Instructions")

function Instructions:initialize()
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
  for _, v in ipairs(self.placeables) do
    v:draw()
  end
end

function Instructions:setUpScreen1()
  local speechBubble = ImagePlaceable("assets/graphics/game/hud/hud_speechbubble.png")
  local explanation = TextPlaceable("W = width   L = length", nil, "center")
  local example = TextPlaceable("I want a 3W x 2L Rectangle!", nil, "center")
  local intro = TextPlaceable("The boss wants you to cut some paper...", nil, "center", Graphics.NORMAL, 1)
  local press = FlashingTextPlaceable("Press to continue!", nil, "center")
  
  speechBubble:setCentreHorizontalScreen()
  speechBubble:setBelow(intro, rowHeight)
  example:setCentreVertical(speechBubble)
  explanation:setBelow(speechBubble)
  press:setBelow(explanation, rowHeight)

  local group = GroupPlaceable({speechBubble, explanation, example, intro, press})
  group:setCentreVerticalScreen()
  
  local mouseRelease = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    self:setUpScreen2()
  end
  
  self.placeables = {group}
  self.onMouseRelease = mouseRelease
end

function Instructions:setUpScreen2()
  local closerExplanation = TextPlaceable("The closer you are, the more points you get!", nil, "center")
  local collectExplanation = TextPlaceable("Reach the target to gain more time!", nil, "center")
  local noTimeExplanation = TextPlaceable("If you run out of time, you're fired!", nil, "center", Graphics.RED)
  local press = FlashingTextPlaceable("Press to start!", nil, "center")
  
  collectExplanation:setBelow(closerExplanation, rowHeight)
  noTimeExplanation:setBelow(collectExplanation, rowHeight)
  press:setBelow(noTimeExplanation, rowHeight)
  
  local group = GroupPlaceable({collectExplanation, closerExplanation, noTimeExplanation, press})
  group:setCentreVerticalScreen()
  
  local mouseRelease = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Game()
  end
  
  self.placeables = {group}
  self.onMouseRelease = mouseRelease
end

function Instructions:mousePressed(x, y, button, isTouch)
end

function Instructions:mouseRelease(x, y, button, istouch)
  self:onMouseRelease()
end    

function Instructions:__tostring()
  return "Instructions"
end