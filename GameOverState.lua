GameOverState = {}


function GameOverState:update(dt)
    love.mouse.setVisible(true)
    TEsound.pitch("gameTheme", 0.9)

    self.counter = self.counter + dt
    
    if (self.counter >= self.WAIT_TIME) then
        self.counter = 0
        self.blink = not self.blink
    end
end                            
    
function GameOverState:draw()  
    Graphics:drawRect(0, 0, width, height, Graphics.BLACK)
    Graphics:drawText("GAME OVER", 0, height / 2, width, "center", Graphics.NORMAL)
    
    if (self.blink) then
        Graphics:drawText("Play Again?", 0, height * (3/4), width, 'center', Graphics.FADED)
	else
        Graphics:drawText("Play Again?", 0, height * (3/4), width, 'center', Graphics.NORMAL)
	end
end

function GameOverState:load()
    self.WAIT_TIME = 0.5
    self.counter = 0 
    self.blink = false
end    


function GameOverState:mouseRelease(x, y, button, istouch)
    TEsound.play("Sounds/SFX/Click.mp3", "click")
    setState(StartState)
end    

function GameOverState:mousePressed(x, y, button, istouch)    
end