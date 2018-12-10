local physics = require("physics")
keysDown = require("keys-down")

local function dragPaddle(event)
	local paddle = event.target

	if ("began" == event.phase) then
		paddle.touchOffsetX = event.x - paddle.x
		display.currentStage:setFocus(paddle)
	-- Store initial offset position and set touch focus on paddle
	elseif ("moved" == event.phase) then
		-- Move paddle to the new touch position
		paddle.x = event.x - paddle.touchOffsetX
		if paddle.x < paddle.width / 2 then
			paddle.x = paddle.width / 2
		end
		if paddle.x > display.contentWidth - paddle.width / 2 then
			paddle.x = display.contentWidth - paddle.width / 2
		end
	elseif ("ended" == event.phase or "cancelled" == event.phase) then
		-- Release touch focus on paddle
		display.currentStage:setFocus(nil)
	end

	return true -- Prevents touch propagation to underlying objects
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
	
	local function onKey(event)
		if event.phase ~= 'down' then return end
		
		if event.keyName == 'left' then
			paddle:setLinearVelocity(-300, 0)
		end
		
		if event.keyName == 'right' then
			paddle:setLinearVelocity(300, 0)
		end
	end
	Runtime:addEventListener("key", onKey)

	local function onEnterFrame()
		if not keysDown['left'] and not keysDown['right'] then
			paddle:setLinearVelocity(0, 0)
		end
	end
	Runtime:addEventListener('enterFrame', onEnterFrame)

	paddle:addEventListener("finalize", function(event)
		paddle:removeEventListener("touch", dragPaddle)
		Runtime:removeEventListener("key", onKey)
		Runtime:removeEventListener("enterFrame", onEnterFrame)
	end)

	return paddle
end

return createPaddle