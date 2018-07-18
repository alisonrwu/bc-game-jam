scaleinator = require "modules/scaleinator".create()
Scale = {
    scalingFactor = 1,
    translationX = 0,
    translationY = 0
}

function Scale:init()
  local resName = baseRes.width .. "x" .. baseRes.height
  scaleinator:newmode(resName, baseRes.width, baseRes.height) 
	scaleinator:update(love.graphics.getWidth(), love.graphics.getHeight()) -- desired resolution
  Scale.scalingFactor = scaleinator:getFactor() 
  Scale.translationX, Scale.translationY = scaleinator:getTranslation() -- after scaling, x and y required to center screen
end

function Scale:draw()
  love.graphics.translate(Scale.translationX, Scale.translationY)
  love.graphics.scale(Scale.scalingFactor)
end

function Scale:screenToWorldCoordinates(screenCoordinates)
  local x = (screenCoordinates.x - Scale.translationX) / Scale.scalingFactor
  local y = (screenCoordinates.y - Scale.translationY) / Scale.scalingFactor
  return Point(x, y)
end

function Scale:getWorldMouseCoordinates()
  local screenCoordinates = Point(love.mouse.getX(), love.mouse.getY())
  return Scale:screenToWorldCoordinates(screenCoordinates)
end