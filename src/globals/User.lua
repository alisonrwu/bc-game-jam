User = class("User")

function User:initialize()
  self.effectIndex = 1
  self.currentEffect = Effect()
  self:loadData()
end

function User:saveData()
  bitser.dumpLoveFile("data_user", self.effectIndex) 
end

function User:loadData()
  if love.filesystem.getRealDirectory("data_user") ~= nil then
    self.effectIndex = bitser.loadLoveFile("data_user") 
    self.currentEffect = effects[self.effectIndex]
  end
end

function User:equipEffect(effectIndex)
  self.currentEffect = effects[effectIndex]
  self.effectIndex = effectIndex
  self:saveData()
end

function User:removeModifiers()
  self.currentEffect:remove()
end

function User:applyModifiers()
  self.currentEffect:apply()
end