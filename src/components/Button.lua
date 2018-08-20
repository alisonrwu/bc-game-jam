Button = class("Button"):include(Orientation):include(Observable)

function Button:initialize(onClick, position, name, color)
  self.onClick = onClick or function() end
  self.position = position or Point()
  self.name = name or ""
  self.color = color
end

function Button:update(dt)
end

function Button:mouseRelease(x, y, button, isTouch)
  if self.color ~= Graphics.GONE then
    if self.bounds:isWithin(Point(x, y)) then 
      self:notifyObservers(self.name)
      self:onClick(self.args) 
    end     
  end
end

function Button:draw()
  error("Cannot draw an unspecified Button!")      
end

function Button:isMouseWithinButton()
  local mouseCoord = scale:getWorldMouseCoordinates()
  return self.bounds:isWithin(mouseCoord)      
end

function Button:setPosition(pos)
  self.position = pos
  self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions)
  self.bounds = scale:worldToScreenBounds(self.bounds)
end

function Button:updateBounds()
  self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
  self.bounds = scale:worldToScreenBounds(self.bounds)
end

ImageButton = Button:subclass("ImageButton")

function ImageButton:initialize(path, onClick, position, color, name)
  Button.initialize(self, onClick, position, name, color)
  self.image = path and love.graphics.newImage(path) or false
  self.dimensions = self.image and Dimensions(self.image:getWidth(), self.image:getHeight()) or Dimensions()
  self.bounds = self.image and Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) or Bounds()
  self.color = color or Graphics.NORMAL
end

function ImageButton:setColor(color)
  self.color = color
end

function ImageButton:setImage(path)
  self.image = path and love.graphics.newImage(path) or false
  self.dimensions = self.image and Dimensions(self.image:getWidth(), self.image:getHeight()) or Dimensions()
  self.bounds = self.image and Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) or Bounds()
end

function ImageButton:draw()
  if not self.image then error("ImageButton does not have an image.") end
  Graphics:draw(self.image, self.position.x, self.position.y, self.color)
end

TextOnImageButton = ImageButton:subclass("TextOnImageButton")

function TextOnImageButton:initialize(path, onClick, position, text, color)
  ImageButton.initialize(self, path, onClick, position, color)
  self.text = text and TextPlaceable(text, nil, nil, self.color) or TextPlaceable()
end

function TextOnImageButton:setColor(color)
  self.color = color
  self.text.color = color
end

function TextOnImageButton:draw()
  TextOnImageButton.super.draw(self)
  self.text:setCentreHorizontal(self)
  self.text:setCentreVertical(self)
  self.text:draw()
end

