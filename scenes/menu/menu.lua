local composer = require("composer")
local scene = composer.newScene()

local ch, cw, cx, cy =
	display.contentHeight,
	display.contentWidth,
	display.contentCenterX,
	display.contentCenterY

function scene:create(event)
	local sceneGroup = self.view

	-- TODO: Simple background for menu...more exciting one for game
	local bg =
		display.newImageRect(sceneGroup, "scenes/menu/background.jpg", cw, ch)
	bg.x = cx
	bg.y = cy
	bg.fill.effect = "filter.crystallize"
	bg.fill.effect.numTiles = 140

	local playButton =
		display.newText(sceneGroup, "Play", cx, cy - 40, native.systemFont, 48)
	playButton:setFillColor(0.82, 0.86, 1)
	playButton:addEventListener("tap", function()
		composer.gotoScene("scenes.game.game", {
			time = 800,
			effect = "crossFade"
		})
	end)

	local highScoresButton =
		display.newText(
			sceneGroup,
			"High Scores",
			cx,
			cy + 40,
			native.systemFont,
			48
		)
	highScoresButton:setFillColor(0.75, 0.78, 1)
	highScoresButton:addEventListener("tap", function()
		composer.gotoScene("scenes.highscores", {
			time = 800,
			effect = "crossFade"
		})
	end)
end

scene:addEventListener("create", scene)

return scene