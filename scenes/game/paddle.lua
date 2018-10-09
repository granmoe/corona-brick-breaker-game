local physics = require("physics")

local function dragPaddle(event)
	local paddle = event.target

	if ("began" == event.phase) then
		paddle.touchOffsetX = event.x - paddle.x
		display.currentStage:setFocus(paddle)
	-- Store initial offset position and set touch focus on paddle
	elseif ("moved" == event.phase) then
		-- Move paddle to the new touch position
		paddle.x = event.x - paddle.touchOffsetX
	elseif ("ended" == event.phase or "cancelled" == event.phase) then
		-- Release touch focus on paddle
		display.currentStage:setFocus(nil)
	end

	return true -- Prevents touch propagation to underlying objects
end

local function key(event)
	print"it worked"
	print(event.target)
	-- if (event.phase == lastEvent.phase) and (event.keyName == lastEvent.keyName) then
	-- 	return false
	-- end -- Filter repeating keys
	if event.phase == "down" then
		if "left" == event.keyName or "a" == event.keyName then
			-- event.target:applyForce(0, 0, -50, -50)
		end
		if "right" == event.keyName or "d" == event.keyName then
			-- event.target:applyForce(0, 0, 50, 50)
		end
	end

	-- lastEvent = event
end

local function createPaddle(group)
	local paddle =
		display.newRect(
			group,
			display.contentCenterX,
			display.contentHeight - 30,
			85,
			20
		)
	physics.addBody(paddle, "dynamic", {
		density = 100000,
		friction = 0.9,
		bounce = 0
	})

	paddle.type = "paddle"
	paddle.fill.effect = "generator.radialGradient"
	paddle.fill.effect.color1 = { 1, 1, 1, 1 }
	paddle.fill.effect.color2 = { 0, 0, 0, 1 }
	paddle.fill.effect.center_and_radiuses = { 0.5, 0.5, 0.1, 0.9 }
	paddle.fill.effect.aspectRatio = 0.1

	paddle:addEventListener("touch", dragPaddle)

	-- TODO: Figure out a better way to do this that will still have instance in scope
	Runtime:addEventListener("key", function(event)
		print(event.phase)
		print(event.keyName)
		if event.phase == "down" then
			if "left" == event.keyName then
				paddle:setLinearVelocity(-300, 0)
			end
			if "right" == event.keyName then
				paddle:setLinearVelocity(300, 0)
			end
		end
		if event.phase == "up" then
			paddle:setLinearVelocity(0, 0)
		end
	end)

	return paddle
end

return createPaddle