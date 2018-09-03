Grid = class("Grid")

function Grid:initialize()
  self.columns = baseRes.width / Shape.CONVERSION_FACTOR
  self.rows = baseRes.height / Shape.CONVERSION_FACTOR
  self.offset = Shape.CONVERSION_FACTOR / 2
end

function Grid:draw()
  for i = 1, self.columns do
    local x = Shape.CONVERSION_FACTOR * i
    x = x - self.offset
    Graphics:drawLine(x, 0, x, baseRes.height, Graphics.FADEDGRAY)
  end
  for i = 1, self.rows do
    local y = Shape.CONVERSION_FACTOR * i
    y = y - self.offset
    Graphics:drawLine(0, y, baseRes.width, y, Graphics.FADEDGRAY)
  end  
end