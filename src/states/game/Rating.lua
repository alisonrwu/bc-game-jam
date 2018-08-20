RatingFactory = {}

function RatingFactory:rate(score)
  if score <= -Level.MAX_SCORE * 0.4 then
    return BadRating("Stop monkeying around!")
  elseif score <= -Level.MAX_SCORE * 0.2 then
    return BadRating("My poor paper!")
  elseif score <= 0 then
    return BadRating("That's coming out your paycheck.")
  elseif score <= Level.MAX_SCORE * 0.2 then
    return GoodRating("Barely passable...")
  elseif score <= Level.MAX_SCORE * 0.6 then
    return GoodRating("Don't start slacking!")
  elseif score <= Level.MAX_SCORE * 1 then
    return GoodRating("That'll do.")
  elseif score <= Level.MAX_SCORE * 1.5 then
    return GoodRating("Don't get cocky kid.")
  elseif score <= Level.MAX_SCORE * 2 then
    return GoodRating("That's a FINE cut.")
  elseif score <= Level.MAX_SCORE * 4 then
    return GoodRating("That's INCREDIBLE!!")
  elseif score <= Level.MAX_SCORE * 8 then
    return GoodRating("EXCELLENT WORK!!!")
  elseif score <= Level.MAX_SCORE * 16 then
    return GoodRating("ARE YOU A CUTTING GENIUS?")
  elseif score <= Level.MAX_SCORE * 20 then
    return GoodRating("HOLY MOLY!!!!!!")
  elseif score <= Level.MAX_SCORE * 30 then
    return GoodRating("NUMBER ONE EMPLOYEE!!")
  else
    return GoodRating("THE GOD OF CUTTING HIMSELF!!")
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
