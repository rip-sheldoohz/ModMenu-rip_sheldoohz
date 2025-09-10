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
	Icon = "rbxassetid://108763465205586",
	PremiumOnly = false
})

--Travel Brookhaven
DiversaoTab:AddParagraph("Teleporte Rápido", "Escolha um destino para se teletransportar instantaneamente pelo mapa.")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local teleportTargets = {}
local nameToInstance = {}

local function scanWorkspace(folder)
	for _, obj in ipairs(folder:GetChildren()) do
		if obj:IsA("Folder") then
			scanWorkspace(obj)
		elseif obj:IsA("BasePart") or obj:IsA("Model") then
			local uniqueName = obj:GetFullName()
			table.insert(teleportTargets, uniqueName)
			nameToInstance[uniqueName] = obj
		end
	end
end

scanWorkspace(Workspace)

DiversaoTab:AddDropdown({
	Name = "Travel Brookhaven",
	Default = "Escolher",
	Options = teleportTargets,
	Callback = function(Value)
		local target = nameToInstance[Value]
		local player = Players.LocalPlayer

		if target and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local position

			if target:IsA("Model") and target:FindFirstChild("PrimaryPart") then
				position = target.PrimaryPart.Position
			elseif target:IsA("Model") and target:GetPivot() then
				position = target:GetPivot().Position
			elseif target:IsA("BasePart") then
				position = target.Position
			end

			if position then
				hrp.CFrame = CFrame.new(position + Vector3.new(0, 5, 0))
				print("[ecohub] teleportou para " .. Value)
			end
		end
	end
})

--Travel Jogadores

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

DiversaoTab:AddParagraph(
    "Sistema de Teleporte para Jogadores",
    "Use esta ferramenta para escolher um jogador específico e se teleportar instantaneamente até a localização dele no jogo."
)

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

--Tirar Safe-Zone
DiversaoTab:AddParagraph(
    "Sistema de Remoção Automática de Safe-Zones",
    "Ative esta opção para remover automaticamente todos os objetos que não são safe-zones dentro da pasta ComplexAdZones no Workspace em tempo real."
)

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

--Travel MusicZones
DiversaoTab:AddParagraph(
    "Sistema de Remoção Automática",
    "Ative esta opção para remover automaticamente todos os objetos dentro da pasta MusicZones no Workspace em tempo real."
)

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
    else
        print("[ecohub] Pasta JobGivers não encontrada no Workspace.")
    end
end

scanJobGivers()

local dropdown = DiversaoTab:AddDropdown({
    Name = "Travel JobGivers",
    Default = "",
    Options = teleportTargets,
    Callback = function(selectedName)
        local target = nameToInstance[selectedName]
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local targetPosition

            if target:IsA("Model") then
                if target.PrimaryPart then
                    targetPosition = target.PrimaryPart.Position
                else
                    targetPosition = target:GetModelCFrame().p
                end
            elseif target:IsA("BasePart") then
                targetPosition = target.Position
            end

            if targetPosition then
                hrp.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
                print("[ecohub] teleportou para " .. selectedName)
            else
                warn("[ecohub] Não foi possível determinar a posição para teleporte.")
            end
        else
            warn("[ecohub] Jogador ou alvo inválido para teleporte.")
        end
    end
})

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

DiversaoTab:AddParagraph(
    "Anti-Barreira Brookhaven", 
    "Remove as barreiras vermelhas invisíveis do mapa automaticamente"
)

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

DiversaoTab:AddParagraph(
    "Auto Teleport Morte", 
    "Teleporta automaticamente para onde você morreu"
)

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

--Status
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local JoinTime = tick()

local StatusTab = Window:MakeTab({
    Name = "Status",
    Icon = "rbxassetid://",
    PremiumOnly = false
})

local function getDayTime()
    local time = Lighting.ClockTime
    if time >= 6 and time < 18 then
        return "Dia"
    else
        return "Noite"
    end
end

local function getPlayTime()
    local elapsed = tick() - JoinTime
    local minutes = math.floor(elapsed / 60)
    local seconds = math.floor(elapsed % 60)
    return string.format("%02d:%02d", minutes, seconds)
end

local function getPing()
    local network = StatsService:FindFirstChild("PerformanceStats")
    if network and network:FindFirstChild("Ping") then
        return tostring(math.floor(network.Ping:GetValue())) .. " ms"
    end
    return "N/A"
end

local statusParagraph = StatusTab:AddParagraph(
    "Status do Brookhaven",
    "Carregando informações..."
)

local function atualizarStatus()
    local nome = LocalPlayer.Name
    local userid = LocalPlayer.UserId
    local jogadores = #Players:GetPlayers()
    local horario = getDayTime()
    local tempoJogo = getPlayTime()
    local ping = getPing()

    local texto = "Nome: " .. nome ..
        "\nID: " .. userid ..
        "\nTempo no jogo: " .. tempoJogo ..
        "\nJogadores no servidor: " .. jogadores ..
        "\nPeríodo do dia: " .. horario ..
        "\nPing: " .. ping

    statusParagraph:SetContent(texto)
end

Players.PlayerAdded:Connect(atualizarStatus)
Players.PlayerRemoving:Connect(atualizarStatus)
Lighting:GetPropertyChangedSignal("ClockTime"):Connect(atualizarStatus)

RunService.RenderStepped:Connect(function()
    atualizarStatus()
end)

--ESP
local ESPTab = Window:MakeTab({
    Name = "ESP",
    Icon = "rbxassetid://",
    PremiumOnly = false
})

--ESP
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

--LocalPlayer
local localplayerTab = Window:MakeTab({
	Name = "Local Player",
	Icon = "rbxassetid://",
	PremiumOnly = false
})

--Velocidade
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

localplayerTab:AddParagraph("Velocidade", "Controle a velocidade de movimento do seu personagem")

local speedEnabled = false
local speedValue = 16
local originalSpeed = 16
local speedConnection

local function setSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedEnabled and speedValue or originalSpeed
    end
end

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    if originalSpeed == 16 then
        originalSpeed = humanoid.WalkSpeed
    end
    setSpeed()
end

localplayerTab:AddToggle({
    Name = "Ativar Velocidade",
    Default = false,
    Callback = function(value)
        speedEnabled = value
        setSpeed()
        
        if speedEnabled then
            speedConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
            if LocalPlayer.Character then
                onCharacterAdded(LocalPlayer.Character)
            end
        else
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
        end
    end
})

localplayerTab:AddSlider({
    Name = "Velocidade",
    Min = 16,
    Max = 1000,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = "vel",
    Callback = function(value)
        speedValue = value
        if speedEnabled then
            setSpeed()
        end
    end
})

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

--NoClip
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

localplayerTab:AddParagraph("NoClip", "Atravesse paredes, parts e qualquer objeto do jogo")

local noclipEnabled = false
local heartbeatConnection
local characterConnection
local descendantConnection

local function forceNoclip()
    if not LocalPlayer.Character then return end
    
    pcall(function()
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        if LocalPlayer.Character:FindFirstChild("Head") then
            LocalPlayer.Character.Head.CanCollide = false
        end
        if LocalPlayer.Character:FindFirstChild("Torso") then
            LocalPlayer.Character.Torso.CanCollide = false
        end
        if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CanCollide = false
        end
        if LocalPlayer.Character:FindFirstChild("UpperTorso") then
            LocalPlayer.Character.UpperTorso.CanCollide = false
        end
        if LocalPlayer.Character:FindFirstChild("LowerTorso") then
            LocalPlayer.Character.LowerTorso.CanCollide = false
        end
    end)
end

local function onHeartbeat()
    if noclipEnabled then
        forceNoclip()
    end
end

local function onDescendantAdded(descendant)
    if noclipEnabled and descendant:IsA("BasePart") then
        descendant.CanCollide = false
        descendant.Changed:Connect(function(property)
            if property == "CanCollide" and noclipEnabled then
                descendant.CanCollide = false
            end
        end)
    end
end

local function onCharacterAdded(character)
    if noclipEnabled then
        wait(0.1)
        
        if descendantConnection then
            descendantConnection:Disconnect()
        end
        descendantConnection = character.DescendantAdded:Connect(onDescendantAdded)
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Changed:Connect(function(property)
                    if property == "CanCollide" and noclipEnabled then
                        part.CanCollide = false
                    end
                end)
            end
        end
        
        forceNoclip()
    end
end

local function restoreCollision()
    if LocalPlayer.Character then
        pcall(function()
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part.Name == "Head" or part.Name == "Torso" or part.Name == "HumanoidRootPart" or 
                       part.Name == "UpperTorso" or part.Name == "LowerTorso" or 
                       part.Name:find("Arm") or part.Name:find("Leg") then
                        part.CanCollide = false
                    else
                        part.CanCollide = true
                    end
                end
            end
        end)
    end
end

localplayerTab:AddToggle({
    Name = "Ativar NoClip",
    Default = false,
    Callback = function(value)
        noclipEnabled = value
        
        if noclipEnabled then
            heartbeatConnection = RunService.Heartbeat:Connect(onHeartbeat)
            characterConnection = LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
            
            if LocalPlayer.Character then
                onCharacterAdded(LocalPlayer.Character)
            end
        else
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
                heartbeatConnection = nil
            end
            if characterConnection then
                characterConnection:Disconnect()
                characterConnection = nil
            end
            if descendantConnection then
                descendantConnection:Disconnect()
                descendantConnection = nil
            end
            
            restoreCollision()
        end
    end
})

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

--FLW
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

localplayerTab:AddParagraph("Sistema FLY", "Voe com personagem, cadeira, carro e qualquer veículo")

local flyEnabled = false
local flySpeed = 50
local flyConnection
local bodyVelocity
local bodyAngularVelocity
local currentTarget
local keys = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}

local function getMainPart()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and rootPart then
            local seatPart = humanoid.SeatPart
            if seatPart then
                local vehicle = seatPart.Parent
                if vehicle and vehicle:FindFirstChild("VehicleSeat") then
                    return vehicle.VehicleSeat
                else
                    return seatPart
                end
            end
            return rootPart
        end
    end
    return nil
end

local function createBodyMovers(part)
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyAngularVelocity then bodyAngularVelocity:Destroy() end

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "FlyVelocity"
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.P = 1250
    bodyVelocity.Parent = part

    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.Name = "FlyAngular"
    bodyAngularVelocity.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyAngularVelocity.AngularVelocity = Vector3.zero
    bodyAngularVelocity.P = 3000
    bodyAngularVelocity.Parent = part
end

local function updateFly()
    if not flyEnabled then return end

    local targetPart = getMainPart()
    if not targetPart then return end

    if currentTarget ~= targetPart then
        currentTarget = targetPart
        createBodyMovers(targetPart)
    end

    if not bodyVelocity or not bodyVelocity.Parent then
        createBodyMovers(targetPart)
    end

    local camera = workspace.CurrentCamera
    local moveVector = Vector3.new(0, 0, 0)

    if keys.W then moveVector = moveVector + camera.CFrame.LookVector end
    if keys.S then moveVector = moveVector - camera.CFrame.LookVector end
    if keys.A then moveVector = moveVector - camera.CFrame.RightVector end
    if keys.D then moveVector = moveVector + camera.CFrame.RightVector end
    if keys.Space then moveVector = moveVector + Vector3.new(0, 1, 0) end
    if keys.LeftShift then moveVector = moveVector - Vector3.new(0, 1, 0) end

    if moveVector.Magnitude > 0 then
        moveVector = moveVector.Unit * flySpeed
    else
        moveVector = Vector3.zero
    end

    bodyVelocity.Velocity = moveVector
    targetPart.AssemblyLinearVelocity = moveVector
end

local function onKeyDown(key)
    if key.KeyCode == Enum.KeyCode.W then keys.W = true end
    if key.KeyCode == Enum.KeyCode.A then keys.A = true end
    if key.KeyCode == Enum.KeyCode.S then keys.S = true end
    if key.KeyCode == Enum.KeyCode.D then keys.D = true end
    if key.KeyCode == Enum.KeyCode.Space then keys.Space = true end
    if key.KeyCode == Enum.KeyCode.LeftShift then keys.LeftShift = true end
end

local function onKeyUp(key)
    if key.KeyCode == Enum.KeyCode.W then keys.W = false end
    if key.KeyCode == Enum.KeyCode.A then keys.A = false end
    if key.KeyCode == Enum.KeyCode.S then keys.S = false end
    if key.KeyCode == Enum.KeyCode.D then keys.D = false end
    if key.KeyCode == Enum.KeyCode.Space then keys.Space = false end
    if key.KeyCode == Enum.KeyCode.LeftShift then keys.LeftShift = false end
end

local function cleanupBodyMovers()
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyAngularVelocity then bodyAngularVelocity:Destroy() bodyAngularVelocity = nil end
    currentTarget = nil
end

local function startFly()
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = RunService.Heartbeat:Connect(updateFly)
    UserInputService.InputBegan:Connect(onKeyDown)
    UserInputService.InputEnded:Connect(onKeyUp)

    local targetPart = getMainPart()
    if targetPart then
        createBodyMovers(targetPart)
    end
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    cleanupBodyMovers()
    keys = {W = false, A = false, S = false, D = false, Space = false, LeftShift = false}
end

localplayerTab:AddToggle({
    Name = "Ativar FLY",
    Default = false,
    Callback = function(value)
        flyEnabled = value
        if flyEnabled then
            startFly()
        else
            stopFly()
        end
    end
})

localplayerTab:AddSlider({
    Name = "Velocidade FLY",
    Min = 10,
    Max = 150,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 5,
    ValueName = "vel",
    Callback = function(value)
        flySpeed = value
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if flyEnabled then
        local targetPart = getMainPart()
        if targetPart then
            createBodyMovers(targetPart)
        end
    end
end)

--Super Pulo

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local superJumpEnabled = false
local jumpPower = 50 -- Valor padrão do Roblox

localplayerTab:AddParagraph(
    "Super Jump / High Jump",
    "Permite pular muito mais alto que o normal."
)

local function updateJumpPower()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            if superJumpEnabled then
                humanoid.JumpPower = jumpPower
            else
                humanoid.JumpPower = 50 -- Valor padrão
            end
        end
    end
end

localplayerTab:AddToggle({
    Name = "Ativar Super Jump",
    Default = false,
    Callback = function(Value)
        superJumpEnabled = Value
        updateJumpPower()
        
        if Value then
            OrionLib:MakeNotification({
                Name = "Super Jump",
                Content = "Super Jump ativado!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        else
            OrionLib:MakeNotification({
                Name = "Super Jump",
                Content = "Super Jump desativado!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

localplayerTab:AddSlider({
    Name = "Força do Pulo",
    Min = 50,
    Max = 500,
    Default = 150,
    Color = Color3.fromRGB(0, 255, 0),
    Increment = 10,
    ValueName = "força",
    Callback = function(Value)
        jumpPower = Value
        if superJumpEnabled then
            updateJumpPower()
        end
    end
})

-- Atualiza quando o jogador respawna
LocalPlayer.CharacterAdded:Connect(function()
    wait(1) -- Aguarda o character carregar completamente
    if superJumpEnabled then
        updateJumpPower()
    end
end)

-- Se já tem character quando o script roda
if LocalPlayer.Character then
    updateJumpPower()
end

--teste
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local originalAppearance = {}
local skinChangerEnabled = false

localplayerTab:AddParagraph(
    "Skin Changer / Outfit Editor",
    "Troque o visual do seu personagem em tempo real."
)

-- Salva a aparência original
local function saveOriginalAppearance()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local humanoidDescription = humanoid:GetAppliedDescription()
        
        originalAppearance = {
            HeadColor = humanoidDescription.HeadColor,
            TorsoColor = humanoidDescription.TorsoColor,
            LeftArmColor = humanoidDescription.LeftArmColor,
            RightArmColor = humanoidDescription.RightArmColor,
            LeftLegColor = humanoidDescription.LeftLegColor,
            RightLegColor = humanoidDescription.RightLegColor,
            Shirt = humanoidDescription.Shirt,
            Pants = humanoidDescription.Pants,
            TShirt = humanoidDescription.GraphicTShirt,
            Face = humanoidDescription.Face,
            Hat = humanoidDescription.HatAccessory,
            Hair = humanoidDescription.HairAccessory
        }
    end
end

-- Aplica mudanças de cor do corpo
local function applyBodyColors(headColor, torsoColor, leftArmColor, rightArmColor, leftLegColor, rightLegColor)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local humanoidDescription = humanoid:GetAppliedDescription()
        
        if headColor then humanoidDescription.HeadColor = headColor end
        if torsoColor then humanoidDescription.TorsoColor = torsoColor end
        if leftArmColor then humanoidDescription.LeftArmColor = leftArmColor end
        if rightArmColor then humanoidDescription.RightArmColor = rightArmColor end
        if leftLegColor then humanoidDescription.LeftLegColor = leftLegColor end
        if rightLegColor then humanoidDescription.RightLegColor = rightLegColor end
        
        humanoid:ApplyDescription(humanoidDescription)
    end
end

-- Aplica roupas
local function applyClothing(shirtId, pantsId, tshirtId)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        local humanoidDescription = humanoid:GetAppliedDescription()
        
        if shirtId then humanoidDescription.Shirt = shirtId end
        if pantsId then humanoidDescription.Pants = pantsId end
        if tshirtId then humanoidDescription.GraphicTShirt = tshirtId end
        
        humanoid:ApplyDescription(humanoidDescription)
    end
end

-- Restaura aparência original
local function restoreOriginalAppearance()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and originalAppearance.HeadColor then
        local humanoid = LocalPlayer.Character.Humanoid
        local humanoidDescription = humanoid:GetAppliedDescription()
        
        humanoidDescription.HeadColor = originalAppearance.HeadColor
        humanoidDescription.TorsoColor = originalAppearance.TorsoColor
        humanoidDescription.LeftArmColor = originalAppearance.LeftArmColor
        humanoidDescription.RightArmColor = originalAppearance.RightArmColor
        humanoidDescription.LeftLegColor = originalAppearance.LeftLegColor
        humanoidDescription.RightLegColor = originalAppearance.RightLegColor
        humanoidDescription.Shirt = originalAppearance.Shirt
        humanoidDescription.Pants = originalAppearance.Pants
        humanoidDescription.GraphicTShirt = originalAppearance.TShirt
        
        humanoid:ApplyDescription(humanoidDescription)
    end
end

-- Toggle principal
localplayerTab:AddToggle({
    Name = "Ativar Skin Changer",
    Default = false,
    Callback = function(Value)
        skinChangerEnabled = Value
        
        if Value then
            saveOriginalAppearance()
            OrionLib:MakeNotification({
                Name = "Skin Changer",
                Content = "Skin Changer ativado!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        else
            restoreOriginalAppearance()
            OrionLib:MakeNotification({
                Name = "Skin Changer",
                Content = "Aparência original restaurada!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

-- Cores predefinidas
local skinColors = {
    ["Pele Clara"] = Color3.fromRGB(255, 220, 177),
    ["Pele Média"] = Color3.fromRGB(215, 187, 123),
    ["Pele Escura"] = Color3.fromRGB(139, 69, 19),
    ["Azul"] = Color3.fromRGB(0, 162, 255),
    ["Verde"] = Color3.fromRGB(0, 255, 0),
    ["Vermelho"] = Color3.fromRGB(255, 0, 0),
    ["Rosa"] = Color3.fromRGB(255, 102, 204),
    ["Roxo"] = Color3.fromRGB(128, 0, 128),
    ["Amarelo"] = Color3.fromRGB(255, 255, 0),
    ["Preto"] = Color3.fromRGB(0, 0, 0),
    ["Branco"] = Color3.fromRGB(255, 255, 255)
}

local currentSkinColor = "Pele Clara"

localplayerTab:AddDropdown({
    Name = "Cor da Pele",
    Default = "Pele Clara",
    Options = {"Pele Clara", "Pele Média", "Pele Escura", "Azul", "Verde", "Vermelho", "Rosa", "Roxo", "Amarelo", "Preto", "Branco"},
    Callback = function(Value)
        if skinChangerEnabled then
            currentSkinColor = Value
            local color = skinColors[Value]
            applyBodyColors(color, color, color, color, color, color)
        end
    end
})

-- Botões para roupas predefinidas
localplayerTab:AddButton({
    Name = "Outfit Noob",
    Callback = function()
        if skinChangerEnabled then
            applyClothing(0, 0, 0) -- Remove todas as roupas
            OrionLib:MakeNotification({
                Name = "Outfit",
                Content = "Outfit Noob aplicado!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

localplayerTab:AddButton({
    Name = "Outfit Casual",
    Callback = function()
        if skinChangerEnabled then
            applyClothing(1031492563, 1235554709, 0) -- IDs de exemplo
            OrionLib:MakeNotification({
                Name = "Outfit",
                Content = "Outfit Casual aplicado!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

localplayerTab:AddButton({
    Name = "Outfit Formal",
    Callback = function()
        if skinChangerEnabled then
            applyClothing(1028595471, 1235554709, 0) -- IDs de exemplo
            OrionLib:MakeNotification({
                Name = "Outfit",
                Content = "Outfit Formal aplicado!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
})

-- Botão para copiar outfit de outro jogador
localplayerTab:AddTextbox({
    Name = "Nome do Jogador",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        if skinChangerEnabled and Value ~= "" then
            local targetPlayer = Players:FindFirstChild(Value)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
                local targetHumanoid = targetPlayer.Character.Humanoid
                local targetDescription = targetHumanoid:GetAppliedDescription()
                
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid:ApplyDescription(targetDescription)
                    OrionLib:MakeNotification({
                        Name = "Outfit Copiado",
                        Content = "Outfit de " .. Value .. " copiado!",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "Erro",
                    Content = "Jogador não encontrado!",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        end
    end
})

-- Botão para restaurar aparência
localplayerTab:AddButton({
    Name = "Restaurar Original",
    Callback = function()
        restoreOriginalAppearance()
        OrionLib:MakeNotification({
            Name = "Restaurado",
            Content = "Aparência original restaurada!",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
})

-- Salva aparência quando spawna
LocalPlayer.CharacterAdded:Connect(function()
    wait(2) -- Aguarda carregar
    saveOriginalAppearance()
end)

-- Se já tem character
if LocalPlayer.Character then
    saveOriginalAppearance()
end

--otimização
local otimizacaoTab = Window:MakeTab({
	Name = "otimização",
	Icon = "rbxassetid://",
	PremiumOnly = false
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local otimizacaoAtiva = false
local configuracaoOriginal = {}
local objetosRemovidos = {}
local conexoesOtimizacao = {}

local configOtimizacao = {
    removerTexturas = false,
    reduzirQualidade = false,
    desabilitarSombras = false,
    reduzirIluminacao = false,
    reduzirParticulas = false,
    desabilitarAnimacoes = false,
    otimizarMeshes = false,
    limparCache = false,
    limitarFPS = false,
    fpsAlvo = 60,
    limpezaAutomatica = false,
    intervaloLimpeza = 30,
    reducaoProfundidade = false,
    otimizarSons = false
}

local function salvarConfiguracaoOriginal()
    configuracaoOriginal.lighting = {
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ShadowSoftness = Lighting.ShadowSoftness,
        GlobalShadows = Lighting.GlobalShadows,
        Technology = Lighting.Technology,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart
    }
    
    configuracaoOriginal.rendering = {
        QualityLevel = settings().Rendering.QualityLevel,
        MeshPartDetailLevel = settings().Rendering.MeshPartDetailLevel,
        MaterialQuality = settings().Rendering.MaterialQuality,
        EnableFRM = settings().Rendering.EnableFRM,
        GraphicsMode = settings().Rendering.GraphicsMode
    }
end

local function otimizarIluminacao()
    if configOtimizacao.reduzirIluminacao then
        Lighting.GlobalShadows = false
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.Brightness = 0.5
        Lighting.Ambient = Color3.new(0.3, 0.3, 0.3)
        Lighting.OutdoorAmbient = Color3.new(0.3, 0.3, 0.3)
        Lighting.ShadowSoftness = 0
        Lighting.FogEnd = 100
        Lighting.FogStart = 0
    end
end

local function otimizarRenderizacao()
    if configOtimizacao.reduzirQualidade then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
        settings().Rendering.MaterialQuality = Enum.MaterialQuality.Level01
        settings().Rendering.EnableFRM = false
        settings().Rendering.GraphicsMode = Enum.GraphicsMode.NoGraphics
    end
end

local function otimizarTexturas(obj)
    if configOtimizacao.removerTexturas then
        pcall(function()
            if obj:IsA("Decal") then
                obj.Transparency = 1
                obj.Texture = "rbxasset://textures/face.png"
                obj.Color3 = Color3.new(0.5, 0.5, 0.5)
            elseif obj:IsA("Texture") then
                obj.Transparency = 1
                obj.Texture = ""
            elseif obj:IsA("SurfaceGui") then
                obj.Enabled = false
            elseif obj:IsA("BillboardGui") then
                obj.Enabled = false
            elseif obj:IsA("ScreenGui") then
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                        child.Image = ""
                        child.ImageTransparency = 1
                    end
                end
            end
            
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.Transparency = math.min(obj.Transparency + 0.1, 0.8)
            end
        end)
    end
end

local function otimizarParticulas(obj)
    if configOtimizacao.reduzirParticulas then
        pcall(function()
            if obj:IsA("ParticleEmitter") then
                obj.Enabled = false
                obj.Rate = 0
                obj:Clear()
            elseif obj:IsA("Fire") then
                obj.Enabled = false
                obj.Size = 0
                obj.Heat = 0
            elseif obj:IsA("Smoke") then
                obj.Enabled = false
                obj.Size = 0
                obj.Opacity = 0
            elseif obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("Explosion") then
                obj.Visible = false
                obj.BlastRadius = 1
                obj.BlastPressure = 0
            elseif obj:IsA("Trail") then
                obj.Enabled = false
                obj.Transparency = NumberSequence.new(1)
            elseif obj:IsA("Beam") then
                obj.Enabled = false
                obj.Transparency = NumberSequence.new(1)
            end
        end)
    end
end

local function otimizarSons(obj)
    if configOtimizacao.otimizarSons then
        pcall(function()
            if obj:IsA("Sound") then
                obj.Volume = math.min(obj.Volume * 0.3, 0.1)
                if obj.IsPlaying then
                    obj:Stop()
                end
                obj.SoundId = ""
            elseif obj:IsA("SoundGroup") then
                obj.Volume = 0.1
            end
        end)
    end
end

local function otimizarMeshes(obj)
    if configOtimizacao.otimizarMeshes then
        pcall(function()
            if obj:IsA("MeshPart") then
                obj.RenderFidelity = Enum.RenderFidelity.Performance
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
            elseif obj:IsA("SpecialMesh") then
                obj.Scale = obj.Scale * 0.7
                if obj.MeshType == Enum.MeshType.FileMesh then
                    obj.MeshId = ""
                    obj.TextureId = ""
                end
            elseif obj:IsA("BlockMesh") or obj:IsA("CylinderMesh") then
                obj.Scale = obj.Scale * 0.8
            end
        end)
    end
end

local function desabilitarAnimacoes(obj)
    if configOtimizacao.desabilitarAnimacoes then
        pcall(function()
            if obj:IsA("Humanoid") then
                for _, track in pairs(obj:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
                obj.PlatformStand = true
            elseif obj:IsA("AnimationTrack") then
                obj:Stop()
            elseif obj:IsA("TweenBase") then
                obj:Cancel()
            end
        end)
    end
end

local function reduzirProfundidade(obj)
    if configOtimizacao.reducaoProfundidade then
        pcall(function()
            if obj:IsA("BasePart") and camera then
                local distancia = (obj.Position - camera.CFrame.Position).Magnitude
                if distancia > 300 then
                    obj.Transparency = 0.9
                    obj.CanCollide = false
                elseif distancia > 150 then
                    obj.Transparency = 0.5
                    if obj.Material ~= Enum.Material.Plastic then
                        obj.Material = Enum.Material.Plastic
                    end
                end
            end
        end)
    end
end

local function processarObjeto(obj)
    if not obj or not obj.Parent then return end
    
    spawn(function()
        pcall(function()
            otimizarTexturas(obj)
            otimizarParticulas(obj)
            otimizarSons(obj)
            otimizarMeshes(obj)
            desabilitarAnimacoes(obj)
            reduzirProfundidade(obj)
        end)
    end)
end

local function processarWorkspace()
    spawn(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            processarObjeto(obj)
            wait()
        end
    end)
end

local function limpezaMemoria()
    spawn(function()
        pcall(function()
            collectgarbage("collect")
            
            for _, obj in pairs(Workspace:GetChildren()) do
                pcall(function()
                    if obj.Name:find("Effect") or obj.Name:find("Drop") or obj.Name:find("Debris") then
                        if obj:IsA("Model") or obj:IsA("Part") then
                            obj:Destroy()
                        end
                    end
                end)
            end
            
            for _, sound in pairs(SoundService:GetChildren()) do
                pcall(function()
                    if sound:IsA("Sound") and not sound.IsPlaying then
                        sound:Destroy()
                    end
                end)
            end
            
            ContentProvider:PreloadAsync({})
        end)
    end)
end

local function limitarFPS()
    if configOtimizacao.limitarFPS then
        spawn(function()
            while configOtimizacao.limitarFPS and otimizacaoAtiva do
                local startTime = tick()
                RunService.Heartbeat:Wait()
                local frameTime = tick() - startTime
                local targetFrameTime = 1 / configOtimizacao.fpsAlvo
                if frameTime < targetFrameTime then
                    wait(targetFrameTime - frameTime)
                end
            end
        end)
    end
end

local function monitorarPerformanceAutomatico()
    spawn(function()
        while otimizacaoAtiva do
            wait(3)
            pcall(function()
                local fps = workspace:GetRealPhysicsFPS()
                local memoria = Stats:GetTotalMemoryUsageMb()
                
                if fps < 20 then
                    configOtimizacao.reduzirQualidade = true
                    configOtimizacao.reduzirIluminacao = true
                    configOtimizacao.otimizarMeshes = true
                    otimizarRenderizacao()
                    otimizarIluminacao()
                    processarWorkspace()
                elseif memoria > 800 then
                    limpezaMemoria()
                end
            end)
        end
    end)
end

local function ativarOtimizacao()
    if otimizacaoAtiva then return end
    
    salvarConfiguracaoOriginal()
    otimizacaoAtiva = true
    
    if configOtimizacao.reduzirIluminacao then
        otimizarIluminacao()
    end
    
    if configOtimizacao.reduzirQualidade then
        otimizarRenderizacao()
    end
    
    processarWorkspace()
    
    if configOtimizacao.limpezaAutomatica then
        conexoesOtimizacao.limpeza = spawn(function()
            while otimizacaoAtiva and configOtimizacao.limpezaAutomatica do
                wait(configOtimizacao.intervaloLimpeza)
                limpezaMemoria()
            end
        end)
    end
    
    conexoesOtimizacao.novosObjetos = Workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if otimizacaoAtiva then
            processarObjeto(obj)
        end
    end)
    
    if configOtimizacao.limitarFPS then
        limitarFPS()
    end
    
    monitorarPerformanceAutomatico()
end

local function desativarOtimizacao()
    if not otimizacaoAtiva then return end
    
    otimizacaoAtiva = false
    
    for nome, conexao in pairs(conexoesOtimizacao) do
        pcall(function()
            if typeof(conexao) == "RBXScriptConnection" then
                conexao:Disconnect()
            end
        end)
    end
    conexoesOtimizacao = {}
    
    if configuracaoOriginal.lighting then
        for prop, valor in pairs(configuracaoOriginal.lighting) do
            pcall(function()
                Lighting[prop] = valor
            end)
        end
    end
    
    if configuracaoOriginal.rendering then
        for prop, valor in pairs(configuracaoOriginal.rendering) do
            pcall(function()
                settings().Rendering[prop] = valor
            end)
        end
    end
end

otimizacaoTab:AddToggle({
    Name = "Sistema Principal",
    Default = false,
    Callback = function(Value)
        if Value then
            ativarOtimizacao()
        else
            desativarOtimizacao()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Remover Texturas",
    Default = false,
    Callback = function(Value)
        configOtimizacao.removerTexturas = Value
        if otimizacaoAtiva then
            processarWorkspace()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Reduzir Qualidade",
    Default = false,
    Callback = function(Value)
        configOtimizacao.reduzirQualidade = Value
        if otimizacaoAtiva then
            otimizarRenderizacao()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Desabilitar Sombras",
    Default = false,
    Callback = function(Value)
        configOtimizacao.desabilitarSombras = Value
        configOtimizacao.reduzirIluminacao = Value
        if otimizacaoAtiva then
            otimizarIluminacao()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Reduzir Iluminacao",
    Default = false,
    Callback = function(Value)
        configOtimizacao.reduzirIluminacao = Value
        if otimizacaoAtiva then
            otimizarIluminacao()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Otimizar Particulas",
    Default = false,
    Callback = function(Value)
        configOtimizacao.reduzirParticulas = Value
        if otimizacaoAtiva then
            processarWorkspace()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Desabilitar Animacoes",
    Default = false,
    Callback = function(Value)
        configOtimizacao.desabilitarAnimacoes = Value
        if otimizacaoAtiva then
            processarWorkspace()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Otimizar Meshes",
    Default = false,
    Callback = function(Value)
        configOtimizacao.otimizarMeshes = Value
        if otimizacaoAtiva then
            processarWorkspace()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Otimizar Sons",
    Default = false,
    Callback = function(Value)
        configOtimizacao.otimizarSons = Value
        if otimizacaoAtiva then
            processarWorkspace()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Reducao Profundidade",
    Default = false,
    Callback = function(Value)
        configOtimizacao.reducaoProfundidade = Value
        if otimizacaoAtiva then
            processarWorkspace()
        end
    end
})

otimizacaoTab:AddToggle({
    Name = "Limpeza Automatica",
    Default = false,
    Callback = function(Value)
        configOtimizacao.limpezaAutomatica = Value
    end
})

otimizacaoTab:AddToggle({
    Name = "Limitar FPS",
    Default = false,
    Callback = function(Value)
        configOtimizacao.limitarFPS = Value
        if Value and otimizacaoAtiva then
            limitarFPS()
        end
    end
})

otimizacaoTab:AddSlider({
    Name = "FPS Alvo",
    Min = 15,
    Max = 120,
    Default = 60,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 5,
    ValueName = "FPS",
    Callback = function(Value)
        configOtimizacao.fpsAlvo = Value
    end    
})

otimizacaoTab:AddSlider({
    Name = "Intervalo Limpeza",
    Min = 10,
    Max = 120,
    Default = 30,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 5,
    ValueName = "segundos",
    Callback = function(Value)
        configOtimizacao.intervaloLimpeza = Value
    end    
})

otimizacaoTab:AddButton({
    Name = "Limpeza Manual",
    Callback = function()
        limpezaMemoria()
    end
})

otimizacaoTab:AddButton({
    Name = "Reset Configuracoes",
    Callback = function()
        desativarOtimizacao()
        wait(1)
        for key, _ in pairs(configOtimizacao) do
            if typeof(configOtimizacao[key]) == "boolean" then
                configOtimizacao[key] = false
            end
        end
        configOtimizacao.fpsAlvo = 60
        configOtimizacao.intervaloLimpeza = 30
    end
})

--Random Servidor
local randomTab = Window:MakeTab({
	Name = "Random Servidor",
	Icon = "rbxassetid://",
	PremiumOnly = false
})

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId

local function teleportToRandomServer()
    OrionLib:MakeNotification({
        Name = "Procurando...",
        Content = "Buscando servidor aleatório...",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
    
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = game:HttpGet(url)
        return HttpService:JSONDecode(response)
    end)
    
    if success and result and result.data then
        local servers = result.data
        local availableServers = {}
        
        for _, server in pairs(servers) do
            if server.playing and server.maxPlayers and server.id then
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(availableServers, server.id)
                end
            end
        end
        
        if #availableServers > 0 then
            local randomServerId = availableServers[math.random(1, #availableServers)]
            
            OrionLib:MakeNotification({
                Name = "Conectando...",
                Content = "Entrando em novo servidor!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            
            local teleportSuccess, teleportError = pcall(function()
                TeleportService:TeleportToPlaceInstance(PlaceId, randomServerId, game.Players.LocalPlayer)
            end)
            
            if not teleportSuccess then
                OrionLib:MakeNotification({
                    Name = "Erro",
                    Content = "Falha ao conectar no servidor.",
                    Image = "rbxassetid://4483345998",
                    Time = 4
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Sem Servidores",
                Content = "Nenhum servidor com vaga encontrado.",
                Image = "rbxassetid://4483345998",
                Time = 4
            })
        end
    else
        OrionLib:MakeNotification({
            Name = "Erro",
            Content = "Falha ao buscar servidores.",
            Image = "rbxassetid://4483345998",
            Time = 4
        })
    end
end

randomTab:AddButton({
    Name = "Servidor Aleatório",
    Callback = function()
        teleportToRandomServer()
    end
})
