Salary = class("Salary")
Salary.static.MAX_AMOUNT = 99999

function Salary:initialize()
  self.amount = 0
  self.iteratedAmount = 0
  self.differenceToIterate = 0
  self.iterate = false
  self.position = Point(40, baseRes.height * 0.88)
  self.dollarSign = ImagePlaceable("assets/graphics/globals/hud_dollarsign.png")
  self.dollarSign:setLeftOfPoint(self.position, -4)
  self.dollarSign.position.y = self.dollarSign.position.y - 5
  self.toDraw = {}
  self.toUpdate = {}
  if love.filesystem.getRealDirectory("data_salary") ~= nil then self:loadAmount() end
end

function Salary:add(amount)
  if amount == 0 then return end
  local amountAdded = amount
  if self.amount + amount > Salary.MAX_AMOUNT then
    amountAdded = Salary.MAX_AMOUNT - self.amount
    self.amount = Salary.MAX_AMOUNT
  else
    self.amount = self.amount + amount
  end
  local amountPopUp 
  if amountAdded > 0 then 
    amountPopUp = NumberPopUp(amountAdded, Graphics.GREEN)
  elseif amountAdded < 0 then
    amountPopUp = NumberPopUp(amountAdded, Graphics.RED)
  else
    amountPopUp = TextPopUp("MAX!")
  end
  amountPopUp.position = Point(self.position.x, self.position.y - 20)
  --amountPopUp:setAbove(self)
  table.insert(self.toDraw, amountPopUp)
  table.insert(self.toUpdate, amountPopUp)
  self:saveAmount()
  self.differenceToIterate = math.ceil((self.amount - self.iteratedAmount) * 0.03)
  self.iterate = true
end

function Salary:update(dt)
  if self.iterate then 
    self.iteratedAmount = self.iteratedAmount + self.differenceToIterate
    if self.differenceToIterate > 0 then
      Sound:createAndPlay("assets/audio/sfx/sfx_coin.wav", "click")
      if self.iteratedAmount >= self.amount then 
        self.iterate = false 
        self.iteratedAmount = self.amount
      end
    else
      Sound:createAndPlay("assets/audio/sfx/sfx_sounds_damage3.wav", "click")
      if self.iteratedAmount <= self.amount then 
        self.iterate = false 
        self.iteratedAmount = self.amount
      end
    end
  end
  for i = 1, #self.toUpdate do
    self.toUpdate[i]:update(dt)
  end
end

function Salary:draw()
  Graphics:drawText(self.iteratedAmount, self.position.x, self.position.y, "left", Graphics.NORMAL)  
  for i = 1, #self.toDraw do
    self.toDraw[i]:draw()
  end
  self.dollarSign:draw()
end

function Salary:saveAmount()
  bitser.dumpLoveFile("data_salary", self.amount)
end

function Salary:loadAmount()
  self.amount = bitser.loadLoveFile("data_salary")
  self.iteratedAmount = self.amount
end