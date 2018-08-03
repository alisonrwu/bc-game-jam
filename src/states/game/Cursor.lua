Cursor = class("Cursor")
Cursor.static.FRAME0 = love.graphics.newImage("assets/graphics/game/player/cursor_base_closed.png")
Cursor.static.FRAME1 = love.graphics.newImage("assets/graphics/game/player/cursor_base_opened.png")
Cursor.static.NO_CUT = love.graphics.newImage("assets/graphics/game/player/cursor_unabletocut.png")
Cursor.static.SCISSORS_FRAME_TABLE = {[0] = Cursor.FRAME0, [1] = Cursor.FRAME1}
Cursor.static.CYCLE = 15

local math = Math

function Cursor:initialize()
  self.frame = Cursor.FRAME0
  self.counter = 0
  self.angle = 0
end

function Cursor:update(lines)
  self.counter = self.counter + 1
  
  if lines[#lines - 10] ~= nil then 
    self.angle = math:calculateAngleOfTwoLines(lines[#lines], lines[#lines - 5]) 
  end    
  
  if self.counter == Cursor.CYCLE then
    self.counter = 0
    if self.frame == Cursor.FRAME0 then self.frame = Cursor.FRAME1 else self.frame = Cursor.FRAME0 end
  end
end

function Cursor:draw(mode)
  local mouse = scale:getWorldMouseCoordinates()
  local frame = self.frame
  local width = frame:getWidth() * 0.5
  local height = frame:getHeight() * 0.5
  
  if mode == "wait" then
    Graphics:drawWithRotationAndOffset(frame, mouse.x, mouse.y, self.angle, width, height, Graphics.NORMAL)
    Graphics:drawWithRotationAndOffset(Cursor.NO_CUT, mouse.x, mouse.y, self.angle, width, height, Graphics.NORMAL)
  elseif mode == "cut" then
    Graphics:drawWithRotationAndOffset(frame, mouse.x, mouse.y, self.angle, width, height, Graphics.FADED)    
  elseif mode == "ready" or mode == "score" then
    Graphics:drawWithRotationAndOffset(frame, mouse.x, mouse.y, self.angle, width, height, Graphics.NORMAL)    
  end
end