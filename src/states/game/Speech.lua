Speech = class("Speech", {bubble = ImagePlaceable("assets/graphics/game/hud/hud_speechbubble.png", Point(10,10))})

function Speech:init(text, color)
  self.text = text or ""
  self.position = Point(20, 20)
  self.color = color or Graphics.NORMAL
end

function Speech:draw()
  Speech.bubble:draw()
  Graphics:drawText(self.text, self.position.x, self.position.y, "left", self.color) 
end
