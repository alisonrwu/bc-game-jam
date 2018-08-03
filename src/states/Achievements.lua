Achievements = State:subclass("Achievements"):include(Observer)

function Achievements:initialize()
  self.achievements = {}
  self.groups = {}
  self:loadAchievements()
  self.currentPage = 1
  self.pageLimit = math.ceil(#self.achievements / 6)
  self.prevButton = ImageButton("assets/graphics/shop/hud_leftarrowbig.png", nil, nil, nil, "prevButton")
  self.prevButton:setRightOfPoint(Point(0, baseRes.height * 0.5 - self.prevButton.dimensions.height * 0.5), 20)
  self.prevButton:registerObserver(self)
  self.nextButton = ImageButton("assets/graphics/shop/hud_rightarrowbig.png", nil, nil, nil, "nextButton")
  self.nextButton:setLeftOfPoint(Point(baseRes.width, baseRes.height * 0.5 - self.nextButton.dimensions.height * 0.5), 20 )
  self.nextButton:registerObserver(self)
  self.title = TextPlaceable("ACHIEVEMENTS")
  self.title:setCentreHorizontalScreen()
  self.title.position.y = 10
  local goBack = function()
    state = MainMenu()
  end
  self.backButton = ImageButton("assets/graphics/globals/hud_back.png", goBack)
  self.backButton:setLeftOfPoint(Point(baseRes.width, 10), 15)
  self:updateButtonVisibility()
  
  self.descriptionBox = ImagePlaceable("assets/graphics/descriptionbox.png")
  self.descriptionBox.position.y = baseRes.height - self.descriptionBox.dimensions.height
  
  self.text = TextPlaceable("")
  self.text.position.x = self.descriptionBox.position.x + 10
  self.text.position.y = self.descriptionBox.position.y + 30
end

function Achievements:update()
  
end

function Achievements:draw()
  self.prevButton:draw()
  self.nextButton:draw()
  self.backButton:draw()  
  self.title:draw()
  --self.descriptionBox:draw()
  self.text:draw()
    local group = self.groups[self.currentPage]
  if group then group:draw() end
--  for _, placeable in ipairs(group.placeables) do
--    placeable.bounds:draw()
--  end
end

function Achievements:loadAchievements()
  self.achievements = achievements
--  if love.filesystem.getRealDirectory("data_shop") ~= nil then 
--    local itemsData = bitser.loadLoveFile("data_shop") 
--    for i = 1, #self.items do
--      local item = self.items[i]
--      local data = itemsData[i]
--      item:setData(data)
--    end
--  end
  self:positionAchievements()  
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

function Achievements:mouseRelease(x, y, button, isTouch) 
  self.prevButton:mouseRelease(x, y, button, isTouch)
  self.nextButton:mouseRelease(x, y, button, isTouch)
  self.backButton:mouseRelease(x, y, button, isTouch)
  local group = self.groups[self.currentPage]
  if group then group:mouseRelease(x, y, button, isTouch) end
end

function Achievements:mousePressed(x, y, button, isTouch)
  
end

function Achievements:notify(event, args)
  if event == self.prevButton.name then
    Sound:createAndPlay("assets/audio/sfx/sfx_menumove.wav", "click")
    self.currentPage = self.currentPage - 1
    if self.currentPage < 1 then self.currentPage = 1 end  
    self:updateButtonVisibility()
  elseif event == self.nextButton.name then
    print("next button")
    Sound:createAndPlay("assets/audio/sfx/sfx_menumove.wav", "click")
    self.currentPage = self.currentPage + 1
    if self.currentPage > self.pageLimit then self.currentPage = self.pageLimit end  
    self:updateButtonVisibility()
  elseif event == Item.static.GO_TO_DETAILS then
    state = Details(args.item, self)
  end
end

function Achievements:__tostring()
  return "Achievements"
end

function Achievements:positionAchievements()
  for i = 1, #self.achievements, 6 do
    local topLeft = self.achievements[i] 
    local topRight = self.achievements[i + 1] or ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE)
    local midLeft = self.achievements[i + 2] or ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE)
    local midRight = self.achievements[i + 3] or ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE)
    local botLeft = self.achievements[i + 4] or ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE)
    local botRight = self.achievements[i + 5] or ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE)
    
    print(topLeft, topRight, midLeft, midRight, botLeft, botRight)
    
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
    end
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
