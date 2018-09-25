local lg = love.graphics

local Brick = {}

function Brick:draw()
	lg.setColor(
		self.r / 255,
		self.g / 255,
		self.b / 255,
		(255 * (self.health / 100)) / 255
	)
	lg.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Brick:takeDamage()
	self.health = self.health - 50
	if self.health <= 0 then
		self:destroy()
	end
end

function Brick:destroy()
	display.remove(self)
	-- self = nil
end

local function createBrick(x, y, width, height, index, bricks, world)
	local brick = {
		x = x,
		y = y,
		health = 100,
		r = math.floor(math.random() * 256),
		g = math.floor(math.random() * 256),
		b = math.floor(math.random() * 256),
		isBrick = true,
		index = index,
		bricks = bricks,
		world = world,
		width = width,
		height = height
	}

	setmetatable(brick, { __index = Brick })

	return brick
end

return createBrick