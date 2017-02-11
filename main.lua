function love.load()
   love.graphics.setBackgroundColor(255,255,255)
   love.graphics.setPointSize( 5 )
   drawing = {}
   mouseX = 0
   mouseY = 0
   lastMouseX = 0
   lastMouseY = 0
   width = love.graphics.getWidth()
   height = love.graphics.getHeight()
   love.graphics.setLineWidth(3)
   angle = 0
   scale = love.graphics.newImage("Graphics/UI/Scale.png")
   scissors = love.graphics.newImage("Graphics/UI/Scissors.png")
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
	if (love.mouse.isDown(1)) then
		table.insert(drawing, {x = mouseX, y = mouseY, lastX = lastMouseX, lastY = lastMouseY})
	end
end

function love.draw()	
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.draw(scale, 50, height - 100)
	for i,v in ipairs(drawing) do
   		love.graphics.line(v.x, v.y, v.lastX, v.lastY)
   	end
   	if ((lastMouseY ~= mouseY or lastMouseX ~= mouseX) and drawing[#drawing - 10] ~= nil and love.mouse.isDown(1)) then
   		angle = math.angle(mouseX, mouseY, drawing[#drawing - 5].x, drawing[#drawing - 5].y)
   	end
   	love.graphics.draw(scissors, love.mouse.getX(), love.mouse.getY(), 
   		angle, 1, 1, scissors:getWidth()/2, scissors:getHeight()/2)
end

function math.angle(x1,y1, x2,y2) 
	return math.atan2(y2-y1, x2-x1) 
end