Observable = {}

function Observable:registerObserver(observer)
  if self.observers == nil then self.observers = {observer} else table.insert(self.observers, observer) end
end

function Observable:notifyObservers(event, args)
  if self.observers then
    for _, observer in ipairs(self.observers) do
      observer:notify(event, args)
    end
  end
end