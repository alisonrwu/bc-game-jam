local MenuManager = {}

width = love.graphics.getWidth()
height = love.graphics.getHeight()

-- The function the title button runs.
-- It is not supposed to do anything.
function dummy()
end

-- The function the start button runs.
-- It causes the transition to start, which will eventually set isMenu = false
function startGame()
    isTransitioningInstructions = true
    TEsound.play("Sounds/SFX/Click.mp3", "click")
end            

titleButton = {}
titleButton.image = love.graphics.newImage("Graphics/Menu/testTitle.png")
titleButton.x = width/6
titleButton.y = height/4
titleButton.press = dummy

startButton = {}
startButton.image = love.graphics.newImage("Graphics/Menu/startButton.png")
startButton.x = width/3
startButton.y = height/2
startButton.press = startGame 


table.insert(MenuManager, startButton)
table.insert(MenuManager, titleButton)

return MenuManager




