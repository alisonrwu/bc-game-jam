Storage = {}

function Storage:saveData(data, name)
  bitser.dumpLoveFile("data_highscores", self.scores)
end

function Storage:loadData()
  
end