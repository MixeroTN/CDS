local mps = game:GetService("MarketplaceService")
local rf = game:GetService("ReplicatedStorage"):WaitForChild("gamepassChecker")

local function returnPassInfo(player, actual, passid)
	if mps:UserOwnsGamePassAsync(actual.UserId, passid) then
		return true
	else
		return false
	end
end
 
rf.OnServerInvoke = returnPassInfo