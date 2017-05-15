Game = {}

function Game:update(dt)
  love.mouse.setVisible(false)

	-- decrement Timer
	remainingTime = remainingTime - dt
	if remainingTime <= 0 then
		gameOver = true
	end

	if (not music) then
		TEsound.stop("menuTheme")
		TEsound.playLooping("Sounds/Music/Paper Cutter.ogg", "music")
		music = true
	end
	TEsound.cleanup()

  --setup RNG for current problem
  if (generated == false) then
    rand1    = love.math.random(12) / 2
  	rand2 = love.math.random(12) / 2
  	generated = true
  end

  if targetUp > 2 then
  	-- TODO: draw some graphic to show ovals added
  	addOvals = true
  end
  if addOvals then
  	if rand1 > 3 then
  		pickRect = true
  		pickOval = false
  	else
  		pickRect = false
  		pickOval = true
  	end
  end
    
  -- exit game
  if love.keyboard.isDown('escape') then
  	love.event.push('quit')
  end
    
  lastMouseX = mouseX
  lastMouseY = mouseY
  mouseX = love.mouse.getX()
  mouseY = love.mouse.getY()

  if (not(gameOver)) then
    -- main drawing mechanic
    if mouseDown and ((mouseX ~= lastMouseX) or (mouseY ~= lastMouseY)) then
    	if (isDrawing) then
    		table.insert(drawing, {x = mouseX, y = mouseY, lastX = lastMouseX, lastY = lastMouseY})
    	end
    -- main intersection mechanic
    for i = 1, #drawing - 10 do
    	if drawing[i].x and drawing[i].y and drawing[i].lastX and drawing[i].lastY then
    		if isIntersect(drawing[i].x, drawing[i].y, drawing[i].lastX, drawing[i].lastY, mouseX, mouseY, lastMouseX, lastMouseY, true, true) then
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
			table.insert(scoreTable, {x = mouseX, y = mouseY, score = currentScore, alpha = 255, boxWidth = intersectionX, boxHeight = intersectionY})
			displayScore()
            remainingTimeAtLastScoring = remainingTime
            generated = false
            mouseDown = false
			scored = true
    end           
		toBeRemoved = {}
	end
end  --???      

	if (gameOver) then
		love.mouse.setVisible(true)
		TEsound.pitch("music", 0.9)
		TEsound.stop("heartbeat")
		drawing = {}
		ScoreManager.reset()
		mouseDown = false
		TEsound.stop("cutting")
	end
end    

------------------------------------------------------------------- Called on every frame to draw the game
function Game:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(BG, 0, 0)

  if (scored == true) then
  	if pickRect then
  		ScoreManager.drawRectangle()
		elseif pickOval then
  		ScoreManager.drawOval()
  	end
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

  	--draw scissors
	Scissors.draw(mouseX, mouseY, lastMouseX, lastMouseY, drawing, mouseDown)

	--Draw UI elements
	love.graphics.setColor(255, 255, 255, 255)
	drawTimer(player.score, scoreThreshold)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(textBubble, 10, 10)
	drawTextBubble(currentScore)
	displayScore()
	if (not gameOver) then
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print("Paycheck: " .. player.score, width - 275, height - 50)
		love.graphics.print("Target: " .. scoreThreshold, width - 220, 55)
		love.graphics.draw(scale, 30, height - 125)
	else
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("fill", 0, 0, width, height)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(textBubble, 10, 10)
		drawTextBubble(currentScore)
		drawTimer(player.score, scoreThreshold)
		displayScore()
	end         
end    

function Game:mouseRelease()
  
end    
