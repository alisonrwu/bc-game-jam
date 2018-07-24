Combo = class("Combo", {baseMultiplier = 1, increase = 0.5})

function Combo:init()
  self.multiplier = Combo.baseMultiplier
end

function Combo:multiply(score) 
  self:update(score)
  if score > 0 then 
    return score * self.multiplier
  else
    return score
  end
end

function Combo:update(score)
  if score >= Level.MAX_SCORE * 0.5 then
    self.multiplier = self.multiplier + Combo.increase
  else
    self.multiplier = Combo.baseMultiplier
  end  
end