function loadItems()
  local baseScissorsItem = Item("assets/graphics/shop/scissors_preview.png", 0, 1)
  baseScissorsItem:setBought(true)
  baseScissorsItem:setEquipped(true)
  
  local pizzaCutterItem = Item("assets/graphics/shop/pizzacutter_preview.png", 0, 2)

  local gardenshearsItem = Item("assets/graphics/shop/gardenshears_preview.png", 0, 3)

  local utilityknifeItem = Item("assets/graphics/shop/utilityknife_preview.png", 0, 4)
  
  local chainsawItem = Item("assets/graphics/shop/chainsaw_preview.png", 0, 5)
  
  local crocodileItem = Item("assets/graphics/shop/crocodile_preview.png", 0, 6)

  local laserItem = Item("assets/graphics/shop/laser_preview.png", 0, 7)

  local handItem = Item("assets/graphics/shop/hand_preview.png", 0, 8)

  return {baseScissorsItem, pizzaCutterItem, gardenshearsItem, utilityknifeItem, chainsawItem, crocodileItem, laserItem, handItem}
end
