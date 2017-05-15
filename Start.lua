Start = {}

function Start:update(dt)
    if (Fade:getAlpha() == 1) then
        setState(Instructions)
    end    
end                            
    
function Start:draw()  
    Graphics:draw(menuBG, 0, 0, Graphics.NORMAL)
    Graphics:draw(TITLE_BUTTON, width/6, height/4, Graphics.NORMAL)
    Graphics:draw(START_BUTTON, width/3, height/2, Graphics.NORMAL)
    Graphics:drawText("Made by: Trevin \"terb\" Wong, Alison \"arwu\" Wu, and Sean \"sdace\" Allen", 10, height - 80, width, center, Graphics.NORMAL)
end
                    
function Start:mouseRelease()
  TEsound.play("Sounds/SFX/Click.mp3", "click")
    Fade:beginFade()
end    

--	love.mouse.setVisible(true)
--  ScoreManager.reset()
