local keysDown = {}

Runtime:addEventListener("key", function(event)
    if event.phase == "down" then
      keysDown[event.keyName] = true
		end
		if event.phase == "up" then
      keysDown[event.keyName] = false
		end
  end)

return keysDown
