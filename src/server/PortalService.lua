--!strict

local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local PortalConfig = require(Shared:WaitForChild("PortalConfig"))

local PortalService = {}
local debounceTable = {}

local function GetPortalTemplate()
	local template = ServerStorage:FindFirstChild("Portal")
	if not template then
		warn("Portal template not found in ServerStorage!")
		return nil
	end
	return template
end

local function GetLobbyPosition()
	local lobby = Workspace:FindFirstChild(PortalConfig.LOBBY_PORTAL_NAME)
	if not lobby then return nil end
	
	local rayOrigin = lobby.Position + Vector3.new(0, 100, 0)
	local result = Workspace:Raycast(rayOrigin, Vector3.new(0, -200, 0))
	
	if result then
		return result.Position + Vector3.new(0, 3, 0)
	else
		return lobby.Position + Vector3.new(0, 5, 0)
	end
end

local function HandleTeleport(player, portalInstance)
	if not player or not player.Character then return end
	if debounceTable[player] then return end
	
	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local targetPos = GetLobbyPosition()
	if not targetPos then
		warn("LobbyPortal not found!")
		return
	end
	
	debounceTable[player] = true
	
	-- Teleport
	hrp.CFrame = CFrame.new(targetPos)
	print("Teleported " .. player.Name .. " to Lobby")
	
	-- Destroy Portal
	if portalInstance.Parent then
		if portalInstance:IsA("Model") then
			portalInstance:Destroy()
		else
			portalInstance:Destroy()
		end
	end
	
	-- Reset Debounce
	task.delay(PortalConfig.TELEPORT_DEBOUNCE, function()
		debounceTable[player] = nil
	end)
end

local function SetupPortalTouch(portal)
	if portal:GetAttribute("TouchConnected") then return end
	portal:SetAttribute("TouchConnected", true)
	
	-- If it's a model, find the PrimaryPart or a part named "TouchPart" or just the first part
	local touchPart = portal
	if portal:IsA("Model") then
		touchPart = portal.PrimaryPart or portal:FindFirstChildWhichIsA("BasePart")
	end
	
	if not touchPart then return end
	
	touchPart.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)
		if player then
			HandleTeleport(player, portal)
		end
	end)
end

function PortalService.SpawnPortal(position, parentFolder)
	local template = GetPortalTemplate()
	if not template then return end
	
	local newPortal = template:Clone()
	newPortal.Parent = parentFolder
	
	if newPortal:IsA("Model") then
		newPortal:SetPrimaryPartCFrame(CFrame.new(position + Vector3.new(0, 5, 0)))
	else
		newPortal.Position = position + Vector3.new(0, 5, 0)
		newPortal.Anchored = true
		newPortal.CanCollide = false
	end
	
	CollectionService:AddTag(newPortal, PortalConfig.PORTAL_TAG)
	SetupPortalTouch(newPortal)
	
	Debris:AddItem(newPortal, PortalConfig.PORTAL_LIFETIME)
end

function PortalService.StartAutoSpawner()
	for _, area in pairs(PortalConfig.AREAS) do
		task.spawn(function()
			local folderName = area.name .. "_Portals"
			local folder = Workspace:FindFirstChild(folderName)
			if not folder then
				folder = Instance.new("Folder")
				folder.Name = folderName
				folder.Parent = Workspace
			end
			
			while true do
				task.wait(area.interval)
				
				if #folder:GetChildren() < area.maxPortals then
					local randomX = math.random(area.minX, area.maxX)
					local randomZ = math.random(area.minZ, area.maxZ)
					local origin = Vector3.new(randomX, area.rayHeight, randomZ)
					
					local params = RaycastParams.new()
					params.FilterType = Enum.RaycastFilterType.Exclude
					params.FilterDescendantsInstances = {folder, Players:GetPlayers()}
					
					local result = Workspace:Raycast(origin, Vector3.new(0, -1000, 0), params)
					if result then
						PortalService.SpawnPortal(result.Position, folder)
					end
				end
			end
		end)
	end
end

return PortalService
