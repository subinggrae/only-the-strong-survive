local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

-- 1. Ensure AttackEvent exists
local eventName = "AttackEvent"
if not ReplicatedStorage:FindFirstChild(eventName) then
	local event = Instance.new("RemoteEvent")
	event.Name = eventName
	event.Parent = ReplicatedStorage
	print("Created " .. eventName .. " in ReplicatedStorage")
end

-- 2. Ensure Coin Template exists
if not ServerStorage:FindFirstChild("Coin") then
	local coin = Instance.new("Part")
	coin.Name = "Coin"
	coin.Size = Vector3.new(2, 2, 0.5)
	coin.Color = Color3.fromRGB(255, 215, 0) -- Gold
	coin.Material = Enum.Material.Neon
	coin.Anchored = true
	coin.CanCollide = false
	coin.Parent = ServerStorage
	print("Created Coin template in ServerStorage")
end

-- 3. Ensure Portal Template exists
if not ServerStorage:FindFirstChild("Portal") then
	local portal = Instance.new("Part")
	portal.Name = "Portal"
	portal.Size = Vector3.new(4, 6, 0.5)
	portal.Color = Color3.fromRGB(160, 32, 240) -- Purple
	portal.Material = Enum.Material.Neon
	portal.Anchored = true
	portal.CanCollide = false
	portal.Parent = ServerStorage
	print("Created Portal template in ServerStorage")
end

-- 4. Ensure LobbyPortal exists
if not Workspace:FindFirstChild("LobbyPortal") then
	local lobby = Instance.new("Part")
	lobby.Name = "LobbyPortal"
	lobby.Size = Vector3.new(10, 1, 10)
	lobby.Position = Vector3.new(0, 5, 0)
	lobby.Anchored = true
	lobby.Parent = Workspace
	print("Created LobbyPortal in Workspace")
end