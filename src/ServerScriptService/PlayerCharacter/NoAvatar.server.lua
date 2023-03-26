game:GetService("Players").PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		local h = workspace:WaitForChild(plr.Name):WaitForChild('Head')
		repeat wait() until h
		for _,v in pairs(h.Parent:GetDescendants()) do
			if v:IsA('MeshPart') or v:IsA('Part') and not v.Name == 'Emitter' then
				v.Transparency = 1
			elseif v:IsA('SpecialMesh') or v:IsA('Decal') then
				v:Destroy()
			end
		end
	end)
end)