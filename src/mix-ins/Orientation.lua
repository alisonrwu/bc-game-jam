Orientation = {}
-- All methods return a new position for placing based on relative.

-- TO-DO: Account for text wrapping.
function Orientation:setAbove(relative, offset)
  Orientation:check(self, relative)
  self.position = Graphics:positionRelative("above", self, relative, offset)
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = Scale:worldToScreenBounds(self.bounds)
  end
end

-- TO-DO: Account for text wrapping.
function Orientation:setBelow(relative, offset)
  Orientation:check(self, relative)
  self.position = Graphics:positionRelative("below", self, relative, offset) 
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = Scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setLeft(relative, offset) 
  Orientation:check(self, relative)
  self.position = Graphics:positionRelative("left", self, relative, offset) 
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = Scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setRight(relative, offset) 
  Orientation:check(self, relative)
  self.position = Graphics:positionRelative("right", self, relative, offset)  
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = Scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setAlignLeftHorizontal(relative)
  Orientation:check(self, relative)
  self.position.x = relative.position.x
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = Scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setCentreHorizontal(relative)
  Orientation:check(self, relative)
  self.position = Graphics:centreHorizontalRelative(self, relative)
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = Scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:setCentreVertical(relative)
  Orientation:check(self, relative)
  self.position = Graphics:centreVerticalRelative(self, relative)
  if self.bounds then 
    self.bounds = Bounds.ofTopLeftAndDimensions(self.position, self.dimensions) 
    self.bounds = Scale:worldToScreenBounds(self.bounds)
  end
end

function Orientation:check(object, relative) 
  if not object.position then error("The object you're trying to position has no position.") end
  if not object.dimensions then error("This object you're trying to position has no dimensions.") end
  if not relative.position then error("The object you're trying to position relative to has no position.") end
  if not relative.dimensions then error("This object you're trying to position relative to has no dimensions.") end
end

