--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CoinConfig = require(Shared:WaitForChild("CoinConfig"))

local LeaderboardService = {}

function LeaderboardService.SetupLeaderboard(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = CoinConfig.LEADERBOARD_NAME
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = CoinConfig.CURRENCY_NAME
	coins.Value = 0
	coins.Parent = leaderstats
	
	return coins
end

function LeaderboardService.AddCoins(player, amount)
	local leaderstats = player:FindFirstChild(CoinConfig.LEADERBOARD_NAME)
	if not leaderstats then return end
	
	local coins = leaderstats:FindFirstChild(CoinConfig.CURRENCY_NAME)
	if coins and coins:IsA("IntValue") then
		coins.Value = coins.Value + amount
	end
end

function LeaderboardService.GetCoins(player)
	local leaderstats = player:FindFirstChild(CoinConfig.LEADERBOARD_NAME)
	if not leaderstats then return 0 end
	
	local coins = leaderstats:FindFirstChild(CoinConfig.CURRENCY_NAME)
	if coins and coins:IsA("IntValue") then
		return coins.Value
	end
	return 0
end

function LeaderboardService.ResetCoins(player)
	local leaderstats = player:FindFirstChild(CoinConfig.LEADERBOARD_NAME)
	if not leaderstats then return end
	
	local coins = leaderstats:FindFirstChild(CoinConfig.CURRENCY_NAME)
	if coins and coins:IsA("IntValue") then
		coins.Value = 0
	end
end

return LeaderboardService
