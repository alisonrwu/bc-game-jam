Utilities = {}

function Utilities:screenToWorldCoordinates(sx, sy)
  return (sx - translationX) / scaleX, (sy - translationY) / scaleY
end

function Utilities:getWorldMouseCoordinates()
  return Utilities:screenToWorldCoordinates(love.mouse.getX(), love.mouse.getY())
end