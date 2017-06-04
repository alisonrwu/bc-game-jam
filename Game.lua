Game = {}

function Game:update(dt)
  Scissors:update(drawing, isDrawing, Game:isMouseMoving(), dt)


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
  Game:updateMouse()
  
    -- main drawing mechanic
    if isDrawing and Game:isMouseMoving() then
        point = {x = mouse.X, y = mouse.Y, lastX = mouse.lastX, lastY = mouse.lastY}
        table.insert(drawing, point)
        
    -- main intersection mechanic
    for i = 1, #drawing - 10 do
    	if drawing[i].x and drawing[i].y and drawing[i].lastX and drawing[i].lastY then
    		if Math:checkMouseIntersection(drawing, mouse, i) then
    			isDrawing = false
                canPlaySound = true
                TEsound.play("Sounds/SFX/Snip.ogg", "snip")        
    			TEsound.stop("cutting", false)
    			Scissors:closeScissors()
    			for j = 1, i do
    				table.insert(toBeRemoved, i)
	    		end
	    	end
	    end
	  end
       

  -- handle sound
  if not Game:isMouseMoving() then
  	TEsound.pause("cutting")
  else
  	TEsound.resume("cutting")
  end    

  -- remove the beginning part of the shape
 if (not isDrawing) then
    Game:cleanUpShape()
    intersectionX = Math:getLastIntersectionX()
    intersectionY = Math:getLastIntersectionY()        
	
         if (intersectionX and intersectionY) then
            startToIntersectionPoint = {x = intersectionX, y = intersectionY, lastX = drawing[1].lastX, lastY = drawing[1].lastY}  
            endToIntersectionPoint = {x = intersectionX, y = intersectionY, lastX = drawing[#drawing].x, lastY = drawing[#drawing].y}             
			table.insert(drawing, 1, startToIntersectionPoint)
			table.insert(drawing, endToIntersectionPoint)    
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
                
			table.insert(scoreTable, {x = mouse.X, y = mouse.Y, score = currentScore, alpha = 255, boxWidth = intersectionX, boxHeight = intersectionY, targetUp = showTargetUp, pickRect = pickRect, pickOval = pickOval})
            
			displayScore(showTargetUp)
                
            remainingTimeAtLastScoring = remainingTime
            generated = false
            isDrawing = false
			scored = true
    end           
		toBeRemoved = {}
	end
end  --???      

	
end    

------------------------------------------------------------------- Called on every frame to draw the Game
function Game:draw()
  love.graphics.setColor(255, 255, 255, 255)
  Graphics:draw(BG, 0, 0, NORMAL)

  --Draw all the lines the user has drawn already
  for i,v in ipairs(drawing) do
    if (isDrawing) then
            Graphics:drawLine(v.x, v.y, v.lastX, v.lastY, Graphics.GRAY)
        else
            Graphics:drawLine(v.x, v.y, v.lastX, v.lastY, Graphics.BLACK)
        end
    end    

  	--draw scissors
	Scissors:draw(mouse)

	--Draw UI elements
	love.graphics.setColor(255, 255, 255, 255)
	drawTimer(player.score, scoreThreshold)
    Graphics:draw(textBubble, 10, 10, Graphics.NORMAL)
	drawTextBubble(currentScore)
	displayScore()
    love.graphics.setColor(255, 255, 255, 255)
    
    love.graphics.print("Paycheck: " .. player.score, width - 275, height - 50)
    love.graphics.print("Target: " .. scoreThreshold, width - 220, 55)
    love.graphics.draw(scale, 30 * windowScale, height - 105 * windowScale)    
    
    
end    

function Game:load()
    love.mouse.setVisible(false)
    Scissors:load()
    mouse = {}
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
    isDrawing = false
    mouseReleased = true
	angle = 0
	indexToRemoveTo = 0
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

function Game:isMouseMoving()
    return ((mouse.X ~= mouse.lastX) or (mouse.Y ~= mouse.lastY))
end    

function Game:updateMouse()
    mouse.lastX = mouse.X 
    mouse.lastY = mouse.Y    
    mouse.X = love.mouse.getX()
    mouse.Y = love.mouse.getY()
end    

function Game:cleanUpShape()
  	for i = 1, #toBeRemoved do 
        table.remove(drawing, 1)
    end
		table.remove(drawing, #drawing)
end    
