local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local optimizationActive = true
local objectsRemoved = 0
local texturesRemoved = 0

local function optimizeLighting()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = math.huge
    Lighting.Brightness = 0
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    Lighting.ShadowSoftness = 0
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or 
           effect:IsA("SunRaysEffect") or 
           effect:IsA("ColorCorrectionEffect") or 
           effect:IsA("BloomEffect") or 
           effect:IsA("DepthOfFieldEffect") or
           effect:IsA("Atmosphere") or
           effect:IsA("Sky") or
           effect:IsA("Clouds") then
            effect:Destroy()
        end
    end
end

local function optimizeWorkspace()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or 
           obj:IsA("Trail") or 
           obj:IsA("Smoke") or 
           obj:IsA("Fire") or 
           obj:IsA("Sparkles") or
           obj:IsA("Beam") or
           obj:IsA("Explosion") then
            obj:Destroy()
            objectsRemoved = objectsRemoved + 1
            print("Efeito removido: " .. obj.ClassName)
        elseif obj:IsA("Decal") or 
               obj:IsA("Texture") or
               obj:IsA("SurfaceGui") or
               obj:IsA("BillboardGui") or
               obj:IsA("ImageLabel") or
               obj:IsA("ImageButton") then
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            else
                obj.Visible = false
            end
            texturesRemoved = texturesRemoved + 1
            print("Textura removida: " .. obj.ClassName)
        elseif obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.TopSurface = Enum.SurfaceType.Smooth
            obj.BottomSurface = Enum.SurfaceType.Smooth
            if obj:IsA("MeshPart") then
                obj.TextureID = ""
            end
        elseif obj:IsA("SpecialMesh") then
            obj.TextureId = ""
        elseif obj:IsA("Sound") then
            if not obj.IsLoaded then
                obj.Volume = 0
            end
        elseif obj:IsA("Motor6D") or obj:IsA("Motor") then
            obj:Destroy()
        end
    end
end

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
        
        pcall(function()
            terrain:FillBall(Vector3.new(0, 0, 0), 1, Enum.Material.Air)
        end)
    end
end

local function cleanupMemory()
    game:GetService("Debris"):ClearAllChildren()
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Script") and obj.Disabled then
            obj:Destroy()
        end
    end
end

local function monitorNewObjects()
    Workspace.DescendantAdded:Connect(function(obj)
        if not optimizationActive then return end
        
        wait(0.1)
        
        if obj:IsA("ParticleEmitter") or 
           obj:IsA("Trail") or 
           obj:IsA("Smoke") or 
           obj:IsA("Fire") or 
           obj:IsA("Sparkles") or
           obj:IsA("Beam") then
            obj:Destroy()
            objectsRemoved = objectsRemoved + 1
            print("Novo efeito bloqueado: " .. obj.ClassName)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
            texturesRemoved = texturesRemoved + 1
            print("Nova textura bloqueada: " .. obj.ClassName)
        elseif obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        end
    end)
end

local function startOptimization()
    optimizeLighting()
    optimizeWorkspace()
    optimizeTerrain()
    cleanupMemory()
    
    RunService.Heartbeat:Connect(function()
        if optimizationActive then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or 
                   obj:IsA("Trail") or 
                   obj:IsA("Smoke") or 
                   obj:IsA("Fire") or 
                   obj:IsA("Sparkles") then
                    obj:Destroy()
                    objectsRemoved = objectsRemoved + 1
                    print("Efeito eliminado em tempo real")
                end
            end
        end
    end)
end

monitorNewObjects()
startOptimization()

print("Otimização ativada com sucesso")
