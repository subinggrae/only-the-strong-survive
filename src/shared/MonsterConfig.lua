--!strict
local MonsterConfig = {
	NAME = "Goblin",
	HEALTH = 100,
	WALK_SPEED = 16,
	
	-- Spawner Configuration
	MAX_COUNT = 10,
	SPAWN_INTERVAL = 5, -- Check every 5 seconds
	
	-- Spawn Area (Box) centered at x=6, z=15
	SPAWN_AREA = {
		MIN = Vector3.new(-14, -50, -5), -- (6-20), Y, (15-20)
		MAX = Vector3.new(26, 50, 35),   -- (6+20), Y, (15+20)
	},
	
	-- Patrol Configuration
	PATROL_RADIUS = 30, -- Wander within this radius of current position
	
	-- Replace with your own Animation ID
	WALK_ANIM_ID = "rbxassetid://507777826", -- Generic R15 Walk as placeholder
}

return MonsterConfig
