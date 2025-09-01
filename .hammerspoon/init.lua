local hs = hs

-- <cmd+alt+r> Reload hammerspoon config
hs.hotkey.bind({ "cmd", "alt" }, "R", function()
	hs.reload()
end)

-- <cmd+shift+j> Display date and time
hs.hotkey.bind({ "cmd", "shift" }, "J", function()
	local date = os.date("%A, %B %d, %Y %I:%M:%S %p")
	hs.alert.show(date)
end)

-- <cmd+alt+v> Open macvim to edit a text field
hs.hotkey.bind({ "cmd", "alt" }, "V", function()
	local originalApp = hs.application.frontmostApplication()
	local originalClipboard = hs.pasteboard.getContents()
	local tmpFile = os.tmpname() .. ".txt"

	hs.eventtap.keyStroke({ "cmd" }, "A")
	hs.timer.doAfter(0.1, function()
		hs.eventtap.keyStroke({ "cmd" }, "C")
		hs.timer.doAfter(0.1, function()
			local textToEdit = hs.pasteboard.getContents()

			local file, err = io.open(tmpFile, "w")
			if not file then
				hs.alert.show("Hammerspoon Error: (cmd+alt+v) Could not create temp file.")
				print("Hammerspoon Error: (cmd+alt+v) Error creating temp file" .. tostring(err))
				return
			end
			file:write(textToEdit)
			file:close()

			local macvim = hs.task.new("/usr/bin/open", function(exitCode, stdOut, stdErr)
				if exitCode ~= 0 then
					hs.alert.show("Hammerspoon Error: (cmd+alt+v) MacVim exited with error.")
					print("Hammerspoon Error: (cmd+alt+v) MacVim task error: " .. stdOut)
					os.remove(tmpFile)
					return
				end

				local editedFile, readErr = io.open(tmpFile, "r")
				if not editedFile then
					hs.alert.show("Hammerspoon Error: (cmd+alt+v) Could not read temp file after editing.")
					print("Hammerspoon Error: (cmd+alt+v) Error reading temp file" .. tostring(readErr))
					os.remove(tmpFile)
					return
				end
				local editedText = editedFile:read("*a")
				editedFile:close()
				os.remove(tmpFile)

				originalApp:activate()
				hs.timer.doAfter(0.2, function()
					hs.pasteboard.setContents(editedText)
					hs.eventtap.keyStroke({ "cmd" }, "V")

					hs.timer.doAfter(0.5, function()
						hs.pasteboard.setContents(originalClipboard)
						hs.alert.show("Text updated from MacVim")
					end)
				end)
			end, { "-a", "MacVim", "-W", tmpFile })
			macvim:start()
		end)
	end)
end)

-- Reload confirmation message
hs.alert.show("Hammerspoon config reloaded.")
