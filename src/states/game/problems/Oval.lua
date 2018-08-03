Oval = Shape:subclass("Oval")

function Oval:initialize(widthInGameUnits, heightInGameUnits, maxScore)
  Shape.initialize(self, widthInGameUnits, heightInGameUnits, maxScore)
  self.xRad, self.yRad = self.dimensions.width * 0.5, self.dimensions.height * 0.5
  self.left, self.top, self.right, self.bot = Point(), Point(), Point(), Point()
  local default = Point(baseRes.width * 0.5 - self.dimensions.width * 0.5, baseRes.height * 0.5 - self.dimensions.height * 0.5)
  self.centre = default
end

function Oval:draw()
  if self.displayAnswer then Graphics:drawLineEllipse(self.centre.x, self.centre.y, self.xRad, self.yRad, Graphics.GREEN) end
end

function Oval:score(drawing)
  self:points(drawing.centre)
  return Oval.super.score(self, drawing)
end

function Oval:points(centre)
  self.left = {x = centre.x - self.xRad, y = centre.y}
  self.top = {x = centre.x, y = centre.y - self.yRad}
  self.right = {x = centre.x + self.xRad, y = centre.y}
  self.bot = {x = centre.x, y = centre.y + self.yRad}  
  self.centre = centre
end

function Oval:pointRepresentation()
  local rep = {}
  local numOfSteps = 10
  local width, height = self.dimensions.width, self.dimensions.height
  local widthStep = width / numOfSteps
  
  local function ellipseFunctionY(x)
    return height * math.sqrt(0.25 - (x/width) * (x/width))
  end
  
  local halfW = width * 0.5
  local halfH = height * 0.5
  
  for i = 0, width, widthStep do
    rep[#rep + 1] = {x = self.left.x + i, y = self.top.y + halfH - ellipseFunctionY(i - halfW)}
  end
  
  for i = 0, width, widthStep do
    rep[#rep + 1] = {x = self.right.x - i, y = self.top.y + halfH + ellipseFunctionY(i - halfW)} 
  end

  return rep
end