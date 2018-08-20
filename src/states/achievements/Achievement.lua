Achievement = class("Achievement"):include(Orientation):include(Observable):include(Observer)
Achievement.static.UNLOCKED = "UNLOCKED"
Achievement.static.LOCKED = "LOCKED"

function Achievement:initialize(text, description, notify, maxProgress)
  self.panel = ImagePlaceable("assets/graphics/misc/button_achievement.png")
  self.panel.color = Graphics.DARKGRAY
  
  self.title = TextPlaceable(text, nil, nil, nil, 0.5)
  self.title:setCentreHorizontal(self.panel)
  self.title:setCentreVertical(self.panel)
  self.title.color = Graphics.DARKGRAY
  
  self.description = description
  self.notify = notify
  
--  self.lockedText = TextPlaceable("LOCKED")
--  self.lock = ImagePlaceable("assets/graphics/misc/hud_lock.png") 
--  self.lock:setLeft(self.lockedText, 5)
--  self.lock:setCentreVertical(self.lockedText)
--  self.lockedDisplay = GroupPlaceable({self.lock, self.lockedText})
--  self.lockedDisplay.color = Graphics.NORMAL
--  self.lockedDisplay:setCentreHorizontal(self.panel)
--  self.lockedDisplay:setCentreVertical(self.panel)
  
  self.progress = 0
  self.maxProgress = maxProgress
  
  self.dimensions = self.panel.dimensions
  self.bounds = Bounds.ofTopLeftAndDimensions(self.panel.position, self.dimensions)
  self.position = self.panel.position

  self.unlocked = false
  
  self.observers = {}
  self.placeables = {self.panel, self.title, self.lockedDisplay}
end

function Achievement:mouseRelease(x, y, button, isTouch)
   if self.bounds:isWithin(Point(x, y)) then 
    self:onClick()
  end         
end

function Achievement:onClick()
  if self.unlocked then
    self:notifyObservers(Achievement.UNLOCKED, {description = self.description}) 
  else
    self:notifyObservers(Achievement.LOCKED, {description = self.description, progress = self.progress, maxProgress = self.maxProgress})
  end
end

function Achievement:setUnlocked(boolean)
  self.unlocked = boolean
  if not self.unlocked then
--    self.lockedDisplay:setColor(Graphics.GONE)
  else
--    self.lockedDisplay:setColor(Graphics.GONE)
    self.panel.color = Graphics.NORMAL
    self.title.color = Graphics.NORMAL
  end
end

function Achievement:draw()
  for _, placeable in ipairs(self.placeables) do
    placeable:draw()
  end
end

function Achievement:setPosition(position)
  local deltaX = position.x - self.position.x
  local deltaY = position.y - self.position.y
  self.position = position
  for _, placeable in ipairs(self.placeables) do
    placeable:setPosition(Point(placeable.position.x + deltaX, placeable.position.y + deltaY))
  end  
  self:updateBounds()
end

function Achievement:updateBounds()
  self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
  self.bounds = scale:worldToScreenBounds(self.bounds)
end

function Achievement:getData()
  return {unlocked = self.unlocked}
end

function Achievement:setData(data)
  self:setUnlocked(data.unlocked)
end

function Achievement:addPopUp()
  local unlockedPopUp = TextPopUp("Achievement Unlocked!", Graphics.YELLOW, 0.5)
  local titlePopUp = TextPopUp(self.title.text, nil, 0.5)
  local boxPopUp = ImagePopUp("assets/graphics/achievement_small.png")
  boxPopUp:setCentreHorizontalScreen()
  boxPopUp:setPosition(Point(boxPopUp.position.x, baseRes.height - boxPopUp.dimensions.height - 30))
  unlockedPopUp:setCentreHorizontal(boxPopUp)
  unlockedPopUp:setCentreVertical(boxPopUp)
  unlockedPopUp:setPosition(Point(unlockedPopUp.position.x, unlockedPopUp.position.y - 12))
  titlePopUp:setCentreHorizontal(boxPopUp)
  titlePopUp:setBelow(unlockedPopUp, 5)
  boxPopUp:setFade(1/120)
  unlockedPopUp:setFade(1/120)
  titlePopUp:setFade(1/120)
  boxPopUp:setRise(0.1)
  unlockedPopUp:setRise(0.1)
  titlePopUp:setRise(0.1)
  user:addPopUp(boxPopUp)
  user:addPopUp(unlockedPopUp)
  user:addPopUp(titlePopUp)
  Sound:createAndPlay("assets/audio/sfx/sfx_achievement_unlocked.wav", "achievement_unlocked")
end

function Achievement:__tostring()
  return "Achievement"
end