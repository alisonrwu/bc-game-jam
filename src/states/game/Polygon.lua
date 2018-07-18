Polygon = class("Polygon", {leeway = 10})

function Polygon:init()
  self.points = {}
  self.lines = {} 
  self.bounds = Bounds()
  self.dimensions = Dimensions()
  self.centre = Point()
  self.closed = false
end

function Polygon:draw() 
  if self.intersection then 
    Graphics:drawLines(self.lines, Graphics.BLACK)
  else
    Graphics:drawLines(self.lines, Graphics.GRAY)
  end
end

function Polygon:insertPoint(point)
  table.insert(self.points, point)
  self:updateLatestLine()
end

function Polygon:updateLatestLine()
  if #self.points > 1 then
    local p1 = self.points[#self.points - 1]
    local p2 = self.points[#self.points]
    local line = Line(p1, p2)
    table.insert(self.lines, line)
  end
end

function Polygon:update()
  for i = 1, #self.lines - Polygon.leeway do
    local currentLine = self.lines[#self.lines]
    local line = self.lines[i]
    local intersection = Math:getLineSegsIntersection(currentLine, line)
    if intersection then 
      self:cleanUpIntersection(i)
      self:redrawToIntersection(intersection)
      self.closed = true
      return
    end
  end
end

function Polygon:cleanUpIntersection(indexOfIntersectingLine)
  for i = 1, indexOfIntersectingLine do 
    table.remove(self.lines, 1)
  end  
  table.remove(self.lines, #self.lines)
end

-- Redraw the parts before and after the intersection that were removed.
function Polygon:redrawToIntersection(intersection)
  local startToIntersection = Line(intersection, self.lines[1].p1)
  local endToIntersection = Line(self.lines[#self.lines].p2, intersection)
  table.insert(self.lines, 1, startToIntersection)
  table.insert(self.lines, endToIntersection)    
end

function Polygon:isMouseAtSamePoint()
  if self:isEmpty() then
    return false
  else 
    local mouseCoord = Scale:getWorldMouseCoordinates()
    local point = self:getLatestPoint()
    return point.x == mouseCoord.x and point.y == mouseCoord.y
  end 
end

function Polygon:updateValues()
  self.bounds = Bounds.ofPoints(self.points)
  self.dimensions = Dimensions.ofBounds(self.bounds)
  self.centre = Point.centreOf(self.bounds, self.dimensions)
end

function Polygon:isEmpty()
  return #self.points == 0
end

function Polygon:getLatestPoint()
  return self.points[#self.points]
end