local binser = require "modules/binser"
HighScore = {
  NUMBER_OF_SCORES = 3,
  scores = {},
  scorePlaceables = {}
}

function HighScore:attemptToAddScore(score)
  local insertPosition

  for insertPosition = 1, HighScore.NUMBER_OF_SCORES, 1 do -- find the position to insert
    local highScore = HighScore.scores[insertPosition]
    if highScore == nil or score > highScore then
      HighScore.scores[insertPosition] = score
      break
    end
  end
end

function HighScore:draw(height)
  
  for _, v in ipairs(self.scorePlaceables) do
    v:draw()
  end
end

function HighScore:saveScores()
  binser.writeFile("data_highscores", HighScore.scores)
end

function HighScore:loadScores()
  HighScore.scores = binser.readFile("data_highscores")[1]
  print(HighScore.scores)
end

function HighScore:createScorePlaceables(startY)
  local scoreTitlePlaceable = TextPlaceable("HIGH SCORES", nil, nil, nil, 1)
  scoreTitlePlaceable.position.x = (baseRes.width * 0.5) - (scoreTitlePlaceable.dimensions.width * 0.5)
  scoreTitlePlaceable.position.y = startY
  table.insert(HighScore.scorePlaceables, scoreTitlePlaceable)
  
  for i = 1, HighScore.NUMBER_OF_SCORES, 1 do
    local scorePlaceable
    local score = HighScore.scores[i]
    if HighScore.scores[i] ~= nil then
      scorePlaceable = TextPlaceable(("%i. %i"):format(i, score))
    else
      scorePlaceable = TextPlaceable(("%i."):format(i))
    end
    scorePlaceable.position.x = (baseRes.width * 0.5) - (scorePlaceable.dimensions.width * 0.5)
    scorePlaceable:setBelow(HighScore.scorePlaceables[i], 20)
    table.insert(HighScore.scorePlaceables, scorePlaceable)
  end
end

function HighScore:endY()
  return HighScore.scorePlaceables[#HighScore.scorePlaceables].position.y
end
