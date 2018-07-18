Game = State:extend("Game")

function Game:update(dt)
  self.level:update(dt)
  
  if self.mode == "wait" then
    self:wait(dt)
  end
  
  if self.mode == "cut" then
    self.drawing:update()
    if self.drawing.closed or not love.mouse.isDown(1) then 
      self.mode = "score" 
    elseif not self.drawing:isMouseAtSamePoint() then
      Sound:play("sfx_cutting")
      self.cursor:update(self.drawing.lines)
      local mouseCoord = Scale:getWorldMouseCoordinates()
      self.drawing:insertPoint(mouseCoord)
    else
      Sound:stop("sfx_cutting")
    end
  end
  
  if self.mode == "score" then
    Sound:play("sfx_snip")
    self.drawing:updateValues()
    self.level:scoreDrawing(self.drawing) 
    self.mode = "wait"
  end

  if self.mode == "ready" then
    if love.mouse.isDown(1) then self.mode = "cut" end
  end
end

function Game:draw()
  self:drawBG()
  self.level:draw()
  self.drawing:draw()
  self.cursor:draw(self.mode)
end

function Game:init()  
  love.mouse.setVisible(false)
  self.mode = "ready"
  self.waitTimer = 0
  self.waitDuration = 1.5
  self.level = Level()
  self.level:generateProblem()
  self.drawing = Polygon()
  self.cursor = Cursor()
  Sound:createAndPlay("assets/audio/music/bgm_papercutter.ogg", "bgm", true, "stream")
end

function Game:drawBG()
  local gameBG = love.graphics.newImage("assets/graphics/game/bg/bg_game16x9.png")
  local scale = love.graphics.newImage("assets/graphics/game/hud/hud_scale.png")
  Graphics:draw(gameBG, 0, 0, Graphics.NORMAL)
  Graphics:draw(scale, 30, baseRes.height - 105, Graphics.NORMAL)  
end

function Game:wait(dt)
  self.waitTimer = self.waitTimer + dt
  
  if self.waitTimer >= self.waitDuration then
    self.waitTimer = 0
    self.mode = "ready"
    self.drawing = Polygon()
    self.level:generateProblem()
  end
end

function Game:mouseRelease(x, y, button, isTouch) 
end

function Game:mousePressed(x, y, button, isTouch)
end