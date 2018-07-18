Button = class("Button"):with(Orientation)

function Button:init(onClick, position)
  self.onClick = onClick or function() end
  self.position = position or Point()
end

function Button:update(dt)
end

function Button:mouseRelease(x, y, button, isTouch)
  if self.bounds:isWithin(Point(x, y)) then self:onClick() end      
end

function Button:draw()
  error("Cannot draw an unspecified Button!")      
end

function Button:isMouseWithinButton()
  local mouseCoord = Scale:getWorldMouseCoordinates()
  return self.bounds:isWithin(mouseCoord)      
end

ImageButton = Button:extend("ImageButton")

function ImageButton:init(path, onClick, position)
  ImageButton.super.init(self, onClick, position)
  self.image = path and love.graphics.newImage(path) or false
  self.dimensions = self.image and Dimensions(self.image:getWidth(), self.image:getHeight()) or Dimensions()
  self.bounds = self.image and Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) or Bounds()
end

function ImageButton:draw()
  if not self.image then error("ImageButton does not have an image.") end
  Graphics:draw(self.image, self.position.x, self.position.y, Graphics.NORMAL)
end