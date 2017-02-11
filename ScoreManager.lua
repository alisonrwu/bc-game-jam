local ScoreManager = {}

inch = 40

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

-- Scores a rectangle by calculating the 4 corner points of a
-- estimated rectangular shape based off user 'drawing' input,
-- comparing the distance of the closest drawing points.
local function rectangleScoring(drawing, x, y)
	-- print('how is my rectangle, is it ', x, 'by', y)
	updateCacheValues(drawing)

	rect.width = x*inch
	rect.height = y*inch
	rect.topL.x = minX
	rect.topL.y = minY

	rect.topR.x = minX+rect.width
	rect.topR.y = minY
	rect.botL.x = minX
	rect.botL.y = minY+rect.height
	rect.botR.x = minX+rect.width
	rect.botR.y = minY+rect.height

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

	if math.abs(rect.width - prevBox.w) > inch then
		return -50
	end

	local score = 0.25*(inch-closestTL) + 0.25*(inch-closestTR) + 0.25*(inch-closestBL) + 0.25*(inch-closestBR)
	-- only print positive score (starts negative)
	if score >= 0 then
		print('Score is ', score)
		return score
	else
		return 0
	end
end

local function drawRectangle()
	love.graphics.setColor(100, 230, 100, 125)
	love.graphics.rectangle('line', prevBox.x, prevBox.y, rect.width, rect.height)
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
ScoreManager.drawRectangle = drawRectangle
ScoreManager.drawBox = drawBox
ScoreManager.reset = reset
-- ScoreManager.getWidth = getWidth
-- ScoreManager.getHeight = getHeight

return ScoreManager