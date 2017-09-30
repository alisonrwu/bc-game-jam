ScoreGenerator = {
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

function ScoreGenerator:calculateComboBonus(score)
    multipliedScore = score * ScoreGenerator.comboMultiplier
    
    if (score >= ScoreGenerator.pointsToContinueCombo) then
        ScoreGenerator.comboMultiplier = ScoreGenerator.comboMultiplier + 0.5
    else
        ScoreGenerator.comboMultiplier = 1
    end
    
    return multipliedScore
end    

-- Scores a rectangle by calculating the 4 corner points of a
-- estimated rectangular shape based off user 'drawing' input,
-- comparing the distance of the closest drawing points.
function ScoreGenerator:rectangleScoring(drawing, x, y)
	ScoreGenerator:updateCacheValues(drawing)

	local centreX = ScoreGenerator.minX+ScoreGenerator.width/2
	local centreY = ScoreGenerator.minY+ScoreGenerator.height/2

	rect.width = x*ScoreGenerator.inch
	rect.height = y*ScoreGenerator.inch

	rect.topL.x = centreX - rect.width/2 -- minX
	rect.topL.y = centreY - rect.height/2 -- minY
	rect.topR.x = centreX + rect.width/2 -- minX+rect.width
	rect.topR.y = centreY - rect.height/2 -- minY
	rect.botL.x = centreX - rect.width/2 -- minX
	rect.botL.y = centreY + rect.height/2 -- minY+rect.height
	rect.botR.x = centreX + rect.width/2 -- minX+rect.width
	rect.botR.y = centreY + rect.height/2 -- minY+rect.height
    
    local sP = drawing
    local cP = ScoreGenerator:createInterpolatedRectangle()
    
    local successPercentage = ScoreGenerator:calculateSuccessPercentage(sP, cP, rect.topL.x, rect.topR.x, rect.topL.y, rect.botL.y)
    local score = ScoreGenerator:transformSuccessPercentage(successPercentage, rect.width * rect.height)
    local comboMultipliedScore = ScoreGenerator:calculateComboBonus(score)
    
    return ScoreGenerator:generateScore(comboMultipliedScore)
end

function ScoreGenerator:ovalScoring(drawing, x, y)
	ScoreGenerator:updateCacheValues(drawing)

	local centreX = ScoreGenerator.minX+ScoreGenerator.width/2
	local centreY = ScoreGenerator.minY+ScoreGenerator.height/2

	oval.xRad = (x/2)*ScoreGenerator.inch
	oval.yRad = (y/2)*ScoreGenerator.inch

	oval.top.x = centreX
	oval.top.y = centreY-oval.yRad
	oval.left.x = centreX-oval.xRad
	oval.left.y = centreY
	oval.right.x = centreX+oval.xRad
	oval.right.y = centreY
	oval.bot.x = centreX
	oval.bot.y = centreY+oval.yRad
    
    local sP = drawing
    local cP = ScoreGenerator:createInterpolatedOval()
    
    local successPercentage = calculateSuccessPercentage(sP, cP, oval.left.x, oval.right.x, oval.top.y, oval.bot.y)
    local score = transformSuccessPercentage(successPercentage, oval.xRad * oval.yRad * math.pi)
    
    local comboMultipliedScore = ScoreGenerator:calculateComboBonus(score)
    
    return ScoreGenerator:generateScore(comboMultipliedScore)
end

function ScoreGenerator:transformSuccessPercentage(successPercentage, targetArea)
   -- Shapes with smaller areas are typically harder to get, so make those sP's worth more
    local scaleFactor = 0.25 * math.exp(-1 * targetArea / 3000) + 0.75
    local transformedPercentage = successPercentage - 0.5
    if(transformedPercentage >= 0) then transformedPercentage = 2 * transformedPercentage end
    
    local score = transformedPercentage * scaleFactor * ScoreGenerator.maximumScore
    
    -- Cap scores at some number of points
    if score > ScoreGenerator.maximumScore then score = ScoreGenerator.maximumScore end
    
    return score
end

function ScoreGenerator:generateScore(score)
  if score < 0 then
    text = "Unacceptable!!"
    color = Graphics.RED
    sound = {path = "Sounds/SFX/Wrong.wav", name = "wrongSound"}
  elseif score >= 0 and score < 20 then
    text = "Barely passable..."
    color = Graphics.GREEN
    sound = {path = "Sounds/SFX/Correct.wav", name = "correct"}
  elseif score >= 20 and score < 60 then
    text = "Don't start slacking!"
    color = Graphics.GREEN
    sound = {path = "Sounds/SFX/Correct.wav", name = "correct"}
  elseif score >= 60 and score < 100 then
    text = "That'll do."
    color = Graphics.GREEN
    sound = {path = "Sounds/SFX/Correct.wav", name = "correct"}
  elseif score >= 100 and score < 150 then
    text = "Don't get cocky."
    color = Graphics.GREEN
    sound = {path = "Sounds/SFX/Correct.wav", name = "correct"}
  elseif score >= 150 then
    text = "That's a FINE cut."
    color = Graphics.GREEN
    sound = {path = "Sounds/SFX/Correct.wav", name = "correct"}
  end
  
  -- Perhaps want to change this if we want to manipulate the points value outside of the score generator.
  points = math.floor(score)
  if score > 0 then
    points = "+" .. points
  end
  
  return {points = points, text = text, color = color, sound = sound}
end

function ScoreGenerator:calculateSuccessPercentage(sP, cP, minimumX, maximumX, minimumY, maximumY)
    if ScoreGenerator.minX < minimumX then minimumX = ScoreGenerator.minX end
    if ScoreGenerator.maxX > maximumX then maximumX = ScoreGenerator.maxX end
    if ScoreGenerator.minY < minimumY then minimumY = ScoreGenerator.minY end
    if ScoreGenerator.maxY > maximumY then maximumY = ScoreGenerator.maxY end
    
    local successes = 0
    local pointsChecked = 0
    
    for i = minimumX, maximumX, 1 do
        for j = minimumY, maximumY, 1 do
            local testPoint = {x = i, y = j}
            local insideDrawing = ScoreGenerator:isPointInsidePolygon(testPoint, sP)
            local insideTestShape = ScoreGenerator:isPointInsidePolygon(testPoint, cP)
            
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

function ScoreGenerator:isPointInsidePolygon(point, polygon)
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

function ScoreGenerator:createInterpolatedRectangle()
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

function ScoreGenerator:createInterpolatedOval()
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

function ScoreGenerator:reset()
	ScoreGenerator.minX = 9999
	ScoreGenerator.maxX = 0
	ScoreGenerator.minY = 9999
	ScoreGenerator.maxY = 0
	ScoreGenerator.width = 0
	ScoreGenerator.height = 0
end

function ScoreGenerator:updateCacheValues(drawing)
	for i,v in ipairs(drawing) do
		if v.x < ScoreGenerator.minX then
			ScoreGenerator.minX = v.x
		end
		if v.x > ScoreGenerator.maxX then
			ScoreGenerator.maxX = v.x
		end
		if v.y < ScoreGenerator.minY then
			ScoreGenerator.minY = v.y
		end
		if v.y > ScoreGenerator.maxY then
			ScoreGenerator.maxY = v.y
		end
	end
	ScoreGenerator.width = ScoreGenerator.maxX-ScoreGenerator.minX
	ScoreGenerator.height = ScoreGenerator.maxY-ScoreGenerator.minY
	prevBox.x = ScoreGenerator.minX
	prevBox.y = ScoreGenerator.minY
	prevBox.w = ScoreGenerator.width
	prevBox.h = ScoreGenerator.height
end

function ScoreGenerator:getComboMultiplier()
    return ScoreGenerator.comboMultiplier
end    

function ScoreGenerator:drawRectangle()
    Graphics:drawLineRect((prevBox.x+(prevBox.w/2))-(rect.width/2), (prevBox.y+(prevBox.h/2))-(rect.height/2), rect.width, rect.height, Graphics.GREEN)
end

function ScoreGenerator:drawOval()
    Graphics:drawLineEllipse((prevBox.x+(prevBox.w/2)), (prevBox.y+(prevBox.h/2)), oval.xRad, oval.yRad)
end