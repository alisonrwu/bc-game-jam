AnimationManager = {}

-- Responsibilities:
--    Animate the scissors attached to the mouse. Handle any other animations in the future.

function AnimationManager:update(currentLine, currentDrawing)
  frameCounter = frameCounter + 1

  if currentDrawing[#currentDrawing - 10] ~= nil then
    angle = AnimationManager:calculateAngleOfLine(currentLine, currentDrawing[#currentDrawing - 5])
  end    
  
  if frameCounter >= FRAMES_TO_CYCLE then
    frameCounter = 0
    scissorsFrameIndex = AnimationManager:cycleAnimationTableIndex(SCISSORS_FRAME_TABLE, scissorsFrameIndex)
    SCISSORS_CURRENT_FRAME = SCISSORS_FRAME_TABLE[scissorsFrameIndex]
  end
end

function AnimationManager:draw()
  Graphics:drawWithRotationAndOffset(SCISSORS_CURRENT_FRAME, currentLine.x, currentLine.y, angle, SCISSORS_CURRENT_FRAME:getWidth()/2, SCISSORS_CURRENT_FRAME:getHeight()/2, Graphics.NORMAL)
end

function AnimationManager:load()
  SCISSORS_FRAME0 = love.graphics.newImage("Graphics/Sprites/ClosedScissors.png")
  SCISSORS_FRAME1 = love.graphics.newImage("Graphics/Sprites/OpenedScissors.png")
  SCISSORS_FRAME_TABLE = {[0] = SCISSORS_FRAME0, [1] = SCISSORS_FRAME1}
  SCISSORS_CURRENT_FRAME = SCISSORS_FRAME0
  FRAMES_TO_CYCLE = 15
  scissorsFrameIndex = 0
  frameCounter = 0
  angle = 0
end

function AnimationManager:cycleAnimationTableIndex(animationTable, frameIndex)
  if frameIndex == #animationTable then
    frameIndex = 0
  else
    frameIndex = frameIndex + 1
  end
  return frameIndex
end

-- Use the coordinates of the second point (X, Y) of each line to calculate an angle.
-- Possibly more accurate way to calculate the angle of the scissors.
function AnimationManager:calculateAngleOfLine(line1, line2) 
	return math.atan2(line2.y - line1.y, line2.x - line1.x) 
end