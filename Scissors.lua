Scissors = {
}


frameCounter = 0

function Scissors:update(mouse, drawing, isDrawing, isMouseMoving, dt)
    shouldAnimate = isDrawing and isMouseMoving
    self.mouse = mouse

    if (shouldAnimate) then
        self.counter = self.counter + dt
        
        if (drawing[#drawing - 10] ~= nil) then
            self.angle = Math:findMouseAngle(drawing, mouse, #drawing - 5);
        end    
	end
    
    if (self.counter >= self.WAIT_TIME) then
        self.counter = 0
        self.shouldScissorsOpen = not self.shouldScissorsOpen
    end
end    
    

function Scissors:draw()
	if (self.shouldScissorsOpen) then
        Graphics:drawWithRotationAndOffset(self.openedScissors, self.mouse.X, self.mouse.Y, self.angle, self.openedScissors:getWidth()/2, self.openedScissors:getHeight()/2, Graphics.NORMAL)
	else
        Graphics:drawWithRotationAndOffset(self.closedScissors, self.mouse.X, self.mouse.Y, self.angle, self.closedScissors:getWidth()/2, self.closedScissors:getHeight()/2, Graphics.NORMAL)
	end
end

function Scissors:load()
    self.WAIT_TIME = 0.3
    self.counter = 0 
    self.shouldScissorsOpen = false
    self.openedScissors = love.graphics.newImage("Graphics/Sprites/OpenedScissors.png") 
    self.closedScissors = love.graphics.newImage("Graphics/Sprites/ClosedScissors.png")
end

function Scissors:closeScissors()
    self.shouldScissorsOpen = false
end
