-- !nocheck
-- Made by CodeDel // Version 3.0 --
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()

-- / Main config and indexes /
local GuiService = game:GetService('GuiService')
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService('RunService')
local StarterGui = game:GetService('StarterGui')
local Class = nil

local SCTable = {
    {C = StarterGui},
    -- Set to false when using PreloadIntro, to show Topbar after intro set TopbarEnabled BoolValue as true
	{N = 'TopbarEnabled', V = false},
    {N = 'PointsNotificationsActive', V = false},
    {N = 'BadgesNotificationsActive', V = true},
    {N = 'ChatBarDisabled', V = true},
    {N = 'AvatarContextMenuEnabled', V = false},
    {N = 'ResetButtonCallback', V = false},
	{C = GuiService},
    {N = 'SetInspectMenuEnabled', V = false}
}

-- // Preload //
--[[task.defer(function()
	local s, e = pcall(function()
		game:GetService('ContentProvider'):PreloadAsync(game:GetService('ReplicatedStorage'))
	end)
end)]]

--[[local s, e = pcall(function()
	game:GetService('ContentProvider'):PreloadAsync(game:GetService('PlayerGui'))
end)]]

-- / CoreCalls /
local coreCall do
    local MAX_RETRIES = 100

    function coreCall(method, ...)
        local result = {}
        print(method, ...)
        for retries = 1, MAX_RETRIES do
            if method then
                result = {pcall(Class[method], ...)}
            end
            if result[1] then
                print('coreCall', method, {...}, 'passed')
                break
            else
                print('coreCall', method, {...}, 'failed')
            end
            RunService.Stepped:Wait()
        end
        return unpack(result)
    end
end

--[[for i, v in pairs(SCTable) do
	print(i, v)
end]]

for i, v in pairs(SCTable) do
    if v.C then
        Class = v.C
        print(Class)
    else
        if Class == StarterGui then
            coreCall('SetCore', Class, SCTable[i].N, SCTable[i].V)
        else
            coreCall(SCTable[i].N, Class, SCTable[i].V)
        end
    end
end

if not game:GetService("RunService"):IsStudio() or script.Parent.Intro.LaunchInStudio.Value then
    repeat
        game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("IntroGUI").Event:Fire()
        task.wait(1)
    until not game.Players.LocalPlayer.PlayerGui:FindFirstChild("IntroGUI")
end

-- game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,false)

--script:Destroy()
