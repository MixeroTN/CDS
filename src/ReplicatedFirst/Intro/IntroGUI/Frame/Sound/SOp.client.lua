while wait() do
	repeat wait() until script.Parent.IsPaused
	script.Parent.TimePosition = 13.1
	script.Parent:Play()
	print('sr')
end