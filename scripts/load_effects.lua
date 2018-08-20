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
    Level.onScore = function(self, score, problem, successPercentage)
      if problem == "Triangle" then
        if successPercentage >= Shape.CORRECT_THRESHOLD then self.combo.multiplier = self.combo.multiplier + Combo.INCREASE * 3 end
      end
    end
    Level.modifyScore = function(self, score)
      if problem == "Triangle" then
        if score > 0 then
          return score * 3
        else 
          return score
        end
      else 
        return score
      end
    end
    Level.generateWidthAndHeight = function()
      local randWidth, randHeight = 0, 0
      while randWidth == randHeight do
        randWidth = love.math.random(Level.MIN_SHAPE_DIMEN, Level.MAX_SHAPE_DIMEN)
        randHeight = love.math.random(Level.MIN_SHAPE_DIMEN, Level.MAX_SHAPE_DIMEN)
      end
      return randWidth, randHeight
    end
  end
  local pizzacutterOnRemove = function()
    Level.onScore = function(self, score) end
    Level.modifyScore = function(self, score) 
        return score
    end
    Level.generateWidthAndHeight = function()
      local randWidth = love.math.random(Level.MIN_SHAPE_DIMEN, Level.MAX_SHAPE_DIMEN)
      local randHeight = love.math.random(Level.MIN_SHAPE_DIMEN, Level.MAX_SHAPE_DIMEN)
      return randWidth, randHeight
    end
  end
  local pizzacutterDescription = "Pizza Cutter"
  local pizzacutterPros = "+ Triple shape and combo gains for triangles (up to 600, +1.5x)" 
  local pizzacutterCons = "- Shapes cannot be the same width and length" 
  local pizzacutterEffect = Effect(pizzacutterOnApply, pizzacutterOnRemove, pizzacutterDescription, pizzacutterPros, pizzacutterCons)

  local gardenshearsOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_gardenshears.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 94, 48, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 48, 94, 48, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 32, y = 25}
    Shape.static.CORRECT_THRESHOLD = 0.45
    Level.static.MIN_SHAPE_DIMEN = 2
    Level.static.MAX_SHAPE_DIMEN = 5
    
  end
  local gardenshearsOnRemove = function()
    Shape.static.CORRECT_THRESHOLD = 0.5
    Level.static.MIN_SHAPE_DIMEN = 1
    Level.static.MAX_SHAPE_DIMEN = 6
  end
  local gardenshearsDescription = "Garden Shears"
  local gardenshearsPros = "+ 5% less accuracy required to gain points and continue combos"
  local gardenshearsCons = "- Shapes cannot be of size 1 or 6"
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
    Level.onScore = function(self, score, successPercentage)
      if successPercentage > 0 then
        local timeGain = successPercentage * 15
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
    function Timer:resetTimer()
      self.time = Timer.RESET_TIME
    end
  end
  local crocodileDescription = "Crocodile"
  local crocodilePros = "+ Gain time based on points         (up to 5s)"
  local crocodileCons = "- No longer reset time on Target Up"
  local crocodileEffect = Effect(crocodileOnApply, crocodileOnRemove, crocodileDescription, crocodilePros, crocodileCons) 

  local chainsawOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_chainsaw.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 2, 92, 40, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 44, 90, 40, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 5, y = 33}
    Cursor.static.EXTRA_ROT = -(math.pi / 6)
    Combo.static.INCREASE = 0.25
    Game.static.OSCILLATION_OFFSET = 0
    Combo.INCREASE = 2
    Game.getDrawPoint = function()
      local mouseCoord = scale:getWorldMouseCoordinates()
      local offset_y = -5 * math.cos(Game.OSCILLATION_OFFSET)
      local offset_x = -5 * math.cos(Game.OSCILLATION_OFFSET)
      mouseCoord.y = mouseCoord.y + offset_y
      mouseCoord.x = mouseCoord.x + offset_x
      Game.static.OSCILLATION_OFFSET = (Game.static.OSCILLATION_OFFSET + (2 * math.pi / 20)) % (2 * math.pi)
      return mouseCoord
    end
  end
  local chainsawOnRemove = function()
    Combo.INCREASE = 0.5
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
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 85, 32, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 38, 85, 32, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.WAITFRAME = love.graphics.newImage("assets/graphics/game/player/cursor_laser_wait.png")
    Cursor.static.OFFSET = {x = 57, y = 17}
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
      
      if self.lefty then
        Cursor.static.EXTRA_ROT = Cursor.EXTRA_ROT * -1
      end

      if mode == "wait" then
        Graphics:drawWithRotationAndOffset(Cursor.WAITFRAME, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, 27, 5, Graphics.NORMAL)
        Graphics:drawWithRotationAndOffset(Cursor.NO_CUT, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.NORMAL)
      elseif mode == "cut" then
        Graphics:drawQWithRotationAndOffset(Cursor.SPRITESHEET, frame, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, Cursor.OFFSET.x, Cursor.OFFSET.y, Graphics.FADED)    
      elseif mode == "ready" or mode == "score" then
        Graphics:drawWithRotationAndOffset(Cursor.WAITFRAME, mouse.x, mouse.y, self.angle + Cursor.EXTRA_ROT, 27, 5, Graphics.NORMAL) 
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
    
    Shape.static.CORRECT_THRESHOLD = 0.6 
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
      
      if self.lefty then
        Cursor.static.EXTRA_ROT = Cursor.EXTRA_ROT * -1
      end

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
  local laserCons = "- 10% more accuracy required to gain points and continue combos"
  local laserEffect = Effect(laserOnApply, laserOnRemove, laserDescription, laserPros, laserCons)
  
  local handOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_hand.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 60, 46, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 46, 60, 46, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 26, y = 18}
    Level.static.MAX_SCORE = 1000
    Level.modifyScore = function(self, score)
      if score < 0 then return (self.total / 2) * -1 else return score end
    end
  end
  local handOnRemove = function()
    Level.static.MAX_SCORE = 200
    Level.modifyScore = function(self, score)
    end
  end
  local handDescription = "Hand"
  local handPros = "+ All points gained quintipled"
  local handCons = "- Lose half your points on a bad cut"
  local handEffect = Effect(handOnApply, handOnRemove, handDescription, handPros, handCons)

  return {baseScissorsEffect, pizzacutterEffect, gardenshearsEffect, utilityknifeEffect, chainsawEffect, crocodileEffect, laserEffect, handEffect}
end
