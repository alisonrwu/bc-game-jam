Speech = class("Speech")
Speech.static.BUBBLE = ImagePlaceable("assets/graphics/game/hud/hud_speechbubble.png", Point(6,8))

function Speech:initialize(text, color)
  self.text = text or ""
  self.iteratedText = ""
  Sound:create("assets/audio/sfx/sfx_blipmale_11.wav", "blipmale", false)
  Sound:create("assets/audio/sfx/sfx_blipfemale_11.wav", "blipfemale", false)
  self.iterationIndex = 1
  self.blip = "male"
  self.position = Point(25, 17)
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
