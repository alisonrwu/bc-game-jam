Combo = class("Combo")
Combo.static.BASE_MULTIPLIER = 0.5
Combo.static.INCREASE = 0.5

function Combo:initialize()
  self.multiplier = Combo.BASE_MULTIPLIER
end

function Combo:multiply(score, successPercentage) 
  self:update(score, successPercentage)
  if score > 0 then 
    return score * self.multiplier
  else
    return score
  end
end

function Combo:update(score, successPercentage)
  if successPercentage * 100 >= 65 then
    self.multiplier = self.multiplier + Combo.INCREASE
  else
    if self.multiplier > 5 then
      Sound:createAndPlay("assets/audio/sfx/sfx_aww.wav", "aww")
      Sound:setVolume("aww", 0.7)
    end
    self.multiplier = Combo.BASE_MULTIPLIER
  end  
end