ScoreManager = {
    inch = 40,
    maximumScore = 160,
    pointsToContinueCombo = 1,
    comboMultiplier = 1,
    minX = 9999,
    maxX = 0,
    minY = 9999,
    maxY = 0,
    width = 0,
    height = 0 
}


local prevBox = {
    x = 0,
    y = 0,
    w = 0,
    h = 0
}

local rect = {
    width = 0,
    height = 0,
    topL = {},
    topR = {},
    botL = {},
    botR = {},
    points = {}
}

local oval = {
    xRad = 0,
    yRad = 0,
    top = {},
    left = {},
    right = {},
    bot = {}
}

function ScoreManager:calculateComboBonus(score)
    if (score >= ScoreManager.pointsToContinueCombo) then
        ScoreManager.comboMultiplier = ScoreManager.comboMultiplier + 0.5
    else
        ScoreManager.comboMultiplier = 1
    end
    
    return score * ScoreManager.comboMultiplier
end    

-- Scores a rectangle by calculating the 4 corner points of a
-- estimated rectangular shape based off user 'drawing' input,
-- comparing the distance of the closest drawing points.
function ScoreManager:rectangleScoring(drawing, x, y)
	ScoreManager:updateCacheValues(drawing)

	local centreX = ScoreManager.minX+ScoreManager.width/2
	local centreY = ScoreManager.minY+ScoreManager.height/2

	rect.width = x*ScoreManager.inch
	rect.height = y*ScoreManager.inch

	rect.topL.x = centreX - rect.width/2 -- minX
	rect.topL.y = centreY - rect.height/2 -- minY
	rect.topR.x = centreX + rect.width/2 -- minX+rect.width
	rect.topR.y = centreY - rect.height/2 -- minY
	rect.botL.x = centreX - rect.width/2 -- minX
	rect.botL.y = centreY + rect.height/2 -- minY+rect.height
	rect.botR.x = centreX + rect.width/2 -- minX+rect.width
	rect.botR.y = centreY + rect.height/2 -- minY+rect.height
    
    local sP = drawing
    local cP = ScoreManager:createInterpolatedRectangle()
    
    local successPercentage = ScoreManager:calculateSuccessPercentage(sP, cP, rect.topL.x, rect.topR.x, rect.topL.y, rect.botL.y)
    local score = ScoreManager:transformSuccessPercentage(successPercentage, rect.width * rect.height)
    local comboMultipliedScore = ScoreManager:calculateComboBonus(score)
    
    return comboMultipliedScore
end

function ScoreManager:ovalScoring(drawing, x, y)
	ScoreManager:updateCacheValues(drawing)

	local centreX = ScoreManager.minX+ScoreManager.width/2
	local centreY = ScoreManager.minY+ScoreManager.height/2

	oval.xRad = (x/2)*ScoreManager.inch
	oval.yRad = (y/2)*ScoreManager.inch

	oval.top.x = centreX
	oval.top.y = centreY-oval.yRad
	oval.left.x = centreX-oval.xRad
	oval.left.y = centreY
	oval.right.x = centreX+oval.xRad
	oval.right.y = centreY
	oval.bot.x = centreX
	oval.bot.y = centreY+oval.yRad
    
    local sP = drawing
    local cP = ScoreManager:createInterpolatedOval()
    
    local successPercentage = calculateSuccessPercentage(sP, cP, oval.left.x, oval.right.x, oval.top.y, oval.bot.y)
    local score = transformSuccessPercentage(successPercentage, oval.xRad * oval.yRad * math.pi)
    
    local comboMultipliedScore = ScoreManager:calculateComboBonus(score)
    
    return comboMultipliedScore
end

function ScoreManager:transformSuccessPercentage(successPercentage, targetArea)
   -- Shapes with smaller areas are typically harder to get, so make those sP's worth more
    local scaleFactor = 0.25 * math.exp(-1 * targetArea / 3000) + 0.75
    local transformedPercentage = successPercentage - 0.5
    if(transformedPercentage >= 0) then transformedPercentage = 2 * transformedPercentage end
    
    local score = transformedPercentage * scaleFactor * ScoreManager.maximumScore
    
    -- Cap scores at some number of points
    if score > ScoreManager.maximumScore then score = ScoreManager.maximumScore end
    
    return score
end

function ScoreManager:calculateSuccessPercentage(sP, cP, minimumX, maximumX, minimumY, maximumY)
    if ScoreManager.minX < minimumX then minimumX = ScoreManager.minX end
    if ScoreManager.maxX > maximumX then maximumX = ScoreManager.maxX end
    if ScoreManager.minY < minimumY then minimumY = ScoreManager.minY end
    if ScoreManager.maxY > maximumY then maximumY = ScoreManager.maxY end
    
    local successes = 0
    local pointsChecked = 0
    
    for i = minimumX, maximumX, 1 do
        for j = minimumY, maximumY, 1 do
            local testPoint = {x = i, y = j}
            local insideDrawing = ScoreManager:isPointInsidePolygon(testPoint, sP)
            local insideTestShape = ScoreManager:isPointInsidePolygon(testPoint, cP)
            
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

function ScoreManager:isPointInsidePolygon(point, polygon)
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

function ScoreManager:createInterpolatedRectangle()
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

function ScoreManager:createInterpolatedOval()
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

function ScoreManager:drawRectangle()
	love.graphics.setColor(70, 230, 70, 125)
	love.graphics.rectangle('line', (prevBox.x+(prevBox.w/2))-(rect.width/2), (prevBox.y+(prevBox.h/2))-(rect.height/2), rect.width, rect.height)

	-- for debugging, prints 4 points that are compared
	--love.graphics.setColor(255, 0, 0, 255)
	--love.graphics.points(rect.topR.x, rect.topR.y)
	--love.graphics.points(rect.topL.x, rect.topL.y)
	--love.graphics.points(rect.botR.x, rect.botR.y)
	--love.graphics.points(rect.botL.x, rect.botL.y)
end

function ScoreManager:drawOval()
	love.graphics.setColor(100, 230, 100, 125)
	love.graphics.ellipse('line', (prevBox.x+(prevBox.w/2)), (prevBox.y+(prevBox.h/2)), oval.xRad, oval.yRad)
end

function ScoreManager:drawBox()
	love.graphics.setColor(200, 200, 200, 255)
	love.graphics.rectangle('line', prevBox.x, prevBox.y, prevBox.w, prevBox.h)
end

function ScoreManager:reset()
	ScoreManager.minX = 9999
	ScoreManager.maxX = 0
	ScoreManager.minY = 9999
	ScoreManager.maxY = 0
	ScoreManager.width = 0
	ScoreManager.height = 0
end

function ScoreManager:updateCacheValues(drawing)
	for i,v in ipairs(drawing) do
		if v.x < ScoreManager.minX then
			ScoreManager.minX = v.x
		end
		if v.x > ScoreManager.maxX then
			ScoreManager.maxX = v.x
		end
		if v.y < ScoreManager.minY then
			ScoreManager.minY = v.y
		end
		if v.y > ScoreManager.maxY then
			ScoreManager.maxY = v.y
		end
	end
	ScoreManager.width = ScoreManager.maxX-ScoreManager.minX
	ScoreManager.height = ScoreManager.maxY-ScoreManager.minY
	prevBox.x = ScoreManager.minX
	prevBox.y = ScoreManager.minY
	prevBox.w = ScoreManager.width
	prevBox.h = ScoreManager.height
end

function ScoreManager:getComboMultiplier()
    return ScoreManager.comboMultiplier
end    

