function loadAchievements()
  
  local a0n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy > 50 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp() 
        end
        user:saveData()
      end
    end
  end
  local a0 = Achievement("1st Cut Is The Deepest", "Cut your first shape with over 50% accuracy.", a0n, 1)
  
  local a1n = function(self, event, args)
    if event == Level.UNLOCKED_SHAPE and self.progress < self.maxProgress then
      local shape = args.shape   
      if shape == "Oval" then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a1 = Achievement("PROMOTED!", "Unlock ovals.", a1n, 1)
  
  local a2n = function(self, event, args)
    if event == Level.UNLOCKED_SHAPE and self.progress < self.maxProgress then
      local shape = args.shape   
      if shape == "Triangle" then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a2 = Achievement("PRRROMOTED AGAIN!", "Unlock triangles.", a2n, 1)
  
  local a3n = function(self, event, args)
    if event == Level.UNLOCKED_SHAPE and self.progress < self.maxProgress then
      local shape = args.shape   
      if shape == "Diamond" then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          Options.static.VETERAN_MODE_LOCKED = false
          user:saveVeteranModeData()
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a3 = Achievement("TOP OF THE LADDER!", "Unlock diamonds.", a3n, 1)
  
  local a4n = function(self, event, args)
    if event == Level.START then
      self.failed = false
    end
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local tutorial = args.tutorial
      local rating = args.rating
      if not tutorial and (rating == "Stop monkeying around!" or rating == "That's coming out your paycheck." or rating == "My poor paper!")  then
        self.failed = true
      end
    end  
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore
      if not self.failed and totalScore > 8000 then
        self:setUnlocked(true)
        self:addPopUp()
      end
      user:saveData()
    end
  end
  local a4 = Achievement("Clean Cut", "Never get a bad rating and get over 8,000 in one session.", a4n, 1)

  local a5n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local totalScore = args.totalScore   
      local timePlayed = args.timePlayed
      if totalScore >= 5000 and timePlayed <= 60 then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a5 = Achievement("Meeting The Quota", "Get over 5000 points in 60 seconds.", a5n, 1)
  
  
  local a6n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local shape = args.shape
      local accuracy = args.accuracy
      if shape == "Rectangle" and accuracy > 80 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a6 = Achievement("Get Rect", "Get 400 rectangles with over 80% accuracy.", a6n, 400)
  
  local a7n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local shape = args.shape
      local accuracy = args.accuracy
      if shape == "Triangle" and accuracy > 80 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a7 = Achievement("Doritos For Breakfast", "Get 300 triangles with over 80% accuracy.", a7n, 300)
  
  local a8n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local shape = args.shape
      local accuracy = args.accuracy
      if shape == "Oval" and accuracy > 80 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a8 = Achievement("Winner's Oval", "Get 200 ovals with over 80% accuracy.", a8n, 200)
  
  local a9n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local shape = args.shape
      local accuracy = args.accuracy
      if shape == "Diamond" and accuracy > 80 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end  
  local a9 = Achievement("Ice Slice Baby", "Get 100 diamonds with over 80% accuracy.", a9n, 100)
  
  local a10n = function(self, event, args)
     if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local timePlayed = args.timePlayed
      if timePlayed >= 500 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a10 = Achievement("Workin' Like A Doge", "Play for 500 seconds in one session.", a10n, 1)
  
  local a11n = function(self, event, args)
   if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local timePlayed = args.timePlayed
      if timePlayed >= 1000 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a11 = Achievement("I'm Resigning", "Play for 1000 seconds in one session.", a11n, 1)
  
  local a12n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy >= 98 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a12 = Achievement("SNIP-erino", "Get over 98% accuracy on a shape.", a12n, 1)
  
  local a13n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local multiplier = args.multiplier
      if multiplier >= 10 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a13 = Achievement("1st Degree Cuts", "Get 10x multiplier in one session.", a13n, 1)
  
  local a14n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local multiplier = args.multiplier
      if multiplier >= 20 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a14 = Achievement("2nd Degree Cuts", "Get 20x multiplier in one session.", a14n, 1)
  
  local a15n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local multiplier = args.multiplier
      if multiplier >= 30 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a15 = Achievement("3rd Degree Cuts", "Get 30x multiplier in one session.", a15n, 1)

  local a16n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local targetUp = args.targetUp
      local timeLeft = args.timeLeft
      if targetUp and timeLeft <= 1 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a16 = Achievement("Cutting It Close", "Get 20 Target Ups with 1 second remaining.", a16n, 20)
  
  local a17n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "Stop monkeying around!" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a17 = Achievement("Cut Chimp", "Monkey around 30 times.", a17n, 30)  
  
  local a18n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "That's coming out your paycheck." then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a18 = Achievement("Dun Goofed", "Cut 100 shapes that are coming out your paycheck.", a18n, 100) 
  
  local a19n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local targetUps = args.targetUps
      local timePlayed = args.timePlayed
      if targetUps >= 10 and timePlayed <= 60 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a19 = Achievement("Ten Too Many Coffees", "Reach 10 Target Ups within 60 seconds.", a19n, 1) 
  
  local a20n = function(self, event, args)
     if event == Salary.MONEY_ADDED and self.progress < self.maxProgress then
      local amount = args.amount
      if amount >= 100000 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a20 = Achievement("Gettin' Paid", "Amass 100,000 dollars.", a20n, 1) 
  
  local a21n = function(self, event, args)
     if event == Salary.MONEY_ADDED and self.progress < self.maxProgress then
      local amount = args.amount
      if amount >= 500000 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a21 = Achievement("Cut Of The Profits", "Amass 500,000 dollars.", a21n, 1) 
  
  local a22n = function(self, event, args)
     if event == Salary.MONEY_ADDED and self.progress < self.maxProgress then
      local amount = args.amount
      if amount >= 999999 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a22 = Achievement("Big Cheese", "Amass 999,999 dollars.", a22n, 1) 

  local a23n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy >= 50 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a23 = Achievement("Hackin' It", "Cut 1000 shapes with over 50% accuracy.", a23n, 1000)
  
  local a24n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy >= 50 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a24 = Achievement("Shreddin' Paper", "Cut 3000 shapes with over 50% accuracy.", a24n, 3000)
  
  local a25n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy >= 50 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a25 = Achievement("The Edge Lord", "Cut 5000 shapes with over 50% accuracy.", a25n, 5000)
  
  local a26n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy < 50 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a26 = Achievement("Don't Fire Me", "Cut 100 shapes with less than 50% accuracy.", a26n, 100)
  
  local a27n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy >= 80 then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a27 = Achievement("My Blade Is Sharp", "Cut 1000 shapes with over 80% accuracy.", a27n, 1000)
  
  local a28n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "That's a FINE cut." then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a28 = Achievement("It's A Fine Day To Cut", "Make a FINE cut over 100 times.", a28n, 100)
  
  local a29n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "That's INCREDIBLE!!" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a29 = Achievement("The Incredible Cut", "Make an INCREDIBLE cut over 50 times.", a29n, 50)
  
  local a30n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "EXCELLENT WORK!!!" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a30 = Achievement("Skills: Microsoft Excel", "Do EXCELLENT WORK over 40 times.", a30n, 40)
  
  local a31n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "ARE YOU A CUTTING GENIUS?" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a31 = Achievement("420 IQ", "Be a CUTTING GENIUS over 30 times.", a31n, 30)
  
  local a32n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "HOLY MOLY!!!!!!" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a32 = Achievement("MOLY HOLY!", "Get the boss to HOLY MOLY over 20 times.", a32n, 20)
  
  local a33n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "NUMBER ONE EMPLOYEE!!" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a33 = Achievement("We Are Number One", "Be the number one employee over 10 times.", a33n, 10)
  
  local a34n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local rating = args.rating
      if rating == "THE GOD OF CUTTING HIMSELF!!" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a34 = Achievement("G.O.C", "Become THE GOD OF CUTTING.", a34n, 1)
  
  local a35n = function(self, event, args)
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore      
      if totalScore >= 5000 then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a35 = Achievement("New Hire", "Get 5000 points in a session.", a35n, 1)
  
  local a36n = function(self, event, args)
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore      
      if totalScore >= 10000 then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a36 = Achievement("Junior Cutter", "Get 10,000 points in a session.", a36n, 1)
  
  local a37n = function(self, event, args)
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore      
      if totalScore >= 30000 then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a37 = Achievement("Senior Cutter", "Get 30,000 points in a session.", a37n, 1)
  
  local a38n = function(self, event, args)
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore      
      if totalScore >= 50000 then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a38 = Achievement("Director Of Cutting", "Get 50,000 points in a session.", a38n, 1)
  
  local a39n = function(self, event, args)
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore      
      if totalScore >= 100000 then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a39 = Achievement("Who's The Boss Now?", "Get 100,000 points in a session.", a39n, 1)
  
  local a40n = function(self, event, args)
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore      
      if totalScore < 0 then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a40 = Achievement("Not even close baby", "Get negative total points in one session.", a40n, 1)
  
  local a41n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local shape = args.shape
      if accuracy >= 50 and shape == "Rectangle" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a41 = Achievement("All Squared Up", "Cut 2000 rectangles with over 50% accuracy.", a41n, 2000)
  
  local a42n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local shape = args.shape
      if accuracy >= 50 and shape == "Oval" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a42 = Achievement("Round The Clock", "Cut 2000 ovals with over 50% accuracy.", a42n, 2000)
  
  local a43n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local shape = args.shape
      if accuracy >= 50 and shape == "Triangle" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a43 = Achievement("It's A Pyramid Scheme", "Cut 2000 triangles with over 50% accuracy.", a43n, 2000)
  
  local a44n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local shape = args.shape
      if accuracy >= 50 and shape == "Diamond" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a44 = Achievement("Pressure Makes Diamonds", "Cut 2000 diamonds with over 50% accuracy.", a44n, 2000)
  
  local a45n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local shape = args.shape
      if accuracy >= 95 and shape == "Rectangle" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a45 = Achievement("Perfectly Square", "Get over 95% accuracy on a rectangle.", a45n, 1)
  
  local a46n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local shape = args.shape
      if accuracy >= 95 and shape == "Oval" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a46 = Achievement("Chief Oval Officer", "Get over 95% accuracy on an oval.", a46n, 1)
  
  local a47n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local shape = args.shape
      if accuracy >= 95 and shape == "Triangle" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a47 = Achievement("The Right Angle", "Get over 95% accuracy on a triangle.", a47n, 1)

  local a48n = function(self, event, args)
     if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local shape = args.shape
      if accuracy >= 95 and shape == "Diamond" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgreFishss then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a48 = Achievement("A Shining Example", "Get over 95% accuracy on a diamond.", a48n, 1)
  
  local a49n = function(self, event, args)
    if event == Level.START then
      self.failed = false
    end
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy < 80 then
        self.failed = true
      end
    end  
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore
      local mode = args.mode
      if not self.failed and totalScore > 10000 and mode == "Veteran" then
        self:setUnlocked(true)
        self:addPopUp()
      end
      user:saveData()
    end
  end
  local a49 = Achievement("Tip-Top Shape", "Cut ONLY shapes with over 80% accuracy and score over 10,000 in one session on VETERAN.", a49n, 1)
  
  local a50n = function(self, event, args)
    if event == Level.START then
      self.failed = false
    end
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy < 90 then
        self.failed = true
      end
    end  
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore
      local mode = args.mode
      if not self.failed and totalScore > 20000 and mode == "Veteran" then
        self:setUnlocked(true)
        self:addPopUp()
      end
      user:saveData()
    end
  end
  local a50 = Achievement("My Life's Work", "Cut ONLY shapes with over 90% accuracy and score over 20,000 in one session on VETERAN.", a50n, 1)
  
  local a51n = function(self, event, args)
    if event == Level.START then
      self.failed = false
    end
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      if accuracy < 95 then
        self.failed = true
      end
    end  
    if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore
      local mode = args.mode
      if not self.failed and totalScore > 30000 and mode == "Veteran" then
        self:setUnlocked(true)
        self:addPopUp()
      end
      user:saveData()
    end
  end
  local a51 = Achievement("TAS Bot", "Cut ONLY shapes with over 95% accuracy and score over 30,000 in one session on VETERAN.", a51n, 1)
  
  local a52n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local points = args.points
      local status = args.status
      local scissors = args.scissors
      if status and status.name == "PIZZA_BUFF" and scissors == "Pizza Cutter" then
        self.progress = self.progress + points
        if self.progress >= self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a52 = Achievement("The Big Slice", "Get over 50,000 points with the pizza buff using the Pizza Cutter.", a52n, 50000)
  
  local a53n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local status = args.status
      local scissors = args.scissors
      if status and status.name == "PIZZA_DEBUFF" and scissors == "Pizza Cutter" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a53 = Achievement("Cutting The Cheese", "Cut 30 shapes with the pizza debuff using the Pizza Cutter.", a53n, 30)
  
  local a54n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local points = args.points
      local scissors = args.scissors
      if points >= 20000 and scissors == "Garden Shears" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a54 = Achievement("Shear Power", "Get over 20,000 points in one cut using the Garden Shears.", a54n, 1)  
  
  local a55n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local accuracy = args.accuracy
      local timePlayed = args.timePlayed
      
      if accuracy >= 50 and timePlayed <= 60 then
        self.progress = self.progress + 1
      end
    end  
    
    if event == Timer.OUT_OF_TIME then
      local scissors = args.scissors
      if scissors == "Utility Knife" and self.progress >= self.maxProgress  then
        self:setUnlocked(true)
        self:addPopUp()
      else
        self.progress = 0
      end
      user:saveData()
    end
  end
  local a55 = Achievement("Cut To The Chase", "Cut 60 shapes with over 50% accuracy in 60 seconds with the Utility Knife.", a55n, 60)
  
  local a56n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local multiplier = args.multiplier
      local scissors = args.scissors
      if multiplier >= 100 and scissors == "Chainsaw" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a56 = Achievement("Buzzy Bee", "Reach 100x combo multiplier in one session with the Chainsaw.", a56n, 1)   
  
  local a57n = function(self, event, args)
    if event == Level.SHAPE_COMPLETED and self.progress < self.maxProgress then
      local charge = args.charge
      local accuracy = args.accuracy
      local scissors = args.scissors
      if accuracy >= 90 and scissors == "Laser" and charge == Level.MAX_CHARGE then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a57 = Achievement("Takin' Charge", "Cut 200 shapes with over 90% accuracy on a full charge with the Laser.", a57n, 200) 
  
  local a58n = function(self, event, args)
   if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local timePlayed = args.timePlayed
      local scissors = args.scissors
      if scissors == "Crocodile" then
        self.progress = self.progress + timePlayed
        if self.progress >= self.maxProgress then
            self:setUnlocked(true)
            self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a58 = Achievement("Crunch Time", "Play for over 5000 seconds with the Crocodile.", a58n, 5000)
  
  local a59n = function(self, event, args)
   if event == Timer.OUT_OF_TIME and self.progress < self.maxProgress then
      local totalScore = args.totalScore
      local scissors = args.scissors
      if totalScore >= 1000000 and scissors == "Hand" then
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
            self:setUnlocked(true)
            self:addPopUp()
        end
        user:saveData()
      end
    end   
  end
  local a59 = Achievement("Handy Man", "Reach 1,000,000 points in one session with the Hand.", a59n, 1)
  
  local a60n = function(self, event, args)
    if event == Shop.BOUGHT_ITEM and self.progress < self.maxProgress then
      local boughtItems = args.boughtItems
      local maxItems = args.maxItems
      if boughtItems >= (maxItems / 2) then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a60 = Achievement("Stocking The Cubicle", "Unlock half the \"scissors\".", a60n, 1)
  
  local a61n = function(self, event, args)
    if event == Shop.BOUGHT_ITEM and self.progress < self.maxProgress then
      local boughtItems = args.boughtItems
      local maxItems = args.maxItems
      if boughtItems >= maxItems then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a61 = Achievement("There Goes My Savings", "Unlock all the \"scissors\".", a61n, 1)

  local a62n = function(self, event, args)
    if event == Achievements.UNLOCKED_ACHIEVEMENT and self.progress < self.maxProgress then
      local unlockedAchievements = args.unlockedAchievements
      local maxAchievements = args.maxAchievements
      if unlockedAchievements >= (maxAchievements / 2) then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a62 = Achievement("Edge Of Glory", "Unlock half of the achievements. Thanks for playing!", a62n, 1)
  
  local a63n = function(self, event, args)
    if event == Achievements.UNLOCKED_ACHIEVEMENT and self.progress < self.maxProgress then
      local unlockedAchievements = args.unlockedAchievements
      local maxAchievements = args.maxAchievements
      if unlockedAchievements >= maxAchievements then 
        self.progress = self.progress + 1
        if self.progress == self.maxProgress then
          self:setUnlocked(true)
          self:addPopUp()
        end
        user:saveData()
      end
    end
  end
  local a63 = Achievement("Cut Above The Rest", "Unlock all the achievements. YOU'RE THE BOMB! Thanks again for playing!!", a63n, 1)
  
  return {a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28,
          a29, a30, a31, a32, a33, a34, a35, a36, a37, a38, a39, a40, a41, a42, a43, a44, a45, a46, a47, a48, a49, a50, a51, a52, a53, a54, a55,
          a56, a57, a58, a59, a60, a61, a62, a63}
end