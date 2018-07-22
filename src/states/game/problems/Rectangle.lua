Rectangle = Shape:extend("Rectangle")

function Rectangle:init(widthInGameUnits, heightInGameUnits, maxScore)
  Rectangle.super:init(widthInGameUnits, heightInGameUnits, maxScore)
  local default = Point(baseRes.width * 0.5 - self.dimensions.width * 0.5, baseRes.height * 0.5 - self.dimensions.height * 0.5)
  self.topL, self.topR, self.botL, self.botR = default, Point(), Point(), Point()
end

function Rectangle:draw()
  if self.displayAnswer then Graphics:drawLineRect(self.topL.x, self.topL.y, self.dimensions.width, self.dimensions.height, Graphics.GREEN) end
end

function Rectangle:score(drawing)
  self:corners(drawing.centre)
  return Rectangle.super.score(self, drawing)
end

function Rectangle:corners(centre)
  self.topL = {x = centre.x - self.dimensions.width * 0.5, y = centre.y - self.dimensions.height * 0.5}
  self.topR = {x = centre.x + self.dimensions.width * 0.5, y = centre.y - self.dimensions.height * 0.5}
  self.botL = {x = centre.x - self.dimensions.width * 0.5, y = centre.y + self.dimensions.height * 0.5}
  self.botR = {x = centre.x + self.dimensions.width * 0.5, y = centre.y + self.dimensions.height * 0.5}   
end

function Rectangle:pointRepresentation()
  local rep = {}
  local numOfSteps = 10
  local width, height = self.dimensions.width, self.dimensions.height
  local widthStep, heightStep = width / numOfSteps, height / numOfSteps
  
  -- Top line
  for i = 0, width, widthStep do
    rep[#rep+1] = Point(self.topL.x + i, self.topL.y)
  end
  
  -- Right line
  for i = 0, height, heightStep do
    rep[#rep+1] = Point(self.topR.x, self.topR.y + i)
  end
  
  -- Bottom line
  for i = 0, width, widthStep do
    rep[#rep+1] = Point(self.botR.x - i, self.botL.y)
  end
  
  -- Left line
  for i = 0, height, heightStep do
    rep[#rep+1] = Point(self.botL.x, self.botL.y - i)
  end
  
  return rep
end

function Rectangle:area()
  return self.dimensions.width * self.dimensions.height
end