local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

local Window = Luna:CreateWindow({
    Name = "EcoHub - Otimização Blox Fruit",
    Subtitle = nil,
    LogoID = "82795327169782", 
    LoadingEnabled = false, 
    LoadingTitle = "Luna Interface Suite", 
    LoadingSubtitle = "by Nebula Softworks",

    ConfigSettings = {
        RootFolder = nil, 
        ConfigFolder = "Eco Hub" 
    },
})

--Otimização Sea 1
local otimizacaosea1Tab = Window:CreateTab({
    Name = "Blox Fruit",
    Icon = "waves",
    ImageSource = "Material",
    ShowTitle = true
})

--Status
local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Status: Otimização Funcionando",
    Style = 2
})

local Paragraph = otimizacaosea1Tab:CreateParagraph({
    Title = "Gerenciador SEA 1 - Otimização",
    Text = [[
Bem-vindo ao Gerenciador SEA 1.  
Este painel foi desenvolvido para otimizar suas ações de forma prática e eficiente, permitindo que você tenha controle completo sobre os recursos e funcionalidades disponíveis.  

Através deste sistema, você poderá monitorar, organizar e gerenciar suas operações de maneira simplificada, garantindo uma experiência mais rápida e intuitiva.
]]
})

--Categoria Traveç
local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Travel Indisponivel",
    Style = 3
})

--Categoria Status


--Categoria WorkSpace
local Paragraph = otimizacaosea1Tab:CreateParagraph({
    Title = "Gerenciador WorkSpace - Blox Fruits",
    Text = "Acompanhe as informações do mapa em tempo real, incluindo as ilhas disponíveis e a quantidade de jogadores em cada uma. Um painel organizado para visualização clara da WorkSpace no Blox Fruits."
})

local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Status: Funcionando WorkSpace",
    Style = 2
})

--Remover NPCs
local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Otimizar NPCs (New)",
    Description = "Remove texturas, animações e nomes dos NPCs automaticamente",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local function optimizeNPC(npc)
                for _, item in ipairs(npc:GetDescendants()) do
                    if item:IsA("Decal") or item:IsA("Texture") or 
                       item:IsA("Shirt") or item:IsA("Pants") or 
                       item:IsA("ShirtGraphic") or item:IsA("SurfaceGui") or
                       item:IsA("BillboardGui") or item:IsA("TextLabel") or
                       item:IsA("TextButton") or item:IsA("ImageLabel") then
                        item:Destroy()
                    end
                    
                    if item:IsA("Animator") or item:IsA("AnimationController") then
                        item:Destroy()
                    end
                    
                    if item:IsA("Humanoid") then
                        for _, track in ipairs(item:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                        item.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        item.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                        item.NameDisplayDistance = 0
                        item.HealthDisplayDistance = 0
                        item.PlatformStand = true
                        item.PlatformStand = false
                    end
                end
                
                if npc:FindFirstChild("Head") then
                    local head = npc.Head
                    for _, gui in ipairs(head:GetChildren()) do
                        if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
                            gui:Destroy()
                        end
                    end
                end
            end
            
            local npcFolder = workspace:FindFirstChild("NPCs")
            if npcFolder and npcFolder:IsA("Folder") then
                for _, npc in ipairs(npcFolder:GetChildren()) do
                    optimizeNPC(npc)
                end
                print("[EcoHub] NPCs existentes otimizados!")
                
                _G.NPCConnection = npcFolder.ChildAdded:Connect(function(newNPC)
                    wait(0.1)
                    optimizeNPC(newNPC)
                    print("[EcoHub] Novo NPC otimizado")
                end)
                
                _G.NPCDescendantConnection = npcFolder.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("Decal") or descendant:IsA("Texture") or 
                       descendant:IsA("Shirt") or descendant:IsA("Pants") or 
                       descendant:IsA("ShirtGraphic") or descendant:IsA("SurfaceGui") or
                       descendant:IsA("Animator") or descendant:IsA("AnimationController") or
                       descendant:IsA("BillboardGui") or descendant:IsA("TextLabel") then
                        descendant:Destroy()
                    end
                end)
                
            else
                print("[EcoHub] Pasta NPCs não encontrada")
            end
        else
            if _G.NPCConnection then
                _G.NPCConnection:Disconnect()
                _G.NPCConnection = nil
            end
            if _G.NPCDescendantConnection then
                _G.NPCDescendantConnection:Disconnect()
                _G.NPCDescendantConnection = nil
            end
            print("[EcoHub] Otimização desativada")
        end
    end
})

--SeaBeasts
local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Otimizar SeaBeasts (New)",
    Description = "Remove texturas, animações e nomes dos SeaBeasts automaticamente",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local function optimizeSeaBeast(seabeast)
                for _, item in ipairs(seabeast:GetDescendants()) do
                    if item:IsA("Decal") or item:IsA("Texture") or 
                       item:IsA("Shirt") or item:IsA("Pants") or 
                       item:IsA("ShirtGraphic") or item:IsA("SurfaceGui") or
                       item:IsA("BillboardGui") or item:IsA("TextLabel") or
                       item:IsA("TextButton") or item:IsA("ImageLabel") then
                        item:Destroy()
                    end
                    
                    if item:IsA("Animator") or item:IsA("AnimationController") then
                        item:Destroy()
                    end
                    
                    if item:IsA("Humanoid") then
                        for _, track in ipairs(item:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                        item.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        item.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                        item.NameDisplayDistance = 0
                        item.HealthDisplayDistance = 0
                        item.PlatformStand = true
                        item.PlatformStand = false
                    end
                end
                
                if seabeast:FindFirstChild("Head") then
                    local head = seabeast.Head
                    for _, gui in ipairs(head:GetChildren()) do
                        if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
                            gui:Destroy()
                        end
                    end
                end
            end
            
            local seabeastFolder = workspace:FindFirstChild("SeaBeasts")
            if seabeastFolder and seabeastFolder:IsA("Folder") then
                for _, seabeast in ipairs(seabeastFolder:GetChildren()) do
                    optimizeSeaBeast(seabeast)
                end
                print("[EcoHub] SeaBeasts existentes otimizados!")
                
                _G.SeaBeastConnection = seabeastFolder.ChildAdded:Connect(function(newSeaBeast)
                    wait(0.1)
                    optimizeSeaBeast(newSeaBeast)
                    print("[EcoHub] Novo SeaBeast otimizado")
                end)
                
                _G.SeaBeastDescendantConnection = seabeastFolder.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("Decal") or descendant:IsA("Texture") or 
                       descendant:IsA("Shirt") or descendant:IsA("Pants") or 
                       descendant:IsA("ShirtGraphic") or descendant:IsA("SurfaceGui") or
                       descendant:IsA("Animator") or descendant:IsA("AnimationController") or
                       descendant:IsA("BillboardGui") or descendant:IsA("TextLabel") then
                        descendant:Destroy()
                    end
                end)
                
            else
                print("[EcoHub] Pasta SeaBeasts não encontrada")
            end
        else
            if _G.SeaBeastConnection then
                _G.SeaBeastConnection:Disconnect()
                _G.SeaBeastConnection = nil
            end
            if _G.SeaBeastDescendantConnection then
                _G.SeaBeastDescendantConnection:Disconnect()
                _G.SeaBeastDescendantConnection = nil
            end
            print("[EcoHub] Otimização SeaBeasts desativada")
        end
    end
})

--SesEvents
local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Otimizar SeaEvents (New)",
    Description = "Remove texturas, animações e nomes dos SeaEvents automaticamente",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local function optimizeSeaEvent(seaevent)
                for _, item in ipairs(seaevent:GetDescendants()) do
                    if item:IsA("Decal") or item:IsA("Texture") or 
                       item:IsA("Shirt") or item:IsA("Pants") or 
                       item:IsA("ShirtGraphic") or item:IsA("SurfaceGui") or
                       item:IsA("BillboardGui") or item:IsA("TextLabel") or
                       item:IsA("TextButton") or item:IsA("ImageLabel") then
                        item:Destroy()
                    end
                    
                    if item:IsA("Animator") or item:IsA("AnimationController") then
                        item:Destroy()
                    end
                    
                    if item:IsA("Humanoid") then
                        for _, track in ipairs(item:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                        item.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        item.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                        item.NameDisplayDistance = 0
                        item.HealthDisplayDistance = 0
                        item.PlatformStand = true
                        item.PlatformStand = false
                    end
                end
                
                if seaevent:FindFirstChild("Head") then
                    local head = seaevent.Head
                    for _, gui in ipairs(head:GetChildren()) do
                        if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
                            gui:Destroy()
                        end
                    end
                end
            end
            
            local seaeventFolder = workspace:FindFirstChild("SeaEvents")
            if seaeventFolder and seaeventFolder:IsA("Folder") then
                for _, seaevent in ipairs(seaeventFolder:GetChildren()) do
                    optimizeSeaEvent(seaevent)
                end
                print("[EcoHub] SeaEvents existentes otimizados!")
                
                _G.SeaEventConnection = seaeventFolder.ChildAdded:Connect(function(newSeaEvent)
                    wait(0.1)
                    optimizeSeaEvent(newSeaEvent)
                    print("[EcoHub] Novo SeaEvent otimizado")
                end)
                
                _G.SeaEventDescendantConnection = seaeventFolder.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("Decal") or descendant:IsA("Texture") or 
                       descendant:IsA("Shirt") or descendant:IsA("Pants") or 
                       descendant:IsA("ShirtGraphic") or descendant:IsA("SurfaceGui") or
                       descendant:IsA("Animator") or descendant:IsA("AnimationController") or
                       descendant:IsA("BillboardGui") or descendant:IsA("TextLabel") then
                        descendant:Destroy()
                    end
                end)
                
            else
                print("[EcoHub] Pasta SeaEvents não encontrada")
            end
        else
            if _G.SeaEventConnection then
                _G.SeaEventConnection:Disconnect()
                _G.SeaEventConnection = nil
            end
            if _G.SeaEventDescendantConnection then
                _G.SeaEventDescendantConnection:Disconnect()
                _G.SeaEventDescendantConnection = nil
            end
            print("[EcoHub] Otimização SeaEvents desativada")
        end
    end
})

--Map
local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Otimizar Map (New)",
    Description = "Remove texturas, animações e efeitos do mapa automaticamente",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local function optimizeObject(obj)
                if obj:IsA("Folder") or obj:IsA("Model") then
                    for _, child in ipairs(obj:GetDescendants()) do
                        if child:IsA("Decal") or child:IsA("Texture") or 
                           child:IsA("SurfaceGui") or child:IsA("BillboardGui") or
                           child:IsA("TextLabel") or child:IsA("ImageLabel") or
                           child:IsA("ParticleEmitter") or child:IsA("Fire") or
                           child:IsA("Smoke") or child:IsA("Explosion") or
                           child:IsA("Beam") or child:IsA("Trail") or
                           child:IsA("Sparkles") or child:IsA("SpecialMesh") then
                            child:Destroy()
                        end
                        
                        if child:IsA("Animator") or child:IsA("AnimationController") then
                            child:Destroy()
                        end
                        
                        if child:IsA("Sound") or child:IsA("SoundGroup") then
                            child:Destroy()
                        end
                        
                        if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then
                            child.Material = Enum.Material.Plastic
                            child.Reflectance = 0
                            child.Transparency = 0
                            if child:FindFirstChild("Mesh") then
                                child.Mesh:Destroy()
                            end
                            for _, surface in ipairs(child:GetChildren()) do
                                if surface:IsA("SurfaceGui") or surface:IsA("Decal") or surface:IsA("Texture") then
                                    surface:Destroy()
                                end
                            end
                        end
                    end
                elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    obj.Transparency = 0
                    if obj:FindFirstChild("Mesh") then
                        obj.Mesh:Destroy()
                    end
                    for _, surface in ipairs(obj:GetChildren()) do
                        if surface:IsA("SurfaceGui") or surface:IsA("Decal") or surface:IsA("Texture") or
                           surface:IsA("ParticleEmitter") or surface:IsA("Fire") or surface:IsA("Smoke") then
                            surface:Destroy()
                        end
                    end
                end
            end
            
            local mapFolder = workspace:FindFirstChild("Map")
            if mapFolder then
                for _, mapObject in ipairs(mapFolder:GetChildren()) do
                    optimizeObject(mapObject)
                end
                print("[EcoHub] Mapa existente otimizado!")
                
                _G.MapConnection = mapFolder.ChildAdded:Connect(function(newMapObject)
                    wait(0.1)
                    optimizeObject(newMapObject)
                    print("[EcoHub] Novo objeto do mapa otimizado")
                end)
                
                _G.MapDescendantConnection = mapFolder.DescendantAdded:Connect(function(descendant)
                    if descendant:IsA("Decal") or descendant:IsA("Texture") or 
                       descendant:IsA("SurfaceGui") or descendant:IsA("BillboardGui") or
                       descendant:IsA("ParticleEmitter") or descendant:IsA("Fire") or
                       descendant:IsA("Smoke") or descendant:IsA("Beam") or
                       descendant:IsA("Trail") or descendant:IsA("Sparkles") or
                       descendant:IsA("SpecialMesh") or descendant:IsA("Sound") or
                       descendant:IsA("Animator") or descendant:IsA("AnimationController") then
                        descendant:Destroy()
                    end
                end)
                
            else
                print("[EcoHub] Pasta Map não encontrada")
            end
        else
            if _G.MapConnection then
                _G.MapConnection:Disconnect()
                _G.MapConnection = nil
            end
            if _G.MapDescendantConnection then
                _G.MapDescendantConnection:Disconnect()
                _G.MapDescendantConnection = nil
            end
            print("[EcoHub] Otimização Map desativada")
        end
    end
})

--SlappingMinigameFolder e ActiveFishingSpots e Enemies e _WorldOrigin e Characters e SpawnedlItems e BauModels
local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Otimizar (SlappingMinigameFolder e ActiveFishingSpots e Enemies e _WorldOrigin e Characters e SpawnedItems e BauModels) (New)",
    Description = nil,
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local function optimizeObject(obj)
                if obj:IsA("Folder") or obj:IsA("Model") then
                    for _, child in ipairs(obj:GetDescendants()) do
                        if child:IsA("Decal") or child:IsA("Texture") or 
                           child:IsA("SurfaceGui") or child:IsA("BillboardGui") or
                           child:IsA("TextLabel") or child:IsA("ImageLabel") or
                           child:IsA("ParticleEmitter") or child:IsA("Fire") or
                           child:IsA("Smoke") or child:IsA("Explosion") or
                           child:IsA("Beam") or child:IsA("Trail") or
                           child:IsA("Sparkles") or child:IsA("SpecialMesh") or
                           child:IsA("Shirt") or child:IsA("Pants") or
                           child:IsA("ShirtGraphic") or child:IsA("TextButton") then
                            child:Destroy()
                        end
                        
                        if child:IsA("Animator") or child:IsA("AnimationController") then
                            child:Destroy()
                        end
                        
                        if child:IsA("Sound") or child:IsA("SoundGroup") then
                            child:Destroy()
                        end
                        
                        if child:IsA("Humanoid") then
                            for _, track in ipairs(child:GetPlayingAnimationTracks()) do
                                track:Stop()
                            end
                            child.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                            child.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                            child.NameDisplayDistance = 0
                            child.HealthDisplayDistance = 0
                            child.PlatformStand = true
                            child.PlatformStand = false
                        end
                        
                        if child:IsA("Part") or child:IsA("MeshPart") or child:IsA("UnionOperation") then
                            child.Material = Enum.Material.Plastic
                            child.Reflectance = 0
                            if child:FindFirstChild("Mesh") then
                                child.Mesh:Destroy()
                            end
                        end
                    end
                elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
                    obj.Material = Enum.Material.Plastic
                    obj.Reflectance = 0
                    if obj:FindFirstChild("Mesh") then
                        obj.Mesh:Destroy()
                    end
                    for _, surface in ipairs(obj:GetChildren()) do
                        if surface:IsA("SurfaceGui") or surface:IsA("Decal") or surface:IsA("Texture") or
                           surface:IsA("ParticleEmitter") or surface:IsA("Fire") or surface:IsA("Smoke") then
                            surface:Destroy()
                        end
                    end
                end
            end
            
            local folders = {
                "SlappingMinigameFolder",
                "ActiveFishingSpots", 
                "Enemies",
                "_WorldOrigin",
                "Characters",
                "SpawnedItems",
                "BauModels"
            }
            
            _G.AllConnections = {}
            _G.AllDescendantConnections = {}
            
            for i, folderName in ipairs(folders) do
                local folder = workspace:FindFirstChild(folderName)
                if folder then
                    for _, obj in ipairs(folder:GetChildren()) do
                        optimizeObject(obj)
                    end
                    print("[EcoHub] " .. folderName .. " otimizado!")
                    
                    _G.AllConnections[i] = folder.ChildAdded:Connect(function(newObj)
                        wait(0.1)
                        optimizeObject(newObj)
                        print("[EcoHub] Novo objeto em " .. folderName .. " otimizado")
                    end)
                    
                    _G.AllDescendantConnections[i] = folder.DescendantAdded:Connect(function(descendant)
                        if descendant:IsA("Decal") or descendant:IsA("Texture") or 
                           descendant:IsA("SurfaceGui") or descendant:IsA("BillboardGui") or
                           descendant:IsA("ParticleEmitter") or descendant:IsA("Fire") or
                           descendant:IsA("Smoke") or descendant:IsA("Beam") or
                           descendant:IsA("Trail") or descendant:IsA("Sparkles") or
                           descendant:IsA("SpecialMesh") or descendant:IsA("Sound") or
                           descendant:IsA("Animator") or descendant:IsA("AnimationController") or
                           descendant:IsA("Shirt") or descendant:IsA("Pants") then
                            descendant:Destroy()
                        end
                    end)
                else
                    print("[EcoHub] Pasta " .. folderName .. " não encontrada")
                end
            end
        else
            if _G.AllConnections then
                for _, connection in pairs(_G.AllConnections) do
                    connection:Disconnect()
                end
                _G.AllConnections = nil
            end
            if _G.AllDescendantConnections then
                for _, connection in pairs(_G.AllDescendantConnections) do
                    connection:Disconnect()
                end
                _G.AllDescendantConnections = nil
            end
            print("[EcoHub] Otimização de todas as pastas desativada")
        end
    end
})
