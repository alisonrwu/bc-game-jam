Shop = State:subclass("Shop"):include(Observer)

function Shop:initialize()
  self.items = {}
  self.groups = {}
  self:loadItems()
  self.currentPage = 1
  self.pageLimit = math.ceil(#self.items / 4)
  self.prevButton = ImageButton("assets/graphics/shop/hud_leftarrowbig.png", nil, nil, nil, "prevButton")
  self.prevButton:setRightOfPoint(Point(0, baseRes.height * 0.5 - self.prevButton.dimensions.height * 0.5), 20)
  self.prevButton:registerObserver(self)
  self.nextButton = ImageButton("assets/graphics/shop/hud_rightarrowbig.png", nil, nil, nil, "nextButton")
  self.nextButton:setLeftOfPoint(Point(baseRes.width, baseRes.height * 0.5 - self.nextButton.dimensions.height * 0.5), 20 )
  self.nextButton:registerObserver(self)
  self.title = TextPlaceable("SHOP")
  self.title:setCentreHorizontalScreen()
  self.title.position.y = 10
  self.extraText = false
  local goBack = function()
    self:saveItems()
    state = MainMenu()
  end
  self.backButton = ImageButton("assets/graphics/globals/hud_back.png", goBack)
  self.backButton:setLeftOfPoint(Point(baseRes.width, 10), 15)
  self:updateButtonVisibility()
end

function Shop:saveItems()
  local itemsData = {}
  for i = 1, #self.items do
    local item = self.items[i]
    local itemData = item:getData()
    itemsData[#itemsData + 1] = itemData
  end
  bitser.dumpLoveFile("data_shop", itemsData)
end

function Shop:loadItems()
  self.items = items
  if love.filesystem.getRealDirectory("data_shop") ~= nil then 
    local itemsData = bitser.loadLoveFile("data_shop") 
    for i = 1, #self.items do
      local item = self.items[i]
      local data = itemsData[i]
      item:setData(data)
    end
  end
  self:positionItems()
end

function Shop:update(dt)
  salary:update(dt)
  if self.extraText then self.extraText:update(dt) end
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
  end 
  
  if self.currentPage == self.pageLimit then
    self.nextButton.color = Graphics.GONE
  end
  
  if self.currentPage ~= 1 and self.currentPage ~= self.pageLimit then
    self.prevButton.color = Graphics.NORMAL
    self.nextButton.color = Graphics.NORMAL
  end
end

function Shop:notify(event, args)
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
  elseif event == Item.static.BUY_SUCCESS then
    print("Buy success")
    Sound:createAndPlay("assets/audio/sfx/sfx_buy.wav", "buy")
    self:setExtraText("Click to equip!", 2.5, Graphics.NORMAL)
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
    local topRight = self.items[i + 1] or ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE)
    local botLeft = self.items[i + 2] or ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE)
    local botRight = self.items[i + 3] or ShapePlaceable("Rectangle", nil, Dimensions(190, 120), Graphics.GONE)
    
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