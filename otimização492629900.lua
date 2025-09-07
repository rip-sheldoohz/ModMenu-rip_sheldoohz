local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local optimizationActive = true
local totalOptimizations = 0
local lastLogTime = 0
local processedObjects = {}

-- Configurações de performance
local BATCH_SIZE = 50 -- Processa apenas 50 objetos por frame
local OPTIMIZATION_INTERVAL = 5 -- Executa otimização principal a cada 5 segundos
local LOG_INTERVAL = 15 -- Log a cada 15 segundos

local function removePlayerClothing(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local success, err = pcall(function()
        local character = targetPlayer.Character
        local itemsToRemove = {}
        
        -- Coleta itens para remover (evita modificar tabela durante iteração)
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Accessory") or 
               item:IsA("Hat") or
               item:IsA("Shirt") or
               item:IsA("Pants") or
               item:IsA("ShirtGraphic") then
                table.insert(itemsToRemove, item)
            end
        end
        
        -- Remove itens coletados
        for _, item in pairs(itemsToRemove) do
            item:Destroy()
        end
        
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
        
        local head = character:FindFirstChild("Head")
        if head then
            local headItemsToRemove = {}
            for _, item in pairs(head:GetChildren()) do
                if item:IsA("Decal") or 
                   item:IsA("SpecialMesh") or
                   item:IsA("SurfaceGui") then
                    table.insert(headItemsToRemove, item)
                end
            end
            
            for _, item in pairs(headItemsToRemove) do
                item:Destroy()
            end
            
            head.BrickColor = BrickColor.new("Light orange")
        end
        
        -- Otimiza partes do corpo
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.SmoothPlastic
                part.BrickColor = BrickColor.new("Light orange")
                part.CastShadow = false
            end
        end
    end)
    
    if not success then
        warn("Erro ao otimizar player " .. targetPlayer.Name .. ": " .. tostring(err))
    end
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
        
        -- Remove efeitos de iluminação
        local effectsToRemove = {}
        for _, effect in pairs(Lighting:GetChildren()) do
            if not effect:IsA("Folder") and not effect:IsA("Sky") then
                table.insert(effectsToRemove, effect)
            end
        end
        
        for _, effect in pairs(effectsToRemove) do
            effect:Destroy()
        end
    end)
end

local function optimizeObjectBatch(objects, startIndex)
    local removed = 0
    local endIndex = math.min(startIndex + BATCH_SIZE - 1, #objects)
    
    for i = startIndex, endIndex do
        local obj = objects[i]
        if obj and obj.Parent then
            pcall(function()
                -- Marca objeto como processado para evitar reprocessamento
                if processedObjects[obj] then return end
                processedObjects[obj] = true
                
                if obj:IsA("ParticleEmitter") or 
                   obj:IsA("Trail") or 
                   obj:IsA("Smoke") or 
                   obj:IsA("Fire") or 
                   obj:IsA("Sparkles") or
                   obj:IsA("Beam") or
                   obj:IsA("Explosion") then
                    obj:Destroy()
                    removed = removed + 1
                elseif obj:IsA("Decal") or 
                       obj:IsA("Texture") or
                       obj:IsA("SurfaceGui") or
                       obj:IsA("BillboardGui") then
                    obj:Destroy()
                    removed = removed + 1
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                    
                    -- Otimiza superfícies
                    local smooth = Enum.SurfaceType.Smooth
                    obj.TopSurface = smooth
                    obj.BottomSurface = smooth
                    obj.FrontSurface = smooth
                    obj.BackSurface = smooth
                    obj.LeftSurface = smooth
                    obj.RightSurface = smooth
                    
                    if obj:IsA("MeshPart") then
                        obj.TextureID = ""
                    end
                elseif obj:IsA("SpecialMesh") then
                    obj.TextureId = ""
                elseif obj:IsA("Sound") and not obj.IsPlaying then
                    obj.Volume = 0
                elseif obj:IsA("PointLight") or 
                       obj:IsA("SpotLight") or 
                       obj:IsA("SurfaceLight") then
                    obj:Destroy()
                    removed = removed + 1
                end
            end)
        end
    end
    
    return removed, endIndex
end

local function optimizeTerrain()
    pcall(function()
        local terrain = Workspace:FindFirstChild("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterTransparency = 1
            terrain.WaterReflectance = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterColor = Color3.new(0, 0, 0)
            
            pcall(function()
                terrain.Decorations = false
            end)
        end
    end)
end

local function cleanupMemory()
    pcall(function()
        -- Limpa objetos processados que foram destruídos
        for obj, _ in pairs(processedObjects) do
            if not obj.Parent then
                processedObjects[obj] = nil
            end
        end
        
        game:GetService("Debris"):ClearAllChildren()
        collectgarbage("collect")
    end)
end

-- Sistema de otimização em lotes
local currentBatch = {}
local currentBatchIndex = 1
local isProcessingBatch = false

local function updateBatchObjects()
    currentBatch = Workspace:GetDescendants()
    currentBatchIndex = 1
end

local function processBatch()
    if isProcessingBatch or not optimizationActive then return end
    if #currentBatch == 0 then
        updateBatchObjects()
        return
    end
    
    isProcessingBatch = true
    
    local removed, newIndex = optimizeObjectBatch(currentBatch, currentBatchIndex)
    totalOptimizations = totalOptimizations + removed
    currentBatchIndex = newIndex + 1
    
    -- Se terminou o lote atual, atualiza para o próximo
    if currentBatchIndex > #currentBatch then
        updateBatchObjects()
    end
    
    isProcessingBatch = false
end

-- Event listeners otimizados
local function setupPlayerEvents()
    -- Conecta eventos para novos players
    Players.PlayerAdded:Connect(function(newPlayer)
        newPlayer.CharacterAdded:Connect(function()
            wait(2) -- Aguarda um pouco mais para o character carregar completamente
            removePlayerClothing(newPlayer)
        end)
    end)
    
    -- Otimiza players existentes
    for _, player in pairs(Players:GetPlayers()) do
        spawn(function()
            if player.Character then
                removePlayerClothing(player)
            end
            player.CharacterAdded:Connect(function()
                wait(2)
                removePlayerClothing(player)
            end)
        end)
    end
end

-- Otimização de objetos novos (menos agressiva)
local newObjectQueue = {}
local function processNewObjectQueue()
    if #newObjectQueue == 0 then return end
    
    local objectsToProcess = {}
    for i = 1, math.min(10, #newObjectQueue) do -- Processa apenas 10 por vez
        table.insert(objectsToProcess, newObjectQueue[i])
    end
    
    -- Remove objetos processados da fila
    for i = 1, #objectsToProcess do
        table.remove(newObjectQueue, 1)
    end
    
    for _, obj in pairs(objectsToProcess) do
        if obj and obj.Parent then
            pcall(function()
                if obj:IsA("ParticleEmitter") or 
                   obj:IsA("Trail") or 
                   obj:IsA("Smoke") or 
                   obj:IsA("Fire") or 
                   obj:IsA("Sparkles") or
                   obj:IsA("Beam") then
                    obj:Destroy()
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                end
            end)
        end
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    if optimizationActive and #newObjectQueue < 100 then -- Limita tamanho da fila
        table.insert(newObjectQueue, obj)
    end
end)

-- Loop principal otimizado
local lastOptimization = 0
local lastBatchProcess = 0

RunService.Heartbeat:Connect(function()
    if not optimizationActive then return end
    
    local currentTime = tick()
    
    -- Processa lote de objetos (mais frequente)
    if currentTime - lastBatchProcess >= 0.1 then -- A cada 100ms
        processBatch()
        processNewObjectQueue()
        lastBatchProcess = currentTime
    end
    
    -- Log periódico
    if currentTime - lastLogTime >= LOG_INTERVAL then
        print("Otimização: Total de " .. totalOptimizations .. " objetos otimizados/removidos")
        lastLogTime = currentTime
    end
end)

-- Otimização completa periódica
spawn(function()
    while optimizationActive do
        wait(OPTIMIZATION_INTERVAL)
        
        if optimizationActive then
            optimizeLighting()
            optimizeTerrain()
            cleanupMemory()
            
            -- Reotimiza players periodicamente
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    removePlayerClothing(player)
                end
            end
        end
    end
end)

-- Inicialização
local function initialize()
    print("Iniciando otimização de performance...")
    
    optimizeLighting()
    optimizeTerrain()
    setupPlayerEvents()
    updateBatchObjects()
    
    print("Otimização ativada com sucesso - Versão otimizada")
end

-- Função para desativar otimização
local function toggleOptimization()
    optimizationActive = not optimizationActive
    print("Otimização " .. (optimizationActive and "ativada" or "desativada"))
end

-- Inicia o sistema
initialize()

-- Adiciona comando para toggle (opcional)
game.Players.LocalPlayer.Chatted:Connect(function(message)
    if message:lower() == "/toggle" then
        toggleOptimization()
    elseif message:lower() == "/status" then
        print("Status: " .. (optimizationActive and "Ativo" or "Inativo") .. 
              " | Otimizações: " .. totalOptimizations)
    end
end)
