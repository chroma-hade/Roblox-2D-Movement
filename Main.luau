local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera

local Player : Player = game:GetService("Players").LocalPlayer
local Character = Player.Character

local Controls = require(Player.PlayerScripts.PlayerModule):GetControls()

local RootPart : BasePart = Character:WaitForChild("HumanoidRootPart")
local Humanoid : Humanoid = Character:WaitForChild("Humanoid")

local CameraOffset = CFrame.new(0,25,11) * CFrame.Angles(-math.rad(66), 0, 0)

local Keys = {
	["W"] = {
		["Vector3"] = Vector3.new(0, 0, -1),
	},
	["A"] = {
		["Vector3"] = Vector3.new(-1, 0, 0),
	},
	["S"] = {
		["Vector3"] = Vector3.new(0, 0, 1),
	},
	["D"] = {
		["Vector3"] = Vector3.new(1, 0, 0),
	},
}

Controls:Disable()

local function SetupKeyValue()
	for Key, Value : {} in Keys do
		Value["Hold"] = false
		Value["Bind"] = false
	end
end

local function ResetOthers(KeyName : string)
	for Key : string, Value : {} in Keys do
		if Key ~= KeyName then
			Keys[Key]["Hold"] = false
		end
	end
end

local function OnInput(Input : InputObject)
	if Keys[Input.KeyCode.Name] ~= nil then
		Keys[Input.KeyCode.Name]["Hold"] = true
		Keys[Input.KeyCode.Name]["Bind"] = true
		ResetOthers(Input.KeyCode.Name)
	end
end

local function OnEnded(Input : InputObject)
	if Keys[Input.KeyCode.Name] ~= nil then
		for Key : string, Value : {} in Keys do
			if Key ~= Input.KeyCode.Name then
				Keys[Key]["Hold"] = Keys[Key]["Bind"]
			end
		end
		Keys[Input.KeyCode.Name]["Hold"] = false
		Keys[Input.KeyCode.Name]["Bind"] = false
	end
end

local function OnRenderStep()
	local Vector = Vector3.new(0,0,0)
	for Key : string, Value : {} in Keys do
		if Value["Hold"] == true then
			Vector += Value["Vector3"]
			break
		end
	end
	if Vector ~= Vector3.new(0, 0, 0) then
		RootPart.CFrame = CFrame.new(RootPart.Position, RootPart.Position + Vector)
	end
	Camera.CFrame = CFrame.new(RootPart.Position) * CameraOffset
	Humanoid:MoveTo(RootPart.Position + Vector)	
end

SetupKeyValue()

UserInputService.InputBegan:Connect(OnInput)
UserInputService.InputEnded:Connect(OnEnded)
RunService.RenderStepped:Connect(OnRenderStep)
