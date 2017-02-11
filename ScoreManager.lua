local ScoreManager = {}

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

local square = {}
square.length = 0
square.topL = {}
square.topR = {}
square.botL = {}
square.botR = {}

local rect = {}
rect.length = 0
rect.topL = {}
rect.topR = {}
rect.botL = {}
rect.botR = {}

-- Scores a square by calculating the 4 corner points of a
-- estimated square shape based off user 'drawing' input,
-- comparing the distance of the closest drawing points.
local function squareScoring(drawing)
	-- print('how is my square')
	updateCacheValues(drawing)

	width = maxX-minX
	height = maxY-minY
	prevBox.x = minX
	prevBox.y = minY
	prevBox.w = width
	prevBox.h = height

	square.length = (width+height)/2
	square.topL.x = minX
	square.topL.y = minY
	square.topR.x = minX+square.length
	square.topR.y = minY
	square.botL.x = minX
	square.botL.y = minY+square.length
	square.botR.x = minX+square.length
	square.botR.y = minY+square.length

	local closestTL = 9999
	local closestTR = 9999
	local closestBL = 9999
	local closestBR = 9999
	for i,v in ipairs(drawing) do
		local l = lengthOf(v.x,v.y, square.topL.x, square.topL.y)
		if l < closestTL then
			closestTL = l
		end
		l = lengthOf(v.x,v.y, square.topR.x, square.topR.y)
		if l < closestTR then
			closestTR = l
		end
		l = lengthOf(v.x,v.y, square.botL.x, square.botL.y)
		if l < closestBL then
			closestBL = l
		end
		l = lengthOf(v.x,v.y, square.botR.x, square.botR.y)
		if l < closestBR then
			closestBR = l
		end
	end
	-- print(closestTL)
	-- print(closestTR)
	-- print(closestBL)
	-- print(closestBR)
	local score = 0.25*(100-closestTL) + 0.25*(100-closestTR) + 0.25*(100-closestBL) + 0.25*(100-closestBR)
	-- only print positive score (starts negative)
	if score >= 0 then
		print('Score is ', score)
		return score
	else
		return 0
	end
end

local function rectangleScoring(drawing, x, y)
	print('how is my rectangle, is it ', x, 'by', y)
end

local function drawSquare()
	love.graphics.setColor(100, 230, 100, 125)
	love.graphics.rectangle('line', prevBox.x, prevBox.y, square.length, square.length)
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

ScoreManager.squareScoring = squareScoring
ScoreManager.rectangleScoring = rectangleScoring
ScoreManager.drawSquare = drawSquare
ScoreManager.drawBox = drawBox
ScoreManager.reset = reset
-- ScoreManager.getWidth = getWidth
-- ScoreManager.getHeight = getHeight

return ScoreManager