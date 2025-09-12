local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "EcoHub - Brookhaven V1", 
    HidePremium = false, 
    SaveConfig = false, 
    ConfigFolder = "OrionTest"
})

--Diversao
local DiversaoTab = Window:MakeTab({
	Name = "Diversao",
	Icon = "rbxassetid://",
	PremiumOnly = false
})

DiversaoTab:AddParagraph("Teleporte Rápido", "Escolha um destino para se teletransportar instantaneamente pelo mapa.")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local teleportTargets = {}
local nameToInstance = {}

local function scanWorkspace(folder)
    for _, obj in ipairs(folder:GetChildren()) do
        if obj:IsA("Folder") then
            scanWorkspace(obj)
        elseif obj:IsA("BasePart") or obj:IsA("Model") then
            if not obj:IsDescendantOf(Players.LocalPlayer.Character or workspace) or 
               (obj.Parent ~= Players.LocalPlayer.Character) then
                
                local displayName = obj.Name
                local fullName = obj:GetFullName()
                
                if obj.Parent and obj.Parent ~= Workspace then
                    displayName = obj.Parent.Name .. " - " .. obj.Name
                end
                
                table.insert(teleportTargets, displayName)
                nameToInstance[displayName] = obj
            end
        end
    end
end

scanWorkspace(Workspace)

table.sort(teleportTargets)

DiversaoTab:AddDropdown({
    Name = "Travel Brookhaven",
    Default = "Escolher",
    Options = teleportTargets,
    Callback = function(Value)
        local target = nameToInstance[Value]
        local player = Players.LocalPlayer
        
        if not target then
            warn("[ecohub] Alvo não encontrado: " .. tostring(Value))
            return
        end
        
        if not player.Character then
            warn("[ecohub] Personagem do jogador não encontrado")
            return
        end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            warn("[ecohub] HumanoidRootPart não encontrado")
            return
        end
        
        local position
        
        if target:IsA("Model") then
            if target.PrimaryPart then
                position = target.PrimaryPart.Position
            else
                local success, pivot = pcall(function()
                    return target:GetPivot()
                end)
                if success and pivot then
                    position = pivot.Position
                else
                    local firstPart = target:FindFirstChildOfClass("BasePart")
                    if firstPart then
                        position = firstPart.Position
                    end
                end
            end
        elseif target:IsA("BasePart") then
            position = target.Position
        end
        
        if position then
            local offset = Vector3.new(0, 5, 0)
            
            if target:IsA("BasePart") then
                local size = target.Size
                offset = Vector3.new(0, math.max(5, size.Y/2 + 3), 0)
            end
            
            local success, err = pcall(function()
                hrp.CFrame = CFrame.new(position + offset)
            end)
            
            if success then
                print("[ecohub] Teleportado para: " .. Value)
                
                RunService.Heartbeat:Wait()
                
                local newPosition = hrp.Position
                local distance = (newPosition - (position + offset)).Magnitude
                
                if distance < 10 then
                    print("[ecohub] Teleporte bem-sucedido!")
                else
                    warn("[ecohub] Teleporte pode ter falido - distância: " .. tostring(distance))
                end
            else
                warn("[ecohub] Erro no teleporte: " .. tostring(err))
            end
        else
            warn("[ecohub] Não foi possível determinar a posição do alvo: " .. Value)
        end
    end
})

--Travel Jogadores
DiversaoTab:AddParagraph(
    "Teleporte para Jogadores",
    "Use esta ferramenta para escolher um jogador específico e se teleportar instantaneamente até a localização dele no jogo."
)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local teleportOptions = {"Escolher"}
local nameToPlayer = {}
local dropdown

local function updatePlayerList()
    local newOptions = {"Escolher"}
    local newNameToPlayer = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(newOptions, player.Name)
            newNameToPlayer[player.Name] = player
        end
    end
    
    teleportOptions = newOptions
    nameToPlayer = newNameToPlayer
    
    if dropdown then
        dropdown:Refresh(teleportOptions, true)
    end
end

local function teleportToPlayer(selectedName)
    if selectedName == "Escolher" or selectedName == "" or not selectedName then
        return
    end

    local targetPlayer = nameToPlayer[selectedName]
    if not targetPlayer or not targetPlayer.Parent then
        updatePlayerList()
        return
    end

    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local localCharacter = LocalPlayer.Character
    if not localCharacter or not localCharacter:FindFirstChild("HumanoidRootPart") then
        return
    end

    local targetPos = targetPlayer.Character.HumanoidRootPart.Position
    localCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))
end

updatePlayerList()

dropdown = DiversaoTab:AddDropdown({
    Name = "Travel Jogadores",
    Default = "Escolher",
    Options = teleportOptions,
    Callback = teleportToPlayer
})

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(0.5)
            updatePlayerList()
        end)
        updatePlayerList()
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if nameToPlayer[player.Name] then
        updatePlayerList()
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    updatePlayerList()
end)

--Travel JobGivers
DiversaoTab:AddParagraph(
    "Teleporte Rápido para JobGivers",
    "Selecione um ponto de JobGiver para se teletransportar instantaneamente até sua localização dentro do mapa."
)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local teleportTargets = {}
local nameToInstance = {}

local function scanJobGivers()
    teleportTargets = {}
    nameToInstance = {}
    
    local jobGiversFolder = Workspace:FindFirstChild("JobGivers")
    if jobGiversFolder then
        for _, obj in ipairs(jobGiversFolder:GetChildren()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local displayName = obj.Name
                table.insert(teleportTargets, displayName)
                nameToInstance[displayName] = obj
            end
        end
        
        if #teleportTargets == 0 then
            table.insert(teleportTargets, "Nenhum JobGiver encontrado")
        else
            table.sort(teleportTargets)
        end
    else
        print("[ecohub] Pasta JobGivers não encontrada no Workspace.")
        table.insert(teleportTargets, "JobGivers não encontrado")
    end
end

scanJobGivers()

local dropdown = DiversaoTab:AddDropdown({
    Name = "Travel JobGivers",
    Default = "",
    Options = teleportTargets,
    Callback = function(selectedName)
        if selectedName == "Nenhum JobGiver encontrado" or selectedName == "JobGivers não encontrado" then
            return
        end
        
        local target = nameToInstance[selectedName]
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local targetPosition
            
            if target:IsA("Model") then
                if target.PrimaryPart then
                    targetPosition = target.PrimaryPart.Position
                else
                    local success, result = pcall(function()
                        return target:GetPivot().Position
                    end)
                    
                    if success then
                        targetPosition = result
                    else
                        local firstPart = target:FindFirstChildOfClass("BasePart")
                        if firstPart then
                            targetPosition = firstPart.Position
                        end
                    end
                end
            elseif target:IsA("BasePart") then
                targetPosition = target.Position
            end
            
            if targetPosition then
                local success, err = pcall(function()
                    hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
                end)
                
                if success then
                    print("[ecohub] teleportou para " .. selectedName)
                else
                    warn("[ecohub] Erro ao teleportar: " .. tostring(err))
                end
            else
                warn("[ecohub] Não foi possível determinar a posição para teleporte.")
            end
        else
            warn("[ecohub] Jogador ou alvo inválido para teleporte.")
        end
    end
})

local function setupJobGiversWatcher()
    local jobGiversFolder = Workspace:FindFirstChild("JobGivers")
    if jobGiversFolder then
        jobGiversFolder.ChildAdded:Connect(function()
            scanJobGivers()
            dropdown:Refresh(teleportTargets, true)
        end)
        
        jobGiversFolder.ChildRemoved:Connect(function()
            scanJobGivers()
            dropdown:Refresh(teleportTargets, true)
        end)
    else
        print("[ecohub] Pasta JobGivers não encontrada no Workspace para conectar eventos.")
    end
end

--Vehicles
DiversaoTab:AddParagraph(
    "Teleporte Rápido para Carros",
    "Selecione um carro para se teletransportar instantaneamente até sua localização dentro do mapa."
)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local teleportTargets = {}
local nameToInstance = {}

local function scanVehicles()
    teleportTargets = {}
    nameToInstance = {}
    
    local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
    if vehiclesFolder then
        for _, obj in ipairs(vehiclesFolder:GetChildren()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local ownerName = "Desconhecido"
                
                local humanoidRootPart = obj:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local bodyVelocity = humanoidRootPart:FindFirstChild("BodyVelocity")
                    if bodyVelocity and bodyVelocity:GetAttribute("Owner") then
                        ownerName = bodyVelocity:GetAttribute("Owner")
                    end
                end
                
                if not ownerName or ownerName == "Desconhecido" then
                    local vehicleScript = obj:FindFirstChildOfClass("Script") or obj:FindFirstChildOfClass("LocalScript")
                    if vehicleScript and vehicleScript:GetAttribute("Owner") then
                        ownerName = vehicleScript:GetAttribute("Owner")
                    end
                end
                
                if not ownerName or ownerName == "Desconhecido" then
                    local stringValue = obj:FindFirstChildOfClass("StringValue")
                    if stringValue and stringValue.Name == "Owner" then
                        ownerName = stringValue.Value
                    end
                end
                
                if not ownerName or ownerName == "Desconhecido" then
                    local objectValue = obj:FindFirstChildOfClass("ObjectValue")
                    if objectValue and objectValue.Name == "Owner" and objectValue.Value then
                        ownerName = objectValue.Value.Name
                    end
                end
                
                -- Formato bem simples: só "carro - nome do usuário"
                local displayName = "carro - " .. ownerName
                table.insert(teleportTargets, displayName)
                nameToInstance[displayName] = obj
            end
        end
        
        if #teleportTargets == 0 then
            table.insert(teleportTargets, "Nenhum Carro encontrado")
        else
            table.sort(teleportTargets)
        end
    else
        print("[ecohub] Pasta Vehicles não encontrada no Workspace.")
        table.insert(teleportTargets, "Carros não encontrado")
    end
end

scanVehicles()

local dropdown = DiversaoTab:AddDropdown({
    Name = "Travel Carro",
    Default = "",
    Options = teleportTargets,
    Callback = function(selectedName)
        if selectedName == "Nenhum Carro encontrado" or selectedName == "Carros não encontrado" then
            return
        end
        
        local target = nameToInstance[selectedName]
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local targetPosition
            
            if target:IsA("Model") then
                if target.PrimaryPart then
                    targetPosition = target.PrimaryPart.Position
                else
                    local success, result = pcall(function()
                        return target:GetPivot().Position
                    end)
                    
                    if success then
                        targetPosition = result
                    else
                        local firstPart = target:FindFirstChildOfClass("BasePart")
                        if firstPart then
                            targetPosition = firstPart.Position
                        end
                    end
                end
            elseif target:IsA("BasePart") then
                targetPosition = target.Position
            end
            
            if targetPosition then
                local success, err = pcall(function()
                    hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
                end)
                
                if success then
                    print("[ecohub] teleportou para " .. selectedName)
                else
                    warn("[ecohub] Erro ao teleportar: " .. tostring(err))
                end
            else
                warn("[ecohub] Não foi possível determinar a posição para teleporte.")
            end
        else
            warn("[ecohub] Jogador ou alvo inválido para teleporte.")
        end
    end
})

local function setupVehiclesWatcher()
    local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
    if vehiclesFolder then
        vehiclesFolder.ChildAdded:Connect(function()
            scanVehicles()
            dropdown:Refresh(teleportTargets, true)
        end)
        
        vehiclesFolder.ChildRemoved:Connect(function()
            scanVehicles()
            dropdown:Refresh(teleportTargets, true)
        end)
    else
        print("[ecohub] Pasta Vehicles não encontrada no Workspace para conectar eventos.")
    end
end

setupVehiclesWatcher()

task.spawn(function()
    while true do
        task.wait(2)
        scanVehicles()
        dropdown:Refresh(teleportTargets, true)
    end
end)

--AdTimeSpent 
DiversaoTab:AddParagraph(
    "Teleporte Rápido para AdTimeSpent",
    "Selecione um item do AdTimeSpent para se teletransportar instantaneamente até sua localização."
)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local teleportTargets = {}
local nameToInstance = {}

local function scanAdTimeSpent()
    teleportTargets = {}
    nameToInstance = {}
    
    local adTimeSpentFolder = Workspace:FindFirstChild("AdTimeSpent")
    if adTimeSpentFolder then
        for _, obj in ipairs(adTimeSpentFolder:GetChildren()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local displayName = obj.Name
                table.insert(teleportTargets, displayName)
                nameToInstance[displayName] = obj
            end
        end
        
        if #teleportTargets == 0 then
            table.insert(teleportTargets, "Nenhum item encontrado")
        else
            table.sort(teleportTargets)
        end
    else
        print("[ecohub] Pasta AdTimeSpent não encontrada no Workspace.")
        table.insert(teleportTargets, "AdTimeSpent não encontrado")
    end
end

scanAdTimeSpent()

local dropdown = DiversaoTab:AddDropdown({
    Name = "Travel AdTimeSpent",
    Default = "",
    Options = teleportTargets,
    Callback = function(selectedName)
        if selectedName == "Nenhum item encontrado" or selectedName == "AdTimeSpent não encontrado" then
            return
        end
        
        local target = nameToInstance[selectedName]
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local targetPosition
            
            if target:IsA("Model") then
                if target.PrimaryPart then
                    targetPosition = target.PrimaryPart.Position
                else
                    local success, result = pcall(function()
                        return target:GetPivot().Position
                    end)
                    
                    if success then
                        targetPosition = result
                    else
                        local firstPart = target:FindFirstChildOfClass("BasePart")
                        if firstPart then
                            targetPosition = firstPart.Position
                        end
                    end
                end
            elseif target:IsA("BasePart") then
                targetPosition = target.Position
            end
            
            if targetPosition then
                local success, err = pcall(function()
                    hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
                end)
                
                if success then
                    print("[ecohub] teleportou para " .. selectedName)
                else
                    warn("[ecohub] Erro ao teleportar: " .. tostring(err))
                end
            else
                warn("[ecohub] Não foi possível determinar a posição para teleporte.")
            end
        else
            warn("[ecohub] Jogador ou alvo inválido para teleporte.")
        end
    end
})

local function setupAdTimeSpentWatcher()
    local adTimeSpentFolder = Workspace:FindFirstChild("AdTimeSpent")
    if adTimeSpentFolder then
        adTimeSpentFolder.ChildAdded:Connect(function()
            scanAdTimeSpent()
            dropdown:Refresh(teleportTargets, true)
        end)
        
        adTimeSpentFolder.ChildRemoved:Connect(function()
            scanAdTimeSpent()
            dropdown:Refresh(teleportTargets, true)
        end)
    else
        print("[ecohub] Pasta AdTimeSpent não encontrada no Workspace para conectar eventos.")
    end
end

setupAdTimeSpentWatcher()

task.spawn(function()
    while true do
        task.wait(2)
        scanAdTimeSpent()
        dropdown:Refresh(teleportTargets, true)
    end
end)

--Sistema Avançado
DiversaoTab:AddParagraph("Sistema Avançado", "Clique nos botões abaixo para se divertir")

--anti-safe zone
local Workspace = game:GetService("Workspace")
local toggleFlag = false

local function limparComplexAdZones()
    local pasta = Workspace:FindFirstChild("ComplexAdZones")
    if pasta then
        local removedAny = false
        for _, obj in ipairs(pasta:GetChildren()) do
            if typeof(obj.Name) == "string" and not string.find(string.lower(obj.Name), "safezone") then
                print("[ecohub] tirou " .. obj.Name)
                obj:Destroy()
                removedAny = true
            end
        end
        if not removedAny then
            print("[ecohub] Nenhum objeto removido na limpeza.")
        end
    else
        print("[ecohub] Pasta ComplexAdZones não encontrada no Workspace.")
    end
end

local function onChildAdded(child)
    if toggleFlag and typeof(child.Name) == "string" and not string.find(string.lower(child.Name), "safezone") then
        print("[ecohub] tirou " .. child.Name)
        child:Destroy()
    end
end

local function onChildRemoved(child)
    if toggleFlag then
        print("[ecohub] objeto removido: " .. tostring(child.Name or "nil"))
    end
end

DiversaoTab:AddToggle({
    Name = "Remoção de Safe-Zones",
    Default = false,
    Save = false,
    Flag = "toggle",
    Callback = function(value)
        toggleFlag = value
        print("[ecohub] Remoção de safe-zones ativada: " .. tostring(toggleFlag))
        if toggleFlag then
            limparComplexAdZones()
        end
    end
})

local pasta = Workspace:FindFirstChild("ComplexAdZones")
if pasta then
    pasta.ChildAdded:Connect(onChildAdded)
    pasta.ChildRemoved:Connect(onChildRemoved)
else
    print("[ecohub] Pasta ComplexAdZones não encontrada no Workspace para conexão do evento.")
end

--anti-musica

local Workspace = game:GetService("Workspace")
local toggleFlag = false

local function limparMusicZones()
    local pasta = Workspace:FindFirstChild("MusicZones")
    if pasta then
        local removedAny = false
        for _, obj in ipairs(pasta:GetChildren()) do
            print("[ecohub] tirou " .. obj.Name)
            obj:Destroy()
            removedAny = true
        end
        if not removedAny then
            print("[ecohub] Nenhum objeto removido na limpeza.")
        end
    else
        print("[ecohub] Pasta MusicZones não encontrada no Workspace.")
    end
end

local function onChildAdded(child)
    if toggleFlag then
        print("[ecohub] tirou " .. child.Name)
        child:Destroy()
    end
end

local function onChildRemoved(child)
    if toggleFlag then
        print("[ecohub] objeto removido: " .. tostring(child.Name or "nil"))
    end
end

DiversaoTab:AddToggle({
    Name = "Remoção de MusicZones",
    Default = false,
    Save = false,
    Flag = "toggle_music",
    Callback = function(value)
        toggleFlag = value
        print("[ecohub] Remoção de objetos em MusicZones ativada: " .. tostring(toggleFlag))
        if toggleFlag then
            limparMusicZones()
        end
    end
})

local pasta = Workspace:FindFirstChild("MusicZones")
if pasta then
    pasta.ChildAdded:Connect(onChildAdded)
    pasta.ChildRemoved:Connect(onChildRemoved)
else
    print("[ecohub] Pasta MusicZones não encontrada no Workspace para conexão do evento.")
end

--Anti-ban
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local antiBarrierEnabled = false
local autoTeleportEnabled = false
local lastDeathPosition = nil
local barrierConnection = nil
local destroyedParts = {}
local processedObjects = {}
local lastUpdate = 0

local banTriggerWords = {
    "barrier", "wall", "invisible", "block", "fence", 
    "border", "limit", "red", "force", "field"
}

local function checkBarrierPart(obj)
    if not obj or not obj.Parent or processedObjects[obj] then
        return false
    end
    
    processedObjects[obj] = true
    
    if not obj:IsA("BasePart") or not obj.CanCollide then
        return false
    end
    
    local lname = obj.Name:lower()
    for _, word in ipairs(banTriggerWords) do
        if lname:find(word) then
            return true
        end
    end
    
    if obj.Transparency >= 0.95 then
        local size = obj.Size
        if (size.X >= 500 or size.Y >= 500 or size.Z >= 500) or
           obj.Material == Enum.Material.ForceField or
           obj:IsA("TrussPart") then
            return true
        end
    end
    
    return false
end

local function removeBarrierParts()
    local currentTick = tick()
    if currentTick - lastUpdate < 0.5 then
        return
    end
    lastUpdate = currentTick
    
    local descendants = Workspace:GetDescendants()
    local processCount = 0
    local maxProcess = 50
    
    for i = 1, math.min(#descendants, maxProcess) do
        local obj = descendants[i]
        
        if checkBarrierPart(obj) and not destroyedParts[obj] then
            destroyedParts[obj] = true
            obj.CanCollide = false
            spawn(function()
                obj:Destroy()
            end)
            processCount = processCount + 1
            
            if processCount >= 10 then
                break
            end
        end
    end
end

local function startAntiBarrier()
    if barrierConnection then
        barrierConnection:Disconnect()
    end
    
    barrierConnection = RunService.Heartbeat:Connect(function()
        if antiBarrierEnabled then
            removeBarrierParts()
        end
    end)
end

DiversaoTab:AddToggle({
    Name = "Anti-Barreira Vermelha",
    Default = false,
    Callback = function(Value)
        antiBarrierEnabled = Value
        if antiBarrierEnabled then
            spawn(function()
                removeBarrierParts()
            end)
            startAntiBarrier()
        else
            if barrierConnection then
                barrierConnection:Disconnect()
                barrierConnection = nil
            end
        end
    end
})

--Anti-ban #2
local function saveDeathPosition()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        lastDeathPosition = LocalPlayer.Character.HumanoidRootPart.Position
    end
end

local function teleportToDeathLocation()
    if lastDeathPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(lastDeathPosition + Vector3.new(0, 5, 0))
        lastDeathPosition = nil
    end
end

local function onCharacterDied()
    if autoTeleportEnabled then
        saveDeathPosition()
    end
end

local function onCharacterAdded(character)
    if autoTeleportEnabled and lastDeathPosition then
        spawn(function()
            wait(1)
            teleportToDeathLocation()
        end)
    end
    
    spawn(function()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Died:Connect(onCharacterDied)
    end)
end

DiversaoTab:AddToggle({
    Name = "Auto Teleport Morte",
    Default = false,
    Callback = function(Value)
        autoTeleportEnabled = Value
        
        if autoTeleportEnabled then
            if LocalPlayer.Character then
                spawn(function()
                    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.Died:Connect(onCharacterDied)
                    end
                end)
            end
            
            LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        end
    end
})

Workspace.DescendantAdded:Connect(function(obj)
    if antiBarrierEnabled then
        spawn(function()
            if checkBarrierPart(obj) and not destroyedParts[obj] then
                destroyedParts[obj] = true
                obj.CanCollide = false
                obj:Destroy()
            end
        end)
    end
end)

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

--anti-afk
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local antiAfkEnabled = false
local antiAfkConnection

local function startAntiAfk()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
    end
    
    antiAfkConnection = task.spawn(function()
        while antiAfkEnabled do
            task.wait(1)
            
            if antiAfkEnabled and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and rootPart then
                    for i = 1, 10 do
                        if not antiAfkEnabled then break end
                        
                        local randomDirection = Vector3.new(
                            math.random(-10, 10),
                            0,
                            math.random(-10, 10)
                        ).Unit
                        
                        local targetPosition = rootPart.Position + (randomDirection * 3)
                        humanoid:MoveTo(targetPosition)
                        
                        task.wait(0.5)
                    end
                    
                    print("[ecohub] Anti-AFK - 10 movimentos feitos")
                end
            end
        end
    end)
end

local function stopAntiAfk()
    antiAfkEnabled = false
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
    print("[ecohub] Anti-AFK desativado")
end

DiversaoTab:AddToggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(Value)
        antiAfkEnabled = Value
        
        if Value then
            print("[ecohub] Anti-AFK ligado")
            startAntiAfk()
        else
            stopAntiAfk()
        end
    end
})

--ESP
local ESPTab = Window:MakeTab({
	Name = "ESP",
	Icon = "rbxassetid://",
	PremiumOnly = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

ESPTab:AddParagraph(
    "ESP Jogadores Brookhaven",
    "ESP com melhor performance, linhas limpas e sem travamentos."
)

local espEnabled = false
local maxDistance = 200
local espObjects = {}
local updateConnection
local lastFullUpdate = 0
local updateInterval = 0.05

local localHRP

local function getTeamColor(player)
    if player.Team and player.Team.TeamColor then
        return player.Team.TeamColor.Color
    else
        -- Cor padrão se não houver time
        return Color3.fromRGB(255, 255, 255)
    end
end

local function createESP(player)
    if espObjects[player] or not player.Character or player == LocalPlayer then 
        return 
    end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not humanoid then 
        return 
    end

    local teamColor = getTeamColor(player)

    -- Removido o quadrado (BoxHandleAdornment)
    
    local outline = Instance.new("SelectionBox")
    outline.Adornee = hrp
    outline.Color3 = teamColor
    outline.LineThickness = 0.05
    outline.Transparency = 0.2
    outline.Parent = hrp

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = teamColor
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 10  -- Tamanho pequeno para o nome
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.Text = player.Name
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = teamColor
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 8  -- Tamanho pequeno para a distância
    distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distanceLabel.Text = "0m"
    distanceLabel.TextStrokeTransparency = 0.3
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    distanceLabel.Parent = billboard

    local line = Instance.new("Beam")
    local attachment0 = Instance.new("Attachment")
    local attachment1 = Instance.new("Attachment")
    
    attachment0.Parent = hrp
    attachment1.Parent = localHRP or LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    
    line.Attachment0 = attachment0
    line.Attachment1 = attachment1
    line.Color = ColorSequence.new(teamColor)
    line.Transparency = NumberSequence.new(0.7)
    line.Width0 = 0.1
    line.Width1 = 0.1
    line.FaceCamera = true
    line.Parent = hrp

    espObjects[player] = {
        outline = outline,
        nameLabel = nameLabel,
        distanceLabel = distanceLabel,
        billboard = billboard,
        line = line,
        attachment0 = attachment0,
        attachment1 = attachment1,
        player = player,
        lastDistance = 0,
        lastUpdate = 0
    }
end

local function destroyESP(player)
    local data = espObjects[player]
    if data then
        pcall(function()
            if data.outline then data.outline:Destroy() end
            if data.billboard then data.billboard:Destroy() end
            if data.line then data.line:Destroy() end
            if data.attachment0 then data.attachment0:Destroy() end
            if data.attachment1 then data.attachment1:Destroy() end
        end)
        espObjects[player] = nil
    end
end

local function updateESP()
    if not espEnabled then return end
    
    if LocalPlayer.Character then
        localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    
    if not localHRP then return end
    
    local currentTime = tick()
    
    if currentTime - lastFullUpdate < updateInterval then
        return
    end
    lastFullUpdate = currentTime
    
    for player, data in pairs(espObjects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local distance = (hrp.Position - localHRP.Position).Magnitude
            local roundedDistance = math.floor(distance)
            
            -- Atualizar cor do time
            local teamColor = getTeamColor(player)
            data.outline.Color3 = teamColor
            data.nameLabel.TextColor3 = teamColor
            data.distanceLabel.TextColor3 = teamColor
            data.line.Color = ColorSequence.new(teamColor)
            
            if math.abs(roundedDistance - data.lastDistance) > 2 or currentTime - data.lastUpdate > 0.5 then
                data.lastDistance = roundedDistance
                data.lastUpdate = currentTime
                
                if distance <= maxDistance then
                    local transparency = math.min(0.8, 0.3 + (distance / 400))
                    data.outline.Transparency = transparency * 0.6
                    
                    data.distanceLabel.Text = roundedDistance .. "m"
                    
                    data.outline.Visible = true
                    data.billboard.Enabled = true
                    data.line.Enabled = true
                else
                    data.outline.Visible = false
                    data.billboard.Enabled = false
                    data.line.Enabled = false
                end
            end
        else
            destroyESP(player)
        end
    end
end

local function startESP()
    if updateConnection then
        updateConnection:Disconnect()
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            createESP(player)
        end
    end
    
    updateConnection = RunService.Heartbeat:Connect(updateESP)
end

local function stopESP()
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end
    
    for player, _ in pairs(espObjects) do
        destroyESP(player)
    end
    espObjects = {}
end

ESPTab:AddToggle({
    Name = "Ativar ESP",
    Default = false,
    Callback = function(value)
        espEnabled = value
        if espEnabled then
            startESP()
        else
            stopESP()
        end
    end
})

ESPTab:AddSlider({
    Name = "Distancia Maxima",
    Min = 50,
    Max = 500,
    Default = 200,
    Color = Color3.fromRGB(255,255,255),
    Increment = 25,
    ValueName = "metros",
    Callback = function(value)
        maxDistance = value
    end    
})

ESPTab:AddSlider({
    Name = "Taxa de Atualizacao",
    Min = 0.02,
    Max = 0.2,
    Default = 0.05,
    Color = Color3.fromRGB(100, 255, 100),
    Increment = 0.01,
    ValueName = "segundos",
    Callback = function(value)
        updateInterval = value
    end    
})

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        local function onCharacterAdded()
            wait(1)
            if espEnabled then
                createESP(player)
            end
        end
        
        player.CharacterAdded:Connect(onCharacterAdded)
        if player.Character then
            onCharacterAdded()
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    destroyESP(player)
end)

LocalPlayer.CharacterAdded:Connect(function()
    wait(2)
    if espEnabled then
        startESP()
    end
end)

-- Atualizar cores quando jogadores mudarem de time
Players.PlayerAdded:Connect(function(player)
    local function onTeamChanged()
        if espObjects[player] and espEnabled then
            local teamColor = getTeamColor(player)
            local data = espObjects[player]
            if data then
                data.outline.Color3 = teamColor
                data.nameLabel.TextColor3 = teamColor
                data.distanceLabel.TextColor3 = teamColor
                data.line.Color = ColorSequence.new(teamColor)
            end
        end
    end
    
    player:GetPropertyChangedSignal("Team"):Connect(onTeamChanged)
end)

--ESP Coffe
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

ESPTab:AddParagraph(
    "ESP Cofre Brookhaven",
    "Encontre cofres no mapa com precisao melhorada."
)

local safeESPEnabled = false
local safeColor = Color3.fromRGB(100, 200, 100)
local safeObjects = {}
local safeUpdateConnection
local safeMaxDistance = 200
local lastUpdate = 0

local function isSafeItem(obj)
    if not obj or not obj.Name then return false end
    
    local name = obj.Name:lower()
    if name:find("safe") or name:find("cofre") or name:find("vault") then
        return true
    end
    
    if obj:IsA("Part") then
        if (obj.BrickColor == BrickColor.new("Really black") or 
            obj.BrickColor == BrickColor.new("Black") or
            obj.BrickColor == BrickColor.new("Dark stone grey")) and
           (obj.Size.X >= 2 and obj.Size.Y >= 2 and obj.Size.Z >= 2) then
            
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("SurfaceGui") then
                    for _, element in pairs(child:GetChildren()) do
                        if element:IsA("Frame") and 
                           (element.BackgroundColor3.G > 0.7) then
                            return true
                        end
                        if element:IsA("TextLabel") and element.Text and 
                           (element.Text:lower():find("safe") or element.Text:lower():find("cofre")) then
                            return true
                        end
                    end
                end
            end
        end
    end
    
    return false
end

local function createSafeESP(safe)
    if safeObjects[safe] or not safe.Parent then 
        return 
    end

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = safe
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.6
    box.Color3 = safeColor
    box.Size = safe.Size + Vector3.new(0.3, 0.3, 0.3)
    box.Parent = safe

    local outline = Instance.new("SelectionBox")
    outline.Adornee = safe
    outline.Color3 = safeColor
    outline.LineThickness = 0.1
    outline.Transparency = 0.3
    outline.Parent = safe

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = safe
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = safe

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = safeColor
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.Text = "COFRE"
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Parent = billboard

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = safeColor
    distanceLabel.Font = Enum.Font.Gotham
    distanceLabel.TextSize = 10
    distanceLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distanceLabel.Text = "0m"
    distanceLabel.TextStrokeTransparency = 0.5
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.Parent = billboard

    safeObjects[safe] = {
        box = box,
        outline = outline,
        nameLabel = nameLabel,
        distanceLabel = distanceLabel,
        billboard = billboard,
        safe = safe,
        lastUpdate = 0
    }
end

local function destroySafeESP(safe)
    local data = safeObjects[safe]
    if data then
        pcall(function()
            if data.box then data.box:Destroy() end
            if data.outline then data.outline:Destroy() end
            if data.billboard then data.billboard:Destroy() end
        end)
        safeObjects[safe] = nil
    end
end

local function updateSafeESP()
    if not safeESPEnabled or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 
    end
    
    local currentTime = tick()
    if currentTime - lastUpdate < 0.1 then
        return
    end
    lastUpdate = currentTime
    
    local localHRP = LocalPlayer.Character.HumanoidRootPart
    
    for safe, data in pairs(safeObjects) do
        if safe and safe.Parent then
            local distance = math.floor((safe.Position - localHRP.Position).Magnitude)
            
            if distance <= safeMaxDistance then
                if currentTime - data.lastUpdate >= 0.3 then
                    data.distanceLabel.Text = distance .. "m"
                    data.lastUpdate = currentTime
                    
                    local transparency = math.min(0.8, 0.4 + (distance / 500))
                    data.box.Transparency = transparency
                    data.outline.Transparency = transparency * 0.7
                end
                
                data.box.Visible = true
                data.outline.Visible = true
                data.billboard.Enabled = true
            else
                data.box.Visible = false
                data.outline.Visible = false
                data.billboard.Enabled = false
            end
        else
            destroySafeESP(safe)
        end
    end
end

local function startSafeESPUpdate()
    if safeUpdateConnection then
        safeUpdateConnection:Disconnect()
    end
    safeUpdateConnection = RunService.Heartbeat:Connect(updateSafeESP)
end

local function scanForSafes()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") and isSafeItem(obj) then
            createSafeESP(obj)
        end
    end
end

ESPTab:AddToggle({
    Name = "ESP Cofre",
    Default = false,
    Callback = function(v)
        safeESPEnabled = v
        if not safeESPEnabled then
            for safe, _ in pairs(safeObjects) do 
                destroySafeESP(safe)
            end
            safeObjects = {}
            if safeUpdateConnection then
                safeUpdateConnection:Disconnect()
                safeUpdateConnection = nil
            end
        else
            scanForSafes()
            startSafeESPUpdate()
        end
    end
})

ESPTab:AddColorpicker({
    Name = "Cor Cofre ESP",
    Default = safeColor,
    Callback = function(c)
        safeColor = c
        for _, data in pairs(safeObjects) do
            pcall(function()
                if data.box then data.box.Color3 = safeColor end
                if data.outline then data.outline.Color3 = safeColor end
                if data.nameLabel then data.nameLabel.TextColor3 = safeColor end
                if data.distanceLabel then data.distanceLabel.TextColor3 = safeColor end
            end)
        end
    end
})

ESPTab:AddSlider({
    Name = "Distancia Cofre",
    Min = 50,
    Max = 500,
    Default = 200,
    Color = Color3.fromRGB(100, 200, 100),
    Increment = 25,
    ValueName = "metros",
    Callback = function(Value)
        safeMaxDistance = Value
    end    
})

Workspace.DescendantAdded:Connect(function(obj)
    if safeESPEnabled and obj:IsA("Part") then
        wait(0.1)
        if isSafeItem(obj) then
            createSafeESP(obj)
        end
    end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if safeObjects[obj] then
        destroySafeESP(obj)
    end
end)

--em breve
