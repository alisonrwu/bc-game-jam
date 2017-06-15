UI = {}    

function UI:displayPtsForShape(ptsForShapeTable)
	for i,v in ipairs(ptsForShapeTable) do
    	if v.score <= 0 then
            Graphics:drawText(math.floor(v.score), v.boxWidth, v.boxHeight, width, left, {255, 127, 127, v.alpha})
		else
            Graphics:drawText("+" .. math.floor(v.score), v.boxWidth, v.boxHeight, width, left, {127, 255, 127, v.alpha})
        end
        
        Graphics:drawTextWithScale("x" .. ScoreManager:getComboMultiplier(), v.boxWidth + 1, v.boxHeight + 27, width, left, 0.9, 0.9, {255, 255, 255, v.alpha})
        -- Since it happens after combo multiplication, it inaccurately represents the combo bonus    
        
        if (ScoreManager:getComboMultiplier() >= 2.5) then
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

function UI:drawTargetShape()    
    local PR = ptsForShapeTable[#ptsForShapeTable].pickRect
    local PO = ptsForShapeTable[#ptsForShapeTable].pickOval
    
    if PR then
        ScoreManager.drawRectangle()
    elseif PO then
        ScoreManager.drawOval()
    else
        ScoreManager.drawRectangle()
    end
end

function UI:drawTextBubble(points)
    Graphics:draw(textBubble, 10, 10, Graphics.NORMAL)
    local feedbackX = 20
    local feedbackY = 20
    
	if Game:isTimeForShapeRequest() then
		if pickRect then
            Graphics:drawText("I need a ".. rand1 .. '" x ' .. rand2 .. '" rectangle!', feedbackX, feedbackY, width, left, Graphics.NORMAL)
		elseif pickOval then
            Graphics:drawText("I need a ".. rand1 .. '" x ' .. rand2 .. '" oval, pronto!', feedbackX, feedbackY, width, left, Graphics.NORMAL)
		end
	else
        UI:drawTargetShape()
		if (points < 0)  then
           Graphics:drawText("That's coming out your paycheck", feedbackX, feedbackY, width, left, Graphics.RED)
		   if (canPlaySound) then
                TEsound.play("Sounds/SFX/Wrong.wav", "wrong")
		        canPlaySound = false
		  end
        end
		if (points >= 0 and points < 20) then
           Graphics:drawText("What are you doing?!", feedbackX, feedbackY, width, left, Graphics.NORMAL)            
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (points >= 20 and points < 60) then
            Graphics:drawText("Are you a monkey?", feedbackX, feedbackY, width, left, Graphics.NORMAL)       
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (points >= 60 and points < 100) then
            Graphics:drawText("Close but not really.", feedbackX, feedbackY, width, left, Graphics.NORMAL)                   
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (points >= 100 and points < 150) then
            Graphics:drawText("Don't get cocky.", feedbackX, feedbackY, width, left, Graphics.NORMAL)                               
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
        if (points >= 150) then
            Graphics:drawText("OwO what's this?", feedbackX, feedbackY, width, left, Graphics.GREEN)                               
            if (canPlaySound) then
                TEsound.play("Sounds/SFX/Correct.wav", "correct")
                canPlaySound = false
            end
        end
    end
end


function UI:drawTimer()
    if (remainingTime < 10) then
        if (heartbeat == false) then
            TEsound.pitch("music", 1.05)
            TEsound.play("Sounds/SFX/heartbeat.mp3", "heartbeat")
            heartbeat = true
        end
            Graphics:drawText("Time: " .. math.ceil(remainingTime, 1), 25, 55, width, left, Graphics.RED)
        else
            Graphics:drawText("Time: " .. math.ceil(remainingTime, 1), 25, 55, width, left, Graphics.NORMAL)
        end
end    