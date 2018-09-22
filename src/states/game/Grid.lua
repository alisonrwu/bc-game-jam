Grid = class("Grid")

function Grid:initialize()
  self.columns = baseRes.width / Shape.CONVERSION_FACTOR
  self.rows = baseRes.height / Shape.CONVERSION_FACTOR
  self.offset = Shape.CONVERSION_FACTOR / 2
  self.alpha = 0.25
  self.color = {0.5, 0.5, 0.5, self.alpha}
end

function Grid:draw()
  for i = 1, self.columns do
    local x = Shape.CONVERSION_FACTOR * i
    x = x - self.offset
    Graphics:drawLine(x, 0, x, baseRes.height, self.color)
  end
  for i = 1, self.rows do
    local y = Shape.CONVERSION_FACTOR * i
    y = y - self.offset
    Graphics:drawLine(0, y, baseRes.width, y, self.color)
  end  
end

function Grid:reduceAlpha(amount)
  self.alpha = self.alpha - amount
  self.color = {self.color[1], self.color[2], self.color[3], self.alpha}
end