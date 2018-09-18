Shape = class("Shape")
Shape.static.CONVERSION_FACTOR = 40
Shape.static.REDUCTION_FACTOR = 0.2
Shape.static.MAX_SIZE_FACTOR = 2
Shape.static.CORRECT_THRESHOLD = 0.5

function Shape:initialize(widthInGameUnits, heightInGameUnits, maxScore)
  self.maxScore = maxScore 
  self.bounds = Bounds()
  self.dimensionsInGameUnits = Dimensions(widthInGameUnits, heightInGameUnits)
  self.dimensions = Dimensions(widthInGameUnits * Shape.CONVERSION_FACTOR, heightInGameUnits * Shape.CONVERSION_FACTOR)
  self.maxSizeDimensions = Dimensions(self.dimensions.width * Shape.MAX_SIZE_FACTOR, self.dimensions.height * Shape.MAX_SIZE_FACTOR)
  self.maxSizeDimensions = Dimensions(400, 400)
  self.displayAnswer = false
end

function Shape:draw()
  error("Cannot draw unspecified Shape!")
end

function Shape:score(drawing)
  local successPercentage = 0
  
  self.bounds = Bounds.ofCentreAndDimensions(drawing.centre, self.dimensions)
  local maxBounds = Math:calculateMaximumBounds(drawing.bounds, self.bounds)
  
  if drawing.dimensions < self.maxSizeDimensions then
    successPercentage = Math:calculateSuccessPercentageOptimized(drawing.points, self:pointRepresentation(), maxBounds, Shape.REDUCTION_FACTOR)
  end
  
  score = self:transformSuccessPercentage(successPercentage)
  return score, successPercentage
end

function Shape:pointRepresentation()
  error("Cannot get point representation of unspecified shape!")
end

function Shape:transformSuccessPercentage(successPercentage)
  local transformedPercentage = successPercentage - Shape.CORRECT_THRESHOLD
  transformedPercentage = 2 * transformedPercentage
  
  local score = transformedPercentage * self.maxScore
  if score > self.maxScore then score = self.maxScore end
  
  return math.ceil(score)
end

function Shape:area()
  error("Cannot get area of unspecified shape!")
end