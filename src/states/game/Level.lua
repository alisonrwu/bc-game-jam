Level = class("Level"):include(Observable):include(Observer)
Level.static.MAX_SCORE = 200
Level.static.INITIAL_TARGET = 600
Level.static.EVERY_X_DIFFICULTY = 3
Level.static.STARTING_TIME = 60
Level.static.MIN_SHAPE_DIMEN = 1
Level.static.MAX_SHAPE_DIMEN = 6
Level.static.POINTS_TO_END_TUTORIAL = 800
Level.static.TARGET_MULTIPLIER = 0.50
Level.static.SHAPE_COMPLETED = "SHAPE_COMPLETED"
Level.static.START = "START"
Level.static.UNLOCKED_SHAPE = "UNLOCKED_SHAPE"

function Level:initialize(mode)
  self.mode = "Baby"
  if self.mode == "Baby" then
    self.grid = Grid()
    self.tutorial = true
    self.shapes = {"Rectangle"}
    self.nextShape = "Oval"
    Level.static.TARGET_MULTIPIER = 0.45
    Level.static.INITIAL_TARGET = 500
  end
  
  if self.mode == "Normal" then
    self.tutorial = false
    self.shapes = {"Rectangle"}
    self.nextShape = "Oval"
    Level.static.TARGET_MULTIPLIER = 0.5
    Level.static.INITIAL_TARGET = 600
  end
  
  if self.mode == "Veteran" then
    self.tutorial = false
    self.shapes = {"Rectangle", "Oval", "Triangle", "Diamond"}
    self.nextShape = "none"
    Level.static.TARGET_MULTIPLIER = 0.6
    Level.static.INITIAL_TARGET = 800
  end
  self.total = 0
  self.iteratedTotal = 0
  self.iterate = false
  self.differenceToIterate = 0
  
  -- add status
  self.target = Level.INITIAL_TARGET
  self.timer = Timer()
  self.timer:registerObserver(self)
  self.combo = Combo()
  self.popUps = {}
  self.speech = Speech()
  self.difficulty = 1
  self.problem = false
  self:generateProblem()
  self.targetsUntil = Level.static.EVERY_X_DIFFICULTY
  self.scoreText = TextPlaceable("Score: ", Point(baseRes.width * 0.05, baseRes.height * 0.8))
  self.scoreCounter = TextPlaceable("1")
  self.scoreCounter:setRight(self.scoreText, 0)
  self.scoreCounter:setPosition(Point(self.scoreCounter.position.x, baseRes.height * 0.8))
  self.targetCounter = TextPlaceable("Target: ", Point(baseRes.width * 0.05, baseRes.height * 0.9))
  self.targetsUntilShape = TextPlaceable(("%i targets till: %s"):format(self.targetsUntil, self.nextShape), nil, nil, nil, 0.5)
  self:registerObserver(user)
  self:notifyObservers(Level.START)
end

function Level:update(dt)
  self.timer:update(dt)
  if self.nextShape == "none" then self.targetsUntilShape:update(dt, "All shapes added.") else 
    self.targetsUntilShape:update(dt, ("%i targets until: %s"):format(self.targetsUntil, self.nextShape))
  end
  self.targetsUntilShape:setLeftOfPoint(Point(baseRes.width * 0.96, 60))
  for i = 1, #self.popUps do
    local popUp = self.popUps[i]
    if popUp ~= nil then 
      popUp:update()
      if popUp.alpha < 0 then self.popUps[i] = nil end
    end
  end
  self.speech:update(dt)
  
  if self.iterate then 
    self.iteratedTotal = self.iteratedTotal + self.differenceToIterate
    if self.differenceToIterate > 0 then
      if self.iteratedTotal >= self.total then 
        self.iterate = false 
        self.iteratedTotal = self.total
        self.scoreCounter:setColor(Graphics.NORMAL)
      end
    else
      if self.iteratedTotal <= self.total then 
        self.iterate = false 
        self.iteratedTotal = self.total
        self.scoreCounter:setColor(Graphics.NORMAL)
      end
    end
  end
  
  self.scoreCounter:update(dt, self.iteratedTotal)
  self.scoreText:update()
  self.targetCounter:update(dt, "Target: " .. self.target)
end

function Level:draw()
  if self.grid then self.grid:draw() end
  self.timer:draw()
  self.speech:draw()
  for i = 1, #self.popUps do
    local popUp = self.popUps[i]
    if popUp ~= nil then popUp:draw() end
  end
  self.problem:draw()
  self.scoreCounter:draw()  
  self.scoreText:draw()
  self.targetCounter:draw()
  self.targetsUntilShape:draw()
end

function Level:scoreDrawing(drawing)
  local score, successPercentage = self.problem:score(drawing)
  local comboMultipliedScore = math.floor(self.combo:multiply(score, successPercentage))  
  local rating = RatingFactory:rate(comboMultipliedScore)
  self.speech = Speech(rating.text, rating.color)
  if (tostring(rating) == "BadRating" and self.tutorial) then
    self.speech:setText("(Trace the shape to get points!)")
    self.speech:setColor(Graphics.YELLOW)
  end
  
  self:onScore(comboMultipliedScore, tostring(self.problem), successPercentage)
  comboMultipliedScore = self:modifyScore(comboMultipliedScore)
  
  local scorePopUp = NumberPopUp(comboMultipliedScore, rating.color, 1, Point.centreOf(self.problem.bounds, self.problem.dimensions))
  local comboPopUp = TextPopUp("x" .. self.combo.multiplier, Graphics.NORMAL, 1, false)
  comboPopUp.position.x = scorePopUp.position.x
  comboPopUp:setAbove(scorePopUp)
  table.insert(self.popUps, scorePopUp)
  table.insert(self.popUps, comboPopUp)

  if self.combo.multiplier > 2 then
    local firePopUp = ImagePopUp("assets/graphics/game/hud/icon_combo.png", Graphics.NORMAL, 1, false)
    firePopUp:setLeft(comboPopUp, 0)
    firePopUp:setCentreVertical(comboPopUp)
    firePopUp:setPosition(Point(firePopUp.position.x, firePopUp.position.y - 5))
    table.insert(self.popUps, firePopUp)  
  end
          
  self:addScore(comboMultipliedScore)
  local status = {shape = tostring(self.problem), accuracy = successPercentage * 100, tutorial = self.tutorial, points = score, targetUp = self:isTargetAchieved(), timeLeft = self.timer.time, rating = rating.text, timePlayed = self.timer.timePlayed, multiplier = self.combo.multiplier, targetUps = self.difficulty - 1, mode = self.mode}
  
  if self:isTutorialOver() then 
    self.tutorial = false 
    self.grid = false
    end
  if self:isTargetAchieved() then
    Sound:createAndPlay("assets/audio/sfx/sfx_targetup.wav", "targetup")
          
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
  if self.mode ~= "Baby" then
    self:notifyObservers(Level.SHAPE_COMPLETED, status)   
  end
end

function Level:addScore(score)
  self.total = self.total + score
  self.differenceToIterate = (self.total - self.iteratedTotal) * 0.1
  if self.differenceToIterate > 0 then self.differenceToIterate = math.ceil(self.differenceToIterate) else self.differenceToIterate = math.floor(self.differenceToIterate) end
  if self.differenceToIterate > 0 then self.scoreCounter:setColor(Graphics.GREEN) else self.scoreCounter:setColor(Graphics.RED) end
  self.iterate = true
end

function Level:generateWidthAndHeight()
  local randWidth = love.math.random(Level.MIN_SHAPE_DIMEN, Level.MAX_SHAPE_DIMEN)
  local randHeight = love.math.random(Level.MIN_SHAPE_DIMEN, Level.MAX_SHAPE_DIMEN)
  return randWidth, randHeight
end

function Level:generateProblem()
  local randWidth, randHeight = self:generateWidthAndHeight()
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

function Level:onScore(score)
  
end

function Level:modifyScore(score)
  return score
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
  self:notifyObservers(Level.UNLOCKED_SHAPE, {shape = self.nextShape})
  if shapesAdded == 1 then
    self.shapes[shapesAdded + 1] = "Oval"
    self.nextShape = "Triangle"
  elseif shapesAdded == 2 then
    self.shapes[shapesAdded + 1] = "Triangle"
    self.nextShape = "Diamond"
  elseif shapesAdded == 3 then
    self.shapes[shapesAdded + 1] = "Diamond"
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
    self:notifyObservers(Timer.OUT_OF_TIME, {timePlayed = self.timer.timePlayed, totalScore = self.total})
    highScore:attemptToAddScore(self.total)
    highScore:saveScores()
    state = GameOver(self.total)
  end
end