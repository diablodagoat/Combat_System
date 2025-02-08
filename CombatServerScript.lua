local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local anim = script:FindFirstChild("GotHitAnim")
local anim2= script:FindFirstChild("BlockBreak")




local function blockBreak(Char)
	if Char:GetAttribute("stunned") ~= true then
		

		Char:SetAttribute("stunned", true)
		Char:SetAttribute("Block", false)

		local humanoid = Char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:TakeDamage(2)
			local animationTrack = humanoid:LoadAnimation(anim2)
			if animationTrack then
				animationTrack:Play()
			end
		end
		
		task.delay(5, function()
			Char:SetAttribute("stunned", false)
		end)
	end
end


local function createDynamicHitbox(player, range, width, height, color)
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local humanoidRootPart = character.HumanoidRootPart
	local hitboxPart = Instance.new("Part")
	hitboxPart.Size = Vector3.new(width, height, range)
	hitboxPart.Anchored = true
	hitboxPart.CanCollide = false
	hitboxPart.Transparency = 1
	hitboxPart.BrickColor = BrickColor.new(color or "Bright red")
	hitboxPart.Material = Enum.Material.ForceField
	hitboxPart.Parent = workspace

	local startTime = tick()
	local hitboxLifetime = 0.2
	local hits = {}

	local connection
	connection = RunService.Heartbeat:Connect(function()
		if not humanoidRootPart or tick() - startTime > hitboxLifetime then
			hitboxPart:Destroy()
			connection:Disconnect()
			return
		end

		local forwardVector = humanoidRootPart.CFrame.LookVector
		local centerPosition = humanoidRootPart.Position + (forwardVector * range / 2)
		hitboxPart.CFrame = CFrame.new(centerPosition, centerPosition + forwardVector)

		for _, part in pairs(workspace:GetPartsInPart(hitboxPart)) do
			local targetCharacter = part.Parent
			if targetCharacter and targetCharacter:FindFirstChild("Humanoid") and targetCharacter.Name ~= player.Name then
				if not hits[targetCharacter.Name] then
					hits[targetCharacter.Name] = true

					-- Check for Block attribute
					if targetCharacter:GetAttribute("Block") then
						--simple vfx (no client replication since it's a prototype)
						local blockEffect = game.ReplicatedStorage["Shield-01"].Main:Clone()
						blockEffect.Parent = targetCharacter.HumanoidRootPart
						blockEffect.ParticleEmitter:Emit()
						blockEffect.ParticleEmitter1:Emit()
						game.Debris:AddItem(blockEffect, 0.5)
						if 	targetCharacter:GetAttribute("Posture") >10 then
							local newP= targetCharacter:GetAttribute("Posture")-10
							targetCharacter:SetAttribute("Posture",newP)
						else
							blockBreak(targetCharacter)
							targetCharacter:SetAttribute("Posture",30)
						end


						return
					else
						local humanoid = targetCharacter.Humanoid
						humanoid:TakeDamage(10)
						humanoid:LoadAnimation(anim):Play()

						local HitEffect = game.ReplicatedStorage.Part.Main:Clone()
						HitEffect.Parent = targetCharacter.HumanoidRootPart
						spawn(function()
							for i, v in HitEffect:GetChildren() do
								v:Emit(v:GetAttribute("EmitCount"))
							end
						end)
						game.Debris:AddItem(HitEffect, 0.3)

						local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
						if targetRoot then
							targetRoot.CFrame = CFrame.new(targetRoot.Position, humanoidRootPart.Position)
						end

						if humanoid.WalkSpeed > 7 then
							local originalSpeed = humanoid.WalkSpeed
							humanoid.WalkSpeed = 7
							task.delay(0.5, function()
								if humanoid then
									humanoid.WalkSpeed = originalSpeed
								end
							end)
						end
					end
				end
			end
		end
	end)

	Debris:AddItem(hitboxPart, hitboxLifetime)
end

game.ReplicatedStorage:FindFirstChild("CombatEvent").OnServerEvent:Connect(function(player, arg)
	local char=player.Character or player.CharacterAdded:wait()


	if arg == "Hit" then
		local range = 5
		local width = 4
		local height = 5
		createDynamicHitbox(player, range, width, height, "Bright red")

	elseif arg == "BlockOn" then

		-- Add Block attribute if not present and set it to true 
		if not char:GetAttribute("Block") then
			char:SetAttribute("Block", true)
			char:SetAttribute("Posture",30)
		end

	elseif arg == "BlockOff" then
		-- Set Block Attribute to false
		if char:GetAttribute("Block") then
			char:SetAttribute("Block", false)
		end
	end
end)
