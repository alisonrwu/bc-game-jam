Diamond = Shape:subclass("Diamond")

function Diamond:initialize(widthInGameUnits, heightInGameUnits, maxScore)
  Shape.initialize(self, widthInGameUnits, heightInGameUnits, maxScore)
  self.left, self.top, self.right, self.bot = Point(), Point(), Point(), Point()
end

function Diamond:draw()
  local points = {self.left.x, self.left.y, self.top.x, self.top.y, self.right.x, self.right.y, self.bot.x, self.bot.y}
  if self.displayAnswer then Graphics:drawPolygon(points, Graphics.GREEN) end
end

function Diamond:score(drawing)
  self:vertices(drawing.centre)
  return Diamond.super.score(self, drawing)
end

function Diamond:vertices(centre)
  self.left = Point(centre.x - self.dimensions.width * 0.5, centre.y)
  self.top = Point(centre.x, centre.y - self.dimensions.height * 0.5)
  self.right = Point(centre.x + self.dimensions.width * 0.5, centre.y)
  self.bot = Point(centre.x, centre.y + self.dimensions.height * 0.5)
end

function Diamond:pointRepresentation()
  local rep = {}
  local numOfSteps = 10
  local width, halfW, height, halfH = self.dimensions.width, self.dimensions.width * 0.5, self.dimensions.height, self.dimensions.height * 0.5
  local widthStep, halfWStep, heightStep, halfHStep = width / numOfSteps, halfW / numOfSteps, height / numOfSteps, halfH / numOfSteps

    -- Left to Top
  local j = 0
  for i = 0, halfW, halfWStep do
    rep[#rep+1] = Point(self.left.x + i, self.left.y - j)
    j = j + halfHStep
  end
  
  j = 0
  -- Top to Right
  for i = 0, halfW, halfWStep do
    rep[#rep+1] = Point(self.top.x + i, self.top.y + j)
    j = j + halfHStep
  end
  
  -- Right to Bot
  j = 0
  for i = 0, halfW, halfWStep do
    rep[#rep+1] = Point(self.right.x - i, self.right.y + j)
    j = j + halfHStep
  end
  
  -- Bot to Left
  j = 0
  for i = 0, halfW, halfWStep do
    rep[#rep+1] = Point(self.bot.x - i, self.bot.y - j)
    j = j + halfHStep
  end
  
  return rep
end

