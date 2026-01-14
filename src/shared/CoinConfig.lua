--!strict

local CoinConfig = {
	-- Coin Settings
	ROTATION_SPEED = 2,
	FLOAT_AMPLITUDE = 0.5,
	FLOAT_FREQUENCY = 3,
	DROP_LIFETIME = 60, -- Seconds before dropped coins disappear
	COIN_TAG = "Coin",
	
	-- Leaderboard Settings
	LEADERBOARD_NAME = "leaderstats",
	CURRENCY_NAME = "Coins",
	
	-- Spawning Settings
	RAY_HEIGHT = 500,
	SPAWN_INTERVAL = 3,
	
	SPAWN_AREAS = {
		{name = "Area_A", minX = -167, maxX = 33, minZ = -133, maxZ = 67, maxCoins = 100},
		{name = "Area_B", minX = 100, maxX = 300, minZ = 100, maxZ = 300, maxCoins = 50}
	},
}

return CoinConfig
