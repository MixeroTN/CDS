-- Made by CodeDel

local Players = game:GetService("Players")

local function onCharacterRemoving(character)
	warn("[Character removed]: " .. character.Name .. " | Players.RespawnTime: " .. Players.RespawnTime)
end

local function onPlayerAdded(player)
	player.CharacterRemoving:Connect(onCharacterRemoving)
end
 
Players.PlayerAdded:Connect(onPlayerAdded)