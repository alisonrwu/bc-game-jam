local ScoreManager = {}

inch = 40
errorMargin = inch*1.5

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
	print(#drawing)

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

	local closestTL = 9999
	local closestTR = 9999
	local closestBL = 9999
	local closestBR = 9999
	for i,v in ipairs(drawing) do
		local l = lengthOf(v.x,v.y, rect.topL.x, rect.topL.y)
		if l < closestTL then
			closestTL = l
		end
		l = lengthOf(v.x,v.y, rect.topR.x, rect.topR.y)
		if l < closestTR then
			closestTR = l
		end
		l = lengthOf(v.x,v.y, rect.botL.x, rect.botL.y)
		if l < closestBL then
			closestBL = l
		end
		l = lengthOf(v.x,v.y, rect.botR.x, rect.botR.y)
		if l < closestBR then
			closestBR = l
		end
	end

	local score = (25* ((errorMargin-closestTL)/errorMargin))
							+ (25* ((errorMargin-closestTR)/errorMargin))
							+ (25* ((errorMargin-closestBL)/errorMargin))
							+ (25* ((errorMargin-closestBR)/errorMargin))
	-- only print positive score (starts negative)
	if score >= 0 then
		print('Score is ', score)
		return score
	else
		return -50 -- 0
	end
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

	local closestT = 9999
	local closestR = 9999
	local closestL = 9999
	local closestB = 9999
	for i,v in ipairs(drawing) do
		local l = lengthOf(v.x,v.y, oval.top.x, oval.top.y)
		if l < closestT then
			closestT = l -- closestT is length of the closest point to TOP correct point
		end
		l = lengthOf(v.x,v.y, oval.right.x, oval.right.y)
		if l < closestR then
			closestR = l
		end
		l = lengthOf(v.x,v.y, oval.left.x, oval.left.y)
		if l < closestL then
			closestL = l
		end
		l = lengthOf(v.x,v.y, oval.bot.x, oval.bot.y)
		if l < closestB then
			closestB = l
		end
	end
	-- print(closestT)
	-- print(closestR)
	-- print(closestL)
	-- print(closestB)

	local score = (25* ((errorMargin-closestT)/errorMargin))
							+ (25* ((errorMargin-closestR)/errorMargin))
							+ (25* ((errorMargin-closestL)/errorMargin))
							+ (25* ((errorMargin-closestB)/errorMargin))
	-- only print positive score (starts negative)
	if score >= 0 then
		print('Score is ', score)
		return score
	else
		return -50 --0
	end
end

local function drawRectangle()
	love.graphics.setColor(70, 230, 70, 125)
	love.graphics.rectangle('line', (prevBox.x+(prevBox.w/2))-(rect.width/2), (prevBox.y+(prevBox.h/2))-(rect.height/2), rect.width, rect.height)

	-- for debugging, prints 4 points that are compared
	-- love.graphics.setColor(200, 200, 200, 255)
	-- love.graphics.points(rect.topR.x, rect.topR.y)
	-- love.graphics.points(rect.topL.x, rect.topL.y)
	-- love.graphics.points(rect.botR.x, rect.botR.y)
	-- love.graphics.points(rect.botL.x, rect.botL.y)
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
    
	-- prevBox.x = 0
	-- prevBox.y = 0
	-- prevBox.w = 0
	-- prevBox.h = 0
    
  rect.width = 0
	rect.height = 0
	rect.topL = {}
	rect.topR = {}
	rect.botL = {}
	rect.botR = {}

	oval.xRad = 0
	oval.yRad = 0
	oval.top = {}
	oval.right = {}
	oval.left = {}
	oval.bot = {}
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

-- helper function, returns length of 2 points
function lengthOf(x1,y1,x2,y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- local function getWidth()
-- 	return width
-- end

-- local function getHeight()
-- 	return height
-- end

ScoreManager.rectangleScoring = rectangleScoring
ScoreManager.ovalScoring = ovalScoring
ScoreManager.drawRectangle = drawRectangle
ScoreManager.drawOval = drawOval
ScoreManager.drawBox = drawBox
ScoreManager.reset = reset
-- ScoreManager.getWidth = getWidth
-- ScoreManager.getHeight = getHeight

return ScoreManager