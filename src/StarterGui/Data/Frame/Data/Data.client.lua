local GId = tostring(game.GameId)
local PId = tostring(game.PlaceId)
local PVer = tostring(game.PlaceVersion)
repeat wait() until not game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('IntroGUI')
script.Parent.Text = "GId: " .. GId ..  " | PId: " .. PId .. " | PVer: " .. PVer
game:GetService('TweenService'):Create(script.Parent, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 0}):Play()
wait(2)
script:Destroy()