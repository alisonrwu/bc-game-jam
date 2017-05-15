require "TEsound"
require "Instructions"
require "ScoreManager"
require "Graphics"
require "Fade"
require "Scissors"
require "Start"

drawing = {}
toBeRemoved = {}
scoreTable = {}

function love.load()
    setState(Start)
    loadImages()
    loadGraphics()
    loadGameSettings()
	
    width = love.graphics.getWidth()
	height = love.graphics.getHeight()   
    
	isDrawing = true
	scored = true
	generated = false

	TEsound.play("Sounds/Music/Paper Cut Title.ogg", "menuTheme")
	TEsound.volume("menuTheme", 0.8)

	music = false
    canPlaySound = false
end

function loadImages()
    icon = love.graphics.newImage("Graphics/UI/Icon.png")
    menuBG = love.graphics.newImage("Graphics/Menu/Background.png")
    BG = love.graphics.newImage("Graphics/UI/Background.png")
    scale = love.graphics.newImage("Graphics/UI/Scale.png")
	textBubble = love.graphics.newImage("Graphics/UI/TextBubble.png")
  	combo = love.graphics.newImage("Graphics/UI/combo.png")
    TITLE_BUTTON = love.graphics.newImage("Graphics/Menu/testTitle.png")
    START_BUTTON = love.graphics.newImage("Graphics/Menu/startButton.png")    
end

function loadGraphics()
    love.window.setIcon(icon:getData())	
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setPointSize(5)
    love.graphics.setLineWidth(3)
        
    font = love.graphics.newImageFont("Graphics/UI/Imagefont.png",
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
		"123456789.,!?-+/():;%&`'*#=[]\"")
	love.graphics.setFont(font)              
end      
    
function loadGameSettings()
    addOvals = false
    pickOval = false
    pickRect = true
    heartbeat = false
    comboBonus = 1
    targetUpOld = 0
    targetUp = 0
    timer = 0
	resetTime = 50
	scoreThreshold = 100
	extraScore = 0  
    currentScore = 0    
    remainingTime = 50    
end        

function setState(s)
    state = s
end    

function love.update(dt)
    state:update(dt)
    Fade:update(dt)
end

function love.draw()
    state:draw()
    Fade:draw()
end    

function gameUpdate(dt)
  love.mouse.setVisible(false)

  -- debug
  -- if (love.keyboard.isDown("a")) then
  --     remainingTime = remainingTime + 999
  --     end
    
  -- if (love.keyboard.isDown("b")) then
  --   love.load()
		-- ScoreManager.reset()
  -- end
    
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
function gameDraw()
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


function pointInRectangle(pointx, pointy, rectx, recty, rectwidth, rectheight)
	return pointx > rectx and pointy > recty and pointx < rectx + rectwidth and pointy < recty + rectheight
end            

------------------------------------------------------------------- Angle calculator for scissors
function math.angle(x1,y1, x2,y2) 
	return math.atan2(y2-y1, x2-x1) 
end

------------------------------------------------------------------- Checks if two lines intersect (or line segments if seg is true)
------------------------------------------------------------------- Lines are given as four numbers (two coordinates)
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
	return true
end

function love.mousepressed(x, y, button, istouch)    
	if (button == 1 and scored == true and isMenu == false and isInstructions == false and not gameOver) then 
		mouseDown = true
		isDrawing = true
		drawing = {}
		TEsound.playLooping("Sounds/SFX/Cutting.ogg", "cutting")
		ScoreManager.reset()
		scored = false
	end

	if (gameOver) then
		love.load()
		ScoreManager.reset()
	end    
end

function displayScore()
	for i,v in ipairs(scoreTable) do
		love.graphics.setColor(255, 255, 255, v.alpha)
		if v.score <= 0 then
			love.graphics.setColor(255, 127, 127, v.alpha)
			love.graphics.print(math.floor(v.score), v.boxWidth, v.boxHeight)
		else
			love.graphics.setColor(127, 255, 127, v.alpha)
			love.graphics.print("+" .. math.floor(v.score), v.boxWidth, v.boxHeight)
      love.graphics.setColor(255, 255, 255, v.alpha)
      love.graphics.print("x" .. comboBonus, v.boxWidth + 1, v.boxHeight + 27, 0, 0.9, 0.9)  
      if (comboBonus >= 1.15) then
      	love.graphics.draw(combo, v.boxWidth - 25, v.boxHeight + 24, 0, 0.175, 0.175) 
      end
      if (targetUp == targetUpOld+1) then
        love.graphics.setColor(230, 230, 130, v.alpha)    
        love.graphics.print("Target Up!", v.boxWidth, v.boxHeight - 26, 0, 0.9, 0.9) 
        love.graphics.setColor(255, 255, 255, v.alpha)    
      end    
		end
		v.alpha = v.alpha - 2
		v.boxHeight = v.boxHeight - 2
		if (v.alpha < 0) then
			table.remove(v)
		end
	end
end

function drawTextBubble(score)
	if ((not scored and not gameOver) or 
        (not gameOver and (remainingTimeAtLastScoring - remainingTime) >= 3)) then
		if pickRect then
			love.graphics.print("I need a ".. rand1 .. '" x ' .. rand2 .. '" rectangle!', 20, 20)
		elseif pickOval then
			love.graphics.print("I need a ".. rand1 .. '" x ' .. rand2 .. '" oval, pronto!', 20, 20)
		end
    elseif (gameOver) then
		love.graphics.setColor(230, 80, 80, 240)
		love.graphics.print("You're fired! Stop wasting paper!", 20, 20)
	else
		if (score < 0)  then
	       comboBonus = 1.00
	       love.graphics.setColor(255, 100, 100, 255)
           love.graphics.print("That's coming out your paycheck", 20, 20)
		   if (canPlaySound) then
                TEsound.play("Sounds/SFX/Wrong.wav", "wrong")
		        canPlaySound = false
		  end
        end
		if (score >= 0 and score < 20) then
            comboBonus = 1.00
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("What are you doing?!", 20, 20)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (score >= 20 and score < 70) then
            comboBonus = 1.00
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("Are you a monkey?", 20, 20)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (score >= 70 and score < 100) then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("Close but not really.", 20, 20)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (score >= 100 and score < 150) then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("Don't get cocky.", 20, 20)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (score >= 150) then
            love.graphics.setColor(127, 255, 127, 255)
            love.graphics.print("OwO what's this?", 20, 20)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
    end
end

function drawTimer(currentScore)
	if (currentScore >= scoreThreshold) then
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

	--Draw timer
	if (remainingTime > 0) then
		love.graphics.setColor(255, 255, 255, 255)
		if (remainingTime < 10) then
			if (heartbeat == false) then
				TEsound.pitch("music", 1.05)
				TEsound.play("Sounds/SFX/heartbeat.mp3", "heartbeat")
				heartbeat = true
			end
			love.graphics.setColor(255, 127, 127, 255)
		else
			if (heartbeat == true) then
				TEsound.pitch("music", 1)
			end
			TEsound.stop("heartbeat")
			heartbeat = false
		end

		love.graphics.print("Time: " .. math.ceil(remainingTime, 1), 25, 55)
	else 
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf("GAME OVER", 0, height / 2, width, 'center')
		if (blinkingCounter2 < 25) then
			love.graphics.print("Play again?", width - 300, height - 90)  
			blinkingCounter2 = blinkingCounter2 + 1
		else
			love.graphics.setColor(255,255,255,100)
			love.graphics.print("Play again?", width - 300, height - 90)
			blinkingCounter2 = blinkingCounter2 + 1

			if (blinkingCounter2 == 50) then
				blinkingCounter2 = 0
			end    
		end    
	end
end     

function love.mousereleased(x, y, button, istouch) 
--	isPressed = true
    
--    if(not mouseReleased and button == 1) then
--        mouseReleased = true
--    end

	state:mouseRelease()
end

function love.keypressed(key, u)
   --Debug
   if key == "rctrl" then --set to whatever key you want to use
      debug.debug()
   end
end