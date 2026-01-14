--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CombatConfig = require(Shared:WaitForChild("CombatConfig"))

local CombatController = {}
CombatController.__index = CombatController

function CombatController.new(player)
	local self = setmetatable({}, CombatController)
	self._player = player
	self._attackTrack = nil
	self._lastAttackTime = 0
	self._remoteEvent = ReplicatedStorage:WaitForChild(CombatConfig.REMOTE_EVENT_NAME)
	
	return self
end

function CombatController:SetupCharacter(character)
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	if self._attackTrack then
		self._attackTrack:Stop()
	end

	local attackAnim = Instance.new("Animation")
	attackAnim.AnimationId = CombatConfig.PUNCH_ANIM_ID
	
	self._attackTrack = animator:LoadAnimation(attackAnim)
	local track = self._attackTrack
	if track then
		track.Priority = Enum.AnimationPriority.Action
	end

	print("Character Setup Complete")
end

function CombatController:FindNearestEnemy()
	local character = self._player.Character
	if not character then return nil end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return nil end

	local nearestEnemy = nil
	local shortestDistance = CombatConfig.ATTACK_RANGE

	for _, otherPlayer in pairs(Players:GetPlayers()) do
		if otherPlayer ~= self._player and otherPlayer.Character then
			local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
			local otherHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")

			if otherRoot and otherHumanoid and otherHumanoid.Health > 0 then
				local distance = (rootPart.Position - otherRoot.Position).Magnitude

				if distance < shortestDistance then
					shortestDistance = distance
					nearestEnemy = otherPlayer
				end
			end
		end
	end

	return nearestEnemy
end

function CombatController:Attack()
	local currentTime = os.clock()
	
	if currentTime - self._lastAttackTime < CombatConfig.ATTACK_COOLDOWN then
		return
	end

	local track = self._attackTrack
	if track then
		track:Play()
		self._lastAttackTime = currentTime
		print("Attack Animation Played")

		local targetPlayer = self:FindNearestEnemy()
		if targetPlayer then
			self._remoteEvent:FireServer(targetPlayer)
			print("Attack Request Sent. Target: " .. targetPlayer.Name)
		end
	else
		warn("Animation Track not loaded")
	end
end

return CombatController
