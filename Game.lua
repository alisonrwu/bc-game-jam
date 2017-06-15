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
  if targetUpCounter > 2 then addOvals = true end
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
                -- Game crashes when it indexes drawing (probably no points left)
                -- Huge bug
                
			table.insert(drawing, 1, startToIntersectionPoint)
			table.insert(drawing, endToIntersectionPoint)    
		end
          
			if pickRect then
				ptsForShape = math.floor(ScoreManager:rectangleScoring(drawing, rand1, rand2))
			elseif pickOval then
				ptsForShape = math.floor(ScoreManager:ovalScoring(drawing, rand1, rand2))
			end
                
			playerScore = playerScore + ptsForShape
                
            if (playerScore >= scoreThreshold) then
                Game:updateTimeAndScore()    
        
                if (canPlaySound) then
                  TEsound.play("Sounds/SFX/newTarget.ogg", "newTarget")
                  canPlaySound = false
                end
            end        

			table.insert(ptsForShapeTable, {x = mouse.X, y = mouse.Y, score = ptsForShape, alpha = 255, boxWidth = intersectionX, boxHeight = intersectionY, targetUp = playerScore >= scoreThreshold, pickRect = pickRect, pickOval = pickOval})
                
            remainingTimeAtLastScoring = remainingTime
            generated = false
            toBeRemoved = {}
	   end
    end       
end    

------------------------------------------------------------------- Called on every frame to draw the Game
function Game:draw()
  Graphics:draw(BG, 0, 0, Graphics.NORMAL)

  for i,v in ipairs(drawing) do
    if isDrawing then
            Graphics:drawLine(v.x, v.y, v.lastX, v.lastY, Graphics.GRAY)
        else
            Graphics:drawLine(v.x, v.y, v.lastX, v.lastY, Graphics.BLACK)
        end
    end    

	Scissors:draw(mouse)
	UI:drawTimer()
	UI:drawTextBubble(ptsForShape)
    UI:displayPtsForShape(ptsForShapeTable)
    
    Graphics:drawText("Paycheck: " .. playerScore, width - 275, height - 50, width - 275, middle, Graphics.NORMAL)
    Graphics:drawText("Target: " .. scoreThreshold, width - 220, 55, width - 275, middle, Graphics.NORMAL)
    Graphics:draw(scale, 30 * windowScale, height - 105 * windowScale, Graphics.NORMAL)
end    

function Game:load()
    love.mouse.setVisible(false)
    Scissors:load()
    mouse = {}
    drawing = {}
    toBeRemoved = {}
    ptsForShapeTable = {}
	playerScore = 0
    scoreThreshold = 100    
    remainingTime = 50
    remainingTimeAtLastScoring = 60
	heartbeat = false
    targetUpCounter = 0
    addOvals = false
    resetTime = 50
    pickRect = true
    pickOval = false
	scoreThreshold = 100
	extraScore = 100
    isDrawing = false
    mouseReleased = true
	generated = false
end    

function Game:mouseRelease(x, y, button, istouch)
  isPressed = true
    
    if(not mouseReleased and button == 1) then
        mouseReleased = true
    end
end    

function Game:mousePressed(x, y, button, istouch)    
	if (button == 1) then 
		isDrawing = true
		drawing = {}
		TEsound.playLooping("Sounds/SFX/Cutting.ogg", "cutting")
		ScoreManager.reset()
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

function Game:updateTimeAndScore()
    remainingTime = resetTime
    remainingTimeAtLastScoring = resetTime
    targetUpCounter = targetUpCounter + 1
    scoreThreshold = scoreThreshold + extraScore * targetUpCounter
end

function Game:isTimeForShapeRequest()
   return remainingTimeAtLastScoring - remainingTime >= 1.5 
end    