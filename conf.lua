-- Configuration
function love.conf(t)
	t.title = "Paper Cut!" -- The title of the window the game is in (string)
	t.version = "0.10.2" -- The LÖVE version this game was made for (string)
	t.window.width = 640
	t.window.height = 480
	t.modules.joystick = false
end