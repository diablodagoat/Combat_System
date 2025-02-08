
local player=game.Players.LocalPlayer
local char=player.Character or player.CharacterAdded:wait()
local uis=game:GetService("UserInputService")

local event=game.ReplicatedStorage:FindFirstChild("CombatEvent")
local gui=player:WaitForChild("PlayerGui")
local button= gui:WaitForChild("ScreenGui"):WaitForChild("m1")
local bdb=false --Block debounce
local db=false --m1 debounce
local count=1
local af=script.Parent:FindFirstChild("Animations") --af=animations folder
local animList={
	af:FindFirstChild("hit1"),
	af:FindFirstChild("hit2"),
	af:FindFirstChild("hit3"),
	af:FindFirstChild("hit4"),
	af:FindFirstChild("block")
}
local block= char:WaitForChild("Humanoid"):LoadAnimation(animList[5])
uis.InputBegan:Connect(function(E,I)
	if I then return end
	if E.UserInputType==Enum.UserInputType.MouseButton1 and not db and not char:GetAttribute("stunned") and not char:GetAttribute("Block") then
		
		
		if count > 4 then 
			count = 1
			
		end
		wait(0.1)
		
		
		
		
		db=true
		
		
		
		
		
		local m1= char:WaitForChild("Humanoid"):LoadAnimation(animList[count])
		m1:Play()
		m1:GetMarkerReachedSignal("Hit"):Connect(function()
			if not char:GetAttribute("Block") then
				event:FireServer("Hit")
			end
		end)
		char:WaitForChild("Humanoid").WalkSpeed = 7
		
		count+=1
		
		task.delay(0.5,function()
			db=false
			if count==3  then
				task.wait(0.3)
			end
			char:WaitForChild("Humanoid").WalkSpeed = 16
		end)
		
		
		
		
		
		
		
		
		
		
	elseif E.UserInputType==Enum.UserInputType.MouseButton2 and not bdb and not char:GetAttribute("stunned") then
		
		
		event:FireServer("BlockOn")
	
		block:Play()
		
		char:WaitForChild("Humanoid").WalkSpeed = 7
		
	end
end)



uis.InputEnded:Connect(function(E,I)
	if I then return end
	if E.UserInputType==Enum.UserInputType.MouseButton2 and not bdb then
		
		char:WaitForChild("Humanoid").WalkSpeed = 16
		block:stop()
		event:FireServer("BlockOff")
		
		bdb=true 
		task.delay(1,function()
			bdb=false
		end)

	end
end)

button.MouseButton1Click:Connect(function()
	print("GUI button clicked!")

	if count > 4 then 
		count = 1
	end





	db=true





	local m1= char:WaitForChild("Humanoid"):LoadAnimation(animList[count])
	m1:Play()
	m1:GetMarkerReachedSignal("Hit"):Connect(function()
		event:FireServer("Hit")
	end)
	char:WaitForChild("Humanoid").WalkSpeed = 7

	count+=1

	task.delay(0.2,function()
		db=false
		char:WaitForChild("Humanoid").WalkSpeed = 16
	end)





end)