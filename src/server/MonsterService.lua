--!strict
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local MonsterConfig = require(Shared:WaitForChild("MonsterConfig"))

local MonsterService = {}

-- Folder to organize monsters
local monsterFolder = Workspace:FindFirstChild("Monsters") or Instance.new("Folder", Workspace)
monsterFolder.Name = "Monsters"

function MonsterService.GetRandomPosition()
	local min = MonsterConfig.SPAWN_AREA.MIN
	local max = MonsterConfig.SPAWN_AREA.MAX
	
	local x = math.random(min.X, max.X)
	local z = math.random(min.Z, max.Z)
	
	-- Raycast from high up to find the terrain/floor
	local rayOrigin = Vector3.new(x, 100, z)
	local rayDirection = Vector3.new(0, -200, 0)
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {monsterFolder} -- Ignore other monsters
	
	local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if rayResult then
		-- Found ground: Spawn 3 studs above it
		return rayResult.Position + Vector3.new(0, 3, 0)
	else
		-- No ground found (void): Fallback to default height
		return Vector3.new(x, 5, z)
	end
end

function MonsterService.SpawnGoblin()
	-- Wait briefly for template
	local template = ServerStorage:WaitForChild("Goblin", 5)
	if not template then
		warn("Goblin template not found in ServerStorage!")
		return
	end

	local goblin = template:Clone()
	
	-- 0. Validate Critical Parts (Root)
	local root = goblin:FindFirstChild("HumanoidRootPart")
	if not root then
		warn("CRITICAL: Custom Goblin model is missing 'HumanoidRootPart'. Cannot spawn.")
		goblin:Destroy()
		return
	end
	
	-- Ensure PrimaryPart is set
	goblin.PrimaryPart = root
	
	-- 1. Enforce safety (Unanchor parts)
	local weldCount = 0
	for _, desc in ipairs(goblin:GetDescendants()) do
		if desc:IsA("BasePart") then
			desc.Anchored = false
		elseif desc:IsA("Weld") or desc:IsA("Motor6D") or desc:IsA("WeldConstraint") then
			weldCount = weldCount + 1
		end
	end
	
	if weldCount == 0 then
		warn("WARNING: Goblin model has NO welds/joints! It will fall apart.")
	end
	
	-- 2. Position
	local startPos = MonsterService.GetRandomPosition()
	goblin:SetPrimaryPartCFrame(CFrame.new(startPos))
	
	goblin.Parent = monsterFolder
	
	-- 3. Setup Humanoid
	local humanoid = goblin:WaitForChild("Humanoid")
	-- Enforce HipHeight if it's too low (prevents sinking/tripping)
	if humanoid.HipHeight < 1.5 then
		humanoid.HipHeight = 3
		print("Forced HipHeight to 3 on Goblin")
	end
	
	-- 4. Animation
	local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
	local walkAnim = Instance.new("Animation")
	walkAnim.AnimationId = MonsterConfig.WALK_ANIM_ID
	
	-- Load animation but don't play immediately
	local walkTrack = animator:LoadAnimation(walkAnim)
	walkTrack.Looped = true
	
	humanoid.Running:Connect(function(speed)
		if speed > 0.1 then
			if not walkTrack.IsPlaying then walkTrack:Play() end
		else
			if walkTrack.IsPlaying then walkTrack:Stop(0.2) end
		end
	end)
	
	-- 5. Start AI
	task.spawn(function()
		MonsterService.PatrolLoop(goblin, startPos)
	end)
	
	-- 6. Cleanup on Death
	humanoid.Died:Connect(function()
		task.wait(2) -- Wait for death animation
		goblin:Destroy()
	end)
end

function MonsterService.PatrolLoop(goblin, spawnOrigin)
	local humanoid = goblin:FindFirstChild("Humanoid")
	local root = goblin:FindFirstChild("HumanoidRootPart")
	
	if not humanoid or not root then return end
	
	humanoid.WalkSpeed = MonsterConfig.WALK_SPEED

	while goblin.Parent do
		if humanoid.Health <= 0 then break end
		
		-- Pick a random point within radius of the SPAWN position (tethered wandering)
		local center = spawnOrigin
		
		local rx = math.random(-MonsterConfig.PATROL_RADIUS, MonsterConfig.PATROL_RADIUS)
		local rz = math.random(-MonsterConfig.PATROL_RADIUS, MonsterConfig.PATROL_RADIUS)
		local target = center + Vector3.new(rx, 0, rz)
		
		humanoid:MoveTo(target)
		
		-- Wait until reached or stuck (timeout 8s)
		local reached = humanoid.MoveToFinished:Wait()
		
		if not reached then
			task.wait(0.5) -- Unstuck pause
		end
		
		task.wait(math.random(1, 3)) -- Idle for 1-3 seconds
	end
end

function MonsterService.StartSpawner()
	task.spawn(function()
		while true do
			local currentMonsters = monsterFolder:GetChildren()
			if #currentMonsters < MonsterConfig.MAX_COUNT then
				-- Wrap in pcall to prevent one bad spawn from killing the whole loop
				local success, err = pcall(function()
					MonsterService.SpawnGoblin()
				end)
				
				if not success then
					warn("Failed to spawn Goblin: " .. tostring(err))
				end
			end
			task.wait(MonsterConfig.SPAWN_INTERVAL)
		end
	end)
end

function MonsterService.Start()
	print("Monster Service Started")
	MonsterService.StartSpawner()
end

return MonsterService
