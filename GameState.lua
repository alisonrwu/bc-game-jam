require "DrawingUpdater"
require "ProblemGenerator"
require "ScoreGenerator"
require "AnimationManager"

GameState = {}

-- Extra stuff:
--    Refactor displayPtsForShape()
--    Refactor AnimationManager/SoundManager, playing sounds
--    Optimize scoring/display

-- New features to add:
--    Let players know when ovals are added
--    Make inch scaling easier to learn (easy mode)
--    Let players know that the point is to survive as long as possible
--    Let players know that real inches are not used (change the measurement system)
--    Let players know that they do not need to left click to finish cutting (simply intersect)
--    Show players correct dimension orders (width by length)
--    Support for triangles
--    Change the scissors graphic
--    Create a shader for the lines
--    Port to android

function GameState:update(dt)
  GameState:updateTimer(dt)
  GameState:updateCurrentLine()
  GameState:updateEnabledShapes()
  SoundManager:playMusic("Sounds/Music/Paper Cutter.ogg", "gameTheme")
  
  if DrawingUpdater:getDrawingDone() == false and GameState:isMouseMoving() and mouseDown then
    TEsound.resume("cuttingSound")
    DrawingUpdater:update(currentLine, currentDrawing)
    AnimationManager:update(currentLine, currentDrawing)
  else
    TEsound.pause("cuttingSound")
  end
  
  if problemGenerated == false then
    currentProblem = ProblemGenerator:createProblem()
    currentFeedback = {text = "I need a " .. currentProblem.width .. " x " .. currentProblem.length .. " " .. currentProblem.type .. "!", color =  currentProblem.color}
    problemGenerated = true
  end 
  
  if DrawingUpdater:getDrawingDone() == true and drawingScored == false then
    TEsound.play("Sounds/SFX/Snip.ogg", "snip") 
    if currentProblem.type == "rectangle" then
      score = ScoreGenerator:rectangleScoring(currentDrawing, currentProblem.width, currentProblem.length)
    elseif currentProblem.type == "oval" then
      score = ScoreGenerator:ovalScoring(currentDrawing, currentProblem.width, currentProblem.length)
    end
    drawingScored = true
    currentFeedback = {text = score.text, color = score.color}
    playerScore = playerScore + score.points
    TEsound.play(score.sound.path, score.sound.name)
    local targetUp = false
  
    if (playerScore >= targetScore) then
      targetUp = true
      GameState:updateTimeAndScore()    
      TEsound.play("Sounds/SFX/newTarget.ogg", "newTarget")
    end
    
    table.insert(pointsTable, {points = score.points, x = love.mouse.getX(), y = love.mouse.getY(), color = score.color, alpha = 255, targetUp = targetUp})
  end
  
  if drawingScored == true then
    GameState:updateForNewProblem(dt, 1.5)
  end
  
  TEsound.cleanup()
end

function GameState:draw()
  Graphics:draw(BG, 0, 0, Graphics.NORMAL)
  Graphics:draw(scale, 30 * windowScale, height - 105 * windowScale, Graphics.NORMAL)
  Graphics:draw(speechBubble, 10, 10, Graphics.NORMAL)
  GameState:displayDrawing()
  GameState:displayHUD()
  GameState:displayFeedback()
  GameState:displayPtsForShape()
  AnimationManager:draw()
  if drawingScored == true then
    if currentProblem.type == "rectangle" then
      ScoreGenerator:drawRectangle()
    elseif currentProblem.type == "oval" then
      ScoreGenerator:drawOval()
    end
  end
end

function GameState:load()
  -- Game Configuration
  STARTING_TIME = 120
  INITIAL_TARGET = 100
  
   -- Loading Managers
  DrawingUpdater:load()
  ProblemGenerator:load()
  AnimationManager:load()
  
  -- Initialization
  mouseDown = false
  targetUpCounter = 0
  playerScore = 0
  targetScore = INITIAL_TARGET
  timer = {time = STARTING_TIME, color = Graphics.NORMAL}
  problemGenerated = false
  drawingScored = false
  currentLine = {x, y, lastX, lastY = 0, 0, 0, 0}
  currentDrawing = {}
  pointsTable = {}
  currentFeedback = {text = "Left click to start!", color = Graphics.NORMAL}
  currentProblem = {text = "", color = Graphics.NORMAL, type = "rectangle"}
  love.mouse.setVisible(false)
  TEsound.playLooping("Sounds/SFX/Cutting.ogg", "cuttingSound")
  timerForNewProblem = 0
end

-- Utility Functions

function GameState:mousePressed(x, y, button, istouch)    
	if button == 1 then 
    mouseDown = true
	end
end

function GameState:mouseRelease(x, y, button, istouch)
  if button == 1 then 
    mouseDown = false
    DrawingUpdater:setDrawingDone(true)
	end
end  

function GameState:isMouseMoving()
  return currentLine.x ~= currentLine.lastX or currentLine.y ~= currentLine.lastY
end    

function GameState:cleanGameState()
  DrawingUpdater:setDrawingDone(false)
  currentDrawing = {}
  problemGenerated = false
  drawingScored = false
  ScoreGenerator:reset()
end

-- Update Functions

function GameState:updateForNewProblem(dt, length)
  timerForNewProblem = timerForNewProblem + dt
  
  if timerForNewProblem >= length then
    GameState:cleanGameState()
    timerForNewProblem = 0
  end
end

function GameState:updateCurrentLine()
    currentLine.lastX = currentLine.x 
    currentLine.lastY = currentLine.y    
    currentLine.x = love.mouse.getX()
    currentLine.y = love.mouse.getY()
end    

function GameState:updateEnabledShapes()
  if targetUpCounter > 2 then
    ProblemGenerator:enableOvals()
  end
end

function GameState:updateTimer(dt)
  timer.time = timer.time - dt
  if timer.time <= 15 then
    timer.color = Graphics.RED
    TEsound.pitch("gameTheme", 1.15)
	end
  
  if timer.time <= 0 then
		setState(GameOverState)  
	end
end

-- Display Functions

function GameState:displayHUD()
  Graphics:drawText("Paycheck: " .. playerScore, width - 275, height - 50, width - 275, middle, Graphics.NORMAL)
  Graphics:drawText("Target: " .. targetScore, width - 220, 55, width - 275, middle, Graphics.NORMAL)
  Graphics:drawText("Time: " .. math.ceil(timer.time, 1), 25, 55, width, left, timer.color)
end

function GameState:displayDrawing()
    for i,v in ipairs(currentDrawing) do
    if drawingDone then
      Graphics:drawLine(v.x, v.y, v.lastX, v.lastY, Graphics.BLACK)
    else
      Graphics:drawLine(v.x, v.y, v.lastX, v.lastY, Graphics.GRAY)
    end
  end  
end

function GameState:displayFeedback()
  local feedbackX = 20
  local feedbackY = 20
  
  Graphics:drawText(currentFeedback.text, feedbackX, feedbackY, width, left, currentFeedback.color)
end

function GameState:updateTimeAndScore()
    timer.time = STARTING_TIME
    targetUpCounter = targetUpCounter + 1
    targetScore = targetScore + INITIAL_TARGET * targetUpCounter
end

function GameState:displayPtsForShape()
	for i,v in ipairs(pointsTable) do
    local comboOffsetX = 1
    local comboOffsetY = 27
    local comboScaleX = 0.95
    local comboScaleY = comboScaleX
    Graphics:drawTextWithScale("x" .. ScoreGenerator:getComboMultiplier(), v.x + comboOffsetX, v.y + comboOffsetY, width, left, comboScaleX, comboScaleY, Graphics:modifyColorAlpha(Graphics.NORMAL, v.alpha))
    Graphics:drawText(v.points, v.x, v.y, width, left, Graphics:modifyColorAlpha(v.color, v.alpha))

    if ScoreGenerator:getComboMultiplier() >= 2.5 then  
      local fireOffsetX = -28
      local fireOffsetY = 26
      local fireScaleX = 0.170
      local fireScaleY = fireScaleX
      Graphics:drawWithScale(combo, v.x + fireOffsetX, v.y + fireOffsetY, fireScaleX, fireScaleY, Graphics:modifyColorAlpha(Graphics.NORMAL, v.alpha))
    end

    if v.targetUp then
      local targetOffsetX = 0
      local targetOffsetY = -31
      local targetScaleX = 1
      local targetScaleY = targetScaleX
      Graphics:drawTextWithScale("Target Up!", v.x + targetOffsetX, v.y + targetOffsetY, width, left, targetScaleX, targetScaleY, Graphics:modifyColorAlpha(Graphics.YELLOW, v.alpha))   
    end  
  
    v.alpha = v.alpha - 2
    v.y = v.y - 2
  
    if (v.alpha < 0) then
      table.remove(v)
    end
  end    
end