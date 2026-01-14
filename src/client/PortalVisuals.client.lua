--!strict

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local PortalConfig = require(Shared:WaitForChild("PortalConfig"))

local function animatePortal(portal)
	local root = portal
	if portal:IsA("Model") then
		root = portal.PrimaryPart or portal:FindFirstChildWhichIsA("BasePart")
	end
	
	if not root then return end
	
	local initialY = root.Position.Y
	local connection
	
	connection = RunService.RenderStepped:Connect(function()
		if not portal or not portal.Parent then
			if connection then connection:Disconnect() end
			return
		end
		
		local time = tick()
		local rotation = time * PortalConfig.VISUALS.ROTATION_SPEED * 50
		local yOffset = math.sin(time * PortalConfig.VISUALS.FLOAT_FREQUENCY) * PortalConfig.VISUALS.FLOAT_AMPLITUDE
		
		local newCFrame = CFrame.new(root.Position.X, initialY + yOffset, root.Position.Z) 
			* CFrame.Angles(0, math.rad(rotation), 0)
			
		if portal:IsA("Model") then
			portal:SetPrimaryPartCFrame(newCFrame)
		else
			root.CFrame = newCFrame
		end
	end)
end

local function onPortalAdded(portal)
	task.spawn(function()
		animatePortal(portal)
	end)
end

CollectionService:GetInstanceAddedSignal(PortalConfig.PORTAL_TAG):Connect(onPortalAdded)

for _, portal in pairs(CollectionService:GetTagged(PortalConfig.PORTAL_TAG)) do
	onPortalAdded(portal)
end
