RatingFactory = {}

function RatingFactory:rate(score)
  if score <= -Level.MAX_SCORE * 0.4 then
    return BadRating("Are you a monkey?")
  elseif score <= -Level.MAX_SCORE * 0.2 then
    return BadRating("My poor paper!")
  elseif score <= 0 then
    return BadRating("That's coming out your paycheck.")
  elseif score <= Level.MAX_SCORE * 0.2 then
    return GoodRating("Barely passable...")
  elseif score <= Level.MAX_SCORE * 0.4 then
    return GoodRating("Don't start slacking!")
  elseif score <= Level.MAX_SCORE * 0.6 then
    return GoodRating("That'll do.")
  elseif score <= Level.MAX_SCORE * 0.9 then
    return GoodRating("Don't get cocky kid.")
  else
    return GoodRating("That's a FINE cut.")
  end
end

Rating = class("Rating")

function Rating:initialize(text, color, sound)
  self.text = text or ""
  self.color = color or Graphics.NORMAL
  self.sound = sound or {}
end

function Rating:__tostring()
  return "Rating"
end

GoodRating = Rating:subclass("GoodRating")

function GoodRating:initialize(text)
  Rating.initialize(self, text, Graphics.GREEN, {path = "assets/audio/sfx/sfx_goodcut.wav", name = "correct"})
end

function GoodRating:__tostring()
  return "GoodRating"
end

BadRating = Rating:subclass("BadRating")

function BadRating:initialize(text)
  Rating.initialize(self, text, Graphics.RED, {path = "assets/audio/sfx/sfx_badcut.wav", name = "wrong"})
end

function BadRating:__tostring()
  return "BadRating"
end
