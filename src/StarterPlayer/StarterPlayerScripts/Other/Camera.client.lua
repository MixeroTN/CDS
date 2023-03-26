--!nocheck
local CAS = game:GetService("ContextActionService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = game.Players.LocalPlayer
local char = player.Character
if not char or not char.Parent then
    char = player.CharacterAdded:wait()
end

local Camera = workspace.CurrentCamera
Camera.CameraType = Enum.CameraType.Scriptable

local p = Instance.new("Part", workspace)
p.Name = 'campart'
p.Size = Vector3.new(1, 1, 1)
p.Anchored = true
p.CanCollide = false
p.Transparency = 1
p.Position = workspace.Baseplate.Position + Vector3.new(0, 5, 0) --char:WaitForChild('Head').Position
char:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(0, 100, 0)

Camera.CameraSubject = p
Camera.CFrame = p.CFrame
Camera.CameraType = Enum.CameraType.Scriptable -- after setting CameraSubject it's reset so again
Camera.FieldOfView = 50
RunService:BindToRenderStep("CameraF", Enum.RenderPriority.Camera.Value, function() Camera.Focus = Camera.CFrame end)
--Camera.Focus = char:WaitForChild('Head').CFrame

	local f = Instance.new("Folder")
	f.Parent = workspace
	f.Name = 'Emitters'
	for i = 1, 360/6 do
		local Point = p.CFrame
		local Offset = CFrame.new(Random.new():NextNumber(15, 25), Random.new():NextNumber(-25, 25), Random.new():NextNumber(10, 15))
		local Object = game:GetService("ReplicatedStorage"):WaitForChild('Emitter'):Clone()
		Object.Parent = f
		Object.CFrame = Point * CFrame.Angles(0, math.rad(Random.new():NextNumber(0, 360)), 0) * Offset
		local h
		pcall(function()
			h = Object:FindFirstChildOfClass('ParticleEmitter')
		end)
		if not h then
			warn('pcall-br', Object.Name, 'h', h)
			break
		end
		h.Acceleration = Vector3.new(Random.new():NextNumber(-.1, .1), 0, 0)
		spawn(function()
			while wait() do
				h:Emit(1)
				wait(100)
			end
		end)
	end

local f = Instance.new("Folder")
f.Parent = workspace
f.Name = 'LocalBoard'
for i = 0, 3 do
	local Point = p.CFrame
	local Offset = CFrame.new(0, 0, 10)
	local Object = game:GetService("ReplicatedStorage"):WaitForChild('Board'):Clone()
	Object.Name = tostring('B' .. i + 1)
	Object.Parent = f
	Object.CFrame = Point * CFrame.Angles(0, math.rad(i*90), 0) * Offset
	Object.SurfaceGui.TextLabel.Text = tostring(i + 1)
	
	script:WaitForChild("CFrameChanged").Changed:Connect(function()
		local Facing = Camera.CFrame.LookVector
		local Vector = (Object.Position - Camera.CFrame.Position).Unit
		local Angle = math.acos(Facing:Dot(Vector))
		
		if Angle == 0 then
			workspace:WaitForChild("Direction"):Fire(Object.Name)
		end
	end)
end

function enable(x)
	if x.Name == 'IntroGUI' then
		TweenService:Create(game.Lighting.White, TweenInfo.new(.7, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {Brightness = 0}):Play()
	end
end
game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui').ChildRemoved:Connect(enable)

local k = Enum.KeyCode

local function Left()
	return UIS:IsKeyDown(k.Q)
end

local function Right()
	return UIS:IsKeyDown(k.E)
end

local function getClosestValue(values, closestTo, fetchCount)
	table.sort(values, function(a, b)
		return math.abs(closestTo - a) < math.abs(closestTo - b)
	end)
	return unpack(values, 1, fetchCount)
end

local v, c, f
local dirv, tdt
local can = true
function move(pp) --math.rad(90) (niedokładne)
	if can and game:GetService("ReplicatedStorage"):FindFirstChild('TeleportUI')
		and not game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('IntroGUI') then
		if Left() or Right() or pp == 'Left' or pp == 'Right' then
			can = false
			local w = workspace.campart.CFrame
			local data
			-- if Left() or Right() then
			if Left() or pp == 'Left' then
				data = math.pi/2
			elseif Right() or pp == 'Right' then
				data = -math.pi/2
			end
			for i = 0,1,.02 do
				Camera.CFrame = workspace.campart.CFrame:Lerp(workspace.campart.CFrame * CFrame.Angles(0, data, 0), i)
				game:GetService('RunService').RenderStepped:Wait()
			end
			-- repairing an inaccurate orientation
			workspace.campart.CFrame = Camera.CFrame
			workspace.campart.Position = workspace.Baseplate.Position + Vector3.new(0, 5, 0)
			local cf = Camera.CFrame - Camera.CFrame.Position
			local xx, yy, zz = cf:ToEulerAnglesYXZ()
			v = {0, 90, 180, 270, -90, -180, -270}
			c = math.deg(yy)
			f = 1
			workspace.campart.Rotation = Vector3.new(0, getClosestValue(v, c, f), 0)
			print(c, getClosestValue(v, c, f), data, workspace.campart.Rotation)
			Camera.CFrame = workspace.campart.CFrame
			script:WaitForChild("CFrameChanged").Value = c
			can = true
		end
	end
end

UIS.InputBegan:Connect(move)

local mcn
pcall(function()
	mcn = game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('MobileCameraNavi')
end)
if mcn then
	spawn(function()
		repeat wait()
			pcall(function()
				mcn = game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('MobileCameraNavi')
			end)
			if not mcn then break end
		until mcn.Enabled
		
		if mcn then
			for _, gc in pairs(mcn.Frame:GetChildren()) do
				if gc:IsA('ImageButton') then
					gc.Activated:Connect(function()
						move(gc.Name)
					end)
				end
			end
		end
	end)
end

workspace:WaitForChild("Move").Event:Connect(function(x) move(x) end)

Camera:GetPropertyChangedSignal('CameraType'):Connect(function()
	game:GetService("ReplicatedStorage"):WaitForChild("ErrorKicker"):FireServer("Banned for exploiting")
end)