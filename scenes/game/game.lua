local composer = require("composer")
local scene = composer.newScene()

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

local ch, cw, cx, cy =
	display.contentHeight,
	display.contentWidth,
	display.contentCenterX,
	display.contentCenterY

-- TODO: Sound FX when hit brick, paddle, break brick, win, start new game
-- TODO: Use this to drag paddle
local function dragPaddle(event)
	local paddle = event.target

	if ("began" == event.phase) then
		display.currentStage:setFocus(paddle)
		paddle.touchOffsetX = event.x - paddle.x
	-- Set touch focus on the paddle
	-- Store initial offset position
	elseif ("moved" == event.phase) then
		-- Move the paddle to the new touch position
		paddle.x = event.x - paddle.touchOffsetX
	elseif ("ended" == event.phase or "cancelled" == event.phase) then
		-- Release touch focus on the paddle
		display.currentStage:setFocus(nil)
	end

	return true -- Prevents touch propagation to underlying objects
end

local function onCollision(event)
	if (event.phase == "began") then
		local obj1 = event.object1
		local obj2 = event.object2
		-- TODO: Lose life, restore paddle/ball, end game
	end
end

function scene:create(event)
	local sceneGroup = self.view

	physics.pause() -- Temporarily pause the physics engine
	local backGroup = display.newGroup()
	local mainGroup = display.newGroup()
	sceneGroup:insert(backGroup)
	sceneGroup:insert(mainGroup)

	local bg =
		display.newImageRect(backGroup, "scenes/game/background.jpg", cw, ch)
	bg.x = cx
	bg.y = cy
	bg.fill.effect = "filter.crystallize"
	bg.fill.effect.numTiles = 140

	-- local paddle = display.newRect(mainGroup, 98, 79)
	-- paddle.x = display.contentCenterX
	-- paddle.y = display.contentHeight - 100
	-- physics.addBody(paddle, {
	-- 	radius = 30,
	-- 	isSensor = true
	-- })
	-- paddle.myName = "paddle"

	-- paddle:addEventListener("touch", dragPaddle)
end

function scene:show(event)
	print(composer.getSceneName())
	if (event.phase == "did") then
		physics.start()
		-- Runtime:addEventListener("collision", onCollision)
	end
end

function scene:hide(event)
	if (event.phase == "did") then
		Runtime:removeEventListener("collision", onCollision)
		physics.pause()
		composer.removeScene("game")
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene