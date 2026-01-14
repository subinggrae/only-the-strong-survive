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

-- 5. Ensure Goblin Template exists (Priority Fix)
local existingDummy = ServerStorage:FindFirstChild("Goblin")
local userModel = ServerStorage:FindFirstChild("gobiln") or ServerStorage:FindFirstChild("goblin")

if userModel then
	-- Found user's custom model (with typo/lowercase)
	if existingDummy and existingDummy ~= userModel then
		-- Delete the green dummy if it exists
		existingDummy:Destroy()
		print("Removed dummy 'Goblin' to use user's custom model.")
	end
	
	-- Rename user model to standard 'Goblin'
	userModel.Name = "Goblin"
	print("Renamed '" .. userModel.Name .. "' to 'Goblin' for compatibility.")
elseif not existingDummy then
	-- Fallback: Create procedural goblin (Only if NO model exists)
	local goblin = Instance.new("Model")
	goblin.Name = "Goblin"
	
	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Size = Vector3.new(2, 2, 1)
	root.Color = Color3.fromRGB(0, 155, 0) -- Greenish
	root.Transparency = 0.5
	root.CanCollide = false
	root.Anchored = false -- Must be unanchored to move
	root.Parent = goblin
	
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(1, 1, 1)
	head.Color = Color3.fromRGB(0, 255, 0) -- Bright Green
	head.Position = root.Position + Vector3.new(0, 1.5, 0)
	head.Anchored = false
	head.Parent = goblin
	
	-- Weld Head to Root
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = root
	weld.Part1 = head
	weld.Parent = root

	local humanoid = Instance.new("Humanoid")
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
	humanoid.HipHeight = 3 -- Prevents falling over by setting "leg" height
	humanoid.Health = 100
	humanoid.MaxHealth = 100
	humanoid.Parent = goblin
	
	goblin.PrimaryPart = root
	goblin.Parent = ServerStorage
	print("Created Goblin template in ServerStorage")
end