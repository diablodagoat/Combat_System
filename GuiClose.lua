local player = game.Players.LocalPlayer
local gui = player.PlayerGui:WaitForChild("ScreenGui")

local function show_hide(guiClone, val)
	guiClone.Frame.Visible = val
	for _, option in pairs(guiClone.Frame:GetChildren()) do
		if option:IsA("GuiObject") then
			option.Visible = val
		end
	end
end

if gui.Frame:FindFirstChild("ImageButton") then
	gui.Frame.ImageButton.MouseButton1Click:Connect(function()
		print("hiding gui")
		show_hide(gui, false)
	end)
else
	warn("ImageButton not found in clone.")
end
