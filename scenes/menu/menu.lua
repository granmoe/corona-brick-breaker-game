local composer = require("composer")
local scene = composer.newScene()

local ch, cw, cx, cy =
	display.contentHeight,
	display.contentWidth,
	display.contentCenterX,
	display.contentCenterY

local playButton
local messageText

function scene:create(event)
	local sceneGroup = self.view

	local bg =
		display.newImageRect(sceneGroup, "scenes/menu/background.jpg", cw, ch)
	bg.x = cx
	bg.y = cy
	bg.fill.effect = "filter.crystallize"
	bg.fill.effect.numTiles = 140

	messageText = display.newText(sceneGroup, '', cx, cy - 100, native.systemFont, 48)

	playButton =
		display.newText(sceneGroup, "Play", cx, cy - 24, native.systemFont, 48)
	playButton:setFillColor(0.82, 0.86, 1)
	playButton:addEventListener("tap", function()
		composer.setVariable('state', 'playing')
		composer.gotoScene("scenes.game.game", {
			time = 800,
			effect = "crossFade"
		})
	end)
end

function scene:show(event)
	if event.phase ~= "did" then return end

	local sceneGroup = self.view

	local state = composer.getVariable("state")
	local messages = {
		["lost"] = "Game Over",
		["won"]  = "You Won! Gratz bruh"
	}
	local message = messages[state]
	messageText.text = message

	if message then
		playButton.text = "Play again"
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)

return scene