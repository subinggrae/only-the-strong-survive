--!strict

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CombatConfig = require(Shared:WaitForChild("CombatConfig"))

local CombatService = {}

function CombatService.ApplyDamage(attacker, target)
	if not attacker or not target then return end
	
	local targetChar = target.Character
	local attackerChar = attacker.Character
	
	if not targetChar or not attackerChar then return end
	
	local targetHum = targetChar:FindFirstChild("Humanoid")
	local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
	local attackerRoot = attackerChar:FindFirstChild("HumanoidRootPart")
	
	if targetHum and targetRoot and attackerRoot and targetHum.Health > 0 then
		local distance = (targetRoot.Position - attackerRoot.Position).Magnitude
		
		if distance <= CombatConfig.ATTACK_RANGE then
			targetHum:TakeDamage(CombatConfig.DAMAGE)
			print(attacker.Name .. " dealt " .. tostring(CombatConfig.DAMAGE) .. " damage to " .. target.Name)
			
			CombatService.CreateVisualEffect(targetRoot.Position)
		else
			warn("Target out of range: " .. tostring(distance) .. " studs")
		end
	end
end

function CombatService.CreateVisualEffect(position)
	local effectPart = Instance.new("Part")
	effectPart.Size = Vector3.new(1, 1, 1)
	effectPart.Color = Color3.new(1, 0, 0)
	effectPart.Material = Enum.Material.Neon
	effectPart.Anchored = true
	effectPart.CanCollide = false
	effectPart.Position = position
	effectPart.Parent = workspace
	
	Debris:AddItem(effectPart, CombatConfig.EFFECT_DURATION)
end

return CombatService
