State = class("State")

function State:init()  
  error("Cannot initialize an unspecified state!")
end

function State:update()  
  error("Cannot update an unspecified state!")
end

function State:draw()  
  error("Cannot draw an unspecified state!")
end

function State:mouseRelease(x, y, button, isTouch) 
  error("Cannot call mouseRelease on an unspecified state!")
end

function State:mousePressed(x, y, button, isTouch)
  error("Cannot call mousePressed on an unspecified state!")
end