Shop = State:subclass("Shop"):include(Observer):include(Observable)
Shop.static.BOUGHT_ITEM = "BOUGHT_ITEM"

function Shop:initialize()
  self.items = {}
  self.groups = {}
  self:loadItems()
  self.currentPage = 1
  self.pageLimit = math.ceil(#self.items / 4)
  self.prevButton = ImageButton("assets/graphics/misc/hud_leftarrow.png", nil, nil, nil, "prevButton")
  self.prevButton:setRightOfPoint(Point(0, baseRes.height * 0.5 - self.prevButton.dimensions.height * 0.5), 20)
  self.prevButton:registerObserver(self)
  self.nextButton = ImageButton("assets/graphics/misc/hud_rightarrow.png", nil, nil, nil, "nextButton")
  self.nextButton:setLeftOfPoint(Point(baseRes.width, baseRes.height * 0.5 - self.nextButton.dimensions.height * 0.5), 20 )
  self.nextButton:registerObserver(self)
  self.title = TextPlaceable(("SHOP %i/%i"):format(self:getBoughtItems(), self:getMaxItems()))
  self.title:setCentreHorizontalScreen()
  self.title.position.y = 10
  self.extraText = TextPlaceable("Click to buy!")
  self.extraText:setCentreHorizontalScreen()
  self.extraText.position.y = baseRes.height - self.extraText.dimensions.height - 5
  local goBack = function()
    state = MainMenu(true)
  end
  self.backButton = ImageButton("assets/graphics/misc/hud_backarrow.png", goBack)
  self.backButton:setLeftOfPoint(Point(baseRes.width, 10), 15)
  self:updateButtonVisibility()
  self:registerObserver(user)
end

function Shop:saveItems()
  local itemsData = {}
  for i = 1, #self.items do
    local item = self.items[i]
    if tostring(item) == "Item" then
      local itemData = item:getData()
      itemsData[#itemsData + 1] = itemData
    end
  end
  bitser.dumpLoveFile("data_shop", itemsData)
end

function Shop:loadItems()
  self.items = items
  if love.filesystem.getRealDirectory("data_shop") ~= nil then 
    local itemsData = bitser.loadLoveFile("data_shop") 
    for i = 1, #self.items do
      local item = self.items[i]
      if tostring(item) == "Item" then
        local data = itemsData[i]
        if data then item:setData(data) end
      end
    end
  end
  self:positionItems()
end

function Shop:getBoughtItems()
  local amount = 0
  for i = 1, #self.items do
    local item = self.items[i]
    if tostring(item) == "Item" then
      local bought = item.bought
      if bought then amount = amount + 1 end
    end
  end
  return amount
end

function Shop:getMaxItems()
  local amount = 0
  for i = 1, #self.items do
    local item = self.items[i]
    if tostring(item) == "Item" then
      amount = amount + 1
    end
  end
  return amount
end

function Shop:update(dt)
  salary:update(dt)
  if self.extraText then self.extraText:update(dt) end
  self.title:setText(("SHOP (%i/%i)"):format(self:getBoughtItems(), self:getMaxItems()))
end

function Shop:draw()
  self.title:draw()
  self.prevButton:draw()
  self.nextButton:draw()
  self.backButton:draw()
  local group = self.groups[self.currentPage]
  if group then group:draw() end
  salary:draw()
  if self.extraText then self.extraText:draw() end
end

function Shop:mouseRelease(x, y, button, isTouch) 
  self.prevButton:mouseRelease(x, y, button, isTouch)
  self.nextButton:mouseRelease(x, y, button, isTouch)
  self.backButton:mouseRelease(x, y, button, isTouch)
  local group = self.groups[self.currentPage]
  if group then group:mouseRelease(x, y, button, isTouch) end
end

function Shop:mousePressed(x, y, button, isTouch)
  
end


function Shop:__tostring()
  return "Shop"
end
  
function Shop:updateButtonVisibility()
  if self.currentPage == 1 then
    self.prevButton.color = Graphics.GONE
    self.nextButton.color = Graphics.NORMAL
  end 
  
  if self.currentPage == self.pageLimit then
    self.prevButton.color = Graphics.NORMAL
    self.nextButton.color = Graphics.GONE
  end
  
  if self.currentPage ~= 1 and self.currentPage ~= self.pageLimit then
    self.prevButton.color = Graphics.NORMAL
    self.nextButton.color = Graphics.NORMAL
  end
  
  if self.currentPage == 1 and self.currentPage == self.pageLimit then
    self.prevButton.color = Graphics.GONE
    self.nextButton.color = Graphics.GONE
  end
end

function Shop:notify(event, args)
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
  elseif event == Item.static.BUY_SUCCESS then
    Sound:createAndPlay("assets/audio/sfx/sfx_buy.wav", "buy")
    self:setExtraText("Click to equip!", 2.5, Graphics.NORMAL)
    self:saveItems()
    self:notifyObservers(Shop.BOUGHT_ITEM, {boughtItems = self:getBoughtItems(), maxItems = self:getMaxItems()}) 
  elseif event == Item.static.BUY_FAIL then
    Sound:createAndPlay("assets/audio/sfx/sfx_error.wav", "error")   
    self:setExtraText("Not enough money!", 1.5, Graphics.RED)
  elseif event == Item.static.GO_TO_DETAILS then
    state = Details(args.item, self)
  end
end

function Shop:setExtraText(text, vanishTimer, color)
  local extraText = FlashingTextPlaceable(text, nil, nil, color, 20)
  extraText:setCentreHorizontalScreen()
  extraText.position.y = baseRes.height - extraText.dimensions.height - 5
  local function onVanish(self, args)
    if args[1] then args[1].extraText = false end
  end
  extraText:replaceTimer("vanish", vanishTimer, onVanish, {self})
  self.extraText = extraText
end

function Shop:positionItems()
  for i = 1, #self.items, 4 do
    local topLeft = self.items[i]
    
    if self.items[i + 1] == nil then self.items[i + 1] = ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE) end
    if self.items[i + 2] == nil then self.items[i + 2] = ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE) end
    if self.items[i + 3] == nil then self.items[i + 3] = ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE) end  
    
    local topRight = self.items[i + 1]
    local botLeft = self.items[i + 2]
    local botRight = self.items[i + 3]
    
    if topRight.position == Point(0, 0) then
      topRight:setRight(topLeft, 20)
    end
    if botLeft.position == Point(0, 0) then
      botLeft:setBelow(topLeft, 20)
    end
    if botRight.position == Point(0, 0) then
      botRight:setBelow(topLeft, 20)
      botRight:setRight(botLeft, 20)    
    end
    
    local group = GroupPlaceable({topLeft, topRight, botLeft, botRight})
    group:setCentreHorizontalScreen()
    group:setCentreVerticalScreen()
    group:registerObserver(self)
    
    self.groups[#self.groups + 1] = group
  end
end