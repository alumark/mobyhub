local localPlayer = game.Players.LocalPlayer

local function WorldToViewportPoint(part)
    local screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
    return Vector2.new(screen.x, screen.y)
end

local size = 20

local box = Instance.new("Part")
box.Anchored = true
box.CanCollide = false
box.Size = Vector3.new(3, 4, 3)
box.Transparency = 1
box.Parent = workspace

local surfaces = {Enum.NormalId.Front, Enum.NormalId.Bottom, Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right, Enum.NormalId.Top}
for _, surface in ipairs(surfaces) do
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.AlwaysOnTop = true
    surfaceGui.Face = surface
    surfaceGui.Parent = box

    local p1 = Instance.new("Frame")
    p1.Size = UDim2.new(UDim.new(0, size), UDim.new(1, 0))
    p1.BorderSizePixel = 0
    p1.BackgroundColor3 = Color3.new(1, 1, 1)
    p1.Parent = surfaceGui
    
    local p2 = Instance.new("Frame")
    p2.Size = UDim2.new(UDim.new(1, 0), UDim.new(0, size))
    p2.BorderSizePixel = 0
    p2.BackgroundColor3 = Color3.new(1, 1, 1)
    p2.Parent = surfaceGui

    local p3 = Instance.new("Frame")
    p3.AnchorPoint = Vector2.new(0, 1)
    p3.Size = UDim2.new(UDim.new(0, size), UDim.new(1, 0))
    p3.BorderSizePixel = 0
    p3.BackgroundColor3 = Color3.new(1, 1, 1)
    p3.Parent = surfaceGui
    
    local p4 = Instance.new("Frame")
    p4.AnchorPoint = Vector2.new(1, 0)
    p4.Size = UDim2.new(UDim.new(1, 0), UDim.new(0, size))
    p4.BorderSizePixel = 0
    p4.BackgroundColor3 = Color3.new(1, 1, 1)
    p4.Parent = surfaceGui
end

function ESPText(part, color)
    local name = Drawing.new("Text")
    name.Text = part.Parent.Name
    name.Color = color
    name.Position = WorldToViewportPoint(part) + Vector2.new(0, 5)
    name.Size = 20
    name.Outline = true
    name.Center = true
    name.Visible = true

    local newBox = box:Clone()
    newBox.Parent = workspace

    local conn
    conn = game:GetService("RunService").Stepped:Connect(function()
        if part or not part.Parent then
            newBox:Destroy()
            name:Remove()
            conn:Disconnect()
        end

        if part and part.Parent then
            name.Position = WorldToViewportPoint(part)
            local cframe, _ = part.Parent:GetBoundingBox()
            newBox.CFrame = cframe
            
            local _, screen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
            if screen then
                name.Visible = true
            else
                name.Visible = false
            end
        end
    end)
end


local function playerAdded(player)
    local function characterAdded(character)
        local humanoidRootPart = character:WaitForChild("Head")
        ESPText(humanoidRootPart, Color3.new(player.TeamColor.r, player.TeamColor.g, player.TeamColor.b))
    end

    player.CharacterAdded:Connect(characterAdded)

    if player.Character then
        characterAdded(player.Character)
    end
end

for _, player in ipairs(game.Players:GetPlayers()) do
    if player ~= localPlayer then
        playerAdded(player)
    end
end

game.Players.ChildAdded:Connect(playerAdded)