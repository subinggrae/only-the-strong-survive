--!strict

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local Server = ServerScriptService:WaitForChild("Server")
local LeaderboardService = require(Server:WaitForChild("LeaderboardService"))
local CoinService = require(Server:WaitForChild("CoinService"))
local PortalService = require(Server:WaitForChild("PortalService"))

-- 1. Initialize Auto Spawners
CoinService.StartAutoSpawner()
PortalService.StartAutoSpawner()

-- 2. Handle Player Events
Players.PlayerAdded:Connect(function(player)
	-- Setup Leaderstats
	LeaderboardService.SetupLeaderboard(player)
	
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		
		-- Handle Death
		humanoid.Died:Connect(function()
			local currentCoins = LeaderboardService.GetCoins(player)
			if currentCoins > 0 then
				local rootPart = character:FindFirstChild("HumanoidRootPart")
				if rootPart then
					CoinService.DropCoins(rootPart.Position, currentCoins)
				end
				LeaderboardService.ResetCoins(player)
			end
		end)
	end)
end)

print("Game Manager Initialized (Coins + Portals)")
