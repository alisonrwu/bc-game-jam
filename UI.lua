UI = {}

function displayScore()
	for i,v in ipairs(scoreTable) do
    	if v.score <= 0 then
            Graphics:drawText(math.floor(v.score), v.boxWidth, v.boxHeight, width, left, {255, 127, 127, v.alpha})
		else
            Graphics:drawText("+" .. math.floor(v.score), v.boxWidth, v.boxHeight, width, left, {127, 255, 127, v.alpha})
        end
        
        Graphics:drawTextWithScale("x" .. comboBonus, v.boxWidth + 1, v.boxHeight + 27, width, left, 0.9, 0.9, {255, 255, 255, v.alpha})
            
        if (comboBonus >= 1.15) then
            Graphics:drawWithScale(combo, v.boxWidth - 25, v.boxHeight + 24, 0.175, 0.175, {255, 255, 255, v.alpha})
        end
        
        if (v.targetUp) then
            Graphics:drawTextWithScale("Target Up!", v.boxWidth, v.boxHeight - 26, width, left, 0.9, 0.9, {230, 230, 130, v.alpha})   
        end  
		
		v.alpha = v.alpha - 2
		v.boxHeight = v.boxHeight - 2
		
        if (v.alpha < 0) then
			table.remove(v)
		end
    end    
end

function drawTargetShape()
    if gameOver then return end
    
    local PR = scoreTable[#scoreTable].pickRect
    local PO = scoreTable[#scoreTable].pickOval
    
    if PR then
        ScoreManager.drawRectangle()
    elseif PO then
        ScoreManager.drawOval()
    else
        ScoreManager.drawRectangle()
    end
end

function drawTextBubble(score)
    if gameOver then return end
    
    local feedbackX = 20
    local feedbackY = 20
    
	if ((not scored and not gameOver) or 
        (not gameOver and (remainingTimeAtLastScoring - remainingTime) >= 3)) then
        love.graphics.setColor(255, 255, 255, 255)
		if pickRect then
			love.graphics.print("I need a ".. rand1 .. '" x ' .. rand2 .. '" rectangle!', feedbackX, feedbackY)
		elseif pickOval then
			love.graphics.print("I need a ".. rand1 .. '" x ' .. rand2 .. '" oval, pronto!', feedbackX, feedbackY)
		end
    elseif (gameOver) then
		love.graphics.setColor(230, 80, 80, 240)
		love.graphics.print("You're fired! Stop wasting paper!", feedbackX, feedbackY)
	else
        drawTargetShape()
		if (score < 0)  then
	       comboBonus = 1.00
	       love.graphics.setColor(255, 100, 100, 255)
           love.graphics.print("That's coming out your paycheck", feedbackX, feedbackY)
		   if (canPlaySound) then
                TEsound.play("Sounds/SFX/Wrong.wav", "wrong")
		        canPlaySound = false
		  end
        end
		if (score >= 0 and score < 20) then
            comboBonus = 1.00
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("What are you doing?!", feedbackX, feedbackY)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (score >= 20 and score < 70) then
            comboBonus = 1.00
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("Are you a monkey?", feedbackX, feedbackY)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (score >= 70 and score < 100) then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("Close but not really.", feedbackX, feedbackY)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (score >= 100 and score < 150) then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print("Don't get cocky.", feedbackX, feedbackY)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (score >= 150) then
            love.graphics.setColor(127, 255, 127, 255)
            love.graphics.print("OwO what's this?", feedbackX, feedbackY)
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
    end
end

function drawTimer()
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
end     
    end