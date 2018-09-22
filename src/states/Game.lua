Game = State:subclass("Game")
Game.static.WAIT_DURATION = 1.5
Game.static.MODE = "Normal"

function Game:update(dt)
  self.level:update(dt)
  self.cursor:update(dt, self.drawing.lines, self.mode)
      
  if self.mode == "wait" then
    self:wait(dt)
  end
  
  if self.mode == "cut" then  
    self:onHoldCut()
    self.drawing:update()
    if self.drawing.closed or not love.mouse.isDown(1) then 
      self.mode = "score" 
    elseif not self.drawing:isMouseAtSamePoint() then
      self.cursor:setMoving(true)
      Sound:play("cutting")
      local drawPt = self:getDrawPoint()
      self.drawing:insertPoint(drawPt)
    else
      Sound:stop("cutting")
      self.cursor:setMoving(false)
    end
  end
  
  if self.mode == "score" then
    Sound:stop("cutting")
    Sound:play("snip")
    self:onScore()
    self.drawing:updateValues()
    self.level:scoreDrawing(self.drawing) 
    self.mode = "wait"
  end

  if self.mode == "ready" then
    if love.mouse.isDown(1) then self.mode = "cut" end
  end
end

function Game:draw()
  self.drawing:draw()
  self.level:draw()
  self.cursor:draw(self.mode)
end

function Game:initialize()
  love.mouse.setVisible(false)
  user:applyModifiers()
  self.mode = "ready"
  self.waitTimer = 0
  self.bg = ImagePlaceable("assets/graphics/game/bg/bg_game16x9.png")
  self.level = Level(Game.MODE)
  self.drawing = Polygon()
  self.cursor = Cursor()
  Sound:create("assets/audio/sfx/sfx_cutting.ogg", "cutting", false)
  Sound:create("assets/audio/sfx/sfx_snip.ogg", "snip", false)
  Sound:createAndPlay("assets/audio/music/bgm_papercutter.ogg", "bgm", true, "stream")
  Sound:setVolume("bgm", 0.9)
end

function Game:wait(dt)
  self.waitTimer = self.waitTimer + dt
  
  if self.waitTimer >= Game.WAIT_DURATION then
    self.waitTimer = 0
    self.mode = "ready"
    self.drawing = Polygon()
    self.level:generateProblem()
  end
end

function Game:getDrawPoint()
  local mouseCoord = scale:getWorldMouseCoordinates()
  return mouseCoord
end

function Game:onHoldCut()
  
end

function Game:onScore()
  
end

function Game:mouseRelease(x, y, button, isTouch) 
end

function Game:mousePressed(x, y, button, isTouch)
end

function Game:__tostring()
  return "Game"
end