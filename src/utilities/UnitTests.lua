UnitTests = {}

-- Cannot be a member of UnitTests otherwise it will cause an infinite loop.
function runAllTests()
  for name, test in pairs(UnitTests) do
    print("Currently running: " .. name)
    test()
  end
end

function UnitTests:pointTests()
  local p = Point()
  assert(p == Point(0, 0), "p should be initialized to default values")
  local b = Bounds(100, 200, 100, 200)
  local d = Dimensions(100, 100)
  local p1 = Point.centreOf(b, d)
  assert(p1 == Point(150, 150), "p1 should be the centre of bounds and dimensions")
end

function UnitTests:lineTests()
  local l = Line()
  assert(l == Line(Point(0, 0), Point(0, 0)), "l should be initialized to default values")
end

function UnitTests:dimensionTests()
  local d = Dimensions()
  assert(d == Dimensions(0, 0), "d should be initialized to default values")
  local d1 = Dimensions(100, 200)
  local d2 = Dimensions(200, 300)
  assert(d1 < d2 == true, "d2 should be larger than d1")
  local b = Bounds(100, 200, 100, 200)
  local d3 = Dimensions.ofBounds(b)
  assert(d3 == Dimensions(100, 100), "d3 should correctly reflect bounds")
end

function UnitTests:boundsTests()
  local b = Bounds()
  assert(b == Bounds(math.huge,-math.huge,math.huge,-math.huge), "b should be initialized to default values")
  local p = Point(100, 200)
  local d = Dimensions(200, 300)
  local b1 = Bounds.ofCentreAndDimensions(p, d)
  assert(b1 == Bounds(0, 200, 50, 350), "b1 should correctly reflect centre and dimensions")
  local points = {Point(100, 100), Point(200, 100), Point(100, 200), Point(200, 200)}
  local b2 = Bounds.ofPoints(points)
  assert(b2 == Bounds(100, 200, 100, 200), "b2 should correctly reflect the bounds of all points")
  local inBounds = Point(150, 150)
  assert(b2:isWithin(inBounds) == true, "inBounds should be within b2 bounds")
  local outOfBounds = Point(300, 300)
  assert(b2:isWithin(outOfBounds) == false, "outOfbOunds should be out of b2 bounds")
end

function UnitTests:placeableTests()
  assert(Placeable:includes(Orientation) == true, "Placeable should include Orientation")
  local i = ImagePlaceable()
  assert(i.image == false and i.dimensions == Dimensions() and i.position == Point(), "i should be initialized to default values")
  assert(ImagePlaceable:includes(Orientation) == true, "ImagePlaceable should include Orientation")
  local i1 = ImagePlaceable("assets/graphics/icon.png")
  assert(i1.dimensions == Dimensions(48, 48), "i1 should have the correct dimensions")
  local t = TextPlaceable()
  assert(t.text == "" and t.dimensions == Dimensions(0, 34) and t.position == Point() and t.align == "left" and t.color == Graphics.NORMAL,
    "t should be initialized to default values")
  local ft = FlashingTextPlaceable()
  assert(ft.baseColor == Graphics.NORMAL and ft.cycle == 15, "ft should be initialized to default values")
end

function UnitTests:orientationTests()
  local p = TextPlaceable("Test", Point(200,100)) -- width is 18 * 4 = 72, height is 34
  local p2 = TextPlaceable("Test2", Point(0, 100)) -- width is 18 * 5 = 90, height is 34
  p2:setLeft(p, 10) -- x begins at 200, subtract width of 90 + offset of 10, p2 new x should be 100
  assert(p2.position == Point(100, 100), "p2 should be to the left of p")
  p2:setRight(p, 10) -- x begins at 200, add width of 72 + offset of 10, p2 new x should be 282
  assert(p2.position == Point(282, 100), "p2 should be to the right of p")
  local p3 = ImagePlaceable("assets/graphics/icon.png", Point(200, 100)) -- width is 48, height is 48
  p2:setBelow(p3, 10) -- y begins at 100, add height of 48 + offset of 10, p2 new y should be 158
  assert(p2.position == Point(282, 158), "p2 should be at the bottom of p3")
  p2:setAbove(p3, 10) -- y begins at 100, subtract height of 34 + offset of 10, p2 new y should be 56
  assert(p2.position == Point(282, 56), "p2 should be above p3")
  p2:setCentreHorizontal(p3) -- x begins at 200, add (48/2 = 24) - (90/2 = 45) = -21, new x should be 179
  assert(p2.position == Point(179, 56), "p2 should be centered horizontally relative to p3")
  p2:setCentreVertical(p3) -- y begins at 100, add (48/2 = 24) - (34/2 = 17) = 7, new y should be 107
  assert(p2.position == Point(179, 107), "p2 should be centered vertically relative to p3")
end

function UnitTests:buttonTests()
  local b = ImageButton()
  assert(b.image == false and b.dimensions == Dimensions() and b.bounds == Bounds(), "b should be initialized to default values")
  b:onClick()
end

function UnitTests:mathTests()
  local b1 = Bounds(10, 20, 8, 12)
  local b2 = Bounds(5, 12, 10, 30)
  local mb = Math:calculateMaximumBounds(b1, b2)
  assert(mb == Bounds(5, 20, 8, 30), "mb isn't the max of b1 and b2")
end

function UnitTests:shapeTests()
  local s = Shape(3, 4, 100)
  local cf = Shape.CONVERSION_FACTOR
  local mf = Shape.MAX_SIZE_FACTOR
  assert(s.maxScore == 100, "shape.maxScore should have the initialized max score")
  assert(s.bounds:instanceOf(Bounds), "shape.bounds should be Bounds object")
  assert(s.dimensionsInGameUnits == Dimensions(3, 4), "shape.dimensionsInGameUnits aren't correct")
  assert(s.dimensions == Dimensions(3 * cf, 4 * cf), "shape.dimensions aren't correct") 
  -- Testing out change to limit size of shape to 400 by 400.
  --assert(s.maxSizeDimensions == Dimensions(3 * cf * mf, 4 * cf * mf), "shape.maxSizeDimensions aren't correct")
end

function UnitTests:highScoreTests()
  local function isSame(table1, table2)
    if #table1 ~= #table2 then return false end
    for i = 1, #table1 do
      if table1[i] ~= table2[i] then return false end
    end
    return true
  end

  HighScore:attemptToAddScore(1)
  assert(isSame(HighScore.scores, {1}), "1 should be added")
  HighScore:attemptToAddScore(4)
  assert(isSame(HighScore.scores, {4, 1}), "4 should be added in the front")
  HighScore:attemptToAddScore(3)
  assert(isSame(HighScore.scores, {4, 3, 1}), "3 should be added in between")
  HighScore:attemptToAddScore(2)
  assert(isSame(HighScore.scores, {4, 3, 2}), "2 should be added at the back")
  HighScore:attemptToAddScore(5)
  assert(isSame(HighScore.scores, {5, 4, 3}), "5 should be added to the front")
  HighScore:attemptToAddScore(0)  
  assert(isSame(HighScore.scores, {5, 4, 3}), "0 should not be added")
  
  
  HighScore.scores = {}
  HighScore:attemptToAddScore(1)  
  assert(isSame(HighScore.scores, {1}), "1 should be added")
  HighScore:attemptToAddScore(1)  
  assert(isSame(HighScore.scores, {1, 1}), "1 should be added")
  HighScore:attemptToAddScore(1)  
  assert(isSame(HighScore.scores, {1, 1, 1}), "1 should be added")
  
  HighScore.scores = {}
  HighScore:attemptToAddScore(5)  
  assert(isSame(HighScore.scores, {5}), "5 should be added")
  HighScore:attemptToAddScore(4)  
  assert(isSame(HighScore.scores, {5, 4}), "4 should be added")
  HighScore:attemptToAddScore(3)  
  assert(isSame(HighScore.scores, {5, 4, 3}), "3 should be added")
end

