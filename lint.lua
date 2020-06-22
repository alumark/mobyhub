

local mt = getrawmetatable(game)
local mt_index = mt.__index

setreadonly(mt, false)

mt.__index = function(instance, index, value)
    if not checkcaller() then
        if instance:IsA("Mouse") then
            if index == "Target" then
                local closestCharacter, closestDistance = nil, math.huge
                for _, currentPlayer in ipairs(game.Players:GetPlayers()) do
                    if currentPlayer ~= game.Players.LocalPlayer then
                        local character = currentPlayer.Character
                        if character then
                            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                            if humanoid and humanoid.Health > 0 then
                                local distance = currentPlayer.DistanceFromCharacter(currentPlayer, value.Position)
                                if distance < closestDistance then
                                    closestCharacter, closestDistance = character, distance
                                end
                            end
                        end
                    end
                end
            
                if closestCharacter then
                    value = closestCharacter.Head
                end
            end
        end
        
        if index == "Hit" then
            local closestCharacter, closestDistance = nil, math.huge
            for _, currentPlayer in ipairs(game.Players:GetPlayers()) do
                if currentPlayer ~= game.Players.LocalPlayer then
                    local character = currentPlayer.Character
                    if character then
                        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local distance = currentPlayer.DistanceFromCharacter(currentPlayer, value)
                            if distance < closestDistance then
                                closestCharacter, closestDistance = character, distance
                            end
                        end
                    end
                end
            end
        
            if closestCharacter then
                value = closestCharacter.Head.CFrame
            end
        end
    end
    
    
    return mt_index(instance, index, value)
end