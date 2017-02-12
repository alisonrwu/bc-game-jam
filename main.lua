require"TEsound"
ScoreManager = require('ScoreManager')
local ScoreManager = require('ScoreManager')
local MenuManager = require('MenuManager')

function love.load()
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setPointSize( 5 )
	drawing = {}
	toBeRemoved = {}
	mouseX = 0
	mouseY = 0
	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()
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
	indexToRemoveTo = 0
	isDrawing = true
	scored = true
	scoreTable = {}
	generated = false
	rand1 = 0
	rand2 = 0
	currentScore = 0
	font = love.graphics.newImageFont("Graphics/UI/Imagefont.png",
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
		"123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font)
    isMenu = true
    isPressed = false
    isTransitioning = false
    music = false
    timer = 0
    alpha = 0
   fadein  = 1
   display = 1.2
   fadeout = 2.5
end


function love.update(dt)
    if(isTransitioning) then
            timer=timer+dt
  if timer<fadein then alpha=timer*3 print("Fade in: ", alpha) -- still fading in
  elseif timer<display then alpha=1 print("Display: ", alpha)
  elseif timer<fadeout then alpha=1-((timer-display)/(fadeout-display)) print("Fade out: ", alpha)
            isMenu = false
  else alpha=0 end
            end
    
    if (isMenu) then
        menuUpdate(dt)
    else 
        gameUpdate()
    end
end

function love.draw()	
    if (isMenu) then
        menuDraw()
    else 
        gameDraw()
    end
end

function gameUpdate()
	if (not music) then
		TEsound.playLooping("Sounds/Music/Paper Cutter.ogg")
		music = true
	end
    TEsound.cleanup()
    
    --setup RNG for current problem
	if (generated == false) then
		rand1 = love.math.random(12) / 2
		rand2 = love.math.random(12) / 2
		generated = true
	end
    
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
				player.score = player.score + math.floor(ScoreManager.rectangleScoring(drawing, rand1, rand2))
                currentScore = math.floor(ScoreManager.rectangleScoring(drawing, rand1, rand2))
				table.insert(scoreTable, {x = mouseX, y = mouseY, score = ScoreManager.rectangleScoring(drawing, rand1, rand2), alpha = 255, boxWidth = intersectionX, boxHeight = intersectionY})
				displayScore()
				scored = true
			end
		end
		if (drawing[1] and intersectionX and intersectionY) then
			intersectionPoint1 = {x = drawing[1].lastX, y = drawing[1].lastY, lastX = intersectionX, lastY = intersectionY}
			table.insert(drawing, 1, intersectionPoint1)
		end
		ScoreManager.rectangleScoring(drawing, rand1, rand2)
		toBeRemoved = {}
	end
end    

------------------------------------------------------------------- Called on every frame to draw the game
function gameDraw()
    --ScoreManager.drawBox()
    if (scored == true) then
		ScoreManager.drawRectangle()
		end	

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
		love.graphics.print("Score: " .. player.score, width - 225, height - 50)
		love.graphics.draw(scale, 25, height - 75)
		love.graphics.draw(textBubble, 10, 10)
		drawTextBubble(currentScore)
		displayScore()
end    

------------------------------------------------------------------- Called on every frame to draw the menu
function menuDraw()
    for i, button in ipairs(MenuManager) do
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(button.image, button.x, button.y)
        end
    
    if (isTransitioning) then
    love.graphics.setColor(255, 255, 255, alpha*255)
    love.graphics.rectangle("fill", 0, 0, screenWidth, screenHeight)
    end

    isPressed = false
end    

------------------------------------------------------------------- Called on every frame to update the menu
function menuUpdate(dt)
    for i, button in ipairs(MenuManager) do
        mouseX = love.mouse.getX()
        mouseY = love.mouse.getY()
        buttonWidth = button.image:getWidth()
        buttonHeight = button.image:getHeight()
    
        if ((pointInRectangle(mouseX, mouseY, button.x, button.y, buttonWidth, buttonHeight)) and isPressed) then
            button.press()
            print("Pressed a button")
            end
        
        
        end    
    end
            
function pointInRectangle(pointx, pointy, rectx, recty, rectwidth, rectheight)
    return pointx > rectx and pointy > recty and pointx < rectx + rectwidth and pointy < recty + rectheight
end            

------------------------------------------------------------------- Angle calculator for scissors
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
	if (button == 1 and scored == true and isMenu == false) then 
		mouseDown = true
		isDrawing = true
		drawing = {}
		TEsound.playLooping("Sounds/SFX/Cutting.ogg", "cutting")
		ScoreManager.reset()
		scored = false
		generated = false
	end
end

function displayScore()
	for i,v in ipairs(scoreTable) do
		love.graphics.setColor(255, 255, 255, v.alpha)
		if v.score < 0 then
			love.graphics.print(math.floor(v.score), v.boxWidth, v.boxHeight)
		else
		love.graphics.print("+" .. math.floor(v.score), v.boxWidth, v.boxHeight)
	end
		v.alpha = v.alpha - 2
		v.boxHeight = v.boxHeight - 2
		if (v.alpha < 0) then
			table.remove(v)
		end
	end
end

function drawTextBubble(score)
	if (not scored) then
		love.graphics.print("Give me a, uh, ".. rand1 .. " x " .. rand2 .. ", pronto!", 20, 20)
	else 
		if (score < 0)  then
			love.graphics.print("You're paying for that.", 20, 20)
		end
		if (score >= 0 and score < 20) then
			love.graphics.print("What are you doing?!", 20, 20)
		end
		if (score >= 20 and score < 70) then
			love.graphics.print("Are you a monkey?", 20, 20)
		end
		if (score >= 70 and score < 100) then
			love.graphics.print("Close but not really.", 20, 20)
		end
		if (score >= 100) then
			love.graphics.print("Don't get cocky.", 20, 20)
		end
	end
end   
     
            
function love.mousereleased(x, y, button, istouch)
    isPressed = true
end

