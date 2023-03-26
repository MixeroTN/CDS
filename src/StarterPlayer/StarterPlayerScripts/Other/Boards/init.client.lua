local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local pages = game:GetService("AssetService"):GetGamePlacesAsync()

local lbsg = workspace:WaitForChild('LocalBoard')
local front, left, right, back = lbsg.B3, lbsg.B4, lbsg.B2, lbsg.B1


local SGs = game:GetService("ReplicatedStorage"):WaitForChild("BSG")

repeat wait() until #SGs.Front:GetChildren() > 0
local cf = SGs.Front:Clone() cf.Parent = front
-- Code inside

repeat wait() until #SGs.Left:GetChildren() > 0
local cl = SGs.Left:Clone() cl.Parent = left

--[[repeat wait() until #SGs.Right:GetChildren() > 0
local cr = SGs.Right:Clone() cr.Parent = right

repeat wait() until #SGs.Back:GetChildren() > 0
local cb = SGs.Back:Clone() cb.Parent = back]]

local dr
workspace:WaitForChild("Direction").Event:Connect(function(x)
	dr = x
	print(dr)
end)

local placesids = {}
local placesnames = {}
local tc = script:WaitForChild('Place')

while wait() do
	for _, place in pairs(pages:GetCurrentPage()) do
		if place.Name ~= game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name then
			table.insert(placesids, place.PlaceId)
			table.insert(placesnames, place.Name)
		end
		print("Name: " .. place.Name)
		print("PlaceId: " .. tostring(place.PlaceId))
	end
	
	if pages.IsFinished then break end
	
	pages:AdvanceToNextPageAsync()
end

local fold = Instance.new("Folder", cl.Board.List) fold.Name = 'FW'

if #placesids == 0 then
	cl.Board.List.ZNoMorePlaces:Destroy()
	cl.Board.List.UIListLayout:Destroy()
	----
	cl.Board.List.ZNoPlaces.Parent = fold
else
	cl.Board.List.ZNoPlaces:Destroy()
	----
	cl.Board.List.ZNoMorePlaces.Parent = fold
	cl.Board.List.UIListLayout.Parent = fold
end

for i = 1, #placesids do
	local tcc = tc:Clone()
	tcc.Parent = cl.Board.List
	tcc.PlaceName.Text = placesnames[i]
	tcc.Play.PlaceId.Value = placesids[i]
	tcc.Name = 'Place' .. tostring(i)
end

for _, elm in pairs(fold:GetChildren()) do
	elm.Parent = cl.Board.List
end
fold:Destroy()

left.Left.Board.List.CanvasSize = UDim2.new(0, 0, 0, left.Left.Board.List.UIListLayout.AbsoluteContentSize.Y)

local gc, im
if game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('MobileCameraNavi') then
	im = 'Swipe to select | Double tap for details'
	left.Left.Board.Tip.Text = im
end
RS.Stepped:Connect(function()
	if left.Left.Board.List.ZNoMorePlaces.AbsolutePosition.Y > (left.Left.Board.List.AbsoluteWindowSize.Y + 12.5) and not gc then
		gc = true
		local prevt = left.Left.Board.Tip.Text 
		spawn(function()
			repeat
				TweenService:Create(left.Left.Board.Tip, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 1}):Play()
				wait(1)
				left.Left.Board.Tip.Text = 'More places below!'
				TweenService:Create(left.Left.Board.Tip, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 0}):Play()
				wait(1)
				TweenService:Create(left.Left.Board.Tip, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 1}):Play()
				wait(1)
				left.Left.Board.Tip.Text = im or prevt
				TweenService:Create(left.Left.Board.Tip, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {TextTransparency = 0}):Play()
				wait(1)
			until
			left.Left.Board.List.CanvasPosition.Y == (left.Left.Board.List.AbsoluteSize.Y - left.Left.Board.List.AbsoluteWindowSize.Y)
			gc = nil
		end)
	end
end)

local prev = dr
local prevf -- prev focused
local focused
--if not front.Front.FrontBoard.Arrows.Visible then -- if not mobile
	RS:BindToRenderStep('cursor', 100, function()
		if dr == 'B4' then -- B4 po raz pierwszy
			if not focused then
				focused = left.Left.Board.List:FindFirstChildOfClass('Frame') or left.Left.Board.List:WaitForChild('ZNoPlaces')
			end
			if focused:IsA('Frame') and not prevf or focused:IsA('Frame') and focused.Name ~= prevf.Name then
				focused.PlaceName.TextColor3 = Color3.fromRGB(255, 0, 255)
				focused.Play.Visible = true
			end
			if prevf and prevf.Name ~= focused.Name then
				prevf.PlaceName.TextColor3 = Color3.fromRGB(0, 0, 0)
				prevf.Play.Visible = false
			end
		elseif dr ~= 'B4' then -- dalej
			if prev == 'B4' then
				if focused:IsA('Frame') then
					focused.PlaceName.TextColor3 = Color3.fromRGB(0, 0, 0)
					focused.Play.Visible = false
				end
				focused.Parent.CanvasPosition = Vector2.new(0, 0)
				focused = nil
			end
		end
		prev = dr
		prevf = focused
	end)
--end

local xs, xr -- success, response // for pcalls
local tg

UIS.InputBegan:Connect(function(input)
	local k = input.KeyCode
	if dr == 'B4' and focused and focused:IsA('Frame') then -- left, Showcases
		if k == Enum.KeyCode.W then
			if focused.Parent:FindFirstChild('Place' .. tostring(tonumber(string.sub(focused.Name, 6)) - 1 )) then
				local prevfo = focused
				focused = focused.Parent:FindFirstChild('Place' .. tostring(tonumber(string.sub(focused.Name, 6)) - 1 ))
				if focused.AbsolutePosition.Y < (focused.Parent.AbsoluteWindowSize.Y + 25) + focused.Size.Y.Offset and focused.AbsolutePosition.Y < prevfo.AbsolutePosition.Y then
					focused.Parent.CanvasPosition = Vector2.new(focused.Parent.CanvasPosition.X, focused.Parent.CanvasPosition.Y - 50)
				end
			end
		elseif k == Enum.KeyCode.S then
			if focused.Parent:FindFirstChild('Place' .. tostring(tonumber(string.sub(focused.Name, 6)) + 1 )) then
				local prevfo = focused
				focused = focused.Parent:FindFirstChild('Place' .. tostring(tonumber(string.sub(focused.Name, 6)) + 1 ))
				if focused.AbsolutePosition.Y > (focused.Parent.AbsoluteWindowSize.Y + 25) - focused.Size.Y.Offset and focused.AbsolutePosition.Y > prevfo.AbsolutePosition.Y then
					focused.Parent.CanvasPosition = Vector2.new(focused.Parent.CanvasPosition.X, focused.Parent.CanvasPosition.Y + 50)
				end
			end
		elseif k == Enum.KeyCode.Space then
			if focused then
				local placeid = focused.Play.PlaceId.Value
				local fgi = game:GetService("MarketplaceService"):GetProductInfo(placeid)
				if not front:FindFirstChild('FrontGame') then
					front.Front.Enabled = false
				else
					front:FindFirstChild('FrontGame'):Destroy()
				end
				local fg = script:WaitForChild("FrontGame"):Clone()
				--fg.Board.Frame.ImageLabel.Image = game:GetService('Players'):GetUserThumbnailAsync(game.CreatorId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
				fg.Board.Frame.ImageLabel.Image = 'rbxassetid://4987332015'
				fg.Board.Frame.Holder.PlaceName.Text = fgi.Name
				fg.Board.Frame.Holder.PlaceDesc.Text = fgi.Description
				fg.Board.PlaceId.Value = placeid
				fg.Parent = front
				game:GetService("ContentProvider"):PreloadAsync({fg.Board.Frame.ImageLabel})
				workspace:WaitForChild("Move"):Fire('Right')
			end
		end
	elseif dr == 'B3' and front:FindFirstChild('FrontGame') and game:GetService("ReplicatedStorage"):FindFirstChild('TeleportUI') then
		if k == Enum.KeyCode.Space then
			print('tak')
			tg = game:GetService("ReplicatedStorage"):WaitForChild('TeleportUI')
			tg.Frame.Info.Text = 'Waiting for an available server...'
			tg.Parent = game.Players.LocalPlayer:WaitForChild('PlayerGui')
			TS:SetTeleportGui(tg)
			xs, xr = pcall(function()
				print('Teleport function')
				TS:Teleport(front:FindFirstChild('FrontGame').Board.PlaceId.Value)
			end)
			if not xs then
				warn('[PCALL ERROR]', xr)
			end
			--script.Disabled = true
		end
	end
end)

UIS.TouchSwipe:Connect(function(drc)
	if dr == 'B4' then -- left, Showcases
		if drc == Enum.SwipeDirection.Down then -- do góry
			if focused.Parent:FindFirstChild('Place' .. tostring(tonumber(string.sub(focused.Name, 6)) - 1 )) then
				local prevfo = focused
				focused = focused.Parent:FindFirstChild('Place' .. tostring(tonumber(string.sub(focused.Name, 6)) - 1 ))
				if focused.AbsolutePosition.Y < (focused.Parent.AbsoluteWindowSize.Y + 25) + focused.Size.Y.Offset and focused.AbsolutePosition.Y < prevfo.AbsolutePosition.Y then
					focused.Parent.CanvasPosition = Vector2.new(focused.Parent.CanvasPosition.X, focused.Parent.CanvasPosition.Y - 50)
				end
			end
		elseif drc == Enum.SwipeDirection.Up then -- na dół
			if focused.Parent:FindFirstChild('Place' .. tostring(tonumber(string.sub(focused.Name, 6)) + 1 )) then
				local prevfo = focused
				focused = focused.Parent:FindFirstChild('Place' .. tostring(tonumber(string.sub(focused.Name, 6)) + 1 ))
				if focused.AbsolutePosition.Y > (focused.Parent.AbsoluteWindowSize.Y + 25) - focused.Size.Y.Offset and focused.AbsolutePosition.Y > prevfo.AbsolutePosition.Y then
					focused.Parent.CanvasPosition = Vector2.new(focused.Parent.CanvasPosition.X, focused.Parent.CanvasPosition.Y + 50)
				end
			end
		end
	end
end)

local prev = tick()
UIS.TouchTap:Connect(function()
	if tick() - prev <= .5 then
		if dr == 'B4' and focused and focused:IsA('Frame') then
			if focused then
				local placeid = focused.Play.PlaceId.Value
				local fgi = game:GetService("MarketplaceService"):GetProductInfo(placeid)
				if not front:FindFirstChild('FrontGame') then
					front.Front.Enabled = false
				else
					front:FindFirstChild('FrontGame'):Destroy()
				end
				local fg = script:WaitForChild("FrontGame"):Clone()
				--fg.Board.Frame.ImageLabel.Image = game:GetService('Players'):GetUserThumbnailAsync(game.CreatorId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
				fg.Board.Frame.ImageLabel.Image = 'rbxassetid://4987332015'
				fg.Board.Frame.Holder.PlaceName.Text = fgi.Name
				fg.Board.Frame.Holder.PlaceDesc.Text = fgi.Description
				fg.Board.PlaceId.Value = placeid
				fg.Board.Tip.Text = 'Double tap to play'
				fg.Parent = front
				game:GetService("ContentProvider"):PreloadAsync({fg.Board.Frame.ImageLabel})
				workspace:WaitForChild("Move"):Fire('Right')
			end
		elseif dr == 'B3' and front:FindFirstChild('FrontGame') and game:GetService("ReplicatedStorage"):FindFirstChild('TeleportUI') then
			print('tak')
			local tg = game:GetService("ReplicatedStorage"):WaitForChild('TeleportUI')
			tg.Frame.Info.Text = 'Waiting for an available server...'
			tg.Parent = game.Players.LocalPlayer:WaitForChild('PlayerGui')
			TS:SetTeleportGui(tg)
			xs, xr = pcall(function()
				print('Teleport function')
				TS:Teleport(front:FindFirstChild('FrontGame').Board.PlaceId.Value)
			end)
			if not xs then
				warn('[PCALL ERROR]', xr)
			end
			--script.Disabled = true
		end
	else
		prev = tick()
	end
end)

--[[UIS.TouchTapInWorld:Connect(function(pos, pbUI)
	if pbUI then return end
	local wlist = {front, left, right, back}
	local unitRay = workspace.CurrentCamera:ViewportPointToRay(pos.X, pos.Y)
	local ray = Ray.new(unitRay.Origin, unitRay.Direction * 10.5)
	local hitPart, worldPos, is = workspace:FindPartOnRayWithWhitelist(ray, wlist)
	if hitPart and is then
		print(hitPart.Name, worldPos)
	end
end)]]

--[[UIS.TouchSwipe:Connect(function(drc)
	if dr == 'B4' then -- left, Showcases
		if drc == Enum.SwipeDirection.Down then -- do góry
			if left.Left.Board.List.CanvasPosition.Y > 0 then
				left.Left.Board.List.CanvasPosition = Vector2.new(left.Left.Board.List.CanvasPosition.X, left.Left.Board.List.CanvasPosition.Y - 25)
			end
		elseif drc == Enum.SwipeDirection.Up then -- na dół
			if left.Left.Board.List.CanvasPosition.Y < left.Left.Board.List.AbsoluteWindowSize.Y - left.Left.Board.List.CanvasPosition.Y then
				left.Left.Board.List.CanvasPosition = Vector2.new(left.Left.Board.List.CanvasPosition.X, left.Left.Board.List.CanvasPosition.Y + 25)
			end
		end
	end
end)]]