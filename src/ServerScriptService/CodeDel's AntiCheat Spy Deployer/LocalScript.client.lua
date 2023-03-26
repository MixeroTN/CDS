local Heartbeat = game:GetService("RunService").Heartbeat

local LastIteration, Start
local FrameUpdateTable = { }
local chance = 0
local CurrentFPS

local function HeartbeatUpdate()
	LastIteration = tick()
	for Index = #FrameUpdateTable, 1, -1 do
		FrameUpdateTable[Index + 1] = (FrameUpdateTable[Index] >= LastIteration - 1) and FrameUpdateTable[Index] or nil
	end

	FrameUpdateTable[1] = LastIteration
	CurrentFPS = (tick() - Start >= 1 and #FrameUpdateTable) or (#FrameUpdateTable / (tick() - Start))
	CurrentFPS = math.floor(CurrentFPS) --print(CurrentFPS)
	if CurrentFPS >= 70 then
		chance = chance + 1
		if chance >= 60 then
			game:GetService("ReplicatedStorage"):WaitForChild("ErrorKicker"):FireServer("Kicked for using a FPS Unlocker tool. This game must run on 60 fps.")
		end
	else
		chance = 0
	end
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end
Start = tick()
game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui').ChildRemoved:Connect(function(x)
	if x.Name == 'IntroGUI' then
		Heartbeat:Connect(HeartbeatUpdate)
	end
end)

pcall(function()
	local acC, c = game:GetService("ReplicatedStorage"):WaitForChild('acC'), 0
	Heartbeat:Connect(function()
		c += 1
		if c >= 60 then
			c = 0
			acC:FireServer(CurrentFPS)
		end
	end)
end)
