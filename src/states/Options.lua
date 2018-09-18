Options = State:subclass("Options")

function Options:initialize()
  self.placeables = {}
  self.onMouseRelease = function() end
  self.title = TextPlaceable("SELECT A DIFFICULTY")
  self.title:setCentreHorizontalScreen()
  self.data = {mode = "Normal", lefty = false}
  
  babyOnClick = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_menumove.wav", "click")
    self:setMode("Baby")
  end
  
  normalOnClick = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_menumove.wav", "click")
    self:setMode("Normal")
  end
  
  veteranOnClick = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_menumove.wav", "click")
    self:setMode("Veteran")
  end
  
  self.baby = ImageButton("assets/graphics/options/button_baby.png", babyOnClick)
  self.normal = ImageButton("assets/graphics/options/button_normal.png", normalOnClick)
  self.veteran = ImageButton("assets/graphics/options/button_veteran.png", veteranOnClick)
  self.normal:setCentreHorizontalScreen()
  self.baby:setLeft(self.normal, 160)
  self.veteran:setRight(self.normal, 160)
  self.babyMode = TextPlaceable("Baby")
  self.normalMode = TextPlaceable("Normal")
  self.veteranMode = TextPlaceable("Veteran")
  self.baby:setAbove(self.babyMode)
  self.babyMode:setCentreHorizontal(self.baby)
  self.normal:setAbove(self.normalMode)
  self.normalMode:setCentreHorizontal(self.normal)
  self.veteran:setAbove(self.veteranMode)
  self.veteranMode:setCentreHorizontal(self.veteran)
  
  self.babyImageAndText = GroupButton({self.baby, self.babyMode})
  self.normalImageAndText = GroupButton({self.normal, self.normalMode})
  self.veteranImageAndText = GroupButton({self.veteran, self.veteranMode})
  
  self.babyImageAndText:setOnClick(babyOnClick)
  self.normalImageAndText:setOnClick(normalOnClick)
  self.veteranImageAndText:setOnClick(veteranOnClick)
  
  self.difficulties = GroupPlaceable({self.babyImageAndText, self.normalImageAndText, self.veteranImageAndText})
  self.difficulties:setBelow(self.title, 15)
    
  self.extraText = TextPlaceable("Click on a face to select that difficulty!", nil, nil, nil, 0.5, baseRes.width * 2)
  self.extraText:setBelow(self.difficulties, 10)
  self.extraText:setCentreHorizontalScreen()
  
  checkboxOnClick = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_menumove.wav", "click") 
    self:setLefty(not self.data.lefty)
  end
  
--  self.checkbox = ImageButton("assets/graphics/misc/hud_checkbox_empty.png", checkboxOnClick)
--  self.leftyMode = TextPlaceable("Lefty Mode")
--  self.checkbox:setLeft(self.leftyMode, 20)
--  self.checkbox:setCentreVertical(self.leftyMode)
--  self.leftyModeCheckBox = GroupPlaceable({self.checkbox, self.leftyMode})
--  self.leftyModeCheckBox:setBelow(self.extraText, 20)
--  self.leftyModeCheckBox:setCentreHorizontalScreen()
  
  playOnClick = function()
    if self.data.mode == "Baby" then
      state = Instructions()
    else
      state = Game()
    end
  end
  
  self.play = TextOnImageButton("assets/graphics/misc/button_thin.png", playOnClick, nil, "Play")
  self.play:setBelow(self.extraText, 20)
  self.play:setCentreHorizontal(self.extraText)
  
  self.group = GroupPlaceable({self.difficulties, self.title, self.extraText, self.play})
  self.group:setCentreVerticalScreen()
  
  self:loadData()
  local goBack = function()
    state = MainMenu(true)
  end
  self.backButton = ImageButton("assets/graphics/misc/hud_backarrow.png", goBack)
  self.backButton:setLeftOfPoint(Point(baseRes.width, 10), 15)
  
  self.placeables = {self.group}
  self:setMode(self.data.mode)
end

function Options:saveData()
  bitser.dumpLoveFile("data_options", self.data) 
end

function Options:loadData()
  if love.filesystem.getRealDirectory("data_options") ~= nil then
    self.data = bitser.loadLoveFile("data_options")
    self:setMode(self.data.mode)
  end
end

function Options:setMode(mode)
  self.baby:setImage("assets/graphics/options/button_baby.png")
  self.normal:setImage("assets/graphics/options/button_normal.png")
  self.veteran:setImage("assets/graphics/options/button_veteran.png")
  if mode == "Baby" then
    self.baby:setImage("assets/graphics/options/button_baby_lightup.png")
    self.extraText:setText("For first time players. Achievements cannot be unlocked in this mode!")
    self.extraText:setCentreHorizontalScreen()    
    self.data.mode = "Baby"
    Game.static.MODE = "Baby"
  elseif mode == "Normal" then
    self.normal:setImage("assets/graphics/options/button_normal_lightup.png")
    self.extraText:setText("For players familiar with the game.")
    self.extraText:setCentreHorizontalScreen()   
    self.data.mode = "Normal"
    Game.static.MODE = "Normal"
  else
    self.veteran:setImage("assets/graphics/options/button_veteran_lightup.png")
    self.extraText:setText("For players who want a challenge.")
    self.extraText:setCentreHorizontalScreen()   
    self.data.mode = "Veteran"
    Game.static.MODE = "Veteran"
  end
  self:saveData()
end

function Options:setLefty(yes)
  if yes then
    self.checkbox:setImage("assets/graphics/misc/hud_checkbox_checked.png")
    self.data.lefty = true
  else 
    self.checkbox:setImage("assets/graphics/misc/hud_checkbox_empty.png")
    self.data.lefty = false
  end
end

function Options:update(dt)
  for _, v in ipairs(self.placeables) do
    v:update()
  end
end                            
  
function Options:draw()  
  for _, v in ipairs(self.placeables) do
    v:draw()
  end
  self.backButton:draw()  
end

function Options:mousePressed(x, y, button, isTouch)
end

function Options:mouseRelease(x, y, button, istouch)
  self:onMouseRelease()
  self.group:mouseRelease(x, y, button, isTouch)
  self.backButton:mouseRelease(x, y, button, isTouch)
end    

function Options:__tostring()
  return "Options"
end