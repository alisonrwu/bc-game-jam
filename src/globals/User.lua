User = class("User"):include(Observer):include(Observable)

function User:initialize()
  self.effectIndex = 1
  self.currentEffect = Effect()
  self.achievements = false
  self.popUpQueue = {}
  self.popUps = {}
  self:loadData()
  for _, achievement in ipairs(self.achievements) do
    self:registerObserver(achievement)
  end
end

function User:saveData()
  bitser.dumpLoveFile("data_user", self.effectIndex) 
  local achievementData = {}
  for i, achievement in ipairs(self.achievements) do
    if tostring(achievement) == "Achievement" then
      local data = {unlocked = achievement.unlocked, progress = achievement.progress}
      achievementData[#achievementData + 1] = data 
    end
  end
  bitser.dumpLoveFile("data_user_achievements", achievementData)
end

function User:loadData()
  if love.filesystem.getRealDirectory("data_user") ~= nil then
    self.effectIndex = bitser.loadLoveFile("data_user") 
    self.currentEffect = effects[self.effectIndex]
  end
  self.achievements = loadAchievements()
  if love.filesystem.getRealDirectory("data_user_achievements") ~= nil then
    achievementData = bitser.loadLoveFile("data_user_achievements")
    for i, data in ipairs(achievementData) do
      local unlocked = data.unlocked
      local progress = data.progress
      self.achievements[i]:setUnlocked(unlocked)
      self.achievements[i].progress = progress
    end
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

function User:notify(event, args)
  self:notifyObservers(event, args)
end

function User:getPopUps()
  if self.popUps then return #self.popUps / 3 else return 0 end
end

function User:addPopUpToQueue(popUp)
  table.insert(self.popUpQueue, popUp)
end


function User:addPopUp(popUp)
  if self.popUps == nil then self.popUps = {popUp} else table.insert(self.popUps, popUp) end
end

function User:drawPopUps()
  if self.popUps ~= nil then
    for i = 1, #self.popUps do
      local popUp = self.popUps[i]
      popUp:draw()
    end
  end
end

function User:updatePopUps(dt)
  if self.popUps ~= nil then
    if #self.popUps == 0 and #self.popUpQueue ~= 0 then
      self:addPopUp(self.popUpQueue[1])
      self:addPopUp(self.popUpQueue[2])
      self:addPopUp(self.popUpQueue[3])
      table.remove(self.popUpQueue, 1)
      table.remove(self.popUpQueue, 1)
      table.remove(self.popUpQueue, 1)
      Sound:createAndPlay("assets/audio/sfx/sfx_achievement_unlocked.wav", "achievement_unlocked")
    end
    for i = 1, #self.popUps do
      local popUp = self.popUps[i]
      if popUp ~= nil then 
        popUp:update(dt)
        if popUp.alpha < 0 then self.popUps[i] = nil end
      end
    end
  end  
end