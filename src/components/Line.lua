Line = class("Line")

function Line:init(p1, p2)
  self.p1, self.p2 = p1 or Point(), p2 or Point()
end

function Line:draw()
  love.graphics.line(self.p2.x, self.p2.y, self.p1.x, self.p1.y)
end

function Line.__eq(l1, l2)
  return l1.p1 == l2.p1 and l1.p2 == l2.p2
end