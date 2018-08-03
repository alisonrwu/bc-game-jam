Effect = class("Effect")

function Effect:initialize(onApply, onRemove, description, pros, cons)
  self.onApply = onApply or function() end
  self.onRemove = onRemove or function() end
  self.description = description and TextPlaceable(description) or TextPlaceable()
  self.pros = pros and TextPlaceable(pros) or TextPlaceable() 
  self.pros:setColor(Graphics.GREEN)
  self.pros:setBelow(self.description)
  self.pros:setCentreHorizontal(self.description)
  self.cons = cons and TextPlaceable(cons) or TextPlaceable() 
  self.cons:setColor(Graphics.RED)
  self.cons:setBelow(self.pros)
  self.cons:setCentreHorizontal(self.description)
  self.display = GroupPlaceable({self.description, self.pros, self.cons})
end

function Effect:remove()
  self:onRemove()
end

function Effect:apply()
  self:onApply()
end

function Effect:draw()
  self.display:draw()
end