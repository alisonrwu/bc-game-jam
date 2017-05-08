GraphicsManager = {}

NORMAL = { 255, 255, 255, 255 }
RED = { 200, 80, 80, 255 }
FADED = { 255, 255, 255, 100 }

function GraphicsManager:setColor(c)    
  if self.lastColor ~= c then
    self.lastColor = c
    love.graphics.setColor(c)
  end
  return self
end

function GraphicsManager:drawRect(x, y, w, h, c )
  if c then self:setColor(c) end
    love.graphics.rectangle("fill", x, y, w, h )
      return self
end

function GraphicsManager:drawText(text, x, y, limit, align, c)
  if c then self:setColor(c) end
    love.graphics.printf(text, x, y, limit, align)
      return self
end    

function GraphicsManager:draw(drawable, x, y, c)
  if c then self:setColor(c) end
    love.graphics.draw(drawable, x, y)
      return self
end      

return GraphicsManager
