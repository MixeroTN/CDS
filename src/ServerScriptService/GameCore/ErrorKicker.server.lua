local DataStore2 = require(game.ServerStorage:WaitForChild('DataStore2'))
DataStore2.Combine("tv1", "ban") --cd status: v0 b, v1 u

local ev = game:GetService("ReplicatedStorage"):WaitForChild("ErrorKicker")
local eb = game:GetService("ServerStorage"):WaitForChild("BAN")

local function doit(player, info)
	local ban = DataStore2("ban", player)
	local p = tostring(player)
	if string.find(info, 'Ban') then
		ban:Increment(1) wait()
	end
	game:GetService("Players"):FindFirstChild(p):Kick(info)
end

ev.OnServerEvent:Connect(doit)
eb.Event:Connect(doit)

game.Players.PlayerAdded:Connect(function(p)
	local ban = DataStore2("ban", p)
	if ban:Get(0) ~= 0 then
		p:Kick("Banned for exploiting")
	end
	local h = game.Workspace:WaitForChild(p.Name):WaitForChild("Humanoid")
	print('e')
	h:GetPropertyChangedSignal('Health'):Connect(function()
		ban:Increment(1) wait()
		p:Kick("Banned for exploiting")
	end)
end)