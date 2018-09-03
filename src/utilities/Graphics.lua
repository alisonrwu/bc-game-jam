Graphics = { 
    NORMAL = { 1, 1, 1, 1 },
    RED = { 0.8, 0.3, 0.3, 1 },
    FADED = { 1, 1, 1, 0.20 },
    BLACK = { 0, 0, 0, 1 },
    WHITE = { 1, 1, 1, 1 },
    GRAY = { 0.5, 0.5, 0.5, 1 },
    DARKGRAY = {0.25, 0.25, 0.25, 1},
    FADEDGRAY = { 0.4, 0.4, 0.4, 0.20},
    GREEN = { 0.3, 0.75, 0.3, 1 },
    YELLOW = {0.85, 0.85, 0.2, 1 },
    BLUE = { 0.45, 0.45, 0.85, 1 },
    GONE = {0, 0, 0, 0 }
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

function Graphics:drawLineTriangle(v1, v2, v3, c)
  if c then self:setColor(c) end
    love.graphics.polygon('line', v1.x, v1.y, v2.x, v2.y, v3.x, v3.y)
end

function Graphics:drawPolygon(points, c)
  if c then self:setColor(c) end
    love.graphics.polygon('line', points)  
end

function Graphics:drawText(text, x, y, a, c)
  if c then self:setColor(c) end
    love.graphics.printf(text, x, y, baseRes.width, a) 
end    
    
function Graphics:drawTextWithScale(text, x, y, a, s, c)
  if c then self:setColor(c) end
    love.graphics.printf(text, x, y, baseRes.width, a, nil, s, s, nil, nil, nil, nil)
end  

function Graphics:drawTextWithScaleAndLimit(text, x, y, a, s, l, c)
  if c then self:setColor(c) end
    love.graphics.printf(text, x, y, l, a, nil, s, s, nil, nil, nil, nil)
end     

function Graphics:draw(drawable, x, y, c)
  if c then self:setColor(c) end
    love.graphics.draw(drawable, x, y, nil)
end      

function Graphics:drawPsystem(psystem, c)
  if c then self:setColor(c) end
    love.graphics.draw(psystem)
end

function Graphics:drawWithScale(drawable, x, y, s, c)
  if c then self:setColor(c) end
    love.graphics.draw(drawable, x, y, nil, s, s, nil, nil, nil, nil)
 end    

function Graphics:drawWithRotationAndOffset(drawable, x, y, r, ox, oy, c, sx, sy)
  if c then self:setColor(c) end
  local sx = sx or 1
  local sy = sy or 1
    love.graphics.draw(drawable, x, y, r, sx, sy, ox, oy)
end  

function Graphics:drawQWithRotationAndOffset(drawable, q, x, y, r, ox, oy, c, sx, sy)
  if c then self:setColor(c) end
  local sx = sx or 1
  local sy = sy or 1
    love.graphics.draw(drawable, q, x, y, r, sx, sy, ox, oy)  
end

function Graphics:drawLine(x, y, lastX, lastY, c)
  if c then self:setColor(c) end
    love.graphics.line(x, y, lastX, lastY)
end

function Graphics:drawLines(lines, c)
  if c then self:setColor(c) end
    for _, line in ipairs(lines) do
      line:draw()
    end
end

function Graphics:positionRelative(orientation, object, relative, offset)
  local orientedPosition = Point(object.position.x, object.position.y)
  if not offset then offset = 0 end
  
  if orientation == "above" then
    orientedPosition.y = math.floor(relative.position.y - (object.dimensions.height + offset))
  end
  
  if orientation == "left" then
    orientedPosition.x = math.floor(relative.position.x - (object.dimensions.width + offset))
  end
  
  if orientation == "right" then
    orientedPosition.x = math.floor(relative.position.x + (relative.dimensions.width + offset))
  end
  
  if orientation == "below" then
    orientedPosition.y = math.floor(relative.position.y + (relative.dimensions.height + offset))
  end
  
  return orientedPosition
end

function Graphics:centreHorizontalRelative(object, relative)  
  local offset = relative.dimensions.width * 0.5 - object.dimensions.width * 0.5
  local centred = Point(math.floor(relative.position.x + offset), math.floor(object.position.y))

  return centred
end

function Graphics:centreVerticalRelative(object, relative)  
  local offset = relative.dimensions.height * 0.5 - object.dimensions.height * 0.5
  local centred = Point(math.floor(object.position.x), math.floor(relative.position.y + offset))

  return centred
end