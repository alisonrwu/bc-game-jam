Details = State:subclass("Details")

function Details:initialize(item, shop)
  self.panel = ImagePlaceable("assets/graphics/shop/hud_panel.png")
  self.image = ImagePlaceable(item.imagePath)
  self.image:setCentreHorizontal(self.panel)
  self.image:setCentreVertical(self.panel)
  self.display = GroupPlaceable({self.panel, self.image})
  self.display:setCentreHorizontalScreen()
  self.display:setCentreVerticalScreen()
  self.display:setPosition(Point(self.display.position.x, self.display.position.y - 80))
  self.effect = effects[item.effectIndex]
  self.effect.display:setBelow(self.display, 10)
  self.effect.display:setCentreHorizontal(self.display)
  local equip = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_load.wav", "load")   
    for i = 1, #shop.items do
      local item = shop.items[i]
      if item.equipped then 
        user:removeModifiers()
        item:setEquipped(false) 
      end
    end
    item:setEquipped(true)
    user:equipEffect(item.effectIndex)
    state = shop
  end
  local goBack = function()
    state = shop
  end
  self.backButton = ImageButton("assets/graphics/globals/hud_back.png", goBack)
  self.backButton:setLeftOfPoint(Point(baseRes.width, 10), 15)
  self.equipButton = TextOnImageButton("assets/graphics/gameover/button_thin.png", equip, nil, "Equip", Graphics.NORMAL)
  self.equipButton:setBelow(self.effect.display, 10)
  self.equipButton:setCentreHorizontal(self.effect.display)
end

function Details:update()
  salary:update()
end

function Details:draw()
  self.display:draw()
  self.effect:draw()
  self.equipButton:draw()
  self.backButton:draw()
  salary:draw()
end

function Details:mouseRelease(x, y, button, isTouch) 
  self.backButton:mouseRelease(x, y, button, isTouch)
  self.equipButton:mouseRelease(x, y, button ,isTouch)
end

function Details:mousePressed(x, y, button, isTouch)
  
end

function Details:__tostring()
  return "Details"
end