Orientation = {}
-- All methods return a new position for placing based on relative.

-- TO-DO: Account for text wrapping.
function Orientation:setAbove(relative, offset)
  Orientation:check(self, relative)
  self:setPosition(Graphics:positionRelative("above", self, relative, offset))
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

-- TO-DO: Account for text wrapping.
function Orientation:setBelow(relative, offset)
  Orientation:check(self, relative)
  self:setPosition(Graphics:positionRelative("below", self, relative, offset))
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setLeft(relative, offset) 
  Orientation:check(self, relative)
  self:setPosition(Graphics:positionRelative("left", self, relative, offset))
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setRight(relative, offset) 
  Orientation:check(self, relative)
  self:setPosition(Graphics:positionRelative("right", self, relative, offset)) 
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setAlignLeftHorizontal(relative)
  Orientation:check(self, relative)
  self:setPosition(relative.position.x, self.position.y)
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setCentreHorizontal(relative)
  Orientation:check(self, relative)
  self:setPosition(Graphics:centreHorizontalRelative(self, relative))
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setCentreVertical(relative)
  Orientation:check(self, relative)
  self:setPosition(Graphics:centreVerticalRelative(self, relative))
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setCentreHorizontalScreen()
  self:setPosition(Point(math.floor(centre.x - self.dimensions.width * 0.5), math.floor(self.position.y)))
  if self.bounds then self:updateBounds() end
end

function Orientation:setCentreVerticalScreen()
  self:setPosition(Point(math.floor(self.position.x), math.floor(centre.y - self.dimensions.height * 0.5)))
  if self.bounds then self:updateBounds() end
end

function Orientation:setLeftOfPoint(point, offset)
  if offset == nil then offset = 0 end
  self:setPosition(Point(math.floor(point.x - (self.dimensions.width + offset)), math.floor(point.y)))
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setRightOfPoint(point, offset)
  if offset == nil then offset = 0 end
  self:setPosition(Point(math.floor(point.x + offset), math.floor(point.y)))
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:check(object, relative) 
  if not relative then error("The object you're trying to position relative to does not exist.") end
  if not object.position then error("The object you're trying to position has no position.") end
  if not object.dimensions then error("This object you're trying to position has no dimensions.") end
  if not relative.position then error("The object you're trying to position relative to has no position.") end
  if not relative.dimensions then error("This object you're trying to position relative to has no dimensions.") end
end

