Triangle = Shape:subclass("Triangle")

function Triangle:initialize(widthInGameUnits, heightInGameUnits, maxScore)
  Shape.initialize(self, widthInGameUnits, heightInGameUnits, maxScore)
  self.vertice_1, self.vertice_2, self.vertice_3 = Point(), Point(), Point()
end

function Triangle:draw()
  if self.displayAnswer then Graphics:drawLineTriangle(self.vertice_1, self.vertice_2, self.vertice_3, Graphics.GREEN) end
end

function Triangle:score(drawing)
  self:vertices(drawing.centre)
  return Triangle.super.score(self, drawing)
end

function Triangle:vertices(centre)
  self.vertice_1 = Point(centre.x - self.dimensions.width * 0.5, centre.y + self.dimensions.height * 0.5)
  self.vertice_2 = Point(centre.x, centre.y - self.dimensions.height * 0.5)
  self.vertice_3 = Point(centre.x + self.dimensions.width * 0.5, centre.y + self.dimensions.height * 0.5)
end

function Triangle:pointRepresentation()
  local rep = {}
  local numOfSteps = 10
  local width, halfW, height = self.dimensions.width, self.dimensions.width * 0.5, self.dimensions.height
  local widthStep, halfWStep, heightStep = width / numOfSteps, halfW / numOfSteps, height / numOfSteps

    -- Vertice 1 to 2
  local j = 0
  for i = 0, halfW, halfWStep do
    rep[#rep+1] = Point(self.vertice_1.x + i, self.vertice_1.y - j)
    j = j + heightStep
  end
  
  j = 0
  -- Vertice 2 to 3
  for i = 0, halfW, halfWStep do
    rep[#rep+1] = Point(self.vertice_2.x + i, self.vertice_2.y + j)
    j = j + heightStep
  end
  
  -- Vertice 1 to 3
  for i = 0, width, widthStep do
    rep[#rep+1] = Point(self.vertice_1.x + i, self.vertice_1.y)
  end
  
  return rep
end

function Triangle:__tostring()
  return "Triangle"
end