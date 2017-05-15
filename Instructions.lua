Instructions = {}

function Instructions:update(dt)
    self.counter = self.counter + dt
    
    if (self.counter >= self.WAIT_TIME) then
        self.counter = 0
        self.blink = not self.blink
    end
end                            
    
function Instructions:draw()  
	Graphics:draw(menuBG, 0, 0, Graphics.NORMAL)
    Graphics:drawText("The boss wants you to cut some paper...", 0, 50, width, 'center', Graphics.NORMAL)
	Graphics:drawText("Better do what he says, fast!", 0, 150, width, 'center', Graphics.RED)
	Graphics:drawText("Use the left mouse button to cut\n the proper size sheets of paper.", 0, 210, width, 'center', Graphics.NORMAL) 
    
    if (self.blink) then
        Graphics:drawText("Click to Start!", 0, 370, width, 'center', Graphics.FADED)
	else
        Graphics:drawText("Click to Start!", 0, 370, width, 'center', Graphics.NORMAL)
	end
end

function Instructions:load()
    self.WAIT_TIME = 0.5
    self.counter = 0 
    self.blink = false
end
                    
function Instructions:mouseRelease(x, y, button, istouch)
  TEsound.play("Sounds/SFX/Click.mp3", "click")
    Fade:resetTimer()
    Fade:beginFade()
end    

function Instructions:mousePressed(x, y, button, istouch)    
end