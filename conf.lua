-- Configuration
function love.conf(t)
	t.title = "Paper Cut!" -- The title of the window the game is in (string)
	t.version = "0.10.2" -- The LÖVE version this game was made for (string)
    windowScale = 1.5
	t.window.width = 640 * windowScale  -- we want our game to be long and thin.
	t.window.height = 480 * windowScale
end