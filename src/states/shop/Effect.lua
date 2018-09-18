Effect = class("Effect")

function Effect:initialize(onApply, onRemove, description, pros, cons, name)
  self.onApply = onApply or function() end
  self.onRemove = onRemove or function() end
  self.description = description and TextPlaceable(description, nil, "center") or TextPlaceable()
  self.pros = pros and TextPlaceable(pros, nil, "center") or TextPlaceable() 
  self.pros:setColor(Graphics.GREEN)
  self.pros:setBelow(self.description)
  self.cons = cons and TextPlaceable(cons, nil, "center") or TextPlaceable() 
  self.cons:setColor(Graphics.RED)
  self.cons:setBelow(self.pros)
  self.display = GroupPlaceable({self.description, self.pros, self.cons})
  self.name = name or ""
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