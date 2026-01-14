--!strict

local PortalConfig = {
	PORTAL_TAG = "Portal",
	LOBBY_PORTAL_NAME = "LobbyPortal",
	
	TELEPORT_DEBOUNCE = 1,
	PORTAL_LIFETIME = 60,
	SPAWN_INTERVAL = 5, -- Global check interval
	
	VISUALS = {
		ROTATION_SPEED = 1,
		FLOAT_AMPLITUDE = 0.5,
		FLOAT_FREQUENCY = 2,
	},
	
	AREAS = {
		{
			name = "Area_A",
			minX = -167, maxX = 33,
			minZ = -133, maxZ = 67,
			maxPortals = 3,
			interval = 30,
			rayHeight = 500
		},
		{
			name = "Area_B",
			minX = 100, maxX = 300,
			minZ = 100, maxZ = 300,
			maxPortals = 3,
			interval = 45,
			rayHeight = 500
		},
		{
			name = "Area_C",
			minX = -300, maxX = -100,
			minZ = -300, maxZ = -100,
			maxPortals = 3,
			interval = 60,
			rayHeight = 500
		}
	}
}

return PortalConfig
