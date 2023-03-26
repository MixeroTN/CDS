local pg = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
local rtime = 10
local tui, tifCan

local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local mobile
if not UIS.KeyboardEnabled and not GuiService:IsTenFootInterface() then
	mobile = true
end

if game:GetService("RunService"):IsStudio() then
	pg.ChildAdded:Connect(function(x)
		if x.Name == 'TeleportUI' then
			tui = pg:WaitForChild('TeleportUI')
			tui.Frame.Info.Text = '!!ROBLOX STUDIO TEST!!'
			wait(1)
			tifCan = true
		end
	end)
end

game:GetService("TeleportService").TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
	tui = pg:WaitForChild('TeleportUI')
	if mobile then
		tui.Frame.Info.Text = 'Teleport failed - ' .. tostring(errorMessage) .. ' (' .. tostring(rtime) .. ') | Double tap to return'
	else
		tui.Frame.Info.Text = 'Teleport failed - ' .. tostring(errorMessage) .. ' (' .. tostring(rtime) .. ') | Press space to return'
	end
	spawn(function()
		wait(1)
		tifCan = true
	end)
	if game:GetService("ReplicatedStorage"):FindFirstChild('TeleportUI') then return end
	for i = 1, rtime + 1 do
		wait(1)
		if game:GetService("ReplicatedStorage"):FindFirstChild('TeleportUI') then return end
		if mobile then
			tui.Frame.Info.Text = 'Teleport failed - ' .. tostring(errorMessage) .. ' (' .. tostring((rtime + 1) - i) .. ') | Double tap to return'
		else
			tui.Frame.Info.Text = 'Teleport failed - ' .. tostring(errorMessage) .. ' (' .. tostring((rtime + 1) - i) .. ') | Press space to return'
		end
	end
	wait(1)
	tui.Frame.Info.Text = 'Retrying to teleport...'
	if game:GetService("ReplicatedStorage"):FindFirstChild('TeleportUI') then return end
	game:GetService('TeleportService'):Teleport(workspace:WaitForChild('LocalBoard').B3:FindFirstChild('FrontGame').Board.PlaceId.Value)
end)

function doit()
	if tifCan then
		tifCan = nil
		tui.Parent = game:GetService("ReplicatedStorage")
	end
end

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space then
		doit()
	end
end)

local prev = tick()
UIS.TouchTap:Connect(function()
	if tick() - prev <= .5 then
		doit()
	else
		prev = tick()
	end
end)