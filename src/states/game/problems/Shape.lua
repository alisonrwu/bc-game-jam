Shape = class("Shape", {CONVERSION_FACTOR = 40, REDUCTION_FACTOR = 0.5, MAX_SIZE_FACTOR = 2})

function Shape:init(widthInGameUnits, heightInGameUnits, maxScore)
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
  
  if drawing.dimensions < self.maxSizeDimensions then
    self.bounds = Bounds.ofCentreAndDimensions(drawing.centre, self.dimensions)
    local maxBounds = Math:calculateMaximumBounds(drawing.bounds, self.bounds)
    successPercentage = Math:calculateSuccessPercentageOptimized(drawing.points, self:pointRepresentation(), maxBounds, Shape.REDUCTION_FACTOR)
  end
  
  score = self:transformSuccessPercentage(successPercentage)
  return score
end

function Shape:pointRepresentation()
  error("Cannot get point representation of unspecified shape!")
end

function Shape:transformSuccessPercentage(successPercentage)
  local transformedPercentage = successPercentage - 0.5
  if transformedPercentage >= 0 then transformedPercentage = 2 * transformedPercentage end

  local score = transformedPercentage * self.maxScore
  if score > self.maxScore then score = self.maxScore end
  
  return score
end

function Shape:area()
  error("Cannot get area of unspecified shape!")
end