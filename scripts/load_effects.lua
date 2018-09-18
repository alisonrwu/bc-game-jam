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
  local baseScissorsEffect = Effect(baseScissorsOnApply, baseScissorsOnRemove, baseScissorsDescription, baseScissorsPros, baseScissorsCons, "Scissors")
  
  local pizzacutterOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_pizzacutter.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 82, 40, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 40, 82, 40, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 11, y = 39}
    
    local buffImg = love.graphics.newImage('assets/graphics/game/player/buff_pizza.png')
    local debuffImg = love.graphics.newImage('assets/graphics/game/player/debuff_pizza.png')
    
    local psystem = love.graphics.newParticleSystem(buffImg, 32)
    psystem:setParticleLifetime(1, 1.5)
    psystem:setEmissionRate(6)
    psystem:setSizeVariation(1)
    psystem:setLinearAcceleration(-15, -200, 10, -200)
    psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    psystem:setEmissionArea("borderrectangle", 25, 8, 0, false)
    psystem:setRelativeRotation(true)
    psystem:setSpread(math.pi / 2)
    psystem:setRotation(math.pi / 4, math.pi)
    psystem:setSpinVariation(1)
    psystem:setSpin(math.pi, 2 * math.pi)
    psystem:setSizes(0.76, 0.7, 0.8, 0.65, 0.86, 1)
    
    pizzaBuff = function(score)
      if score > 0 then return score * 2 else return score end
    end
    
    pizzaDebuff = function(score)
      if score < 0 then return score * 2 else return score end
    end
    
    Level.onScore = function(self, score, problem, successPercentage)
      if problem == "Triangle" then
        if score > 0 then
          psystem:setTexture(buffImg)
          self.currentStatus = Status(psystem, 3, pizzaBuff, "PIZZA_BUFF")
        else
          psystem:setTexture(debuffImg)
          self.currentStatus = Status(psystem, 3, pizzaDebuff, "PIZZA_DEBUFF")
        end
      end
    end
  end
  local pizzacutterOnRemove = function()
    Level.onScore = function(self, score) end
  end
  local pizzacutterDescription = "Pizza Cutter"
  local pizzacutterPros = "+ Cutting a good triangle doubles point gains (lasts 3 shapes)" 
  local pizzacutterCons = "- Cutting a bad triangle doubles point losses (lasts 3 shapes)" 
  local pizzacutterEffect = Effect(pizzacutterOnApply, pizzacutterOnRemove, pizzacutterDescription, pizzacutterPros, pizzacutterCons, "Pizza Cutter")

  local gardenshearsOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_gardenshears.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 94, 48, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 48, 94, 48, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 32, y = 25}
    Shape.transformSuccessPercentage = function(self, successPercentage)
      local transformedPercentage = successPercentage - Shape.CORRECT_THRESHOLD      
      transformedPercentage = 32 * (transformedPercentage ^ 3)
      
      local score = transformedPercentage * self.maxScore
      
      return math.ceil(score)
    end
    Level.onScore = function(self, score, problemName, successPercentage)
      if successPercentage * 100 >= 90 then 
        local leaf = love.graphics.newImage("assets/graphics/game/player/particle_leaf.png")
        local leafSystem = love.graphics.newParticleSystem(leaf, 50)
        leafSystem:setParticleLifetime(1, 1)
        leafSystem:setEmissionRate(50)
        leafSystem:setSizeVariation(1)
        leafSystem:setLinearAcceleration(-1, -1, 1, 1)
        leafSystem:setSpeed(200, 200)
        leafSystem:setEmissionArea("borderellipse", 10, 10, 0, true)
        leafSystem:setSizes(0.75, 1.25, 0.85, 0.65, 0.5, 1, 0.3, 1.5)
        
        local leafPopUp = ParticleSystemPopUp(leafSystem, Graphics.NORMAL, 1, false)
        leafPopUp:setPosition(scale:getWorldMouseCoordinates())
        leafPopUp:setRise(0)
        leafPopUp:setFade(1/50)
        leafPopUp:setTimeBeforeFade(0.25)
        table.insert(self.popUps, leafPopUp)  
      end
    end
  end
  local gardenshearsOnRemove = function()
    Shape.transformSuccessPercentage = function(self, successPercentage)
      local transformedPercentage = successPercentage - Shape.CORRECT_THRESHOLD
      transformedPercentage = 2 * transformedPercentage
      
      local score = transformedPercentage * self.maxScore
      if score > self.maxScore then score = self.maxScore end
      
      return math.ceil(score)
    end    
    Level.onScore = function(self, score)
    end
  end
  local gardenshearsDescription = "Garden Shears"
  local gardenshearsPros = "+ Gain points exponentially based on accuracy (up to 800)"
  local gardenshearsCons = "- Lose points exponentially based on accuracy (down to -800)"
  local gardenshearsEffect = Effect(gardenshearsOnApply, gardenshearsOnRemove, gardenshearsDescription, gardenshearsPros, gardenshearsCons, "Garden Shears")
  
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
  local utilityknifePros = "+ Decrease wait time between shapes (to 0.5s)"
  local utilityknifeCons = "- Lose time on bad cuts (up to 20s)"
  local utilityknifeEffect = Effect(utilityknifeOnApply, utilityknifeOnRemove, utilityknifeDescription, utilityknifePros, utilityknifeCons, "Utility Knife")

  local crocodileOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_crocodile.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 80, 41, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 42, 80, 42, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 24, y = 25}
    Level.onScore = function(self, score, problem, successPercentage)
      if successPercentage > Shape.CORRECT_THRESHOLD then
        local timeGain = math.floor(successPercentage * 7)
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
  local crocodilePros = "+ Gain time based on points (up to 7s)"
  local crocodileCons = "- Time does not reset on Target Up"
  local crocodileEffect = Effect(crocodileOnApply, crocodileOnRemove, crocodileDescription, crocodilePros, crocodileCons, "Crocodile") 

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
  local chainsawPros = "+ Increase combo multiplier on good cuts (to 2.0x)"
  local chainsawCons = "- Very unstable"
  local chainsawEffect = Effect(chainsawOnApply, chainsawOnRemove, chainsawDescription, chainsawPros, chainsawCons, "Chainsaw") 
  
  local laserOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_laser.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 95, 32, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 38, 95, 32, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.WAITFRAME = love.graphics.newImage("assets/graphics/game/player/cursor_laser_wait.png")
    Cursor.static.OFFSET = {x = 5, y = 17}
    Cursor.static.EXTRA_ROT = -(math.pi / 2.5)
    
    Level.static.CHARGE = 0
    Level.static.MAX_CHARGE = 180 -- runs at around 60fps so it takes around 3 seconds
    Level.static.CHARGE_BAR_SPRITEMAP = love.graphics.newImage("assets/graphics/game/player/charge_bar_spritemap.png")
    
    Game.onHoldCut = function(self)
      if Level.CHARGE == 0 then 
        Sound:createAndPlay("assets/audio/sfx/sfx_laser_charge.wav", "laser_charge", false) 
        Sound:setVolume("laser_charge", 0.15)
        Sound:setPitch("laser_charge", 0.66)
        self.playDing = true
      end
      if Level.CHARGE == Level.MAX_CHARGE then
        if self.playDing then
          Sound:stop("laser_charge")
          Sound:createAndPlay("assets/audio/sfx/sfx_charge_max.wav", "charge_max", false)
          Sound:setVolume("charge_max", 0.65)
        end 
        self.playDing = false
      end
      if Level.CHARGE < Level.MAX_CHARGE then
        Level.static.CHARGE = Level.CHARGE + 1  
      end
    end
    Level.drawChargeBar = function(self)
      local segment = Level.MAX_CHARGE / 8
      local posOfQuadToDraw = math.floor(Level.CHARGE / segment)
      local width = 30;
      local height = 15;
      
      local quadToDraw = love.graphics.newQuad(posOfQuadToDraw * width, 0, width, height, Level.CHARGE_BAR_SPRITEMAP:getDimensions())
      local mouse = scale:getWorldMouseCoordinates()
      Graphics:drawQWithRotationAndOffset(Level.CHARGE_BAR_SPRITEMAP, quadToDraw, mouse.x, mouse.y, 0, Cursor.OFFSET.x - 40, Cursor.OFFSET.y + 40, Graphics.NORMAL)
    end
    Level.modifyScore = function(self, score)
      Sound:stop("laser_charge")
      local percentageOfCharge = Level.CHARGE / Level.MAX_CHARGE
      local maxScore = 200 -- you can get an extra 200 points
      local percentageOfScore = percentageOfCharge * maxScore
      local extraScore = 0
      Level.static.CHARGE = 0
      if score >= 0 then 
        extraScore = score + percentageOfScore
      else
        extraScore = score - (percentageOfScore * 2)
      end
      return math.floor(extraScore)
    end
    
  end
  local laserOnRemove = function()
    Level.static.CHARGE = false
    Game.onHoldCut = function(self)
    end
    Level.modifyScore = function(self, score)
      return score
    end
  end
  local laserDescription = "Laser"
  local laserPros = "+ Charge up to gain more points on a good cut (up to +200)"
  local laserCons = "- Lose double those points on a bad cut (down to -400)"
  local laserEffect = Effect(laserOnApply, laserOnRemove, laserDescription, laserPros, laserCons, "Laser")
  
  local handOnApply = function()
    Cursor.static.SPRITESHEET = love.graphics.newImage("assets/graphics/game/player/cursor_hand.png")
    Cursor.static.FRAME1 = love.graphics.newQuad(0, 0, 60, 46, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.FRAME2 = love.graphics.newQuad(0, 46, 60, 46, Cursor.SPRITESHEET:getDimensions())
    Cursor.static.OFFSET = {x = 26, y = 18}
    Level.static.MAX_SCORE = 1000
    Level.modifyScore = function(self, score)
      if score < 0 then 
        return math.floor((self.total / 2) * -1)
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
  local handPros = "+ Point gains are quintupled"
  local handCons = "- Lose half your points on a bad cut"
  local handEffect = Effect(handOnApply, handOnRemove, handDescription, handPros, handCons, "Hand")
  
  return {baseScissorsEffect, pizzacutterEffect, gardenshearsEffect, utilityknifeEffect, chainsawEffect, crocodileEffect, laserEffect, handEffect}
end
