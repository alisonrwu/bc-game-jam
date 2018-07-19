PopUp = class("PopUp", {RISE = 2, FADE = 1/80}):with(Orientation)

function PopUp:init(color, scale, position) 
  self.color = color or Graphics.NORMAL
  self.scale = scale or 1
  self.position = position or Point()
  self.alpha = 1
end

function PopUp:update()
  self.position.y = self.position.y - PopUp.RISE
  self.alpha = self.alpha - PopUp.FADE
end

function PopUp:draw()
  error("Cannot draw an unspecified PopUp!")
end

TextPopUp = PopUp:extend("TextPopUp")

function TextPopUp:init(text, color, scale, position)
  TextPopUp.super.init(self, color, scale, position)
  self.text = text or ""
  self.dimensions = Dimensions(self.scale * font:getWidth(self.text), self.scale * font:getHeight(self.text))
end

function TextPopUp:draw()
  local color = Graphics:modifyColorAlpha(self.color, self.alpha)
  Graphics:drawTextWithScale(self.text, self.position.x, self.position.y, "left", self.scale, color)   
end

NumberPopUp = PopUp:extend("NumberPopUp")

function NumberPopUp:init(number, color, scale, position)
  NumberPopUp.super.init(self, color, scale, position)
  self.number = self:addSign(number)
  self.dimensions = Dimensions(self.scale * font:getWidth(self.number), self.scale * font:getHeight(self.number))
end

function NumberPopUp:addSign(number)
  if number > 0 then 
    return "+" .. number 
  else
    return number
  end
end

function NumberPopUp:draw()
  local color = Graphics:modifyColorAlpha(self.color, self.alpha)
  Graphics:drawTextWithScale(self.number, self.position.x, self.position.y, "left", self.scale, color)   
end

ImagePopUp = PopUp:extend("ImagePopUp")

function ImagePopUp:init(path, color, scale, position)
  ImagePopUp.super.init(self, color, scale, position)
  self.image = love.graphics.newImage(path) or false
  self.dimensions = self.image and Dimensions(self.scale * self.image:getWidth(), self.scale * self.image:getHeight()) or Dimensions()
end

function ImagePopUp:draw()
  local color = Graphics:modifyColorAlpha(self.color, self.alpha)
  Graphics:drawWithScale(self.image, self.position.x, self.position.y, self.scale, color)
end