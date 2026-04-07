function init()
  self.duplicateChance = config.getParameter("allowDuplicateChance")
  self.recipes = config.getParameter("recipes")
  self.swingTime = config.getParameter("swingTime")
  activeItem.setArmAngle(-math.pi / 2)
end

function update(dt, fireMode, shiftHeld)
  updateAim()

  if not self.swingTimer and fireMode == "primary" and player then
    self.swingTimer = self.swingTime
  end

  if self.swingTimer then
    self.swingTimer = math.max(0, self.swingTimer - dt)

    activeItem.setArmAngle((-math.pi / 2) * (self.swingTimer / self.swingTime))

    if self.swingTimer == 0 then
      learnBlueprint()
    end
  end
end

function learnBlueprint()
  local recipesToLearn = self.recipes

  if type(recipesToLearn) ~= "table" then
    recipesToLearn = {recipesToLearn}
  end

  for _, itemName in ipairs(recipesToLearn) do
    if type(itemName) == "table" then
      itemName = chooseRecipe(itemName)
    end

    player.giveBlueprint(itemName)
  end

  animator.playSound("learnBlueprint")

  item.consume(1)
end

function chooseRecipe(recipeOrRecipes)
  if type(recipeOrRecipes) == "table" then
    local choice = recipeOrRecipes[math.random(1, #recipeOrRecipes)]
    return chooseRecipe(choice)
  else
    return recipeOrRecipes
  end
end

function updateAim()
  self.aimAngle, self.aimDirection = activeItem.aimAngleAndDirection(0, activeItem.ownerAimPosition())
  activeItem.setFacingDirection(self.aimDirection)
end
