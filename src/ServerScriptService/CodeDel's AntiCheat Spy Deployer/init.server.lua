game.Players.PlayerAdded:Connect(function(p)
	local rs, spy, la, ch, oi, on, ww = require(game:GetService("ServerStorage"):WaitForChild('RandomString')), nil, tick(), 0, nil, false, nil
	local eb = game:GetService("ServerStorage"):WaitForChild("BAN")
	spy = script.LocalScript:Clone()
	spy.Name = tostring(rs.getRandomString(Random.new():NextNumber(20, 30), true))
	spy.Parent = p:WaitForChild('PlayerGui')
	

	local ec = Instance.new("RemoteEvent")
	ec.Name = 'acC'
	ec.Parent = game:GetService("ReplicatedStorage")

	ec.OnServerEvent:Connect(function(nad, wia) --print(nad, 'ok')
		on = true
		oi = tick()
		ww = wia
		if tick() - la <= .5 then
			ch = ch + 1 --print('ch', ch)
			if ch >= 10 then
				eb:Fire(nad, 'You has been kicked by exploiting')
			end
		else
			ch = 0 --print('ch', ch)
		end
		--print(nad.Name, spy.Name)
	end)

	
	local ichC = 0
	local function lch() --print('ich')
		for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do --game:GetService("ReplicatedStorage"):GetChildren()
			if v:IsA("RemoteEvent") and not string.find(v.Parent.Name, 'Default') then --print(v.Name)
				v.OnServerEvent:Connect(function(n, w) --print(n.Name, w)
					if tick() - oi >= 10 then
						ichC = ichC + 1
						if ichC >= 5 then
							eb:Fire(n, 'You has been permanently banned by exploiting')
						end
					else ichC = 0
					end
				end)
			end
		end
		for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do --game:GetService("ReplicatedStorage"):GetChildren()
			if v:IsA("RemoteEvent") then --print(v.Name)
				v.OnServerEvent:Connect(function(n, w) --print(n.Name, w)
					if tick() - oi >= 10 then
						ichC = ichC + 1
						if ichC >= 5 then
							eb:Fire(n, 'You has been permanently banned by exploiting')
						end
					else ichC = 0
					end
				end)
			end
		end
	end

	repeat wait() until on
	while on do wait(1) --print('checking')
		if not oi then
			oi = tick() --print('no oi')
		else
			if tick() - oi >= 10 then
				lch() wait(10)
			end
		end
	end
end)