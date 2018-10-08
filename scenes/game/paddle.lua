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

local function createPaddle(group)
	local paddle =
		display.newRect(
			group,
			display.contentCenterX,
			display.contentHeight - 30,
			85,
			20
		)
	physics.addBody(paddle, "static", {
		friction = 0.9,
		bounce = 1
	})
	paddle.type = "paddle"
	paddle.fill.effect = "generator.radialGradient"
	paddle.fill.effect.color1 = { 1, 1, 1, 1 }
	paddle.fill.effect.color2 = { 0, 0, 0, 1 }
	paddle.fill.effect.center_and_radiuses = { 0.5, 0.5, 0.1, 0.9 }
	paddle.fill.effect.aspectRatio = 0.1

	paddle:addEventListener("touch", dragPaddle)

	return paddle
end

return createPaddle