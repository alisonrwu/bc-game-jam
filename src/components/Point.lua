local static = {}
static.centreOf = function (bounds, dimensions)
    return Point(bounds.minX + dimensions.width * 0.5, bounds.minY + dimensions.height * 0.5)
end

Point = class("Point", static)

function Point:init(x, y)
  self.x, self.y = x or 0, y or 0
end

function Point.__eq(p1, p2)
  return p1.x == p2.x and p1.y == p2.y
end

function Point.__tostring(p)
  return ("Point: x = %i, y = %i"):format(p.x, p.y)
end
