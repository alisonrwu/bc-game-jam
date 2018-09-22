Wait = {}

-- If a timer underneath that key doesn't exist, add one. Otherwise, replace the timer specified by the key.
function Wait:replaceTimer(key, seconds, callback, args)
  if self.timers == nil then 
    self.timers = {[key] = {timeLeft = seconds, callback = callback, args = args}} 
  else 
    self.timers[key] = {timeLeft = seconds, callback = callback, args = args}
  end
end

-- Wait until timer runs down to 0 then trigger the callback.
function Wait:wait(dt)
  if self.timers ~= nil then
    for key, timer in pairs(self.timers) do
      timer.timeLeft = timer.timeLeft - dt
      if timer.timeLeft <= 0 then 
        timer.callback(self, timer.args) -- we want to pass in the original class and not the Wait mix-in
        self.timers[key] = nil
      end
    end
  end
end