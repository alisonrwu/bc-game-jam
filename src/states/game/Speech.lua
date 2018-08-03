Speech = class("Speech")
Speech.static.BUBBLE = ImagePlaceable("assets/graphics/game/hud/hud_speechbubble.png", Point(10,10))

function Speech:initialize(text, color)
  self.text = text or ""
  self.iteratedText = ""
  self.iterationIndex = 1
  self.blip = "male"
  self.position = Point(20, 20)
  self.color = color or Graphics.NORMAL
  self.iterate = true
end

function Speech:setText(text)
  self.text = text
  self.iterate = true
end

function Speech:setColor(color)
  self.color = color
end

function Speech:update()
  if self.iterate then 
    if self.iterationIndex == string.len(self.text) then self.iterate = false end
    self.iteratedText = string.sub(self.text, 1, self.iterationIndex)
    self.iterationIndex = self.iterationIndex + 1
    if self.blip == "male" then 
      Sound:play("blipmale")
      self.blip = "female"
    else
      Sound:play("blipfemale")
      self.blip = "male"
    end
  end
end

function Speech:draw()
  Speech.BUBBLE:draw()
  Graphics:drawText(self.iteratedText, self.position.x, self.position.y, "left", self.color) 
end
