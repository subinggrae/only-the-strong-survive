--!strict

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CoinConfig = require(Shared:WaitForChild("CoinConfig"))

local function animateCoin(coin)
	if not coin:IsA("BasePart") then return end
	
	local initialY = coin.Position.Y
	local connection
	
	connection = RunService.RenderStepped:Connect(function()
		if not coin or not coin.Parent then
			if connection then connection:Disconnect() end
			return
		end
		
		local time = tick()
		local rotation = time * CoinConfig.ROTATION_SPEED * 50 -- Speed adjustment
		local yOffset = math.sin(time * CoinConfig.FLOAT_FREQUENCY) * CoinConfig.FLOAT_AMPLITUDE
		
		coin.CFrame = CFrame.new(coin.Position.X, initialY + yOffset, coin.Position.Z) 
			* CFrame.Angles(0, math.rad(rotation), 0)
	end)
end

local function onCoinAdded(coin)
	task.spawn(function()
		animateCoin(coin)
	end)
end

CollectionService:GetInstanceAddedSignal(CoinConfig.COIN_TAG):Connect(onCoinAdded)

for _, coin in pairs(CollectionService:GetTagged(CoinConfig.COIN_TAG)) do
	onCoinAdded(coin)
end
