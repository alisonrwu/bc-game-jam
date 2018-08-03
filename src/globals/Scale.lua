scaleinator = require "modules/scaleinator".create()
Scale = class("Scale")

function Scale:initialize(resolution)
  self.scalingFactor = 1
  self.translationX = 0
  self.translationY = 0
  self.unflooredFactor = 1
  self.menuBG = ImagePlaceable(("assets/graphics/menu/bg/bg_menu%s.png"):format(resolution.name))
  self.gameBG = ImagePlaceable(("assets/graphics/game/bg/bg_game%s.png"):format(resolution.name))
  
  scaleinator:newmode(resolution.name, resolution.width, resolution.height) 
	scaleinator:update(love.graphics.getWidth(), love.graphics.getHeight()) -- desired resolution
  self.scalingFactor = scaleinator:getFactor() 
  self.unflooredFactor = scaleinator:getunflooredfactor()
  self.translationX, self.translationY = scaleinator:getTranslation() -- after scaling, x and y required to center screen
end

function Scale:draw()
  love.graphics.scale(self.unflooredFactor)
  local stateName = tostring(state)
  if stateName == "MainMenu" or stateName == "Instructions" or stateName == "Shop" or stateName == "Details" or stateName == "Achievements" then 
    self.menuBG:draw()
  elseif stateName == "Game" then
    self.gameBG:draw()
  end
  love.graphics.scale(1/self.unflooredFactor, 1/self.unflooredFactor)
  love.graphics.translate(self.translationX, self.translationY)
  love.graphics.scale(self.scalingFactor)
end

function Scale:worldToScreenBounds(bounds)
  local minX = (bounds.minX * self.scalingFactor) + self.translationX
  local maxX = (bounds.maxX * self.scalingFactor) + self.translationX
  local minY = (bounds.minY * self.scalingFactor) + self.translationY
  local maxY = (bounds.maxY * self.scalingFactor) + self.translationY
  return Bounds(minX, maxX, minY, maxY)
end

function Scale:screenToWorldCoordinates(coordinates)
  local x = (coordinates.x - self.translationX) / self.scalingFactor
  local y = (coordinates.y - self.translationY) / self.scalingFactor
  return Point(x, y)
end

function Scale:getWorldMouseCoordinates()
  local screenCoordinates = Point(love.mouse.getX(), love.mouse.getY())
  return self:screenToWorldCoordinates(screenCoordinates)
end