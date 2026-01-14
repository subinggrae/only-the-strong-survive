--!strict

local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CoinConfig = require(Shared:WaitForChild("CoinConfig"))
local LeaderboardService = require(script.Parent:WaitForChild("LeaderboardService"))

local CoinService = {}

local function GetCoinTemplate()
	local template = ServerStorage:FindFirstChild("Coin")
	if not template then
		warn("Coin template not found in ServerStorage!")
		return nil
	end
	return template
end

local function SetupCoinTouch(coin)
	if coin:GetAttribute("TouchConnected") then return end
	coin:SetAttribute("TouchConnected", true)
	
	local connection
	connection = coin.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			-- Award Coin
			LeaderboardService.AddCoins(player, 1)
			
			-- Cleanup
			if connection then connection:Disconnect() end
			coin:Destroy()
		end
	end)
end

function CoinService.SpawnCoinAtPosition(position, parentFolder, temporary)
	local template = GetCoinTemplate()
	if not template then return end
	
	local newCoin = template:Clone()
	newCoin.Position = position + Vector3.new(0, 3, 0)
	newCoin.Anchored = true
	newCoin.CanCollide = false
	newCoin.Parent = parentFolder
	
	-- Tag for client animation and server logic
	CollectionService:AddTag(newCoin, CoinConfig.COIN_TAG)
	SetupCoinTouch(newCoin)
	
	if temporary then
		Debris:AddItem(newCoin, CoinConfig.DROP_LIFETIME)
	end
end

function CoinService.StartAutoSpawner()
	task.spawn(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		
		while true do
			task.wait(CoinConfig.SPAWN_INTERVAL)
			
			for _, area in pairs(CoinConfig.SPAWN_AREAS) do
				local folderName = area.name .. "_Coins"
				local folder = Workspace:FindFirstChild(folderName)
				if not folder then
					folder = Instance.new("Folder")
					folder.Name = folderName
					folder.Parent = Workspace
				end
				
				-- Update filter list dynamically
				params.FilterDescendantsInstances = {folder, Players:GetPlayers()}
				
				if #folder:GetChildren() < area.maxCoins then
					local randomX = math.random(area.minX, area.maxX)
					local randomZ = math.random(area.minZ, area.maxZ)
					local origin = Vector3.new(randomX, CoinConfig.RAY_HEIGHT, randomZ)
					local direction = Vector3.new(0, -1000, 0)
					
					local result = Workspace:Raycast(origin, direction, params)
					if result then
						CoinService.SpawnCoinAtPosition(result.Position, folder, false)
					end
				end
			end
		end
	end)
end

function CoinService.DropCoins(position, amount)
	if amount <= 0 then return end
	
	local folder = Workspace:FindFirstChild("DroppedCoins") or Instance.new("Folder", Workspace)
	folder.Name = "DroppedCoins"
	
	local template = GetCoinTemplate()
	if not template then return end
	
	for i = 1, amount do
		task.spawn(function()
			-- Small random spread
			local spreadX = math.random(-8, 8)
			local spreadZ = math.random(-8, 8)
			local origin = Vector3.new(position.X + spreadX, CoinConfig.RAY_HEIGHT, position.Z + spreadZ)
			
			local result = Workspace:Raycast(origin, Vector3.new(0, -1000, 0))
			local targetPos = position -- Fallback
			
			if result then
				targetPos = result.Position
			else
				targetPos = position + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
			end
			
			CoinService.SpawnCoinAtPosition(targetPos, folder, true)
		end)
		
		if i % 20 == 0 then task.wait() end -- Throttle spawning if dropping huge amounts
	end
end

return CoinService
