function init()
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
      activeItem.setArmAngle(-math.pi / 2)
      self.swingTimer = nil
    end
  end
end

function learnBlueprint()
  local recipeList = collectRecipes(self.recipes)
  local learnedAny = false

  for _, itemName in ipairs(recipeList) do
    if not player.blueprintKnown(itemName) then
      player.giveBlueprint(itemName)
      learnedAny = true
    end
  end

  if learnedAny then
    animator.playSound("learnBlueprint")
    item.consume(1)
  end
end

function collectRecipes(recipeOrRecipes, result, seen)
  result = result or {}
  seen = seen or {}

  if type(recipeOrRecipes) == "table" then
    for _, recipe in ipairs(recipeOrRecipes) do
      collectRecipes(recipe, result, seen)
    end
  else
    if not seen[recipeOrRecipes] then
      seen[recipeOrRecipes] = true
      table.insert(result, recipeOrRecipes)
    end
  end

  return result
end

function updateAim()
  self.aimAngle, self.aimDirection = activeItem.aimAngleAndDirection(0, activeItem.ownerAimPosition())
  activeItem.setFacingDirection(self.aimDirection)
end