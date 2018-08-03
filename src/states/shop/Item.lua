Item = class("Item"):include(Orientation):include(Observable)
Item.static.BUY_SUCCESS = "BOUGHT!"
Item.static.BUY_FAIL = "NO MONEY!"
Item.static.EQUIP_SUCCESS = "EQUIPPED!"
Item.static.GO_TO_DETAILS = "DETAILS!"

function Item:initialize(path, cost, effectIndex)
  self.imagePath = path
  self.panel = ImagePlaceable("assets/graphics/shop/hud_panel.png")
  self.panel.color = Graphics.DARKGRAY
  if path then 
    self.image = ImagePlaceable(path)
    self.image:setCentreHorizontal(self.panel)
    self.image:setCentreVertical(self.panel)
    self.image.color = Graphics.DARKGRAY
  end
  if cost then
    self.cost = cost
    self.costDisplay = TextPlaceable(self.cost)
    self.lock = ImagePlaceable("assets/graphics/shop/hud_lock.png") 
    self.lock:setLeft(self.costDisplay, 5)
    self.lock:setCentreVertical(self.costDisplay)
    self.lockedCost = GroupPlaceable({self.lock, self.costDisplay})
    self.lockedCost.color = Graphics.NORMAL
    self.lockedCost:setCentreHorizontal(self.panel)
    self.lockedCost:setCentreVertical(self.panel)
  end
  
  self.dimensions = self.panel.dimensions
  self.bounds = Bounds.ofTopLeftAndDimensions(self.panel.position, self.dimensions)
  self.position = self.panel.position

  self.bought = false
  self.equipped = false

  self.equippedDisplay = TextPlaceable("EQUIPPED")
  self.equippedDisplay:setColor(Graphics.GONE)
  self.equippedDisplay:setCentreHorizontal(self.panel)
  self.equippedDisplay:setCentreVertical(self.panel)
  
  self.effectIndex = effectIndex or 1
  
  self.observers = {}
  self.placeables = {self.panel, self.image, self.lockedCost, self.equippedDisplay}
end

function Item:mouseRelease(x, y, button, isTouch)
   if self.bounds:isWithin(Point(x, y)) then 
    self:onClick()
  end         
end

function Item:onClick()
  if not self.bought then
    if salary.amount >= self.cost then
      salary:add(-1 * self.cost)
      self:notifyObservers(Item.BUY_SUCCESS)
      self:setBought(true)
    else
      self:notifyObservers(Item.BUY_FAIL)
    end
  else
    if not self.equipped then
      self:notifyObservers(Item.GO_TO_DETAILS, {item = self})
    end
  end
end

function Item:setBought(boolean)
  self.bought = boolean
  if self.bought then
    self.lockedCost:setColor(Graphics.GONE)
    self.panel.color = Graphics.NORMAL
    self.image.color = Graphics.NORMAL
  else
    self.lockedCost:setColor(Graphics.NORMAL)
    self.panel.color = Graphics.DARKGRAY
    self.image.color = Graphics.DARKGRAY
  end
end

function Item:setEquipped(boolean)
  self.equipped = boolean
  if self.equipped then
    self.equippedDisplay:setColor(Graphics.NORMAL)
  else
    self.equippedDisplay:setColor(Graphics.GONE)
  end
end

function Item:draw()
  for _, placeable in ipairs(self.placeables) do
    placeable:draw()
  end
end

function Item:setPosition(position)
  local deltaX = position.x - self.position.x
  local deltaY = position.y - self.position.y
  self.position = position
  for _, placeable in ipairs(self.placeables) do
    placeable:setPosition(Point(placeable.position.x + deltaX, placeable.position.y + deltaY))
  end  
end

function Item:updateBounds()
  self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
  self.bounds = scale:worldToScreenBounds(self.bounds)
end

function Item:getData()
  return {bought = self.bought, equipped = self.equipped}
end

function Item:setData(data)
  self:setBought(data.bought)
  self:setEquipped(data.equipped)
end