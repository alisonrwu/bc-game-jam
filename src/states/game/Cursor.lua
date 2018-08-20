Cursor = class("Cursor")
Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_scissors.png")
Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 96, 44, Cursor.SPRITESHEET:getDimensions())
Cursor.static.FRAME2 = love.graphics.newQuad(0, 47, 96, 48, Cursor.SPRITESHEET:getDimensions())
Cursor.static.OFFSET = {x = 35, y = 24}
Cursor.static.EXTRA_ROT = 0
Cursor.static.NO_CUT = love.graphics.newImage("assets/graphics/game/player/cursor_unabletocut.png")
Cursor.static.CYCLE = 15

local math = Math

function Cursor:initialize()
  self.frame = Cursor.FRAME1
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
    if self.frame == Cursor.FRAME1 then self.frame = Cursor.FRAME2 else self.frame = Cursor.FRAME1 end
  end
end

function Cursor:draw(mode)
  local mouse = scale:getWorldMouseCoordinates()
  local frame = self.frame
  
  if mode == "wait" then
    Graphics:drawQWithRotationAndOffset(Cursor.SPRITESHEET, frame, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.NORMAL)
    Graphics:drawWithRotationAndOffset(Cursor.NO_CUT, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.NORMAL)
  elseif mode == "cut" then
    Graphics:drawQWithRotationAndOffset(Cursor.SPRITESHEET, frame, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.FADED)    
  elseif mode == "ready" or mode == "score" then
    Graphics:drawQWithRotationAndOffset(Cursor.SPRITESHEET, frame, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.NORMAL)
  end
end