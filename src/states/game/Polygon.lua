Polygon = class("Polygon")
Polygon.static.LEEWAY = 10

function Polygon:initialize()
  self.points = {}
  self.lines = {} 
  self.bounds = Bounds()
  self.dimensions = Dimensions()
  self.centre = Point()
  self.closed = false
end

local myMath = Math

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
  for i = 1, #self.lines - Polygon.LEEWAY do
    local currentLine = self.lines[#self.lines]
    local line = self.lines[i]
    local intersection = myMath:getLineSegsIntersection(currentLine, line)
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
    local mouseCoord = scale:getWorldMouseCoordinates()
    local point = self:getLatestPoint()
    return point.x == mouseCoord.x and point.y == mouseCoord.y
  end 
end

function Polygon:updateValues()
  self:reducePoints()
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

function Polygon:getLatestPoint()
  return self.points[#self.points]
end

function Polygon:reducePoints()
  local points = self.points
  i = 1
  while i <= #points do
    local firstIndex = i
    local secondIndex = (i + 1) % (#points + 1)
    local thirdIndex = (i + 2) % (#points + 1)
    if secondIndex == 0 then secondIndex = 1 end
    if thirdIndex == 0 then thirdIndex = 1 end
    
    local firstPt = points[firstIndex]
    local secondPt = points[secondIndex]
    local thirdPt = points[thirdIndex]
    
    if firstPt == secondPt or secondPt == thirdPt or firstPt == thirdPt then return end
    
      local function inBetween(a, b, c)
        -- we want to check if b is in-between a and c
        local sqrt = math.sqrt
        local ab = sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y))
        local bc = sqrt((b.x - c.x) * (b.x - c.x) + (b.y - c.y) * (b.y - c.y))
        local ac = sqrt((a.x - c.x) * (a.x - c.x) + (a.y - c.y) * (a.y - c.y))
        if ab + bc == ac then return true else return false end
      end
    
    if inBetween(firstPt, secondPt, thirdPt, "horizontal") then 
      table.remove(points, secondIndex) 
    elseif inBetween(secondPt, thirdPt, firstPt, "horizontal") then
      table.remove(points, thirdIndex) 
    elseif inBetween(thirdPt, firstPt, secondPt, "horizontal") then
      table.remove(points, firstIndex) 
    else
      i = i + 1
    end
  end
  
  return points
end