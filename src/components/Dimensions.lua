Dimensions = class("Dimensions")
Dimensions.static.ofBounds = function (bounds)
  local width = bounds.maxX - bounds.minX
  local height = bounds.maxY - bounds.minY
  return Dimensions(width, height) 
end

function Dimensions:initialize(width, height)
  self.width, self.height = width or 0, height or 0
end

function Dimensions.__eq(d1, d2)
  return d1.width == d2.width and d1.height == d2.height
end

function Dimensions.__lt(d1, d2)
  return d1.width < d2.width and d1.height < d2.height
end

function Dimensions.__tostring(d)
  return ("Dimensions: width = %i, height = %i"):format(d.width, d.height)
end

function Dimensions.__add(d1, d2)
  return Dimensions(d1.width + d2.width, d1.height + d2.height)
end
