local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local isSP=false
-- Rig names in ReplicatedStorage
local rigNames = { "Block Rig", "Normal Rig" }

-- Function to clone and parent the model in the Workspace
local function respawnModel(rigName)
	print(rigName)
	local storedModel = ReplicatedStorage:FindFirstChild(rigName)
	if storedModel then
		local newRig = storedModel:Clone()

		-- Ensure the rig has a PrimaryPart defined
		if newRig.PrimaryPart then
			newRig.Parent = Workspace
			newRig:SetPrimaryPartCFrame(CFrame.new(math.random(-10, 10), 5, math.random(-10, 10)))
			print(rigName .. " respawned.")
		else
			warn("No PrimaryPart found for " .. rigName)
		end
	else
		warn("Model not found in ReplicatedStorage: " .. rigName)
	end
end

-- Function to check health and respawn if necessary
local function checkHealthAndRespawn()
	for _, rigName in ipairs(rigNames) do
		local rig = Workspace:FindFirstChild(rigName)
		if rig then
			local humanoid = rig:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health <= 0 then
				print(rigName .. " has died! Respawning...")
				isSP=true
				wait(2)
				isSP=false
				rig:Destroy()
				respawnModel(rigName)

			end
		end
	end
end

-- Initial spawning
for _, rigName in ipairs(rigNames) do
	respawnModel(rigName)
end

-- Run the health check loop with a delay to avoid overloading the server
RunService.Heartbeat:Connect(function()
	wait(1)
	if not isSP  then
		checkHealthAndRespawn()
	end
	
end)
