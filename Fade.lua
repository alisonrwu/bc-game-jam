Fade = {
    stateToTransitionTo = {},
    fadingToBlack = false,
    timer1 = 0,
    timer2 = 0,
    display = 0,
    alpha = 0
}

function Fade:update(dt)
    if (self.fadingToBlack == true) then
       Fade:increaseAlpha(dt, 0.5)
    end 
    
    if (self.alpha >= 1) then
        self.fadingToBlack = false
        self.display = self.display + dt
    end    
    
    if (self.display >= 0.5) then
        Fade:decreaseAlpha(dt, 0.5)
    end    
end     

function Fade:draw()
     Graphics:drawRect(0, 0, width, height, {0, 0, 0, self.alpha * 255})
end    
    
function Fade:fadeToState(s)
    Fade:setState(s)
    Fade:beginFade()
end        

function Fade:increaseAlpha(dt, length)
    self.timer1 = self.timer1 + dt
    
    if self.timer1 < length then self.alpha = self.alpha + (dt / length)
        else self.alpha = 1
            if (self.stateToTransitionTo) then setState(self.stateToTransitionTo)
            end
        end
end

function Fade:decreaseAlpha(dt, length)
    self.timer2 = self.timer2 + dt
    
    if self.timer2 < length then self.alpha = self.alpha - (dt / length)
        else 
            self.alpha = 0  
    end
end    
        
function Fade:beginFade()
    Fade:resetTimer()
    self.fadingToBlack = true
end                
        
function Fade:setState(s)
    self.stateToTransitionTo = s
end
        
function Fade:resetTimer()
    self.display = 0
    self.timer1 = 0
    self.timer2 = 0
end             
    
function Fade:getAlpha()
    return self.alpha
end


