--!strict

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CombatController = require(script.Parent:WaitForChild("CombatController"))

local player = Players.LocalPlayer
local controller = CombatController.new(player)

local function onCharacterAdded(character)
	controller:SetupCharacter(character)
end

local function onInputBegan(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		controller:Attack()
	end
end

if player.Character then
	onCharacterAdded(player.Character)
end

player.CharacterAdded:Connect(onCharacterAdded)
UserInputService.InputBegan:Connect(onInputBegan)
