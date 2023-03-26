-- Disabling player-to-player collisions

local PS = game:GetService("PhysicsService")
PS:CreateCollisionGroup("Player")
PS:CollisionGroupSetCollidable("Player","Player",false)
 
game.Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        Character:WaitForChild("HumanoidRootPart")
        Character:WaitForChild("Head")
        Character:WaitForChild("Humanoid")
        for i,v in pairs(Character:GetChildren()) do
            if v:IsA("BasePart") then
                PS:SetPartCollisionGroup(v,"Player")
            end
        end
    end)
end)