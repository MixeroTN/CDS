local PL = game:GetService("Players")
local TS = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")

local TIMEE, IDLE = 5*60, false -- at least 160, to no-instantly at least ~350 (5*60)

UIS.InputBegan:Connect(function()
	if IDLE then
		IDLE = false
		print('INPUT')
	end
end)

PL.LocalPlayer.Idled:Connect(function(tim)
	if IDLE then return end
	print('Player is idle for ' .. tim .. 'seconds')
	IDLE = true
	local startedAt = tick()
	while IDLE do
		wait(10)
		print((TIMEE - tim), '<=', tick() - startedAt, (TIMEE - tim) <= tick() - startedAt)
		if (TIMEE - tim) <= tick() - startedAt then
			print('Time to teleport!')
			IDLE = false
			local tg = game:GetService("ReplicatedStorage"):WaitForChild('TeleportUI')
			tg.Frame.Info.Text = 'Teleporting to avoid AFK KICK...'
			tg.Parent = game.Players.LocalPlayer:WaitForChild('PlayerGui')
			TS:SetTeleportGui(tg)
			local xs, xr = pcall(function()
				print('Teleport function')
				TS:Teleport(4902715737)
			end)
			if not xs then
				warn('[PCALL ERROR]', xr)
				--IDLE = true
			end
		end
	end
end)