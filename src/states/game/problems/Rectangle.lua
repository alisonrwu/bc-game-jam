Rectangle = Shape:extend("Rectangle")

function Rectangle:init(widthInGameUnits, heightInGameUnits, maxScore)
  Rectangle.super:init(widthInGameUnits, heightInGameUnits, maxScore)
  self.topL, self.topR, self.botL, self.botR = Point(), Point(), Point(), Point()
end

function Rectangle:draw()
  if self.displayAnswer then Graphics:drawLineRect(self.topL.x, self.topL.y, self.dimensions.width, self.dimensions.height, Graphics.GREEN) end
end

function Rectangle:score(drawing)
  self:corners(drawing.centre)
  return Rectangle.super.score(self, drawing)
end

function Rectangle:corners(centre)
  self.topL = {x = centre.x - self.dimensions.width/2, y = centre.y - self.dimensions.height/2}
  self.topR = {x = centre.x + self.dimensions.width/2, y = centre.y - self.dimensions.height/2}
  self.botL = {x = centre.x - self.dimensions.width/2, y = centre.y + self.dimensions.height/2}
  self.botR = {x = centre.x + self.dimensions.width/2, y = centre.y + self.dimensions.height/2}   
end

function Rectangle:pointRepresentation()
  local pointRect = {}
  local numOfSteps = 10
  local width, height = self.dimensions.width, self.dimensions.height
  local widthStep, heightStep = width / numOfSteps, height / numOfSteps
  
  -- Top line
  for i = 0, width, widthStep do
      pointRect[#pointRect+1] = Point(self.topL.x + i, self.topL.y)
  end
  
  -- Right line
  for i = 0, height, heightStep do
      pointRect[#pointRect+1] = Point(self.topR.x, self.topR.y + i)
  end
  
  -- Bottom line
  for i = 0, width, widthStep do
      pointRect[#pointRect+1] = Point(self.botR.x - i, self.botL.y)
  end
  
  -- Left line
  for i = 0, height, heightStep do
      pointRect[#pointRect+1] = Point(self.botL.x, self.botL.y - i)
  end
  
  return pointRect
end

function Rectangle:area()
  return self.dimensions.width * self.dimensions.height
end