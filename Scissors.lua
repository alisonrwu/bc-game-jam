local Scissors = {}

scissors1 = love.graphics.newImage("Graphics/UI/Scissors.png")
scissors2 = love.graphics.newImage("Graphics/UI/Scissors2.png")
frameCounter = 0


local function draw(mouseX, mouseY, lastMouseX, lastMouseY, drawing, mouseDown)

	-- Determining angle for the scissors
	if ((lastMouseY ~= mouseY or lastMouseX ~= mouseX) and drawing[#drawing - 10] ~= nil and mouseDown) then
		angle = math.angle(mouseX, mouseY, drawing[#drawing - 5].x, drawing[#drawing - 5].y)
	end

	-- Draw the scissors
	love.graphics.setColor(255, 255, 255, 255)
	if (frameCounter < 11) then
		love.graphics.draw(scissors1, love.mouse.getX(), love.mouse.getY(), angle, 1, 1, scissors1:getWidth()/2, scissors1:getHeight()/2) 
		if mouseDown and Game:isMouseMoving()  then
			frameCounter = frameCounter + 1
		end
	else
		love.graphics.draw(scissors2, love.mouse.getX(), love.mouse.getY(), angle, 1, 1, scissors2:getWidth()/2, scissors2:getHeight()/2)
		if mouseDown and Game:isMouseMoving()  then
			frameCounter = frameCounter + 1
			if (frameCounter >= 21) then
				frameCounter = 0
			end
		end
	end
end

local function setFrameCounter(number)
	frameCounter = number
end

Scissors.draw = draw
Scissors.setFrameCounter = setFrameCounter

return Scissors