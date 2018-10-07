local physics = require("physics")

local Brick = {}

function Brick:takeDamage()
	self.health = self.health - 50
	if self.health <= 0 then
		self:destroy()
	end

	self.fill.effect = "generator.checkerboard"
	self.fill.effect.color1 = { 0, 0, 0, 0 }
	self.fill.effect.color2 = { 1, 0.5, 0.5, 1 }
	self.fill.effect.xStep = 40
	self.fill.effect.yStep = 15
end

function Brick:destroy()
	display.remove(self)
	-- sometimes need to use self:removeSelf() depending on object type (text)
	-- self = nil -- would this cause a crash?
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

	setmetatable(brick, { __index = Brick })

	return brick
end

return createBrick