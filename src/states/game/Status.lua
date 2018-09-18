Status = class("Status")
Status.static.COLOR = Graphics.NORMAL

function Status:initialize(psystem, timer, apply, name)
  self.psystem = psystem or false
  self.timer = timer or false
  self.apply = apply or false
  self.name = name or ""
end

function Status:update(dt)
  if self.psystem then
    local mouseCoord = scale:getWorldMouseCoordinates()
    self.psystem:setPosition(mouseCoord.x, mouseCoord.y)
    self.psystem:update(dt) 
  end
end

function Status:draw()
  if self.psystem then Graphics:drawPsystem(self.psystem, Status.COLOR) end
end

function Status:decrementTimer()
  if self.timer > 0 then
    self.timer = self.timer - 1
  end
end

function Status:modifyScore(score)
  if self.apply then
    return self.apply(score)
  else
    return score
  end
end

function Status:setPsystem(psystem)
  self.psystem = psystem
end