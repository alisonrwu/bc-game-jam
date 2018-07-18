Timer = class("Timer", {DANGER_TIME_LEFT = 15, DANGER_COLOR = Graphics.RED, DANGER_PITCH = 1.2})

function Timer:init()
  self.color = Graphics.NORMAL
  self.time = Level.STARTING_TIME
  self.position = Point(25, 55)
end

function Timer:update(dt)
  self.time = self.time - dt
  
  if self.time <= 0 then
		state = GameOver()  
	elseif self.time <= Timer.DANGER_TIME_LEFT then
    self.color = Timer.DANGER_COLOR
    Sound:setPitch("bgm", Timer.DANGER_PITCH)
	end
end

function Timer:draw()
  Graphics:drawText("Time: " .. math.ceil(self.time, 1), self.position.x, self.position.y, "left", self.color)
end

function Timer:resetTimer()
  self.time = Level.STARTING_TIME
end