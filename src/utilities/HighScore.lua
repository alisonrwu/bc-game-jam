local bitser = require "modules/bitser"
HighScore = {
  NUMBER_OF_SCORES = 3,
  scores = {},
  scorePlaceables = {}
}

function HighScore:attemptToAddScore(score)
  for insertPosition = 1, HighScore.NUMBER_OF_SCORES, 1 do -- find the position to insert
    local highScore = HighScore.scores[insertPosition]
    if highScore == nil or score > highScore then
      table.insert(HighScore.scores, insertPosition, score)
      if #HighScore.scores > HighScore.NUMBER_OF_SCORES then HighScore.scores[#HighScore.scores] = nil end -- get rid of any excess elements
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
  bitser.dumpLoveFile("data_highscores", HighScore.scores)
end

function HighScore:loadScores()
  HighScore.scores = bitser.loadLoveFile("data_highscores")
end

function HighScore:createScorePlaceables(startY)
  local placeables = {}
  
  local scoreTitlePlaceable = TextPlaceable("HIGH SCORES", nil, nil, nil, 1)
  scoreTitlePlaceable.position.x = (baseRes.width * 0.5) - (scoreTitlePlaceable.dimensions.width * 0.5)
  scoreTitlePlaceable.position.y = startY
  table.insert(placeables, scoreTitlePlaceable)
  
  for i = 1, HighScore.NUMBER_OF_SCORES, 1 do
    local scorePlaceable
    local score = HighScore.scores[i]
    if HighScore.scores[i] ~= nil then
      scorePlaceable = TextPlaceable(("%i. %i"):format(i, score))
    else
      scorePlaceable = TextPlaceable(("%i."):format(i))
    end
    scorePlaceable.position.x = (baseRes.width * 0.5) - (scorePlaceable.dimensions.width * 0.5)
    scorePlaceable:setBelow(placeables[i], 20)
    table.insert(placeables, scorePlaceable)
  end
  
  HighScore.scorePlaceables = placeables
end

function HighScore:endY()
  return HighScore.scorePlaceables[#HighScore.scorePlaceables].position.y
end
