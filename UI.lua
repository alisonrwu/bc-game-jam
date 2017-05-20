UI = {}

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
      if (showTargetUp) then
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