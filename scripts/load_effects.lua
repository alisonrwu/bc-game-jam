function loadEffects()
  local baseScissorsOnApply = function()
    Cursor.static.FRAME0 = love.graphics.newImage("assets/graphics/game/player/cursor_base_closed.png")
    Cursor.static.FRAME1 = love.graphics.newImage("assets/graphics/game/player/cursor_base_opened.png")
  end
  local BaseScissorsOnRemove = function() end
  local baseScissorsDescription = ""
  local baseScissorsPros = "+ Nothing"
  local baseScissorsCons = "- Nothing"
  local baseScissorsEffect = Effect(baseScissorsOnApply, baseScissorsOnRemove, baseScissorsDescription, baseScissorsPros, baseScissorsCons)


  local redScissorsOnApply = function()
    Combo.static.BASE_MULTIPLIER = 0.5
    Combo.static.INCREASE = 1
    Cursor.static.FRAME0 = love.graphics.newImage("assets/graphics/game/player/cursor_red_closed.png")
    Cursor.static.FRAME1 = love.graphics.newImage("assets/graphics/game/player/cursor_red_opened.png")
  end
  local redScissorsOnRemove = function()
    Combo.static.BASE_MULTIPLIER = 1
    Combo.static.INCREASE = 0.5
  end
  local redScissorsDescription = ""
  local redScissorsPros = "+ Increase combo multiplier"
  local redScissorsCons = "- Decrease combo base multiplier"
  local redScissorsEffect = Effect(redScissorsOnApply, redScissorsOnRemove, redScissorsDescription, redScissorsPros, redScissorsCons)

  local crazyScissorsOnApply = function()
    Level.static.STARTING_TIME = 15
    Level.static.MAX_SCORE = 300
    Cursor.static.FRAME0 = love.graphics.newImage("assets/graphics/game/player/cursor_crazy_closed.png")
    Cursor.static.FRAME1 = love.graphics.newImage("assets/graphics/game/player/cursor_crazy_opened.png")
  end
  local crazyScissorsOnRemove = function()
    Level.static.STARTING_TIME = 60
    Level.static.MAX_SCORE = 200
  end
  local crazyScissorsDescription = ""
  local crazyScissorsPros = "+ Increase shape score"
  local crazyScissorsCons = "- Decrease time"
  local crazyScissorsEffect = Effect(crazyScissorsOnApply, crazyScissorsOnRemove, crazyScissorsDescription, crazyScissorsPros, crazyScissorsCons)

  return {baseScissorsEffect, redScissorsEffect, crazyScissorsEffect}
end
