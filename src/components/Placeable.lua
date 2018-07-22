Placeable = class("Placeable"):with(Orientation)

function Placeable:init(position, scale)
  self.position = position or Point()
  self.scale = scale or 1
end

function Placeable:update()
  error("Cannot update an unspecified Placeable!")
end

function Placeable:draw()
  error("Cannot draw an unspecified Placeable!")
end

ImagePlaceable = Placeable:extend("ImagePlaceable")

function ImagePlaceable:init(path, position, scale)
  ImagePlaceable.super.init(self, position, scale)       
  self.image = path and love.graphics.newImage(path) or false
  self.dimensions = self.image and Dimensions(self.image:getWidth(), self.image:getHeight()) or Dimensions()
end

function ImagePlaceable:update()
end

function ImagePlaceable:draw()
  Graphics:draw(self.image, self.position.x, self.position.y, Graphics.NORMAL)           
end

ShapePlaceable = Placeable:extend("ShapePlaceable")

function ShapePlaceable:init(shapeName, position, dimensions, color)
  ShapePlaceable.super.init(self, position)       
  self.shapeName = shapeName or "Rectangle"
  self.dimensions = dimensions or Dimensions()
  self.color = color or Graphics.NORMAL
end

function ShapePlaceable:update()
end

function ShapePlaceable:draw()
  if self.shapeName == "Rectangle" then
    Graphics:drawLineRect(self.position.x, self.position.y, self.dimensions.width, self.dimensions.height, self.color)
  end         
end

TextPlaceable = Placeable:extend("TextPlaceable")

function TextPlaceable:init(text, position, align, color, scale)
  TextPlaceable.super.init(self, position, scale)
  self.text = text or ""
  self.dimensions = Dimensions(font:getWidth(self.text) * self.scale, font:getHeight(self.text) * self.scale)
  self.align = align or "left"
  self.color = color or Graphics.NORMAL 
end

function TextPlaceable:update(text)
  if text then self.text = text end
end

function TextPlaceable:draw()
  Graphics:drawTextWithScale(self.text, self.position.x, self.position.y, self.align, self.scale, self.color)
end

FlashingTextPlaceable = TextPlaceable:extend("FlashingTextPlaceable")

function FlashingTextPlaceable:init(text, position, align, color, cycle, scale)
  FlashingTextPlaceable.super.init(self, text, position, align, color, scale)
  self.baseColor = self.color
  self.counter = 0
  self.cycle = cycle or 15
  self.alpha = 0.25  
end

function FlashingTextPlaceable:update(dt)
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
