function loadEffects()
  local baseScissorsOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_scissors.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 96, 44, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 47, 96, 48, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 30, y = 24}
  end
  local baseScissorsOnRemove = function() end
  local baseScissorsDescription = "Scissors"
  local baseScissorsPros = "+ Zero negative effects"
  local baseScissorsCons = "- Zero positive effects"
  local baseScissorsEffect = Effect(baseScissorsOnApply, baseScissorsOnRemove, baseScissorsDescription, baseScissorsPros, baseScissorsCons)
  
  local pizzacutterOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_pizzacutter.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 82, 40, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 40, 82, 40, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 11, y = 39}
    
    local buffImg = love.graphics.newImage('assets/graphics/game/player/buff_pizza.png')
    local debuffImg = love.graphics.newImage('assets/graphics/game/player/debuff_pizza.png')
    
    psystem = love.graphics.newParticleSystem(buffImg, 32)
    psystem:setParticleLifetime(1, 1.5) -- Particles live at least 2s and at most 5s.
    psystem:setEmissionRate(6)
    psystem:setSizeVariation(1)
    psystem:setLinearAcceleration(-15, -200, 10, -200) -- Random movement in all directions.
    psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.
    psystem:setEmissionArea("borderrectangle", 25, 8, 0, false)
    psystem:setRelativeRotation(true)
    psystem:setSpread(math.pi / 2)
    psystem:setRotation(math.pi / 4, math.pi)
    psystem:setSpinVariation(1)
    psystem:setSpin(math.pi, 2 * math.pi)
    psystem:setSizes(0.76, 0.7, 0.8, 0.65, 0.86, 1)
    
    pizzaBuff = function(score)
      if score > 0 then return score * 2 end
    end
    
    pizzaDebuff = function(score)
      if score < 0 then return score * 2 end
    end
    
    Level.onScore = function(self, score, problem, successPercentage)
      if problem == "Triangle" then
        if score > 0 then
          psystem:setTexture(buffImg)
          self.currentStatus = Status(psystem, 3, pizzaBuff)
        else
          psystem:setTexture(debuffImg)
          self.currentStatus = Status(psystem, 3, pizzaDebuff)
        end
      end
    end
  end
  local pizzacutterOnRemove = function()
    Level.onScore = function(self, score) end
  end
  local pizzacutterDescription = "Pizza Cutter"
  local pizzacutterPros = "+ Cutting a good triangle doubles point gains for the next 3 shapes" 
  local pizzacutterCons = "- Cutting a bad triangle doubles point losses for the next 3 shapes" 
  local pizzacutterEffect = Effect(pizzacutterOnApply, pizzacutterOnRemove, pizzacutterDescription, pizzacutterPros, pizzacutterCons)

  local gardenshearsOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_gardenshears.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 94, 48, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 48, 94, 48, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 32, y = 25}
    Shape.transformSuccessPercentage = function(self, successPercentage)
      local transformedPercentage = successPercentage - Shape.CORRECT_THRESHOLD
      transformedPercentage = 16 * (transformedPercentage ^ 3)
      
      local score = transformedPercentage * self.maxScore
      if score > self.maxScore then score = self.maxScore end
      
      return math.ceil(score)
    end
    Level.generateProblem = function(self)
      local randWidth, randHeight = self:generateWidthAndHeight()
      local shape = self.shapes[love.math.random(1, #self.shapes)]

      if shape == "Rectangle" then
        self.problem = Rectangle(randWidth, randHeight, Level.MAX_SCORE * 0.75)
      elseif shape == "Oval" then
        self.problem = Oval(randWidth, randHeight, Level.MAX_SCORE)
      elseif shape == "Triangle" then
        self.problem = Triangle(randWidth, randHeight, Level.MAX_SCORE * 0.75)
      elseif shape == "Diamond" then
        self.problem = Diamond(randWidth, randHeight, Level.MAX_SCORE * 0.75)
      end
      
      if self.tutorial then 
        self.problem.displayAnswer = true 
        self.speech = Speech(("Cut out this %iW x %iL %s!"):format(randWidth, randHeight, shape))
      else
        self.speech = Speech(("I need a %iW x %iL %s!"):format(randWidth, randHeight, shape))
      end
    end
  end
  local gardenshearsOnRemove = function()
    Shape.transformSuccessPercentage = function(self, successPercentage)
      local transformedPercentage = successPercentage - Shape.CORRECT_THRESHOLD
      transformedPercentage = 2 * transformedPercentage
      
      local score = transformedPercentage * self.maxScore
      if score > self.maxScore then score = self.maxScore end
      
      return math.floor(score)
    end    
    Level.generateProblem = function(self)
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
  end
  local gardenshearsDescription = "Garden Shears"
  local gardenshearsPros = "+ Point gain and loss is exponential"
  local gardenshearsCons = "- Straight edged shapes are worth less points (down to 150)"
  local gardenshearsEffect = Effect(gardenshearsOnApply, gardenshearsOnRemove, gardenshearsDescription, gardenshearsPros, gardenshearsCons)
  
  local utilityknifeOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_utilityknife.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 64, 44, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 0, 64, 44, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 61, y = 40}
    Game.static.WAIT_DURATION = 0.5
    Level.onScore = function(self, score)
      if score < 0 then
        local timeLoss = score / 10
        if self.timer.time + timeLoss < 0 then 
          self.timer.time = 0 
        else
          self.timer.time = self.timer.time + timeLoss
        end
        local position = Point(self.timer.position.x + 90, self.timer.position.y)
        local popUp = NumberPopUp(timeLoss, Graphics.RED, 1, position)
        table.insert(self.popUps, popUp)
      end
    end
  end
  local utilityknifeOnRemove = function()
    Game.static.WAIT_DURATION = 1.5
    Level.onScore = function(self, score)
    end
  end
  local utilityknifeDescription = "Utility Knife"
  local utilityknifePros = "+ Decrease wait time between shapes     (to 0.5s)"
  local utilityknifeCons = "- Lose time on bad cuts           (up to 20s)"
  local utilityknifeEffect = Effect(utilityknifeOnApply, utilityknifeOnRemove, utilityknifeDescription, utilityknifePros, utilityknifeCons)

  local crocodileOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_crocodile.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 80, 41, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 42, 80, 42, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 24, y = 25}
    Level.onScore = function(self, score, problem, successPercentage)
      if successPercentage > 0 then
        local timeGain = math.floor(successPercentage * 10)
        if self.timer.time + timeGain < 0 then 
          self.timer.time = 0 
        else
          self.timer.time = self.timer.time + timeGain
        end
        local position = Point(self.timer.position.x + 90, self.timer.position.y)
        local popUp = NumberPopUp(timeGain, Graphics.GREEN, 1, position)
        table.insert(self.popUps, popUp)
      end
    end
    Timer.resetTimer = function(self)
    end
  end
  local crocodileOnRemove = function()
    Level.onScore = function(self, score)
    end
    Timer.resetTimer = function(self)
      self.time = Timer.RESET_TIME
    end
  end
  local crocodileDescription = "Crocodile"
  local crocodilePros = "+ Gain time based on points         (up to 5s)"
  local crocodileCons = "- Time does not reset on Target Up"
  local crocodileEffect = Effect(crocodileOnApply, crocodileOnRemove, crocodileDescription, crocodilePros, crocodileCons) 

  local chainsawOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_chainsaw.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 2, 92, 40, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 44, 90, 40, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 5, y = 33}
    Cursor.static.EXTRA_ROT = -(math.pi / 6)
    Combo.static.INCREASE = 2
    Game.static.OSCILLATION_OFFSET = 0
    Game.getDrawPoint = function()
      local mouseCoord = scale:getWorldMouseCoordinates()
      local offset_y = -5 * math.cos(Game.OSCILLATION_OFFSET)
      local offset_x = -5 * math.cos(Game.OSCILLATION_OFFSET)
      mouseCoord.y = mouseCoord.y + offset_y
      mouseCoord.x = mouseCoord.x + offset_x
      Game.static.OSCILLATION_OFFSET = (love.math.random(0, (2 * math.pi)))
      return mouseCoord
    end
  end
  local chainsawOnRemove = function()
    Combo.static.INCREASE = 0.5
    Game.getDrawPoint = function()
      local mouseCoord = scale:getWorldMouseCoordinates()
      return mouseCoord
    end
  end
  local chainsawDescription = "Chainsaw"
  local chainsawPros = "+ Add 2x combo multiplier on good cuts instead of 0.5x"
  local chainsawCons = "- Very unstable"
  local chainsawEffect = Effect(chainsawOnApply, chainsawOnRemove, chainsawDescription, chainsawPros, chainsawCons) 
  
  local laserOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_laser_shorten.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 95, 32, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 38, 95, 32, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.WAITFRAME = love.graphics.newImage("assets/graphics/game/player/cursor_laser_wait.png")
    Cursor.static.OFFSET = {x = 67, y = 17}
    Cursor.static.EXTRA_ROT = -(math.pi / 2.5)
    Game.getDrawPoint = function()
      local mouseCoord = scale:getWorldMouseCoordinates()
      local offset_x = Cursor.OFFSET.x * -1 * math.cos(Cursor.EXTRA_ROT)
      local offset_y = Cursor.OFFSET.x * -1 * math.sin(Cursor.EXTRA_ROT)
      mouseCoord.x = mouseCoord.x + offset_x
      mouseCoord.y = mouseCoord.y + offset_y
      return mouseCoord
    end
    Cursor.update = function(self, lines)
      self.counter = self.counter + 1
      
      if self.counter == Cursor.CYCLE then
        self.counter = 0
        if self.frame == Cursor.FRAME1 then self.frame = Cursor.FRAME2 else self.frame = Cursor.FRAME1 end
      end
    end
    
    Cursor.draw = function(self, mode)
      local mouse = scale:getWorldMouseCoordinates()
      local frame = self.frame
      
      if mode == "wait" then
        Graphics:drawWithRotationAndOffset(Cursor.WAITFRAME, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, 37, 5, Graphics.NORMAL)
        Graphics:drawWithRotationAndOffset(Cursor.NO_CUT, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.NORMAL)
      elseif mode == "cut" then
        Graphics:drawQWithRotationAndOffset(Cursor.SPRITESHEET, frame, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.FADED)    
      elseif mode == "ready" or mode == "score" then
        Graphics:drawWithRotationAndOffset(Cursor.WAITFRAME, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, 37, 5, Graphics.NORMAL) 
      end
    end
    
    Polygon.isMouseAtSamePoint = function(self)
      if self:isEmpty() then
        return false
      else 
        local mouseCoord = scale:getWorldMouseCoordinates()
        local offset_x = Cursor.OFFSET.x * -1 * math.cos(Cursor.EXTRA_ROT)
        local offset_y = Cursor.OFFSET.x * -1 * math.sin(Cursor.EXTRA_ROT)
        mouseCoord.x = mouseCoord.x + offset_x
        mouseCoord.y = mouseCoord.y + offset_y
        local point = self:getLatestPoint()
        return point.x == mouseCoord.x and point.y == mouseCoord.y
      end 
    end
    
    Shape.static.CORRECT_THRESHOLD = 0.55
  end
  local laserOnRemove = function()
    Game.getDrawPoint = function()
      local mouseCoord = scale:getWorldMouseCoordinates()
      return mouseCoord
    end
    Cursor.update = function(self, lines)
      self.counter = self.counter + 1
      
      if lines[#lines - 10] ~= nil then 
        self.angle = Math:calculateAngleOfTwoLines(lines[#lines], lines[#lines - 5]) 
      end    
      
      if self.counter == Cursor.CYCLE then
        self.counter = 0
        if self.frame == Cursor.FRAME1 then self.frame = Cursor.FRAME2 else self.frame = Cursor.FRAME1 end
      end
    end
    Cursor.draw = function(self, mode)
      local mouse = scale:getWorldMouseCoordinates()
      local frame = self.frame

      if mode == "wait" then
        Graphics:drawQWithRotationAndOffset(Cursor.SPRITESHEET, frame, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.NORMAL)
        Graphics:drawWithRotationAndOffset(Cursor.NO_CUT, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.NORMAL)
      elseif mode == "cut" then
        Graphics:drawQWithRotationAndOffset(Cursor.SPRITESHEET, frame, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.FADED)    
      elseif mode == "ready" or mode == "score" then
        Graphics:drawQWithRotationAndOffset(Cursor.SPRITESHEET, frame, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.NORMAL)    
      end
    end
    
    Polygon.isMouseAtSamePoint = function(self)
      if self:isEmpty() then
        return false
      else 
        local mouseCoord = scale:getWorldMouseCoordinates()
        local point = self:getLatestPoint()
        return point.x == mouseCoord.x and point.y == mouseCoord.y
      end 
    end
    Shape.static.CORRECT_THRESHOLD = 0.5
    
  end
  local laserDescription = "Laser"
  local laserPros = "+ Shoots a laser to draw your line"
  local laserCons = "- 5% more accuracy required to gain points and continue combos"
  local laserEffect = Effect(laserOnApply, laserOnRemove, laserDescription, laserPros, laserCons)
  
  local handOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_hand.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 60, 46, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 46, 60, 46, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 26, y = 18}
    Level.static.MAX_SCORE = 1000
    Level.modifyScore = function(self, score)
      if score < 0 then 
        if self.total > 0 then 
          return math.floor((self.total / 2) * -1)
        else 
          return score
        end
      else
        return score
      end
    end
  end
  local handOnRemove = function()
    Level.static.MAX_SCORE = 200
    Level.modifyScore = function(self, score)
      return score
    end
  end
  local handDescription = "Hand"
  local handPros = "+ All points gained quintipled"
  local handCons = "- Lose half your points on a bad cut"
  local handEffect = Effect(handOnApply, handOnRemove, handDescription, handPros, handCons)

  return {baseScissorsEffect, pizzacutterEffect, gardenshearsEffect, utilityknifeEffect, chainsawEffect, crocodileEffect, laserEffect, handEffect}
end
