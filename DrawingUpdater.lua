DrawingUpdater = {}

-- Responsibility: 
--    Fill the "drawing" table inside of the GameState with lines.
--    Also detect intersections, handle intersections and "finish" the drawing.

-- Need to find a way to keep context of the class members when calling functions attached to the class.

function DrawingUpdater:update(cl, cd)
  -- Find a better way to copy the current line and insert it into the current drawing?
  currentLine = cl
  currentDrawing = cd
  local line = {x = currentLine.x, y = currentLine.y, lastX = currentLine.lastX, lastY = currentLine.lastY}
  table.insert(currentDrawing, line)
  
  if DrawingUpdater:checkIntersection() then
    DrawingUpdater:cleanUpIntersection()
    DrawingUpdater:redrawToIntersection()
    drawingDone = true
  end
end

function DrawingUpdater:load()
  drawingDone = false
  intersectionIndex = 0
  intersectionX = 0
  intersectionY = 0
end

-- Check every single line segment in the drawing and see if ANY intersect with the current drawn line.
function DrawingUpdater:checkIntersection()
  for i = 1, #currentDrawing - 10 do
    if DrawingUpdater:isIntersecting(currentDrawing[i].x, currentDrawing[i].y, currentDrawing[i].lastX, currentDrawing[i].lastY, currentLine.x, currentLine.y, currentLine.lastX, currentLine.lastY, true, true) then
      intersectionIndex = i
      return true
    end
  end
  return false
end

-- Clean up the intersection by removing all the line segments that exist at the end and beginning of the intersection.
function DrawingUpdater:cleanUpIntersection()
  for j = 1, intersectionIndex do 
    table.remove(currentDrawing, 1)
  end
  table.remove(currentDrawing, #currentDrawing)
end

-- Redraw the parts before and after the intersection that were removed.
function DrawingUpdater:redrawToIntersection()    
    startToIntersectionPoint = {x = intersectionX, y = intersectionY, lastX = currentDrawing[1].lastX, lastY = currentDrawing[1].lastY}  
    endToIntersectionPoint = {x = intersectionX, y = intersectionY, lastX = currentDrawing[#currentDrawing].x, lastY = currentDrawing[#currentDrawing].y}        
    table.insert(currentDrawing, 1, startToIntersectionPoint)
    table.insert(currentDrawing, endToIntersectionPoint)    
end

-- Determines whether or not two lines are intersecting and saves the coordinates of the intersection.
function DrawingUpdater:isIntersecting(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y, seg1, seg2)
	local a1,b1,a2,b2 = l1p2y-l1p1y, l1p1x-l1p2x, l2p2y-l2p1y, l2p1x-l2p2x
	local c1,c2 = a1*l1p1x+b1*l1p1y, a2*l2p1x+b2*l2p1y
	local det,x,y = a1*b2 - a2*b1
  
	if det==0 then return false, "The lines are parallel." end
	x, y = (b2*c1-b1*c2)/det, (a1*c2-a2*c1)/det
	
  if seg1 or seg2 then
		local min,max = math.min, math.max
		if seg1 and not (min(l1p1x,l1p2x) <= x and x <= max(l1p1x,l1p2x) and min(l1p1y,l1p2y) <= y and y <= max(l1p1y,l1p2y)) or
			seg2 and not (min(l2p1x,l2p2x) <= x and x <= max(l2p1x,l2p2x) and min(l2p1y,l2p2y) <= y and y <= max(l2p1y,l2p2y)) then
			return false, "The lines don't intersect."
		end
	end
  
  intersectionX = x
  intersectionY = y
    
  return true
end

function DrawingUpdater:getDrawingDone()
  return drawingDone
end

function DrawingUpdater:setDrawingDone(boolean)
  drawingDone = boolean
end