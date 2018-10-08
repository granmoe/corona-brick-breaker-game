local physics = require("physics")

function onCollision(event)
	local self = event.target

	if event.phase == "began" then
		self.health = self.health - 50

		if self.health <= 0 then
			-- self:removeEventListener("collision") -- why isn't this working? Do in a lifecycle hook?
			display.remove(self)
			return
			-- sometimes need to use self:removeSelf() depending on object type (text)
			-- self = nil -- would this cause a crash?
		end

		self.fill.effect = "generator.checkerboard"
		self.fill.effect.color1 = { 0, 0, 0, 0 }
		self.fill.effect.color2 = { 1, 0.5, 0.5, 1 }
		self.fill.effect.xStep = 40
		self.fill.effect.yStep = 15
	end
end

local function createBrick(group, x, y, width, height)
	-- last arg is border radius
	local brick = display.newRect(group, x, y, width, height)
	local r, b, g =
		math.random(1, 100) / 100,
		math.random(1, 100) / 100,
		math.random(1, 100) / 100

	brick:setFillColor(r, b, g)
	brick.fill.effect = "generator.radialGradient"
	brick.fill.effect.color1 = { 1, 1, 1, 1 }
	brick.fill.effect.color2 = { 0, 0, 0, 1 }
	brick.fill.effect.center_and_radiuses = { 0.5, 0.5, 0.2, 0.8 }
	brick.fill.effect.aspectRatio = 0.1

	brick.health = 100
	brick.type = "brick"
	physics.addBody(brick, "static")

	brick:addEventListener("collision", onCollision)

	return brick
end

return createBrick