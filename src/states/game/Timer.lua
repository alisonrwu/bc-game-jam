Timer = class("Timer")
Timer.static.DANGER_TIME_LEFT = 15
Timer.static.DANGER_PITCH = 1.2
Timer.static.DANGER_COLOR = Graphics.RED
Timer.static.OUT_OF_TIME = "OUT_OF_TIME"
Timer.static.RESET_TIME = Level.STARTING_TIME

function Timer:initialize()
  self.observers = {}
  self.color = Graphics.NORMAL
  self.time = Level.STARTING_TIME
  self.timePlayed = 0
  self.position = Point(25, 56)
end

function Timer:update(dt)
  if self.time <= 0 then 
    for _, obs in ipairs(self.observers) do
      obs:notify(Timer.OUT_OF_TIME)
    end
    return
  end
	if self.time <= Timer.DANGER_TIME_LEFT then
    self.color = Timer.DANGER_COLOR
    Sound:setPitch("bgm", Timer.DANGER_PITCH)
	else 
    self.color = Graphics.NORMAL
    Sound:setPitch("bgm", 1)
  end
  self.time = self.time - dt
  if self.time <= 0 then self.time = 0 end
  self.timePlayed = self.timePlayed + dt
end

function Timer:registerObserver(observer)
  table.insert(self.observers, observer)
end

function Timer:draw()
  Graphics:drawText("Time: " .. math.ceil(self.time, 1), self.position.x, self.position.y, "left", self.color)
end

function Timer:resetTimer()
  self.time = Timer.RESET_TIME
end