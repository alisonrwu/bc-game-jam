HighScore = class("HighScore"):include(Wait)
HighScore.static.NUMBER_OF_SCORES = 3

function HighScore:initialize()
  self.scores = {}
  self.scorePlaceables = {}
  self.yourScoresPosition = false 
  if love.filesystem.getRealDirectory("data_highscores") ~= nil then self:loadScores() end
end

function HighScore:hidePlaceables()
  for i, placeable in ipairs(self.scorePlaceables) do
    placeable.color = Graphics.GONE 
  end
end

function HighScore:resetColor()
  for i, placeable in ipairs(self.scorePlaceables) do
    if not self.yourScoresPosition or i ~= self.yourScoresPosition + 1 then
      placeable.color = Graphics.NORMAL 
    else
      placeable.color = Graphics.YELLOW 
    end
  end
end

function HighScore:update(dt)
  self:wait(dt)
end

function HighScore:attemptToAddScore(score)
  local added = false
  for insertPosition = 1, HighScore.NUMBER_OF_SCORES, 1 do -- find the position to insert
    local highScore = self.scores[insertPosition]
    if highScore == nil or score > highScore then
      self.yourScoresPosition = insertPosition
      added = true
      table.insert(self.scores, insertPosition, score)
      if #self.scores > HighScore.NUMBER_OF_SCORES then self.scores[#self.scores] = nil end -- get rid of any excess elements
      break
    end
  end
  if not added then self.yourScoresPosition = false end
end

function HighScore:draw(height)
  for _, v in ipairs(self.scorePlaceables) do
    v:draw()
  end
end

function HighScore:saveScores()
  bitser.dumpLoveFile("data_highscores", self.scores)
end

function HighScore:loadScores()
  self.scores = bitser.loadLoveFile("data_highscores")
end

function HighScore:createScorePlaceables(startY)
  local placeables = {}
  
  local scoreTitlePlaceable = TextPlaceable("HIGH SCORES", nil, nil, nil, 1)
  scoreTitlePlaceable.position.x = (baseRes.width * 0.5) - (scoreTitlePlaceable.dimensions.width * 0.5)
  scoreTitlePlaceable.position.y = startY
  table.insert(placeables, scoreTitlePlaceable)
  
  for i = 1, HighScore.NUMBER_OF_SCORES, 1 do
    local scorePlaceable
    local score = self.scores[i]
    if self.scores[i] ~= nil then
      scorePlaceable = TextPlaceable(("%i. %i"):format(i, score))
    else
      scorePlaceable = TextPlaceable(("%i."):format(i))
    end
    if self.yourScoresPosition and i == self.yourScoresPosition + 1 then scorePlaceable.color = Graphics.YELLOW end
    scorePlaceable.position.x = (baseRes.width * 0.5) - (scorePlaceable.dimensions.width * 0.5)
    scorePlaceable:setBelow(placeables[i], 8)
    table.insert(placeables, scorePlaceable)
  end
  
  self.scorePlaceables = placeables
end

function HighScore:endY()
  return self.scorePlaceables[#self.scorePlaceables].position.y
end
