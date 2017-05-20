GameOver = {}


function GameOver:update(dt)
    love.mouse.setVisible(true)
    TEsound.pitch("music", 0.9)
    TEsound.stop("heartbeat")
    drawing = {}
    ScoreManager.reset()
    mouseDown = false
    TEsound.stop("cutting")
    
    self.counter = self.counter + dt
    
    if (self.counter >= self.WAIT_TIME) then
        self.counter = 0
        self.blink = not self.blink
    end
end                            
    
function GameOver:draw()  
    Graphics:drawRect(0, 0, width, height, Graphics.BLACK)
    Graphics:drawText("GAME OVER", 0, height / 2, width, "center", Graphics.NORMAL)
    
    drawTimer(player.score, scoreThreshold)
    displayScore()
    
    if (self.blink) then
        Graphics:drawText("Play Again?", 0, height * (3/4), width, 'center', Graphics.FADED)
	else
        Graphics:drawText("Play Again?", 0, height * (3/4), width, 'center', Graphics.NORMAL)
	end
end

function GameOver:load()
    self.WAIT_TIME = 0.5
    self.counter = 0 
    self.blink = false
end    

                    
function GameOver:mouseRelease(x, y, button, istouch)
    TEsound.play("Sounds/SFX/Click.mp3", "click")
    love.load()
    ScoreManager.reset()
end    

function GameOver:mousePressed(x, y, button, istouch)    
end