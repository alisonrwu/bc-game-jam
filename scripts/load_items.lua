function loadItems()
  local baseScissorsItem = Item("assets/graphics/shop/scissors_preview.png", 0, 1)
  baseScissorsItem:setBought(true)
  baseScissorsItem:setEquipped(true)
  
  local pizzaCutterItem = Item("assets/graphics/shop/pizzacutter_preview.png", 4000, 2)

  local gardenshearsItem = Item("assets/graphics/shop/gardenshears_preview.png", 8000, 3)

  local utilityknifeItem = Item("assets/graphics/shop/utilityknife_preview.png", 16000, 4)
  
  local chainsawItem = Item("assets/graphics/shop/chainsaw_preview.png", 32000, 5)
  
  local laserItem = Item("assets/graphics/shop/laser_preview.png", 64000, 6)
  
  local crocodileItem = Item("assets/graphics/shop/crocodile_preview.png", 128000, 7)

  local handItem = Item("assets/graphics/shop/hand_preview.png", 256000, 8)
  
  return {baseScissorsItem, pizzaCutterItem, gardenshearsItem, utilityknifeItem, chainsawItem, laserItem, crocodileItem, handItem}
end
