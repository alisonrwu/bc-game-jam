PopUp = class("PopUp"):include(Orientation)
PopUp.RISE = 1.9
PopUp.FADE = 1/95

function PopUp:initialize(color, scale, position) 
  self.color = color or Graphics.NORMAL
  self.scale = scale or 1
  self.position = position or Point()
  self.alpha = 1
end

function PopUp:update()
  local oldPosition = self.position.y
  local rise = self.rise and self.rise or PopUp.RISE
  local fade = self.fade and self.fade or PopUp.FADE
  self.position.y = self.position.y - rise
  self.alpha = self.alpha - fade
end

function PopUp:draw()
  error("Cannot draw an unspecified PopUp!")
end

function PopUp:setPosition(position)
  self.position = position
end

function PopUp:setRise(rise)
  self.rise = rise
end

function PopUp:setFade(fade)
  self.fade = fade
end

TextPopUp = PopUp:subclass("TextPopUp")

function TextPopUp:initialize(text, color, scale, position)
  PopUp.initialize(self, color, scale, position)
  self.text = text or ""
  self.dimensions = Dimensions(self.scale * font:getWidth(self.text), self.scale * font:getHeight(self.text))
end

function TextPopUp:draw()
  local color = Graphics:modifyColorAlpha(self.color, self.alpha)
  Graphics:drawTextWithScale(self.text, self.position.x, self.position.y, "left", self.scale, color)   
end

NumberPopUp = PopUp:subclass("NumberPopUp")

function NumberPopUp:initialize(number, color, scale, position)
  PopUp.initialize(self, color, scale, position)
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

ImagePopUp = PopUp:subclass("ImagePopUp")

function ImagePopUp:initialize(path, color, scale, position)
  PopUp.initialize(self, color, scale, position)
  self.image = love.graphics.newImage(path) or false
  self.dimensions = self.image and Dimensions(self.scale * self.image:getWidth(), self.scale * self.image:getHeight()) or Dimensions()
end

function ImagePopUp:draw()
  local color = Graphics:modifyColorAlpha(self.color, self.alpha)
  Graphics:drawWithScale(self.image, self.position.x, self.position.y, self.scale, color)
end