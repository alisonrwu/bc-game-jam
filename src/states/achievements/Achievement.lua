Achievement = class("Achievement"):include(Orientation):include(Observable)

function Achievement:initialize(text, achievementIndex)
  self.panel = ImagePlaceable("assets/graphics/detailbutton.png")
  self.panel.color = Graphics.DARKGRAY
  
  self.title = TextPlaceable(text, nil, nil, nil, 0.5)
  self.title:setCentreHorizontal(self.panel)
  self.title:setCentreVertical(self.panel)
  self.title.color = Graphics.DARKGRAY
  
  self.lockedText = TextPlaceable("LOCKED")
  self.lock = ImagePlaceable("assets/graphics/shop/hud_lock.png") 
  self.lock:setLeft(self.lockedText, 5)
  self.lock:setCentreVertical(self.lockedText)
  self.lockedDisplay = GroupPlaceable({self.lock, self.lockedText})
  self.lockedDisplay.color = Graphics.NORMAL
  self.lockedDisplay:setCentreHorizontal(self.panel)
  self.lockedDisplay:setCentreVertical(self.panel)
  
  self.dimensions = self.panel.dimensions
  self.bounds = Bounds.ofTopLeftAndDimensions(self.panel.position, self.dimensions)
  self.position = self.panel.position

  self.unlocked = false
  self.achievementIndex = achievementIndex or 1
  
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
    self:notifyObservers(Achievement.UNLOCKED)
  else
    self.notifyObservers(Achievement.LOCKED)
  end
end

function Achievement:setUnlocked(boolean)
  self.unlocked = boolean
  if not self.unlocked then
    self.lockedDisplay:setColor(Graphics.NORMAL)
  else
    self.lockedDisplay:setColor(Graphics.GONE)
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