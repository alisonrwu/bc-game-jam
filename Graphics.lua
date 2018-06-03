Graphics = {
    NORMAL = { 1, 1, 1, 1 },
    RED = { 0.75, 0.25, 0.25, 1 },
    FADED = { 1, 1, 1, 0.25 },
    BLACK = { 0, 0, 0, 1 },
    GRAY = { 0.5, 0.5, 0.5, 1 },
    GREEN = { 0.25, 0.75, 0.25, 1 },
    YELLOW = {0.75, 0.75, 0.25, 1 }
}

function Graphics:setColor(c)    
  if self.lastColor ~= c then
    self.lastColor = c
    love.graphics.setColor(c)
  end
end

function Graphics:modifyColorAlpha(color, alpha)
  return {color[1], color[2], color[3], alpha}
end

function Graphics:drawRect(x, y, w, h, c)
  if c then self:setColor(c) end
    love.graphics.rectangle("fill", x, y, w, h )
end

function Graphics:drawLineRect(x, y, w, h, c)
  if c then self:setColor(c) end
    love.graphics.rectangle("line", x, y, w, h )
end

function Graphics:drawLineEllipse(x, y, w, h, c)
  if c then self:setColor(c) end    
    love.graphics.ellipse('line', x, y, w, h)
end

function Graphics:drawText(text, x, y, limit, align, c)
  if c then self:setColor(c) end
    love.graphics.printf(text, x, y, limit, align) 
end    
    
function Graphics:drawTextWithScale(text, x, y, limit, align, sx, sy, c)
  if c then self:setColor(c) end
    love.graphics.printf(text, x, y, limit, align, nil, sx, sy, nil, nil, nil, nil)
end     

function Graphics:draw(drawable, x, y, c)
  if c then self:setColor(c) end
    love.graphics.draw(drawable, x, y, nil)
end      

function Graphics:drawWithScale(drawable, x, y, sx, sy, c)
  if c then self:setColor(c) end
    love.graphics.draw(drawable, x, y, nil, sx, sy, nil, nil, nil, nil)
 end    

function Graphics:drawWithRotationAndOffset(drawable, x, y, r, ox, oy, c)
  if c then self:setColor(c) end
    love.graphics.draw(drawable, x, y, r, 1, 1, ox, oy)
end  

function Graphics:drawLine(x, y, lastX, lastY, c)
  if c then self:setColor(c) end
    love.graphics.line(x, y, lastX, lastY)
end

return Graphics
