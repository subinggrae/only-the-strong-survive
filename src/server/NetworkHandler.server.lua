--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CombatConfig = require(Shared:WaitForChild("CombatConfig"))
local CombatService = require(script.Parent:WaitForChild("CombatService"))

local attackEvent = ReplicatedStorage:WaitForChild(CombatConfig.REMOTE_EVENT_NAME)

attackEvent.OnServerEvent:Connect(function(player, targetPlayer)
	-- Runtime Type Checking for safety
	if typeof(targetPlayer) == "Instance" and targetPlayer:IsA("Player") then
		if targetPlayer ~= player then
			CombatService.ApplyDamage(player, targetPlayer)
		end
	end
end)

print("Combat Network Handler Initialized")
