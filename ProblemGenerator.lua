ProblemGenerator = {}
  
function ProblemGenerator:createProblem()
  local randWidth = love.math.random(12) / 2
  local randLength = love.math.random(12) / 2
  local shape = shapeTable[love.math.random(0, #shapeTable)]

  if shape == "rectangle" then
    problemText = ProblemGenerator:createRectangleProblem(randWidth, randLength)
  elseif shape == "oval" then
    problemText = ProblemGenerator:createOvalProblem(randWidth, randLength)
  end
  
  return problemText
end

function ProblemGenerator:createRectangleProblem(w, l)
  return {width = w, length = l, color = Graphics.NORMAL, type = "rectangle"}
end

function ProblemGenerator:createOvalProblem(w, l)
  return {width = w, length = l, color = Graphics.NORMAL, type = "rectangle"}
end

function ProblemGenerator:enableOvals()
  shapeTable[1] = "oval"
end

function ProblemGenerator:load()
  shapeTable = {[0] = "rectangle"}
end