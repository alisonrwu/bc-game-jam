function loadItems()
  local baseScissorsItem = Item("assets/graphics/game/player/cursor_base_closed.png", 0, 1)
  baseScissorsItem:setBought(true)
  baseScissorsItem:setEquipped(true)

  local redScissorsItem = Item("assets/graphics/game/player/cursor_red_closed.png", 1000, 2)

  local crazyScissorsItem = Item("assets/graphics/game/player/cursor_crazy_closed.png", 5000, 3) 
  
  return {baseScissorsItem, redScissorsItem, crazyScissorsItem}
end
