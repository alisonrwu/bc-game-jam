function love.load()
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
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()
	if (love.mouse.isDown(1)) then
		table.insert(drawing, {x = mouseX, y = mouseY, lastX = lastMouseX, lastY = lastMouseY})
	end
	lastMouseX = mouseX
	lastMouseY = mouseY
end

function love.draw()	
	love.graphics.setColor(0, 0, 0, 255)
	for i,v in ipairs(drawing) do
   		love.graphics.line(v.x, v.y, v.lastX, v.lastY)
   	end
end