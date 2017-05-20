local ScoreManager = {}

inch = 40
maximumScore = 160

local minX = 9999
local maxX = 0
local minY = 9999
local maxY = 0
local width = 0
local height = 0

local prevBox = {}
prevBox.x = 0
prevBox.y = 0
prevBox.w = 0
prevBox.h = 0

local rect = {}
rect.width = 0
rect.height = 0
rect.topL = {}
rect.topR = {}
rect.botL = {}
rect.botR = {}
rect.points = {}

local oval = {}
oval.xRad = 0
oval.yRad = 0
oval.top = {}
oval.left = {}
oval.right = {}
oval.bot = {}

-- Scores a rectangle by calculating the 4 corner points of a
-- estimated rectangular shape based off user 'drawing' input,
-- comparing the distance of the closest drawing points.
local function rectangleScoring(drawing, x, y)
	-- print('how is my rectangle, is it ', x, 'by', y)
	updateCacheValues(drawing)
	-- print(#drawing)

	local centreX = minX+width/2
	local centreY = minY+height/2

	rect.width = x*inch
	rect.height = y*inch

	rect.topL.x = centreX - rect.width/2 -- minX
	rect.topL.y = centreY - rect.height/2 -- minY
	rect.topR.x = centreX + rect.width/2 -- minX+rect.width
	rect.topR.y = centreY - rect.height/2 -- minY
	rect.botL.x = centreX - rect.width/2 -- minX
	rect.botL.y = centreY + rect.height/2 -- minY+rect.height
	rect.botR.x = centreX + rect.width/2 -- minX+rect.width
	rect.botR.y = centreY + rect.height/2 -- minY+rect.height
    
    local sP = drawing
    local cP = createInterpolatedRectangle()
    
    local successPercentage = calculateSuccessPercentage(sP, cP, rect.topL.x, rect.topR.x, rect.topL.y, rect.botL.y)
    local score = transformSuccessPercentage(successPercentage, rect.width * rect.height)
    
    print("Score = ", score)
    return score
end

local function ovalScoring(drawing, x, y)
	-- print('how is my oval')
	updateCacheValues(drawing)

	local centreX = minX+width/2
	local centreY = minY+height/2

	oval.xRad = (x/2)*inch
	oval.yRad = (y/2)*inch

	oval.top.x = centreX
	oval.top.y = centreY-oval.yRad
	oval.left.x = centreX-oval.xRad
	oval.left.y = centreY
	oval.right.x = centreX+oval.xRad
	oval.right.y = centreY
	oval.bot.x = centreX
	oval.bot.y = centreY+oval.yRad
    
    local sP = drawing
    local cP = createInterpolatedOval()
    
    local successPercentage = calculateSuccessPercentage(sP, cP, oval.left.x, oval.right.x, oval.top.y, oval.bot.y)
    local score = transformSuccessPercentage(successPercentage, oval.xRad * oval.yRad * math.pi)
    
    print("Score = ", score)
    return score
end

function transformSuccessPercentage(successPercentage, targetArea)
   -- Shapes with smaller areas are typically harder to get, so make those sP's worth more
    local scaleFactor = 0.25 * math.exp(-1 * targetArea / 3000) + 0.75
    local score = successPercentage * scaleFactor * maximumScore
    
    -- Cap scores at some number of points
    if score > maximumScore then score = maximumScore end
    
    return score
end

function calculateSuccessPercentage(sP, cP, minimumX, maximumX, minimumY, maximumY)
    if minX < minimumX then minimumX = minX end
    if maxX > maximumX then maximumX = maxX end
    if minY < minimumY then minimumY = minY end
    if maxY > maximumY then maximumY = maxY end
    
    local successes = 0
    local pointsChecked = 0
    
    for i = minimumX, maximumX, 1 do
        for j = minimumY, maximumY, 1 do
            local testPoint = {x = i, y = j}
            local insideDrawing = isPointInsidePolygon(testPoint, sP)
            local insideTestShape = isPointInsidePolygon(testPoint, cP)
            
            if insideDrawing or insideTestShape then
                pointsChecked = pointsChecked + 1
            end
            
            if insideDrawing and insideTestShape then
                successes = successes + 1
            end
        end
    end
    
    local successPercentage = successes / pointsChecked
    
    print("SuccessP = ", successPercentage)
    
    return successPercentage
end

function isPointInsidePolygon(point, polygon)
    local x = point.x
    local y = point.y
    
    local inside = false
    local lastPoint = polygon[#polygon]
    for _, p in ipairs(polygon) do
        local xi = p.x
        local yi = p.y
        
        local xj = lastPoint.x
        local yj = lastPoint.y
        
        lastPoint = p
        
        local intersect = ((yi > y) ~= (yj > y)) and (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
        if intersect then
            inside = not inside
        end
    end
    
    return inside
end

function createInterpolatedRectangle()
    local outputList = {}
    
    -- Top line
    local diff = rect.topR.x - rect.topL.x
    local step = diff / 10
    
    for i = 0, diff, step do
        outputList[#outputList+1] = {x = rect.topL.x + i, y = rect.topL.y}
    end
    
    -- Right line
    diff = rect.botR.y - rect.topR.y
    step = diff / 10
    
    for i = 0, diff, step do
        outputList[#outputList+1] = {x = rect.topR.x, y = rect.topR.y + i}
    end
    
    -- Bottom line
    diff = rect.botR.x - rect.botL.x
    step = diff / 10
    
    for i = 0, diff, step do
        outputList[#outputList+1] = {x = rect.botR.x - i, y = rect.botL.y}
    end
    
    -- Left line
    diff = rect.botL.y - rect.topL.y
    step = diff / 10
    
    for i = 0, diff, step do
        outputList[#outputList+1] = {x = rect.botL.x, y = rect.botL.y - i}
    end
    
    return outputList
end

function createInterpolatedOval()
    local outputList = {}
    
    local h = oval.bot.y - oval.top.y
    local w = oval.right.x - oval.left.x
    
    local function ellipseFunctionY(x)
        -- h * sqrt(1/4 - (x/w)^2)
        return h * math.sqrt(1/4 - (x/w) * (x/w))
    end
    
    local step = w / 10
    local halfW = w / 2
    local halfH = h / 2
    
    for i = 0, w, step do
        outputList[#outputList+1] = {x = oval.left.x + i,
                                     y = oval.top.y + halfH - ellipseFunctionY(i - halfW)}
    end
    
    for i = 0, w, step do
       outputList[#outputList+1] = {x = oval.right.x - i,
                                    y = oval.top.y + halfH + ellipseFunctionY(i - halfW)} 
    end
    
    return outputList
end

local function drawRectangle()
	love.graphics.setColor(70, 230, 70, 125)
	love.graphics.rectangle('line', (prevBox.x+(prevBox.w/2))-(rect.width/2), (prevBox.y+(prevBox.h/2))-(rect.height/2), rect.width, rect.height)

	-- for debugging, prints 4 points that are compared
	--love.graphics.setColor(255, 0, 0, 255)
	--love.graphics.points(rect.topR.x, rect.topR.y)
	--love.graphics.points(rect.topL.x, rect.topL.y)
	--love.graphics.points(rect.botR.x, rect.botR.y)
	--love.graphics.points(rect.botL.x, rect.botL.y)
end

local function drawOval()
	love.graphics.setColor(100, 230, 100, 125)
	love.graphics.ellipse('line', (prevBox.x+(prevBox.w/2)), (prevBox.y+(prevBox.h/2)), oval.xRad, oval.yRad)

	-- love.graphics.setColor(200, 200, 200, 255)
	-- love.graphics.points(oval.top.x, oval.top.y)
	-- love.graphics.points(oval.left.x, oval.left.y)
	-- love.graphics.points(oval.right.x, oval.right.y)
	-- love.graphics.points(oval.bot.x, oval.bot.y)
end

local function drawBox()
	love.graphics.setColor(200, 200, 200, 255)
	love.graphics.rectangle('line', prevBox.x, prevBox.y, prevBox.w, prevBox.h)
end

local function reset()
	minX = 9999
	maxX = 0
	minY = 9999
	maxY = 0
	width = 0
	height = 0
end

function updateCacheValues(drawing)
	for i,v in ipairs(drawing) do
		if v.x < minX then
			minX = v.x
		end
		if v.x > maxX then
			maxX = v.x
		end
		if v.y < minY then
			minY = v.y
		end
		if v.y > maxY then
			maxY = v.y
		end
	end
	width = maxX-minX
	height = maxY-minY
	prevBox.x = minX
	prevBox.y = minY
	prevBox.w = width
	prevBox.h = height
end

ScoreManager.rectangleScoring = rectangleScoring
ScoreManager.ovalScoring = ovalScoring
ScoreManager.drawRectangle = drawRectangle
ScoreManager.drawOval = drawOval
ScoreManager.drawBox = drawBox
ScoreManager.reset = reset

return ScoreManager