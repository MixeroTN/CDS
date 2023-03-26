local UIS = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local mobile
if not UIS.KeyboardEnabled and not GuiService:IsTenFootInterface() then
	mobile = true
end
if mobile then
	function enable(x)
		if x.Name == 'IntroGUI' then
			script.Parent.Enabled = true
		end
	end
	
	script.Parent.Parent.ChildRemoved:Connect(enable)
else
	script.Parent.Parent:WaitForChild("Events").DestroyMCN:Fire()
end