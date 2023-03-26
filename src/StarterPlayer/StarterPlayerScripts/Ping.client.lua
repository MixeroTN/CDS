while true do
	wait(5)
	game:GetService("ReplicatedStorage"):WaitForChild('Ping'):FireServer(tick())
end