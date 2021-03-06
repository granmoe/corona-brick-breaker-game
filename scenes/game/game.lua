local composer = require("composer")
local scene = composer.newScene()
local createBrick = require("scenes.game.brick")
local createPaddle = require("scenes.game.paddle")

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local ch, cw, cx, cy =
	display.contentHeight,
	display.contentWidth,
	display.contentCenterX,
	display.contentCenterY

function scene:create(event)
	local sceneGroup = self.view

	physics.pause() -- Temporarily pause the physics engine
	local backGroup = display.newGroup()
	local mainGroup = display.newGroup()
	sceneGroup:insert(backGroup)
	sceneGroup:insert(mainGroup)

	local background =
		display.newImageRect(backGroup, "scenes/game/background.jpg", cw, ch)
	background.x = cx
	background.y = cy
	background.fill.effect = "filter.crystallize"
	background.fill.effect.numTiles = 90 -- 140
	-- Add walls
	local ceiling = display.newRect(cx, -5, cw, 10)
	local leftWall = display.newRect(-5, cy, 10, ch)
	local rightWall = display.newRect(cw + 5, cy, 10, ch)
	physics.addBody(ceiling, "static", { bounce = 0 })
	physics.addBody(leftWall, "static", { bounce = 0 })
	physics.addBody(rightWall, "static", { bounce = 0 })
	ceiling:setFillColor(0, 0, 0)
	leftWall:setFillColor(0, 0, 0)
	rightWall:setFillColor(0, 0, 0)

	-- Add bricks
	local bricks = {}
	local width = cw / 7
	local height = 20
	local startX = width / 2
	local startY = 30
	for row = 0, 2 do
		for col = 0, 6 do
			local x = startX + col * width
			local y = startY + row * height
			local brick = createBrick(mainGroup, x, y, width, height, bricks)
		end
	end

	createPaddle(mainGroup)

	local ball = display.newCircle(mainGroup, cx, cy, 13)
	ball:setFillColor(1, 1, 1)
	ball.fill.effect = "generator.radialGradient"
	ball.fill.effect.color1 = { 1, 1, 1, 1 }
	ball.fill.effect.color2 = { 0, 0, 0, 1 }
	ball.fill.effect.center_and_radiuses = { 0.5, 0.5, 0, 1 }
	ball.fill.effect.aspectRatio = 1

	physics.addBody(ball, {
		radius = 13,
		density = 1,
		friction = 0.5,
		bounce = 1
	})

	ball:setLinearVelocity(0, 200)

	function removeEventListeners()
		Runtime:removeEventListener('enterFrame', updateBall)
		Runtime:removeEventListener('enterFrame', checkBrickCount)
	end

	local function updateBall()
		local limitedVx, limitedVy = ball:getLinearVelocity()
		if limitedVx < -200 then limitedVx = -200 end
		if limitedVx > 200 then limitedVx = 200 end
		if limitedVy < -200 then limitedVy = -200 end
		if limitedVy > 200 then limitedVy = 200 end

		ball:setLinearVelocity(limitedVx, limitedVy)
		if ball.y > ch - ball.width / 2 then
			composer.setVariable('state', 'lost')
			composer.gotoScene('scenes.menu.menu')
			removeEventListeners()
		end
	end

	Runtime:addEventListener('enterFrame', updateBall)

	local function checkBrickCount()
		local numBricks = 0
		for _ in pairs(bricks) do numBricks = numBricks + 1 end
		if numBricks == 0 then
			composer.setVariable('state', 'won')
			composer.gotoScene('scenes.menu.menu')
			removeEventListeners()
		end
	end

	Runtime:addEventListener('enterFrame', checkBrickCount)
end

function scene:show(event)
	if (event.phase == "did") then
		physics.start()
	end
end

function scene:hide(event)
	if (event.phase == "did") then
		physics.pause()
		composer.removeScene("scenes.game.game")
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene