--!strict

local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local MusicConfig = require(Shared:WaitForChild("MusicConfig"))

local MusicController = {}

function MusicController:Init()
	local sound = Instance.new("Sound")
	sound.Name = "BackgroundMusic"
	sound.SoundId = MusicConfig.BGM_ID
	sound.Volume = 0 -- Start at 0 for fade in
	sound.Looped = MusicConfig.LOOPED
	sound.Parent = SoundService
	
	sound:Play()
	
	-- Fade In Effect
	local tweenInfo = TweenInfo.new(MusicConfig.FADE_IN_TIME, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(sound, tweenInfo, {Volume = MusicConfig.VOLUME})
	tween:Play()
	
	print("Music Controller: Started BGM")
end

MusicController:Init()

return MusicController
