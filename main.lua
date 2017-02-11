function love.load()
   love.graphics.setBackgroundColor(122,195,255)
end

function love.update(dt)
   -- exit game
   if love.keyboard.isDown('escape') then
	love.event.push('quit')
   end
end

function love.draw()
	love.graphics.print("Hello World", 400, 300)
end