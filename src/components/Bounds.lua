local MIN_VALUE = -math.huge
local MAX_VALUE = math.huge

Bounds = class("Bounds", static)
Bounds.static.ofPoints = function (points)
          local minX, maxX, minY, maxY = MAX_VALUE, MIN_VALUE, MAX_VALUE, MIN_VALUE
        for i = 1, #points do
          local point = points[i]
          if point.x < minX then
            minX = point.x
          end
          if point.x > maxX then
            maxX = point.x
          end
          if point.y < minY then
            minY = point.y
          end
          if point.y > maxY then
            maxY = point.y
          end
        end  
        return Bounds(minX, maxX, minY, maxY) 
end
Bounds.static.ofCentreAndDimensions = function(centre, dimensions)
  local minX = centre.x - (dimensions.width * 0.5)
  local maxX = centre.x + (dimensions.width * 0.5)
  local minY = centre.y - (dimensions.height * 0.5)
  local maxY = centre.y + (dimensions.height * 0.5)
  return Bounds(minX, maxX, minY, maxY) 
end
Bounds.static.ofTopLeftAndDimensions = function(topLeft, dimensions)
  local minX = topLeft.x
  local maxX = topLeft.x + dimensions.width
  local minY = topLeft.y
  local maxY = topLeft.y + dimensions.height
  return Bounds(minX, maxX, minY, maxY)
end

function Bounds:initialize(minX, maxX, minY, maxY)
  self.minX, self.maxX = minX or MAX_VALUE, maxX or MIN_VALUE
  self.minY, self.maxY = minY or MAX_VALUE, maxY or MIN_VALUE  
end

function Bounds:isWithin(point)
  return point.x > self.minX and point.x < self.maxX and point.y > self.minY and point.y < self.maxY
end

function Bounds.__eq(b1, b2)
  return b1.minX == b2.minX and b1.maxX == b2.maxX and b1.minY == b2.minY and b1.maxY == b2.maxY
end

function Bounds.__tostring(b)
  return ("Bounds: minX = %i, maxX = %i, minY = %i, maxY = %i"):format(b.minX, b.maxX, b.minY, b.maxY)
end

function Bounds:draw()
  Graphics:drawRect(self.minX, self.minY, self.maxX - self.minX, self.maxY - self.minY)
end