RatingFactory = {}

function RatingFactory:rate(score)
  if score <= 0 then
    return BadRating("Are you a monkey?")
  elseif score <= Level.MAX_SCORE * 0.2 then
    return GoodRating("Throw away this trash!")
  elseif score <= Level.MAX_SCORE * 0.4 then
    return GoodRating("Still not good enough.")
  elseif score <= Level.MAX_SCORE * 0.6 then
    return GoodRating("Barely passable...")
  elseif score <= Level.MAX_SCORE * 0.9 then
    return GoodRating("Don't get cocky kid.")
  else
    return GoodRating("That's a FINE cut.")
  end
end

Rating = class("Rating")

function Rating:init(text, color, sound)
  self.text = text or ""
  self.color = color or Graphics.NORMAL
  self.sound = sound or {}
end

GoodRating = Rating:extend("GoodRating")

function GoodRating:init(text)
  self.super.init(self, text, Graphics.GREEN, {path = "assets/audio/sfx/sfx_goodcut.wav", name = "correct"})
end

BadRating = Rating:extend("BadRating")

function BadRating:init(text)
  self.super.init(self, text, Graphics.RED, {path = "assets/audio/sfx/sfx_badcut.wav", name = "wrong"})
end
