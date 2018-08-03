Level = class("Level")
Level.static.MAX_SCORE = 200
Level.static.INITIAL_TARGET = 500
Level.static.EVERY_X_DIFFICULTY = 4
Level.static.STARTING_TIME = 60
Level.static.MAX_SHAPE_DIMEN = 6
Level.static.POINTS_TO_END_TUTORIAL = Level.static.INITIAL_TARGET
Level.static.TARGET_MULTIPLIER = 0.4

function Level:initialize()
  self.total = 0
  self.tutorial = true
  self.target = Level.INITIAL_TARGET
  self.timer = Timer()
  self.timer:registerObserver(self)
  self.combo = Combo()
  self.popUps = {}
  self.speech = Speech()
  self.difficulty = 1
  self.shapes = {"Rectangle"}
  self.problem = false
  self.nextShape = "Oval"
  self:generateProblem()
  self.targetsUntil = Level.static.EVERY_X_DIFFICULTY
  self.scoreCounter = TextPlaceable("Score: ", Point(baseRes.width * 0.6, baseRes.height * 0.9))
  self.targetCounter = TextPlaceable("Target: ", Point(baseRes.width * 0.2, baseRes.height * 0.9))
  self.targetsUntilShape = TextPlaceable(("%i targets till: %s"):format(self.targetsUntil, self.nextShape), nil, nil, nil, 0.5)
end

function Level:update(dt)
  for i = 1, #self.popUps do
    local popUp = self.popUps[i]
    popUp:update()
    if popUp.alpha < 0 then self.popUps[i] = nil end
  end
  self.timer:update(dt)
  self.speech:update(dt)
  self.scoreCounter:update(dt, "Score: " .. self.total)
  self.targetCounter:update(dt, "Target: " .. self.target)
  if self.nextShape == "none" then self.targetsUntilShape:update(dt, "All shapes added.") else 
    self.targetsUntilShape:update(dt, ("%i targets until: %s"):format(self.targetsUntil, self.nextShape))
  end
  self.targetsUntilShape:setLeftOfPoint(Point(baseRes.width * 0.95, 60))
end

function Level:draw()
  self.speech:draw()
  for i = 1, #self.popUps do
    local popUp = self.popUps[i]
    popUp:draw()
  end
  self.problem:draw()
  self.timer:draw()
  self.scoreCounter:draw()  
  self.targetCounter:draw()
  self.targetsUntilShape:draw()
end

function Level:scoreDrawing(drawing)
  local score = self.problem:score(drawing)
  local comboMultipliedScore = math.floor(self.combo:multiply(score))  
  local rating = RatingFactory:rate(comboMultipliedScore)
  self.speech = Speech(rating.text, rating.color)
  if (tostring(rating) == "BadRating" and self.tutorial) then
    self.speech:setText("(Trace the shape to get points!)")
    self.speech:setColor(Graphics.YELLOW)
  end
  
  local scorePopUp = NumberPopUp(comboMultipliedScore, rating.color, 1, scale:getWorldMouseCoordinates())
  local comboPopUp = TextPopUp("x" .. self.combo.multiplier, Graphics.NORMAL, 1, false)
  comboPopUp.position.x = scorePopUp.position.x
  comboPopUp:setAbove(scorePopUp)
  table.insert(self.popUps, scorePopUp)
  table.insert(self.popUps, comboPopUp)
  
  if self.combo.multiplier > 2 then
    local firePopUp = ImagePopUp("assets/graphics/game/hud/icon_combo.png", Graphics.NORMAL, 0.30, false)
    firePopUp:setLeft(comboPopUp, 0)
    firePopUp:setCentreVertical(comboPopUp)
    table.insert(self.popUps, firePopUp)
  end

  self.total = self.total + comboMultipliedScore
  
  if self:isTutorialOver() then self.tutorial = false end
  if self:isTargetAchieved() then
    Sound:createAndPlay("assets/audio/sfx/sfx_targetup.ogg", "targetup")
    local targetUpPopUp = TextPopUp("Target Up!", Graphics.YELLOW, 1, false)
    targetUpPopUp.position.x = scorePopUp.position.x
    targetUpPopUp:setBelow(scorePopUp)
    table.insert(self.popUps, targetUpPopUp)
    self.timer:resetTimer()
    self:increaseTarget()
    self:increaseDifficulty()
  end

  self.problem.displayAnswer = true
  Sound:createAndPlay(rating.sound.path, rating.sound.name)
end

function Level:generateProblem()
  local randWidth = love.math.random(Level.MAX_SHAPE_DIMEN)
  local randHeight = love.math.random(Level.MAX_SHAPE_DIMEN)
  local shape = self.shapes[love.math.random(1, #self.shapes)]

  if shape == "Rectangle" then
    self.problem = Rectangle(randWidth, randHeight, Level.MAX_SCORE)
  elseif shape == "Oval" then
    self.problem = Oval(randWidth, randHeight, Level.MAX_SCORE)
  elseif shape == "Triangle" then
    self.problem = Triangle(randWidth, randHeight, Level.MAX_SCORE)
  elseif shape == "Diamond" then
    self.problem = Diamond(randWidth, randHeight, Level.MAX_SCORE)
  end
  
  if self.tutorial then 
    self.problem.displayAnswer = true 
    self.speech = Speech(("Cut out this %iW x %iL %s!"):format(randWidth, randHeight, shape))
  else
    self.speech = Speech(("I need a %iW x %iL %s!"):format(randWidth, randHeight, shape))
  end
end

function Level:isTargetAchieved()
  return self.total >= self.target 
end

function Level:isTutorialOver()
  return self.total >= Level.POINTS_TO_END_TUTORIAL
end

function Level:increaseTarget()
  self.target = math.floor(self.target + self.target * Level.TARGET_MULTIPLIER)
end

function Level:increaseDifficulty()
  self.targetsUntil = self.targetsUntil - 1
  if self.targetsUntil == 0 then 
    self.targetsUntil = Level.static.EVERY_X_DIFFICULTY
    self:addNewShape() 
  end  
end

function Level:addNewShape()
  local shapesAdded = #self.shapes
  if shapesAdded == 1 then
    self.shapes[2] = "Oval"
    self.nextShape = "Triangle"
  elseif shapesAdded == 2 then
    self.shapes[3] = "Triangle"
    self.nextShape = "Diamond"
  elseif shapesAdded == 3 then
    self.shapes[4] = "Diamond"
    self.nextShape = "none"
  end
  
  if shapesAdded < 4 then
    local popUp = TextPopUp(("%ss added!"):format(self.shapes[#self.shapes]), Graphics.NORMAL, 1, mouseCoord)
    popUp:setBelow(self.popUps[#self.popUps])
    popUp.position.x = self.popUps[#self.popUps].position.x    
  end
  table.insert(self.popUps, popUp)
end

function Level:notify(event)
  if event == Timer.OUT_OF_TIME then
    highScore:attemptToAddScore(self.total)
    highScore:saveScores()
    state = GameOver(self.total)
  end
end