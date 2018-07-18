Combo = class("Combo", {baseMultiplier = 1, increase = 0.5})

function Combo:init()
  self.multiplier = Combo.baseMultiplier
end

function Combo:multiply(score) 
  local multiplied = score * self.multiplier
  self:update(multiplied)
  return multiplied
end

function Combo:update(score)
  if score >= Level.MAX_SCORE * 0.5 then
    self.multiplier = self.multiplier + Combo.increase
  else
    self.multiplier = Combo.baseMultiplier
  end  
end