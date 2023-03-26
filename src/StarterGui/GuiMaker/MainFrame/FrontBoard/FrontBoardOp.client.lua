local UIS = game:GetService("UserInputService")
local GS = game:GetService("GuiService")

script.Parent.Title.Text = 'Welcome ' .. game.Players.LocalPlayer.Name .. '!'

local mobile
if not UIS.KeyboardEnabled and not GS:IsTenFootInterface() then
	mobile = true
end

for _, v in pairs(script.Parent:GetChildren()) do
	if mobile then
		if string.find(v.Name, 'Arrows') then
			v.Visible = true
		end
	else
		if string.find(v.Name, 'Keys') then
			v.Visible = true
		end
	end
	if string.find(v.Name, 'LD') then
		v.Visible = false
	end
end

script.Parent.Parent = game:GetService("ReplicatedStorage").BSG.Front
script:Destroy()