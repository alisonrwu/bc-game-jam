function love.load()
	player = {}
	player.score = 0

	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setPointSize( 5 )
	drawing = {}
	lastMouseX = 0
	lastMouseY = 0
end

function love.update(dt)
	-- exit game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end
	lastMouseX = mouseX
	lastMouseY = mouseY
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	if love.mouse.isDown(1) and ((mouseX ~= lastMouseX) or (mouseY ~= lastMouseY)) then
		table.insert(drawing, {x = mouseX, y = mouseY, lastX = lastMouseX, lastY = lastMouseY})
		-- print('inserted')

		for i = 1, #drawing-20 do
			if drawing[i].x and drawing[i].y and drawing[i].lastX and drawing[i].lastY then
				if isIntersect(drawing[i].x, drawing[i].y, drawing[i].lastX, drawing[i].lastY, mouseX, mouseY, lastMouseX, lastMouseY, true, true) then
					print('CUT')
				end
			end
		end
	end

 end

 function love.draw()	
 	love.graphics.setColor(0, 0, 0, 255)
 	for i,v in ipairs(drawing) do
 		love.graphics.line(v.x, v.y, v.lastX, v.lastY)
 	end
 	love.graphics.rectangle('line', 50, 50, 100, 100)
 end

-- function hasValue(table, val)
--     for i,v in ipairs (table) do
--         if v == val then
--             return true
--         end
--     end
--     return false
-- end

-- Checks if two lines intersect (or line segments if seg is true)
-- Lines are given as four numbers (two coordinates)
function isIntersect(l1p1x,l1p1y, l1p2x,l1p2y, l2p1x,l2p1y, l2p2x,l2p2y, seg1, seg2)
	local a1,b1,a2,b2 = l1p2y-l1p1y, l1p1x-l1p2x, l2p2y-l2p1y, l2p1x-l2p2x
	local c1,c2 = a1*l1p1x+b1*l1p1y, a2*l2p1x+b2*l2p1y
	local det,x,y = a1*b2 - a2*b1
	if det==0 then return false, "The lines are parallel." end
	x,y = (b2*c1-b1*c2)/det, (a1*c2-a2*c1)/det
	if seg1 or seg2 then
		local min,max = math.min, math.max
		if seg1 and not (min(l1p1x,l1p2x) <= x and x <= max(l1p1x,l1p2x) and min(l1p1y,l1p2y) <= y and y <= max(l1p1y,l1p2y)) or
		   seg2 and not (min(l2p1x,l2p2x) <= x and x <= max(l2p1x,l2p2x) and min(l2p1y,l2p2y) <= y and y <= max(l2p1y,l2p2y)) then
			return false, "The lines don't intersect."
		end
	end
	return true --x,y
end
