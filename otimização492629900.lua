local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local optimizationActive = true
local totalOptimizations = 0
local lastLogTime = 0
local fps = 0
local frameCount = 0
local lastTime = tick()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OptimizerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Parent = screenGui
fpsLabel.BackgroundTransparency = 1
fpsLabel.Position = UDim2.new(0, 10, 0, 10)
fpsLabel.Size = UDim2.new(0, 300, 0, 50)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 18
fpsLabel.TextStrokeTransparency = 0
fpsLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

local function updateFPS()
    frameCount = frameCount + 1
    local currentTime = tick()
    
    if currentTime - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = currentTime
    end
end

local function animateRGB()
    local time = tick() * 2
    local r = math.sin(time) * 0.5 + 0.5
    local g = math.sin(time + 2) * 0.5 + 0.5
    local b = math.sin(time + 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

local function removePlayerClothing(targetPlayer)
    pcall(function()
        local character = targetPlayer.Character
        if character then
            for _, item in pairs(character:GetChildren()) do
                if item:IsA("Accessory") or 
                   item:IsA("Hat") or
                   item:IsA("Shirt") or
                   item:IsA("Pants") or
                   item:IsA("ShirtGraphic") then
                    item:Destroy()
                end
            end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            end
            
            local head = character:FindFirstChild("Head")
            if head then
                for _, item in pairs(head:GetChildren()) do
                    if item:IsA("Decal") or 
                       item:IsA("SpecialMesh") or
                       item:IsA("SurfaceGui") then
                        item:Destroy()
                    end
                end
                head.BrickColor = BrickColor.new("Light orange")
            end
            
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.SmoothPlastic
                    part.BrickColor = BrickColor.new("Light orange")
                end
            end
        end
    end)
end

local function optimizeLighting()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = math.huge
        Lighting.Brightness = 0
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ShadowSoftness = 0
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ClockTime = 12
        
        for _, effect in pairs(Lighting:GetChildren()) do
            if not effect:IsA("Folder") then
                effect:Destroy()
            end
        end
    end)
end

local function optimizeWorkspace()
    local removed = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("ParticleEmitter") or 
               obj:IsA("Trail") or 
               obj:IsA("Smoke") or 
               obj:IsA("Fire") or 
               obj:IsA("Sparkles") or
               obj:IsA("Beam") or
               obj:IsA("Explosion") or
               obj:IsA("SelectionBox") or
               obj:IsA("Handles") then
                obj:Destroy()
                removed = removed + 1
            elseif obj:IsA("Decal") or 
                   obj:IsA("Texture") or
                   obj:IsA("SurfaceGui") or
                   obj:IsA("BillboardGui") or
                   obj:IsA("ImageLabel") or
                   obj:IsA("ImageButton") then
                obj:Destroy()
                removed = removed + 1
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.TopSurface = Enum.SurfaceType.Smooth
                obj.BottomSurface = Enum.SurfaceType.Smooth
                obj.FrontSurface = Enum.SurfaceType.Smooth
                obj.BackSurface = Enum.SurfaceType.Smooth
                obj.LeftSurface = Enum.SurfaceType.Smooth
                obj.RightSurface = Enum.SurfaceType.Smooth
                
                if obj:IsA("MeshPart") then
                    obj.TextureID = ""
                end
            elseif obj:IsA("SpecialMesh") then
                obj.TextureId = ""
            elseif obj:IsA("Sound") then
                if not obj.IsPlaying then
                    obj.Volume = 0
                end
            elseif obj:IsA("PointLight") or 
                   obj:IsA("SpotLight") or 
                   obj:IsA("SurfaceLight") then
                obj:Destroy()
                removed = removed + 1
            end
        end)
    end
    
    return removed
end

local function optimizeTerrain()
    pcall(function()
        if Workspace:FindFirstChild("Terrain") then
            local terrain = Workspace.Terrain
            terrain.WaterWaveSize = 0
            terrain.WaterTransparency = 1
            terrain.WaterReflectance = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterColor = Color3.new(0, 0, 0)
            terrain.Decorations = false
        end
    end)
end

local function cleanupMemory()
    pcall(function()
        game:GetService("Debris"):ClearAllChildren()
        collectgarbage("collect")
    end)
end

local function optimizeAllPlayers()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        removePlayerClothing(targetPlayer)
    end
end

Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function()
        wait(1)
        removePlayerClothing(newPlayer)
    end)
end)

for _, existingPlayer in pairs(Players:GetPlayers()) do
    if existingPlayer.Character then
        removePlayerClothing(existingPlayer)
    end
    existingPlayer.CharacterAdded:Connect(function()
        wait(1)
        removePlayerClothing(existingPlayer)
    end)
end

Workspace.DescendantAdded:Connect(function(obj)
    if not optimizationActive then return end
    
    spawn(function()
        wait(0.05)
        pcall(function()
            if obj:IsA("ParticleEmitter") or 
               obj:IsA("Trail") or 
               obj:IsA("Smoke") or 
               obj:IsA("Fire") or 
               obj:IsA("Sparkles") or
               obj:IsA("Beam") then
                obj:Destroy()
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        end)
    end)
end)

local function startOptimization()
    optimizeLighting()
    local removed = optimizeWorkspace()
    optimizeTerrain()
    optimizeAllPlayers()
    cleanupMemory()
    
    totalOptimizations = totalOptimizations + removed
    
    local currentTime = tick()
    if currentTime - lastLogTime >= 10 then
        print("Otimização: " .. removed .. " objetos removidos | Total: " .. totalOptimizations)
        lastLogTime = currentTime
    end
end

RunService.RenderStepped:Connect(function()
    updateFPS()
    
    fpsLabel.TextColor3 = animateRGB()
    fpsLabel.Text = string.format("FPS: %d | Player: %s | Otimizado: %d", fps, player.Name, totalOptimizations)
    
    if optimizationActive then
        for _, obj in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("ParticleEmitter") or 
                   obj:IsA("Trail") or 
                   obj:IsA("Smoke") or 
                   obj:IsA("Fire") or 
                   obj:IsA("Sparkles") then
                    obj:Destroy()
                    totalOptimizations = totalOptimizations + 1
                end
            end)
        end
    end
end)

spawn(function()
    while optimizationActive do
        startOptimization()
        wait(3)
    end
end)

startOptimization()
print("Otimização ativada com sucesso")
