Math = {}

-- Returns the intersection of two line segments.
-- This intersection method uses Cramer's Rule. I did not originally write this, but I did modify it.
function Math:getLineSegsIntersection(l1, l2)
  -- a1 + b1 = c1 where a1 is the co-efficient of x and b1 is the co-efficient of y
  -- a2 + b2 = c2 where a2 is the co-efficient of x and b2 is the co-efficient of y
	local a1,b1,a2,b2 = l1.p2.y-l1.p1.y, l1.p1.x-l1.p2.x, l2.p2.y-l2.p1.y, l2.p1.x-l2.p2.x 
	local c1,c2 = a1*l1.p1.x+b1*l1.p1.y, a2*l2.p1.x+b2*l2.p1.y
	local det = a1*b2 - a2*b1   -- form a matrix from both line equations and find the determinant
  local x, y = (b2*c1-b1*c2)/det, (a1*c2-a2*c1)/det -- solve for x and y
  local intersection = Point(x, y)

  if det == 0 and x == 0 and y == 0 then return false end -- the lines are the same line
  if det == 0 and x ~= 0 and y ~= 0 then return false end -- the lines are parallel
	
	if Math:isIntersectionWithinSegment(l1, intersection) and Math:isIntersectionWithinSegment(l2, intersection) then
    return intersection
  else
    return false
  end
end

-- Checks if the intersection is within bounds of the line segment.
function Math:isIntersectionWithinSegment(segment, intersection)
  local min, max = math.min, math.max
  local x, y = intersection.x, intersection.y
  local minX = min(segment.p1.x, segment.p2.x)
  local maxX = max(segment.p1.x, segment.p2.x)
  local minY = min(segment.p1.y, segment.p2.y)
  local maxY = max(segment.p1.y, segment.p2.y)
  
  return (x >= minX and x <= maxX and y >= minY and y <= maxY) 
end

-- Calculates the percentage of how much area was covered in the "correct" polygon by the "attempt" polygon.
-- Optimized by reducing the amount of area needed to check by multiplying everything by reductionFactor.
function Math:calculateSuccessPercentageOptimized(attempt, correct, bounds, reductionFactor)
  local reducedAttempt = Math:reducePoints(attempt, reductionFactor)
  local reducedCorrect = Math:reducePoints(correct, reductionFactor)
  local reducedBounds = Math:reduceBounds(bounds, reductionFactor)
  
  return Math:calculateSuccessPercentage(reducedAttempt, reducedCorrect, reducedBounds)
end

function Math:reducePoints(points, reductionFactor)
  local reduced = {}
  for _, point in ipairs(points) do
    local reducedPoint = {x = point.x * reductionFactor, y  = point.y * reductionFactor}
    table.insert(reduced, reducedPoint)
  end
  return reduced
end

function Math:reduceBounds(bounds, reductionFactor)
  local reduced = {}
  reduced.minX = bounds.minX * reductionFactor
  reduced.maxX = bounds.maxX * reductionFactor
  reduced.minY = bounds.minY * reductionFactor
  reduced.maxY = bounds.maxY * reductionFactor
  return reduced
end

-- Given two bounding boxes, return the maximum bounding box covering both.
function Math:calculateMaximumBounds(b1, b2)
  local min, max = math.min, math.max
  local minX = min(b1.minX, b2.minX)
  local maxX = max(b1.maxX, b2.maxX)
  local minY = min(b1.minY, b2.minY)
  local maxY = max(b1.maxY, b2.maxY)
  return Bounds(minX, maxX, minY, maxY)
end

-- Calculates the percentage of how much area was covered in the "correct" polygon by the "attempt" polygon.
function Math:calculateSuccessPercentage(attempt, correct, bounds)
    local successes = 0
    local pointsChecked = 0
    
    for i = bounds.minX, bounds.maxX, 1 do
        for j = bounds.minY, bounds.maxY, 1 do
            local testPoint = {x = i, y = j}
            local insideDrawing = self:isPointInsidePolygon(testPoint, attempt)
            local insideShape = self:isPointInsidePolygon(testPoint, correct)
            
            if insideDrawing or insideShape then
                pointsChecked = pointsChecked + 1
            end
            
            if insideDrawing and insideShape then
                successes = successes + 1
            end
        end
    end
    
    local successPercentage = successes / pointsChecked
    
    print("SuccessP = ", successPercentage)
    
    return successPercentage
end


-- Checks if a point is inside a polygon.
function Math:isPointInsidePolygon(point, polygon)
    local x = point.x
    local y = point.y
    
    local inside = false
    local lastPoint = polygon[#polygon]
    for _, p in ipairs(polygon) do
        local xi = p.x
        local yi = p.y
        
        local xj = lastPoint.x
        local yj = lastPoint.y
        
        lastPoint = p
        
        local intersect = ((yi > y) ~= (yj > y)) and (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
        if intersect then
            inside = not inside
        end
    end
    
    return inside
end

function Math:calculateAngleOfTwoLines(line1, line2) 
	return math.atan2(line2.p1.y - line1.p1.y, line2.p1.x - line1.p1.x) 
end