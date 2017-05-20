Graphics = {
    NORMAL = { 255, 255, 255, 255 },
    RED = { 200, 80, 80, 255 },
    FADED = { 255, 255, 255, 100 },
    BLACK = { 0, 0, 0, 255 }
}

function Graphics:setColor(c)    
  if self.lastColor ~= c then
    self.lastColor = c
    love.graphics.setColor(c)
  end
end

function Graphics:drawRect(x, y, w, h, c )
  if c then self:setColor(c) end
    love.graphics.rectangle("fill", x, y, w, h )
end

function Graphics:drawText(text, x, y, limit, align, c)
  if c then self:setColor(c) end
    love.graphics.printf(text, x, y, limit, align)
end    

function Graphics:draw(drawable, x, y, c)
  if c then self:setColor(c) end
    love.graphics.draw(drawable, x, y, 0, windowScale, windowScale)
end      

return Graphics
