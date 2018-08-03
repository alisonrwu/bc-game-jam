Placeable = class("Placeable"):include(Orientation):include(Wait):include(Observable)

function Placeable:initialize(position, scale)
  self.position = position or Point()
  self.scale = scale or 1
end

function Placeable:update(dt)
  self:wait(dt)
end

function Placeable:draw()
  error("Cannot draw an unspecified Placeable!")
end

function Placeable:setPosition(position)
  self.position = position
  self:updateBounds()
end

function Placeable:updateBounds()
  self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
  self.bounds = scale:worldToScreenBounds(self.bounds)
end

function Placeable:setColor(color)
  self.color = color
end

function Placeable:mouseRelease()
  
end

ImagePlaceable = Placeable:subclass("ImagePlaceable")

function ImagePlaceable:initialize(path, position, scale, color)
  Placeable.initialize(self, position, scale)       
  self.image = path and love.graphics.newImage(path) or false
  self.dimensions = self.image and Dimensions(self.image:getWidth(), self.image:getHeight()) or Dimensions()
  self.color = color or Graphics.NORMAL
end

function ImagePlaceable:update(dt)
end

function ImagePlaceable:draw()
  Graphics:draw(self.image, self.position.x, self.position.y, self.color)           
end

ShapePlaceable = Placeable:subclass("ShapePlaceable")

function ShapePlaceable:initialize(shapeName, position, dimensions, color)
  Placeable.initialize(self, position)       
  self.shapeName = shapeName or "Rectangle"
  self.dimensions = dimensions or Dimensions()
  self.color = color or Graphics.NORMAL
  self:updateBounds()
end

function ShapePlaceable:update()
end

function ShapePlaceable:draw()
  if self.shapeName == "Rectangle" then
    Graphics:drawLineRect(self.position.x, self.position.y, self.dimensions.width, self.dimensions.height, self.color)
  end         
end

TextPlaceable = Placeable:subclass("TextPlaceable")

function TextPlaceable:initialize(text, position, align, color, scale)
  Placeable.initialize(self, position, scale)
  self.text = text or ""
  if self.text ~= "" then
    self.dimensions = Dimensions(font:getWidth(self.text) * self.scale, font:getHeight(self.text) * self.scale)
    self.dimensions.height = self.dimensions.height + (self.dimensions.height * math.floor(self.dimensions.width / baseRes.width))
    if self.dimensions.width >= baseRes.width then self.dimensions.width = baseRes.width end
  else
    self.dimensions = Dimensions(0, 0)
  end
  self:updateBounds()
  self.align = align or "left"
  self.color = color or Graphics.NORMAL 
end

function TextPlaceable:update(dt, text)
  Placeable.update(self, dt)
  if text then 
    self.text = text 
    self.dimensions = Dimensions(font:getWidth(self.text) * self.scale, font:getHeight(self.text) * self.scale)
    self.dimensions.height = self.dimensions.height + (self.dimensions.height * math.floor(self.dimensions.width / baseRes.width))
    if self.dimensions.width >= baseRes.width then self.dimensions.width = baseRes.width end
  end
  self:updateBounds()
end

function TextPlaceable:draw()
  Graphics:drawTextWithScale(self.text, self.position.x, self.position.y, self.align, self.scale, self.color)
end

FlashingTextPlaceable = TextPlaceable:subclass("FlashingTextPlaceable")

function FlashingTextPlaceable:initialize(text, position, align, color, cycle, scale)
  TextPlaceable.initialize(self, text, position, align, color, scale)
  self.baseColor = self.color
  self.counter = 0
  self.cycle = cycle or 15
  self.alpha = 0.25  
end

function FlashingTextPlaceable:update(dt)
  TextPlaceable.update(self, dt)
  self.counter = (self.counter + 1) % (self.cycle + 1)
  if self.counter == self.cycle then 
    if self.color == self.baseColor then 
      self.color = Graphics:modifyColorAlpha(self.color, self.alpha) 
    else 
      self.color = self.baseColor 
    end
  end
end

function FlashingTextPlaceable:draw()
  FlashingTextPlaceable.super.draw(self) 
end

GroupPlaceable = Placeable:subclass("GroupPlaceable")
local MIN_VALUE = -math.huge
local MAX_VALUE = math.huge

function GroupPlaceable:initialize(placeables, position, scale)
  Placeable.initialize(self, position, scale)
  self.placeables = placeables or {}
  self.bounds = Bounds()
  for _, placeable in ipairs(self.placeables) do
    local bounds = Bounds.ofTopLeftAndDimensions(placeable.position, placeable.dimensions)
    self.bounds = Math:calculateMaximumBounds(bounds, self.bounds)
  end
  self.position = Point(self.bounds.minX, self.bounds.minY)
  self.dimensions = Dimensions.ofBounds(self.bounds)
end

function GroupPlaceable:setPosition(position)
  local deltaX = position.x - self.position.x
  local deltaY = position.y - self.position.y
  self.position = position
  self:updateBounds()
  for _, placeable in ipairs(self.placeables) do
    placeable:setPosition(Point(placeable.position.x + deltaX, placeable.position.y + deltaY))
  end  
end

function GroupPlaceable:updateBounds()
  self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
  for _, placeable in ipairs(self.placeables) do
    placeable:updateBounds()
  end
end

function GroupPlaceable:update(dt)
  for _, placeable in ipairs(self.placeables) do
    placeable:update(dt)
  end
end

function GroupPlaceable:draw()
  for _, placeable in ipairs(self.placeables) do
    placeable:draw()
  end
end

function GroupPlaceable:mouseRelease(x, y, button, isTouch)
  for _, placeable in ipairs(self.placeables) do
    placeable:mouseRelease(x, y, button, isTouch)
  end  
end

function GroupPlaceable:registerObserver(observer)
  for _, placeable in ipairs(self.placeables) do
    placeable:registerObserver(observer)
  end   
end

function GroupPlaceable:setColor(color)
  for _, placeable in ipairs(self.placeables) do
    placeable:setColor(color)
  end   
end