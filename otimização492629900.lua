local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variáveis de controle
local optimizationActive = true
local totalOptimizations = 0
local lastLogTime = 0
local fps = 0
local frameCount = 0
local lastTime = tick()

-- Criar GUI
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

-- Função para calcular FPS
local function updateFPS()
    frameCount = frameCount + 1
    local currentTime = tick()
    
    if currentTime - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = currentTime
    end
end

-- Função para animar cor RGB
local function animateRGB()
    local time = tick() * 2
    local r = math.sin(time) * 0.5 + 0.5
    local g = math.sin(time + 2) * 0.5 + 0.5
    local b = math.sin(time + 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

-- Função para otimizar lighting
local function optimizeLighting()
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
end

-- Função para otimizar workspace
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

-- Função para otimizar terreno
local function optimizeTerrain()
    if Workspace:FindFirstChild("Terrain") then
        local terrain = Workspace.Terrain
        terrain.WaterWaveSize = 0
        terrain.WaterTransparency = 1
        terrain.WaterReflectance = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterColor = Color3.new(0, 0, 0)
        
        pcall(function()
            terrain.Decorations = false
        end)
    end
end

-- Função para limpar memória
local function cleanupMemory()
    pcall(function()
        game:GetService("Debris"):ClearAllChildren()
    end)
    
    collectgarbage("collect")
end

-- Monitorar novos objetos
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

-- Sistema principal
local function startOptimization()
    optimizeLighting()
    local removed = optimizeWorkspace()
    optimizeTerrain()
    cleanupMemory()
    
    totalOptimizations = totalOptimizations + removed
    
    local currentTime = tick()
    if currentTime - lastLogTime >= 10 then
        print("Otimização: " .. removed .. " objetos removidos | Total: " .. totalOptimizations)
        lastLogTime = currentTime
    end
end

-- Atualizar GUI
RunService.RenderStepped:Connect(function()
    updateFPS()
    
    -- Atualizar texto com cor RGB
    fpsLabel.TextColor3 = animateRGB()
    fpsLabel.Text = string.format("FPS: %d | Player: %s | Otimizado: %d", fps, player.Name, totalOptimizations)
    
    -- Otimização contínua sem spam
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

-- Otimização periódica
spawn(function()
    while optimizationActive do
        startOptimization()
        wait(3)
    end
end)

-- Inicialização
startOptimization()
print("Otimização ativada com sucesso")
