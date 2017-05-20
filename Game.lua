Game = {}

function Game:update(dt)
  love.mouse.setVisible(false)

	-- decrement Timer
	remainingTime = remainingTime - dt
	if remainingTime <= 0 then
		setState(GameOver)
	end

	if (not music) then
		TEsound.stop("menuTheme")
		TEsound.playLooping("Sounds/Music/Paper Cutter.ogg", "music")
		music = true
	end
	TEsound.cleanup()

  --setup RNG for current problem
  if (generated == false) then Game:generateProblem() end
  if targetUp > 2 then addOvals = true end
  Game:pickShape()      
    
  lastMouseX = mouseX
  lastMouseY = mouseY
  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()

  
    -- main drawing mechanic
    if mouseDown and ((mouseX ~= lastMouseX) or (mouseY ~= lastMouseY)) then
    	if (isDrawing) then
    		table.insert(drawing, {x = mouseX, y = mouseY, lastX = lastMouseX, lastY = lastMouseY})
    	end
    -- main intersection mechanic
    for i = 1, #drawing - 10 do
    	if drawing[i].x and drawing[i].y and drawing[i].lastX and drawing[i].lastY then
    		if isIntersecting(drawing[i].x, drawing[i].y, drawing[i].lastX, drawing[i].lastY, mouseX, mouseY, lastMouseX, lastMouseY, true, true) then
    			print("I am running")
    			isDrawing = false
                canPlaySound = true
                TEsound.play("Sounds/SFX/Snip.ogg", "snip")        
    			TEsound.stop("cutting", false)
    			Scissors.setFrameCounter(20)
    			for j = 1, i do
    				table.insert(toBeRemoved, i)
	    		end
	    	end
	    end
	  end
       

  -- handle sound
  if (not((mouseX ~= lastMouseX) or (mouseY ~= lastMouseY))) then
  	TEsound.pause("cutting")
  else
  	TEsound.resume("cutting")
  end    

  -- remove the beginning part of the shape
  if (not isDrawing) then
  	for i = 1, #toBeRemoved do 
			-- print("to be removed index: ", i)
			table.remove(drawing, 1)
		end
		table.remove(drawing, #drawing)

		if (drawing[#drawing] and intersectionX and intersectionY) then
			intersectionPoint2 = {x = intersectionX, y = intersectionY, lastX = drawing[#drawing].x, lastY = drawing[#drawing].y}
			table.insert(drawing, intersectionPoint2)
		end
          
		if (drawing[1] and intersectionX and intersectionY) then
			intersectionPoint1 = {x = drawing[1].lastX, y = drawing[1].lastY, lastX = intersectionX, lastY = intersectionY}
			table.insert(drawing, 1, intersectionPoint1)
		end
            
    if scored == false then
			local score = 0
			if pickRect then
				score = math.floor(ScoreManager.rectangleScoring(drawing, rand1, rand2))
			elseif pickOval then
				score = math.floor(ScoreManager.ovalScoring(drawing, rand1, rand2))
			end
			player.score = player.score + score
			currentScore = score * comboBonus
			comboBonus = comboBonus + 0.05
            
            
            showTargetUp = false
            if (player.score >= scoreThreshold) then
                showTargetUp = true
                remainingTime = resetTime
                remainingTimeAtLastScoring = resetTime
                extraScore = extraScore + 100
                scoreThreshold = scoreThreshold + extraScore
                targetUpOld = targetUp
                targetUp = targetUp + 1
                if (canPlaySound) then
                  TEsound.play("Sounds/SFX/newTarget.ogg", "newTarget")
                  canPlaySound = false
                end
            end
                
			table.insert(scoreTable, {x = mouseX, y = mouseY, score = currentScore, alpha = 255, boxWidth = intersectionX, boxHeight = intersectionY, targetUp = showTargetUp, pickRect = pickRect, pickOval = pickOval})
            
			displayScore(showTargetUp)
                
            remainingTimeAtLastScoring = remainingTime
            generated = false
            mouseDown = false
			scored = true
    end           
		toBeRemoved = {}
	end
end  --???      

	
end    

------------------------------------------------------------------- Called on every frame to draw the Game
function Game:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(BG, 0, 0, 0, windowScale, windowScale)

  --Draw all the lines the user has drawn already
  if (isDrawing) then
  	love.graphics.setColor(126, 126, 126, 255)
  else
  	love.graphics.setColor(0, 0, 0, 255)
  end

  for i,v in ipairs(drawing) do
  	love.graphics.line(v.x, v.y, v.lastX, v.lastY)
  end

  	--draw scissors
	Scissors.draw(mouseX, mouseY, lastMouseX, lastMouseY, drawing, mouseDown)

	--Draw UI elements
	love.graphics.setColor(255, 255, 255, 255)
	drawTimer(player.score, scoreThreshold)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(textBubble, 10, 10)
	drawTextBubble(currentScore)
	displayScore()
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Paycheck: " .. player.score, width - 275, height - 50)
		love.graphics.print("Target: " .. scoreThreshold, width - 220, 55)
		love.graphics.draw(scale, 30 * windowScale, height - 105 * windowScale)      
end    

function Game:load()
    currentScore = 0
    scoreThreshold = 100
    drawing = {}
    player = {}
    player.score = 0
    toBeRemoved = {}
    scoreTable = {}
    drawing = {}
	toBeRemoved = {}
    player = {}
	player.score = 0
    remainingTime = 50
    remainingTimeAtLastScoring = 60
    comboBonus = 1
	heartbeat = false
     targetUpOld = 0
  targetUp = 0
  addOvals = false
  pickOval = false
  pickRect = true
    resetTime = 50
	scoreThreshold = 100
	extraScore = 0
    rand1 = 0
	rand2 = 0
	currentScore = 0
    mouseDown = false
    mouseReleased = true
	angle = 0
	indexToRemoveTo = 0
	isDrawing = true
    scored = true
	scoreTable = {}
	generated = false
end    

function Game:mouseRelease(x, y, button, istouch)
  isPressed = true
    
    if(not mouseReleased and button == 1) then
        mouseReleased = true
    end
end    

function Game:mousePressed(x, y, button, istouch)    
	if (button == 1 and scored == true) then 
		mouseDown = true
		isDrawing = true
		drawing = {}
		TEsound.playLooping("Sounds/SFX/Cutting.ogg", "cutting")
		ScoreManager.reset()
		scored = false
	end
end

function Game:pickShape()
  if addOvals then
  	if rand1 > 3 then
  		pickRect = true
  		pickOval = false
  	else
  		pickRect = false
  		pickOval = true
  	end
  end
end

function Game:generateProblem()
    rand1 = love.math.random(12) / 2
  	rand2 = love.math.random(12) / 2
  	generated = true
end  
