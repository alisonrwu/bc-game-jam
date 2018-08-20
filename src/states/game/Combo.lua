Combo = class("Combo")
Combo.static.BASE_MULTIPLIER = 1
Combo.static.INCREASE = 0.5

function Combo:initialize()
  self.multiplier = Combo.BASE_MULTIPLIER
end

function Combo:multiply(score, successPercentage) 
  self:update(successPercentage)
  if score > 0 then 
    return score * self.multiplier
  else
    return score
  end
end

function Combo:update(successPercentage)
  if successPercentage >= Shape.CORRECT_THRESHOLD then
    self.multiplier = self.multiplier + Combo.INCREASE
  else
    self.multiplier = Combo.BASE_MULTIPLIER
    -- dropped multiplier sound
  end  
end