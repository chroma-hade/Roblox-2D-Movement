local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Camera = workspace.CurrentCamera

local Player : Player = game:GetService("Players").LocalPlayer
local Character = Player.Character

local Controls = require(Player.PlayerScripts.PlayerModule):GetControls()

local RootPart : BasePart = Character:WaitForChild("HumanoidRootPart")
local Humanoid : Humanoid = Character:WaitForChild("Humanoid")

local Hold = {
	["W"] = false,
	["A"] = false,
	["S"] = false,
	["D"] = false,
}

local Bind = {
	["W"] = false,
	["A"] = false,
	["S"] = false,
	["D"] = false,
}

Controls:Disable()

local function OnInput(Input : InputObject)
	if Bind[Input.KeyCode.Name] ~= nil then
		for index, key in Hold do
			if Hold[index] ~= nil then
				if index ~= Input.KeyCode.Name then
					Hold[index] = false
				end
			end
		end
		Hold[Input.KeyCode.Name] = true
		Bind[Input.KeyCode.Name] = true
	end
end

local function OnEnded(Input : InputObject)
	if Bind[Input.KeyCode.Name] ~= nil then
		for index, key in Hold do
			if Hold[index] ~= nil then
				if index ~= Input.KeyCode.Name then
					Hold[index] = Bind[index]
				end
			end
		end
		Hold[Input.KeyCode.Name] = false
		Bind[Input.KeyCode.Name] = false
	end
end

local function OnRenderStep()
	local Vector = Vector3.new(0,0,0)
	if Hold["W"] == true then
		Vector += Vector3.new(0,0,-1)
	elseif Hold["S"] == true then
		Vector += Vector3.new(0,0,1)
	elseif Hold["A"] == true then
		Vector += Vector3.new(-1,0,0)
	elseif Hold["D"] == true then
		Vector += Vector3.new(1,0,0)
	end	
	if Vector ~= Vector3.new(0, 0, 0) then
		RootPart.CFrame = CFrame.new(RootPart.Position, RootPart.Position + Vector)
	end
	Humanoid:MoveTo(RootPart.Position + Vector)
	Camera.CFrame = CFrame.new(RootPart.Position) * CFrame.new(0,25,11) * CFrame.Angles(-math.rad(66), 0, 0)
end

UserInputService.InputBegan:Connect(OnInput)
UserInputService.InputEnded:Connect(OnEnded)
RunService.RenderStepped:Connect(OnRenderStep)
