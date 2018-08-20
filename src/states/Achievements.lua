Achievements = State:subclass("Achievements"):include(Observer):include(Observable)
Achievements.static.UNLOCKED_ACHIEVEMENT = "UNLOCKED_ACHIEVEMENT"

function Achievements:initialize()
  self.achievements = {}
  self.groups = {}
  self:loadAchievements()
  self.currentPage = 1
  self.pageLimit = math.ceil(#self.achievements / 6)
  self.prevButton = ImageButton("assets/graphics/misc/hud_leftarrow.png", nil, nil, nil, "prevButton")
  self.prevButton:setRightOfPoint(Point(0, baseRes.height * 0.5 - self.prevButton.dimensions.height * 0.5), 20)
  self.prevButton:registerObserver(self)
  self.nextButton = ImageButton("assets/graphics/misc/hud_rightarrow.png", nil, nil, nil, "nextButton")
  self.nextButton:setLeftOfPoint(Point(baseRes.width, baseRes.height * 0.5 - self.nextButton.dimensions.height * 0.5), 20 )
  self.nextButton:registerObserver(self)
  self.title = TextPlaceable(("ACHIEVEMENTS (%i/%i)"):format(self:getUnlockedAchievements(), self:getMaxAchievements()))
  self.title:setCentreHorizontalScreen()
  self.title.position.y = 10
  local goBack = function()
    state = MainMenu()
  end
  self.backButton = ImageButton("assets/graphics/misc/hud_backarrow.png", goBack)
  self.backButton:setLeftOfPoint(Point(baseRes.width, 10), 15)
  self:updateButtonVisibility()
  
  self.descriptionBox = ImagePlaceable("assets/graphics/misc/box_description.png")
  self.descriptionBox.position.y = baseRes.height - self.descriptionBox.dimensions.height
  
  self.extraText = TextPlaceable("Click an achievement to view it!")
  self.extraText.position.x = self.descriptionBox.position.x + 25
  self.extraText.position.y = self.descriptionBox.position.y + 45
  self.extraText:setLimit(baseRes.width - 50)
  self:registerObserver(user)
end

function Achievements:update(dt)
  self.title:setText(("ACHIEVEMENTS (%i/%i)"):format(self:getUnlockedAchievements(), self:getMaxAchievements()))
end

function Achievements:draw()
  self.prevButton:draw()
  self.nextButton:draw()
  self.backButton:draw()  
  self.title:draw()
  --self.descriptionBox:draw()
  local group = self.groups[self.currentPage]
  if group then group:draw() end
  self.extraText:draw()

--  for _, placeable in ipairs(group.placeables) do
--    placeable.bounds:draw()
--  end
end

function Achievements:loadAchievements()
  self.achievements = user.achievements
  self:positionAchievements()  
end

function Achievements:getUnlockedAchievements()
  local amount = 0
  for i = 1, #self.achievements do
    local achievement = self.achievements[i]
    if tostring(achievement) == "Achievement" then
      local unlocked = achievement.unlocked
      if unlocked then amount = amount + 1 end
    end
  end
  return amount
end

function Achievements:getMaxAchievements()
  local amount = 0
  for i = 1, #self.achievements do
    local achievement = self.achievements[i]
    if tostring(achievement) == "Achievement" then
      amount = amount + 1
    end
  end
  return amount
end

function Achievements:updateButtonVisibility()
  if self.currentPage == 1 then
    self.prevButton.color = Graphics.GONE
  end 
  
  if self.currentPage == self.pageLimit then
    self.nextButton.color = Graphics.GONE
  end
  
  if self.currentPage ~= 1 and self.currentPage ~= self.pageLimit then
    self.prevButton.color = Graphics.NORMAL
    self.nextButton.color = Graphics.NORMAL
  end
end
--  for _, placeable in ipairs(group.placeables) do
--    placeable.bounds:draw()
--  end
function Achievements:mouseRelease(x, y, button, isTouch)
    --  for _, placeable in ipairs(group.placeables) do
--    placeable.bounds:draw()
--  endton, isTouch) 
  self.prevButton:mouseRelease(x, y, button, isTouch)
  self.nextButton:mouseRelease(x, y, button, isTouch)
  self.backButton:mouseRelease(x, y, button, isTouch)
  local group = self.groups[self.currentPage]
  if group then group:mouseRelease(x, y, button, isTouch) end
end

function Achievements:mousePressed(x, y, button, isTouch)
  
end

function Achievements:__tostring()
  return "Achievements"
end

function Achievements:positionAchievements()
  for i = 1, #self.achievements, 6 do
    local topLeft = self.achievements[i] 
    if self.achievements[i + 1] == nil then self.achievements[i + 1] = ShapePlaceable("Rectangle", nil, Dimensions(190, 50), Graphics.GONE) end
    if self.achievements[i + 2] == nil then self.achievements[i + 2] = ShapePlaceable("Rectangle", nil, Dimensions(190, 50), Graphics.GONE) end
    if self.achievements[i + 3] == nil then self.achievements[i + 3] = ShapePlaceable("Rectangle", nil, Dimensions(190, 50), Graphics.GONE) end
    if self.achievements[i + 4] == nil then self.achievements[i + 4] = ShapePlaceable("Rectangle", nil, Dimensions(190, 50), Graphics.GONE) end
    if self.achievements[i + 5] == nil then self.achievements[i + 5] = ShapePlaceable("Rectangle", nil, Dimensions(190, 50), Graphics.GONE) end      
    
    local topRight = self.achievements[i + 1]
    local midLeft = self.achievements[i + 2]
    local midRight = self.achievements[i + 3]
    local botLeft = self.achievements[i + 4]
    local botRight = self.achievements[i + 5]
    
    if topRight.position == Point(0, 0) then
      topRight:setRight(topLeft, 20)
    end
    if midLeft.position == Point(0,0) then
      midLeft:setBelow(topLeft, 15)
    end
    if midRight.position == Point(0,0) then
      midRight:setBelow(topRight, 15)
      midRight:setRight(topLeft, 20)
    end
    if botLeft.position == Point(0, 0) then
      botLeft:setBelow(midLeft, 15)
    end  local a26n = function(self, event, args)
    if event == Achievements.UNLOCKED_ACHIEVEMENT and self.progress < self.maxProgress then
      local unlocked_all = args.unlocked_all
      if unlocked_all then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a26 = Achievement("Faithful Fan", "Unlock all the achievements. Thank you for playing.", a26n, 1)
    if botRight.position == Point(0, 0) then
      botRight:setBelow(midRight, 15)
      botRight:setRight(botLeft, 20)    
    end
        
    local group = GroupPlaceable({topLeft, topRight, midLeft, midRight, botLeft, botRight})
    group:setCentreHorizontalScreen()
    group:setCentreVerticalScreen()
    group:setPosition(Point(group.position.x, group.position.y - 30))
    group:registerObserver(self)
    
    self.groups[#self.groups + 1] = group
  end
end

function Achievements:notify(event, args)
  if event == self.prevButton.name then
    Sound:createAndPlay("assets/audio/sfx/sfx_menumove.wav", "click")
    self.currentPage = self.currentPage - 1
    if self.currentPage < 1 then self.currentPage = 1 end  
    self:updateButtonVisibility()
  elseif event == self.nextButton.name then
    Sound:createAndPlay("assets/audio/sfx/sfx_menumove.wav", "click")
    self.currentPage = self.currentPage + 1
    if self.currentPage > self.pageLimit then self.currentPage = self.pageLimit end  
    self:updateButtonVisibility()
  elseif event == Achievement.UNLOCKED then
    local text = ("%s"):format(args.description)
    self.extraText:setText(text)
    self:notifyObservers(Achievements.UNLOCKED_ACHIEVEMENT, {unlockedAchievements = self:getUnlockedAchievements(), maxAchievements = self:getMaxAchievements()}) 
  elseif event == Achievement.LOCKED then
    local text = ("%s %i/%i"):format(args.description, args.progress, args.maxProgress)
    self.extraText:setText(text)
  end
end
