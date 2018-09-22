-- Configuration
function love.conf(t)
	t.title = "Paper Cut!" -- The title of the window the game is in (string)
	t.version = "11.1" -- The LÖVE version this game was made for (string)
	t.window.width = 960
	t.window.height = 600
  t.identity = "paper-cut"
  t.window.fullscreen = true
  t.window.borderless = true
  t.window.fullscreentype = "desktop"
end