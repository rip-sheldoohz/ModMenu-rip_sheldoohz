local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "EcoHub - Brainrot Otimização", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "EcoHubBrainrot"
})

--Local Player
local LocalPlayerTab = Window:MakeTab({
	Name = "Local Player",
	PremiumOnly = false
})

--Bypass
LocalPlayerTab:AddLabel("System Bypass - Roube Um Brainrot")

LocalPlayerTab:AddToggle({
    Name = "Bypass",
    Default = true,
    Save = true,
    Flag = "bypass_toggle",
    Callback = function(Value)
        if Value then
            local function obfuscateName()
                local chars = {"Game", "Ui", "System", "Tool", "Helper", "Manager", "Handler", "Controller", "Service", "Module", "Core", "Main"}
                local nums = tostring(math.random(1000, 9999))
                local extras = {"_" .. tostring(tick()):sub(-3), "_Secure", "_Protected", "_Hidden"}
                return chars[math.random(#chars)] .. nums .. extras[math.random(#extras)]
            end

            local function safeGetService(serviceName)
                local success, service = pcall(function()
                    return game:GetService(serviceName)
                end)
                return success and service or nil
            end

            local Services = {
                Players = safeGetService("Players"),
                RunService = safeGetService("RunService"),
                TeleportService = safeGetService("TeleportService"),
                UserInputService = safeGetService("UserInputService"),
                TweenService = safeGetService("TweenService"),
                ReplicatedStorage = safeGetService("ReplicatedStorage"),
                Lighting = safeGetService("Lighting"),
                StarterPlayer = safeGetService("StarterPlayer"),
                GuiService = safeGetService("GuiService"),
                CoreGui = safeGetService("CoreGui"),
                HttpService = safeGetService("HttpService")
            }

            if not Services.Players then
                return
            end

            local player = Services.Players.LocalPlayer
            if not player then
                return
            end

            local function safeDestroy(obj)
                pcall(function()
                    if obj and obj.Parent then
                        if obj.ClassName == "LocalScript" or obj.ClassName == "Script" or obj.ClassName == "ModuleScript" then
                            obj.Disabled = true
                            task.wait(0.1)
                        end
                        obj:Destroy()
                    end
                end)
            end

            local function cleanupDetection()
                local detectores = {
                    "anticheat", "ac", "detection", "monitor", "guard", "security",
                    "detector", "scanner", "watcher", "tracker", "observer", "logger",
                    "reporter", "checker", "validator", "inspector", "auditor", "sentinel",
                    "firewall", "shield", "protection", "defense", "barrier"
                }
                
                local suspicious = {
                    "admin", "mod", "staff", "detect", "anti", "cheat",
                    "hack", "exploit", "script", "monitor", "security", "ban",
                    "kick", "warn", "alert", "notify", "log", "report"
                }
                
                local function containsSuspicious(name, wordList)
                    if name and type(name) == "string" and wordList then
                        local lowerName = string.lower(name)
                        for i = 1, #wordList do
                            if wordList[i] and string.find(lowerName, string.lower(wordList[i]), 1, true) then
                                return true
                            end
                        end
                    end
                    return false
                end
                
                local objectsToRemove = {}
                
                pcall(function()
                    local descendants = game:GetDescendants()
                    for i = 1, #descendants do
                        if i % 100 == 0 then
                            task.wait(0.05)
                        end
                        
                        local obj = descendants[i]
                        if obj and obj.Parent then
                            pcall(function()
                                local className = obj.ClassName
                                if className == "LocalScript" or className == "Script" or className == "ModuleScript" then
                                    if containsSuspicious(obj.Name, detectores) then
                                        objectsToRemove[#objectsToRemove + 1] = obj
                                    end
                                end
                            end)
                        end
                    end
                end)
                
                for i = 1, #objectsToRemove do
                    if i % 3 == 0 then
                        task.wait(0.1)
                    end
                    safeDestroy(objectsToRemove[i])
                end
                
                pcall(function()
                    if Services.Players then
                        local players = Services.Players:GetPlayers()
                        for i = 1, #players do
                            local targetPlayer = players[i]
                            if targetPlayer and targetPlayer.PlayerGui then
                                local guis = targetPlayer.PlayerGui:GetChildren()
                                for j = 1, #guis do
                                    local gui = guis[j]
                                    if gui and containsSuspicious(gui.Name, suspicious) then
                                        safeDestroy(gui)
                                    end
                                end
                            end
                        end
                    end
                end)
            end

            task.spawn(function()
                task.wait(3)
                pcall(cleanupDetection)
            end)

            local lastMonitorCheck = tick()
            local MONITOR_INTERVAL = 15
            local isCurrentlyMonitoring = false
            local protectionActive = true

            local function lightweightMonitor()
                if isCurrentlyMonitoring or not protectionActive then
                    return
                end
                
                local currentTime = tick()
                if currentTime - lastMonitorCheck < MONITOR_INTERVAL then
                    return
                end
                
                isCurrentlyMonitoring = true
                lastMonitorCheck = currentTime
                
                task.spawn(function()
                    pcall(function()
                        local suspiciousObjects = {}
                        local descendants = game:GetDescendants()
                        local maxCheck = math.min(#descendants, 150)
                        
                        for i = 1, maxCheck do
                            if i % 25 == 0 then
                                task.wait(0.03)
                            end
                            
                            local obj = descendants[i]
                            pcall(function()
                                if obj and obj.Parent and obj.Name then
                                    local lowerName = string.lower(obj.Name)
                                    if string.find(lowerName, "anticheat", 1, true) or 
                                       string.find(lowerName, "detection", 1, true) or 
                                       string.find(lowerName, "monitor", 1, true) or
                                       string.find(lowerName, "security", 1, true) or
                                       string.find(lowerName, "sentinel", 1, true) then
                                        suspiciousObjects[#suspiciousObjects + 1] = obj
                                    end
                                end
                            end)
                        end
                        
                        for i = 1, #suspiciousObjects do
                            safeDestroy(suspiciousObjects[i])
                            task.wait(0.1)
                        end
                    end)
                    
                    isCurrentlyMonitoring = false
                end)
            end

            if Services.RunService then
                Services.RunService.Heartbeat:Connect(function()
                    pcall(lightweightMonitor)
                end)
            end

            if Services.Players then
                Services.Players.PlayerAdded:Connect(function(newPlayer)
                    pcall(function()
                        if newPlayer then
                            task.spawn(function()
                                task.wait(5)
                                
                                pcall(function()
                                    if newPlayer.PlayerGui then
                                        local guis = newPlayer.PlayerGui:GetChildren()
                                        for i = 1, #guis do
                                            local gui = guis[i]
                                            pcall(function()
                                                if gui and gui.Name then
                                                    local lowerGuiName = string.lower(gui.Name)
                                                    if string.find(lowerGuiName, "admin", 1, true) or 
                                                       string.find(lowerGuiName, "mod", 1, true) or 
                                                       string.find(lowerGuiName, "detect", 1, true) or
                                                       string.find(lowerGuiName, "anti", 1, true) then
                                                        safeDestroy(gui)
                                                    end
                                                end
                                            end)
                                        end
                                    end
                                end)
                            end)
                        end
                    end)
                end)
            end
            
            task.spawn(function()
                while protectionActive do
                    task.wait(10)
                    pcall(function()
                        if player and player.PlayerGui then
                            for _, gui in pairs(player.PlayerGui:GetChildren()) do
                                if gui.Name:find("Orion") or gui.Name:find("EcoHub") then
                                    if gui:FindFirstChild("Main") then
                                        gui.Main.Visible = true
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

--Anti-Afk
LocalPlayerTab:AddParagraph("Sistema Anti-AFK","Ativa movimento automático para evitar AFK")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid")
local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")

local antiAfkEnabled = false
local moveTask = nil

local function updateRefs(char)
    humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart")
end

player.CharacterAdded:Connect(function(char)
    character = char
    updateRefs(char)
end)

local function isMoving()
    if hrp then
        return hrp.Velocity.Magnitude > 0.1
    end
    return false
end

local function tryTeleportStep(moveVec)
    if not hrp then return end
    pcall(function()
        hrp.CFrame = hrp.CFrame + (moveVec.Unit * 1)
    end)
end

local function startAntiAfk()
    if moveTask then return end
    moveTask = task.spawn(function()
        while antiAfkEnabled do
            if humanoid and hrp and humanoid.Parent then
                local dir = math.random(1,4)
                local moveVec
                if dir == 1 then moveVec = Vector3.new(1,0,0)
                elseif dir == 2 then moveVec = Vector3.new(-1,0,0)
                elseif dir == 3 then moveVec = Vector3.new(0,0,1)
                else moveVec = Vector3.new(0,0,-1) end

                local t0 = tick()
                while tick() - t0 < 1 and antiAfkEnabled do
                    pcall(function() humanoid:Move(moveVec, true) end)
                    RunService.Heartbeat:Wait()
                end

                pcall(function() humanoid:Move(Vector3.new(0,0,0), true) end)

                if not isMoving() then
                    pcall(function() humanoid:MoveTo(hrp.Position + moveVec * 3) end)
                    local t1 = tick()
                    while tick() - t1 < 0.8 and not isMoving() and antiAfkEnabled do
                        RunService.Heartbeat:Wait()
                    end
                    if not isMoving() then
                        tryTeleportStep(moveVec)
                    end
                end

                task.wait(0.15)
            else
                task.wait(0.5)
            end
        end
        moveTask = nil
    end)
end

local function stopAntiAfk()
    antiAfkEnabled = false
    if humanoid then
        pcall(function() humanoid:Move(Vector3.new(0,0,0), true) end)
    end
end

LocalPlayerTab:AddToggle({
    Name = "Anti-AFK (NEW)",
    Default = false,
    Callback = function(Value)
        antiAfkEnabled = Value
        if Value then
            startAntiAfk()
        else
            stopAntiAfk()
        end
    end
})

--Evento Normal
local NormalTab = Window:MakeTab({
	Name = "Evento Normal",
	PremiumOnly = false
})

NormalTab:AddParagraph(
    "Gerenciador Workspace -- Evento Normal", 
    "Descrição: remove coisas dentro da pasta (Folder)"
)

--Remover Audio
NormalTab:AddToggle({
    Name = "Remover Sounds",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("Sounds")
            
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: Sounds")
            else
                print("[EcoHub] Pasta não encontrada: Sounds")
            end
        end
    end
})

NormalTab:AddToggle({
    Name = "Remover ToolsAdds",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("ToolsAdds")
            
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: ToolsAdds")
            else
                print("[EcoHub] Pasta não encontrada: ToolsAdds")
            end
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

NormalTab:AddToggle({
    Name = "Remover PathfindingRegions",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("PathfindingRegions")
            
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: PathfindingRegions")
            else
                print("[EcoHub] Pasta não encontrada: PathfindingRegions")
            end
        end
    end
})

NormalTab:AddToggle({
    Name = "Remover Events",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("Events")
            
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: Events")
            else
                print("[EcoHub] Pasta não encontrada: Events")
            end
        end
    end
})

NormalTab:AddToggle({
    Name = "Remover SonsAnon (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("SonsAnon")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: SonsAnon")
            else
                print("[EcoHub] Pasta não encontrada: SonsAnon")
            end
        end
    end
})

NormalTab:AddToggle({
    Name = "Remover RainWeather (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("RainWeather")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
            end
        end
    end
})

NormalTab:AddToggle({
    Name = "Remover Road (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("Road")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
            end
        end
    end
})

NormalTab:AddToggle({
    Name = "Remover Map (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local mapFolder = ws:FindFirstChild("Map")
            if mapFolder and mapFolder:IsA("Folder") then
                local objectsToRemove = {"Banners", "Nature", "Misc", "Fences", "DecorativeWall", "mexicanserver", "WallRoaches"}
                for _, objectName in ipairs(objectsToRemove) do
                    local obj = mapFolder:FindFirstChild(objectName)
                    if obj then
                        obj:Destroy()
                    end
                end
            end
        end
    end
})

NormalTab:AddLabel("Deseja Remover Roleta Galaxy")

NormalTab:AddToggle({
    Name = "Remover GalaxySpinWheels (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("GalaxySpinWheels")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: GalaxySpinWheels")
            else
                print("[EcoHub] Pasta não encontrada: GalaxySpinWheels")
            end
        end
    end
})

--Evento Galaxy
local EventoGalaxyTab = Window:MakeTab({
	Name = "Evento Galaxy",
	PremiumOnly = false
})

EventoGalaxyTab:AddParagraph(
    "Gerenciador Workspace -- Evento Galaxy", 
    "Descrição: remove coisas dentro da pasta (Folder)"
)

--GalaxyWeather
EventoGalaxyTab:AddToggle({
    Name = "Remover GalaxyWeather (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("GalaxyWeather")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: GalaxyWeather")
            else
                print("[EcoHub] Pasta não encontrada: GalaxyWeather")
            end
        end
    end
})

--GalaxyMap
EventoGalaxyTab:AddToggle({
    Name = "Remover GalaxyMap (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("GalaxyMap")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: GalaxyMap")
            else
                print("[EcoHub] Pasta não encontrada: GalaxyMap")
            end
        end
    end
})

--Evento Snow
local EventoSnowTab = Window:MakeTab({
	Name = "Evento Snow",
	PremiumOnly = false
})

EventoSnowTab:AddParagraph(
    "Gerenciador Workspace -- Evento Snow (NEVE)", 
    "Descrição: remove coisas dentro da pasta (Folder)"
)

--StarfallWeather
EventoSnowTab:AddToggle({
    Name = "Remover StarfallWeather (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("StarfallWeather")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: StarfallWeather")
            else
                print("[EcoHub] Pasta não encontrada: StarfallWeather")
            end
        end
    end
})

--SnowWeather
EventoSnowTab:AddToggle({
    Name = "Remover SnowWeather (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("SnowWeather")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: SnowWeather")
            else
                print("[EcoHub] Pasta não encontrada: SnowWeather")
            end
        end
    end
})

--Piles
EventoSnowTab:AddToggle({
    Name = "Remover Piles (UPDATE)",
    Default = false,
    Callback = function(Value)
        if Value then
            local ws = game:GetService("Workspace")
            local folder = ws:FindFirstChild("Piles")
            if folder and folder:IsA("Folder") then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                end
                print("[EcoHub] Objetos removidos da pasta: Piles")
            else
                print("[EcoHub] Pasta não encontrada: Piles")
            end
        end
    end
})

local EventoScriptTab = Window:MakeTab({
    Name = "Script Premium",
    PremiumOnly = false
})

EventoScriptTab:AddLabel("Status: Lennon Hub Online")

EventoScriptTab:AddParagraph("Informações do Script","Este script ativa o Lennon Hub, uma ferramenta avançada de automação e otimização. Certifique-se de estar em um ambiente compatível antes de executar.")

EventoScriptTab:AddButton({
    Name = "Ativar Lennon Hub",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "EcoHub - Script",
            Content = "Executando Lennon Hub... Aguarde",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/MJw2J4T6/raw"))()
        end)
        
        if success then
            OrionLib:MakeNotification({
                Name = "EcoHub - Sucesso",
                Content = "Lennon Hub ativado com sucesso",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "EcoHub - Erro",
                Content = "Falha ao executar o script",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

EventoScriptTab:AddLabel("Status: Miranda Hub Online")

EventoScriptTab:AddParagraph("Informações do Script","Este botão executa o Miranda Hub, um script poderoso focado em automação, otimização e melhorias de gameplay. Use com responsabilidade.")

EventoScriptTab:AddButton({
    Name = "Ativar Miranda Hub",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "EcoHub - Script",
            Content = "Executando Miranda Hub... Aguarde",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/JJVhs3rK/raw"))()
        end)
        
        if success then
            OrionLib:MakeNotification({
                Name = "EcoHub - Sucesso",
                Content = "Miranda Hub ativado com sucesso",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "EcoHub - Erro",
                Content = "Falha ao executar o script",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

--Status (:
local EventoStatusTab = Window:MakeTab({
    Name = "Status",
    PremiumOnly = false
})

local tempoInicio = tick()
local player = game.Players.LocalPlayer

local function obterTempoFormatado(segundos)
    local horas = math.floor(segundos / 3600)
    local minutos = math.floor((segundos % 3600) / 60)
    local segs = math.floor(segundos % 60)
    
    if horas > 0 then
        return horas .. "h " .. minutos .. "m " .. segs .. "s"
    elseif minutos > 0 then
        return minutos .. "m " .. segs .. "s"
    else
        return segs .. "s"
    end
end

EventoStatusTab:AddLabel("Status do Jogador")

local tempoLabel = EventoStatusTab:AddLabel("Tempo de Uso: Carregando...")
local usuarioLabel = EventoStatusTab:AddLabel("Usuario: " .. player.Name)
local nomeLabel = EventoStatusTab:AddLabel("Nome: " .. player.DisplayName)
local idLabel = EventoStatusTab:AddLabel("ID: " .. player.UserId)
local idadeLabel = EventoStatusTab:AddLabel("Idade: " .. player.AccountAge .. " dias")
local playersLabel = EventoStatusTab:AddLabel("Jogadores: Carregando...")

coroutine.wrap(function()
    while true do
        wait(1)
        
        local tempoDeUso = math.floor(tick() - tempoInicio)
        local playersOnline = #game.Players:GetPlayers()
        local maxPlayers = game.Players.MaxPlayers
        
        tempoLabel:Set("Tempo de Uso: " .. obterTempoFormatado(tempoDeUso))
        playersLabel:Set("Jogadores: " .. playersOnline .. "/" .. maxPlayers)
    end
end)()
