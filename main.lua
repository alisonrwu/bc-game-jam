require"TEsound"
ScoreManager = require('ScoreManager')

function love.load()
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setPointSize( 5 )
	drawing = {}
	toBeRemoved = {}
	mouseX = 0
	mouseY = 0
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	love.graphics.setLineWidth(3)
	angle = 0
	scale = love.graphics.newImage("Graphics/UI/Scale.png")
	scissors1 = love.graphics.newImage("Graphics/UI/Scissors.png")
	scissors2 = love.graphics.newImage("Graphics/UI/Scissors2.png")
	textBubble = love.graphics.newImage("Graphics/UI/TextBubble.png")
	player = {}
	player.score = 0
	lastMouseX = 0
	lastMouseY = 0
	frameCounter = 0
	TEsound.playLooping("Sounds/Music/Paper Cutter.ogg")
	indexToRemoveTo = 0
	isDrawing = true
	scored = true
	scoreTable = {}

	font = love.graphics.newImageFont("Graphics/UI/Imagefont.png",
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
		"123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font)
end

function love.update(dt)
	TEsound.cleanup()

	-- exit game
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	lastMouseX = mouseX
	lastMouseY = mouseY
	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()

	if mouseDown and ((mouseX ~= lastMouseX) or (mouseY ~= lastMouseY)) then
		if (isDrawing) then
			table.insert(drawing, {x = mouseX, y = mouseY, lastX = lastMouseX, lastY = lastMouseY})
		end

		for i = 1, #drawing - 10 do
			if drawing[i].x and drawing[i].y and drawing[i].lastX and drawing[i].lastY then
				if isIntersect(drawing[i].x, drawing[i].y, drawing[i].lastX, drawing[i].lastY, mouseX, mouseY, lastMouseX, lastMouseY, true, true) then
					print(i)
					isDrawing = false
					mouseDown = false
					TEsound.stop("cutting", false)
                    frameCounter = 18
					for j = 1, i do
						table.insert(toBeRemoved, i)
					end
					print('CUT')
				end
			end
		end
	end

	if (not mouseDown) then
		for i = 1, #toBeRemoved do 
			-- print("to be removed index: ", i)
			table.remove(drawing, 1)
		end
		table.remove(drawing, #drawing)

		if (drawing[#drawing] and intersectionX and intersectionY) then
			intersectionPoint2 = {x = intersectionX, y = intersectionY, lastX = drawing[#drawing].x, lastY = drawing[#drawing].y}
			table.insert(drawing, intersectionPoint2)
			if scored == false then
				player.score = player.score + math.floor(ScoreManager.squareScoring(drawing))
				table.insert(scoreTable, {x = mouseX, y = mouseY, score = ScoreManager.squareScoring(drawing), alpha = 255, boxWidth = intersectionX, boxHeight = intersectionY})
				displayScore()
				scored = true
			end
		end
		if (drawing[1] and intersectionX and intersectionY) then
			intersectionPoint1 = {x = drawing[1].lastX, y = drawing[1].lastY, lastX = intersectionX, lastY = intersectionY}
			table.insert(drawing, 1, intersectionPoint1)
		end

		toBeRemoved = {}
	end
end

function love.draw()
	ScoreManager.drawBox()
	ScoreManager.drawSquare()

	--Draw all the lines the user has drawn already
	if (isDrawing) then
		love.graphics.setColor(126, 126, 126, 255)
	else
		love.graphics.setColor(0, 0, 0, 255)
	end

	for i,v in ipairs(drawing) do
		love.graphics.line(v.x, v.y, v.lastX, v.lastY)
	end

	-- Determining angle for the scissors
	if ((lastMouseY ~= mouseY or lastMouseX ~= mouseX) and drawing[#drawing - 10] ~= nil and mouseDown) then
		angle = math.angle(mouseX, mouseY, drawing[#drawing - 5].x, drawing[#drawing - 5].y)
	end

	-- Draw the scissors
	love.graphics.setColor(255, 255, 255, 255)
	if (frameCounter < 9) then
		love.graphics.draw(scissors1, love.mouse.getX(), love.mouse.getY(), 
			angle, 1, 1, scissors1:getWidth()/2, scissors1:getHeight()/2) 
		if (mouseDown) and ((mouseX ~= lastMouseX) or (mouseY ~= lastMouseY))  then
			frameCounter = frameCounter + 1
			end else
			love.graphics.draw(scissors2, love.mouse.getX(), love.mouse.getY(), 
				angle, 1, 1, scissors2:getWidth()/2, scissors2:getHeight()/2)
			if (mouseDown) and ((mouseX ~= lastMouseX) or (mouseY ~= lastMouseY))  then
				frameCounter = frameCounter + 1
				if (frameCounter == 19) then
					frameCounter = 0
				end
			end
		end

		--Draw UI elements
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Score: " .. player.score, width - 200, height - 50)
		love.graphics.draw(scale, 25, height - 75)
		love.graphics.draw(textBubble, 10, 10)
		displayScore()
	end

function math.angle(x1,y1, x2,y2) 
	return math.atan2(y2-y1, x2-x1) 
	end

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
	intersectionX = x
	intersectionY = y
	return true --x,y
end

function love.mousepressed(x, y, button, istouch)
	if (button == 1) then 
		mouseDown = true
		isDrawing = true
		drawing = {}
		TEsound.playLooping("Sounds/SFX/Cutting.ogg", "cutting")
		ScoreManager.reset()
		scored = false
	end
end

function love.mousereleased(x, y, button, istouch)
	-- ScoreManager.squareScoring(drawing)
end

function displayScore()
	for i,v in ipairs(scoreTable) do
		love.graphics.setColor(255, 255, 255, v.alpha)
		love.graphics.print("+" .. math.floor(v.score), v.boxWidth, v.boxHeight)
		v.alpha = v.alpha - 2
		v.boxHeight = v.boxHeight - 2
		if (v.alpha < 0) then
			table.remove(v)
		end
	end
end
