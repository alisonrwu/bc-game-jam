local MenuManager = {}
width = love.graphics.getWidth()
height = love.graphics.getHeight()
title = love.graphics.newImage("Graphics/Menu/testTitle.png")
start = love.graphics.newImage("Graphics/Menu/startButton.png")



function dummy()
end


        
function startGame()
    isMenu = false
end            
     
startButton = {}
titleButton = {}

startButton.image = start
startButton.x = width/3
startButton.y = height/2
startButton.press = startGame
titleButton.image = title
titleButton.x = width/6
titleButton.y = height/4
titleButton.press = dummy

table.insert(MenuManager, startButton)
table.insert(MenuManager, titleButton)

return MenuManager