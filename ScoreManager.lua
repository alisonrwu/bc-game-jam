local ScoreManager = {}
local square = {}

local minX = 999
local maxX = 0
local minY = 999
local maxY = 0
local width = 0
local height = 0

local prevBox = {}
prevBox.x = 0
prevBox.y = 0
prevBox.w = 0
prevBox.h = 0

local function squareScoring(drawing)
	-- print('how is my square')

	for i,v in ipairs(drawing) do
		-- print(v.x)
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
		-- table.insert(box, {x = mouseX, y = mouseY, lastX = lastMouseX, lastY = lastMouseY})
	end

	width = maxX-minX
	-- print('width: ', width)
	height = maxY-minY
	-- print('height: ', height)

	-- print('minX: ', minX)
	-- print('maxX: ', maxX)
	-- print('minY: ', minY)
	-- print('maxY: ', maxY)

	prevBox.x = minX
	prevBox.y = minY
	prevBox.w = width
	prevBox.h = height
	-- print(prevBox.x)

	-- for i = 1, #drawing do
	-- 	print(drawing[i].x)
	-- end
end

local function drawBox()
	love.graphics.setColor(200, 200, 200, 255)
	love.graphics.rectangle('line', prevBox.x, prevBox.y, prevBox.w, prevBox.h)
end

local function reset()
	minX = 999
	maxX = 0
	minY = 999
	maxY = 0
	width = 0
	height = 0
end

-- local function getWidth()
-- 	return width
-- end

-- local function getHeight()
-- 	return height
-- end

ScoreManager.squareScoring = squareScoring
ScoreManager.drawBox = drawBox
ScoreManager.reset = reset
-- ScoreManager.getWidth = getWidth
-- ScoreManager.getHeight = getHeight

return ScoreManager