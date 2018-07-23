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

function Scale:worldToScreenBounds(bounds)
  local minX = (bounds.minX * Scale.scalingFactor) + Scale.translationX
  local maxX = (bounds.maxX * Scale.scalingFactor) + Scale.translationX
  local minY = (bounds.minY * Scale.scalingFactor) + Scale.translationY
  local maxY = (bounds.maxY * Scale.scalingFactor) + Scale.translationY
  return Bounds(minX, maxX, minY, maxY)
end

function Scale:screenToWorldCoordinates(coordinates)
  local x = (coordinates.x - Scale.translationX) / Scale.scalingFactor
  local y = (coordinates.y - Scale.translationY) / Scale.scalingFactor
  return Point(x, y)
end

function Scale:getWorldMouseCoordinates()
  local screenCoordinates = Point(love.mouse.getX(), love.mouse.getY())
  return screenCoordinates
  --return Scale:screenToWorldCoordinates(screenCoordinates)
end