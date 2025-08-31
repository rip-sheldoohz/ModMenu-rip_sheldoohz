local function obfuscateName()
    local chars = {"Game", "Ui", "System", "Tool", "Helper", "Manager", "Handler", "Controller"}
    local nums = tostring(math.random(1000, 9999))
    return chars[math.random(#chars)] .. nums
end

local guiName = obfuscateName()
local mainFrameName = obfuscateName()
local scriptName = obfuscateName()

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
    GuiService = safeGetService("GuiService")
}

if not Services.Players then
    return
end

local player = Services.Players.LocalPlayer
if not player then
    return
end

local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

local isMobile = false
pcall(function()
    if Services.GuiService and Services.UserInputService then
        isMobile = Services.GuiService:IsTenFootInterface() or Services.UserInputService.TouchEnabled
    end
end)

local function safeDestroy(obj)
    pcall(function()
        if obj and obj.Parent then
            if obj.ClassName == "LocalScript" or obj.ClassName == "Script" or obj.ClassName == "ModuleScript" then
                obj.Disabled = true
                wait(0.1)
            end
            obj:Destroy()
        end
    end)
end

local function cleanupDetection()
    local detectores = {
        "anticheat", "ac", "detection", "monitor", "guard", "security",
        "detector", "scanner", "watcher", "tracker", "observer", "logger",
        "reporter", "checker", "validator", "inspector", "auditor"
    }
    
    local suspicious = {
        "admin", "mod", "staff", "detect", "anti", "cheat",
        "hack", "exploit", "script", "monitor", "security"
    }
    
    local function containsSuspicious(name, wordList)
        pcall(function()
            if name and type(name) == "string" and wordList then
                local lowerName = string.lower(name)
                for i = 1, #wordList do
                    if wordList[i] and string.find(lowerName, string.lower(wordList[i]), 1, true) then
                        return true
                    end
                end
            end
        end)
        return false
    end
    
    local objectsToRemove = {}
    
    pcall(function()
        local descendants = game:GetDescendants()
        for i = 1, #descendants do
            if i % 100 == 0 then
                wait(0.05)
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
            wait(0.1)
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
    wait(3)
    pcall(cleanupDetection)
end)

local lastMonitorCheck = tick()
local MONITOR_INTERVAL = 20
local isCurrentlyMonitoring = false

local function lightweightMonitor()
    if isCurrentlyMonitoring then
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
            local maxCheck = math.min(#descendants, 100)
            
            for i = 1, maxCheck do
                if i % 25 == 0 then
                    wait(0.05)
                end
                
                local obj = descendants[i]
                pcall(function()
                    if obj and obj.Parent and obj.Name then
                        local lowerName = string.lower(obj.Name)
                        if string.find(lowerName, "anticheat", 1, true) or 
                           string.find(lowerName, "detection", 1, true) or 
                           string.find(lowerName, "monitor", 1, true) then
                            suspiciousObjects[#suspiciousObjects + 1] = obj
                        end
                    end
                end)
            end
            
            for i = 1, #suspiciousObjects do
                safeDestroy(suspiciousObjects[i])
                wait(0.15)
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
                    wait(5)
                    
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
                                           string.find(lowerGuiName, "detect", 1, true) then
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

print("Sistema carregado com seguranca total")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--Exemplo
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

local Window = Rayfield:CreateWindow({
   Name = "EcoHub - CounterBlox V1",
   Icon = 0,
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "EcoHub - CounterBlox V1",
      Subtitle = "Key System",
      Note = "Use a chave para acessar o painel",
      FileName = "CounterBloxV1",
      SaveKey = false,
      GrabKeyFromSite = true,
      Key = {"CounterBloxV1"}
   }
})

-- Dependências
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Tab
local CounterBloxTabAimbot1 = Window:CreateTab("Aimbot - Counter Blox")

-- Configurações padrão
local AimbotAtivo = false
local FOVSize = 300
local SmoothnessFactor = 0.25
local MaxWorldDistance = 2000
local LockedTarget = nil
local MiraModo = "Head" -- Head, Torso, ClosestPart

-- Parágrafo informativo
CounterBloxTabAimbot1:CreateParagraph({
    Title = "Modo Aimbot",
    Content = "Esse aimbot mira automaticamente em inimigos visíveis dentro do FOV. Modos disponíveis: Cabeça, Torso ou Parte mais próxima."
})

-- Função para checar se o alvo é válido
local function IsTargetValid(plr)
    if not plr or plr == LocalPlayer then return false end
    local char = plr.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    local part = (MiraModo == "Torso" and char:FindFirstChild("HumanoidRootPart")) or char:FindFirstChild("Head")
    if not part then return false end

    if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then return false end

    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}

    local rayResult = Workspace:Raycast(origin, direction, rayParams)
    if rayResult and rayResult.Instance and not part:IsDescendantOf(rayResult.Instance.Parent) then
        return false
    end

    return true
end

-- Alvo mais próximo com base no FOV
local function GetClosestEnemy()
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local closest, shortestDist = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsTargetValid(plr) then
            local char = plr.Character
            local part =
                (MiraModo == "Torso" and char:FindFirstChild("HumanoidRootPart")) or
                (MiraModo == "ClosestPart" and char:GetChildren()[1]) or
                char:FindFirstChild("Head")

            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                local worldDist = (Camera.CFrame.Position - part.Position).Magnitude

                if onScreen and dist < shortestDist and dist <= FOVSize and worldDist <= MaxWorldDistance then
                    shortestDist = dist
                    closest = plr
                end
            end
        end
    end

    return closest
end

-- Loop de atualização
RunService.RenderStepped:Connect(function()
    if not AimbotAtivo then
        LockedTarget = nil
        return
    end

    if not LockedTarget or not IsTargetValid(LockedTarget) then
        LockedTarget = GetClosestEnemy()
    end

    if LockedTarget and IsTargetValid(LockedTarget) then
        local char = LockedTarget.Character
        local aimPart = (MiraModo == "Torso" and char:FindFirstChild("HumanoidRootPart")) or char:FindFirstChild("Head")
        if aimPart then
            local desired = CFrame.new(Camera.CFrame.Position, aimPart.Position)
            Camera.CFrame = Camera.CFrame:Lerp(desired, SmoothnessFactor)
        end
    end
end)

-- Interface
CounterBloxTabAimbot1:CreateToggle({
    Name = "Aimbot (Visível)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(v)
        AimbotAtivo = v
        Rayfield:Notify({
            Title = "Aimbot",
            Content = v and "Aimbot ativado" or "Aimbot desativado",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

CounterBloxTabAimbot1:CreateDropdown({
    Name = "Modo de Mira",
    Options = {"Head", "Torso", "ClosestPart"},
    CurrentOption = "Head",
    Flag = "AimMode",
    Callback = function(v)
        MiraModo = v
    end,
})

CounterBloxTabAimbot1:CreateSlider({
    Name = "FOV (px)",
    Range = {100, 500},
    Increment = 10,
    CurrentValue = FOVSize,
    Flag = "AimbotFOV",
    Callback = function(v)
        FOVSize = v
    end,
})

CounterBloxTabAimbot1:CreateSlider({
    Name = "Suavidade",
    Range = {0, 0.6},
    Increment = 0.01,
    CurrentValue = SmoothnessFactor,
    Flag = "AimbotSmoothness",
    Callback = function(v)
        SmoothnessFactor = v
    end,
})

CounterBloxTabAimbot1:CreateSlider({
    Name = "Alcance (studs)",
    Range = {500, 3000},
    Increment = 50,
    CurrentValue = MaxWorldDistance,
    Flag = "AimbotWorldRange",
    Callback = function(v)
        MaxWorldDistance = v
    end,
})


-- Página ESP
local CounterBloxTabEsp = Window:CreateTab("ESP - Counter Blox")

--ESP ARMAS
CounterBloxTabEsp:CreateParagraph({
    Title = "Sistema de ESP para Armas",
    Content = "Ative este recurso para visualizar armas espalhadas no mapa, mesmo através das paredes, facilitando a coleta e localização durante a partida."
})

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local MAX_DISTANCE = 300
local UPDATE_INTERVAL = 0.1
local espObjects = {}
local lastUpdate = 0
local espEnabled = false
local espColor = Color3.fromRGB(255, 255, 255)

local function isWeapon(obj)
    if obj.ClassName == "Tool" then return true end
    if obj.ClassName == "Model" and obj:FindFirstChild("Handle") then return true end
    if obj.ClassName == "Part" or obj.ClassName == "MeshPart" then return true end
    return false
end

local function getMainPart(obj)
    if obj.ClassName == "Tool" then
        return obj:FindFirstChild("Handle")
    elseif obj.ClassName == "Model" then
        return obj.PrimaryPart or obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
    elseif obj.ClassName == "Part" or obj.ClassName == "MeshPart" then
        return obj
    end
    return nil
end

local function createWeaponESP(obj)
    local mainPart = getMainPart(obj)
    if not mainPart then return nil end
    
    local gui = Instance.new("BillboardGui")
    gui.Name = "WeaponESP"
    gui.Adornee = mainPart
    gui.Size = UDim2.new(0, 80, 0, 22)
    gui.StudsOffset = Vector3.new(0, 0.5, 0)
    gui.AlwaysOnTop = false
    gui.Parent = obj
    gui.Enabled = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.65, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = obj.Name
    nameLabel.TextColor3 = espColor
    nameLabel.TextScaled = false
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextStrokeTransparency = 0.2
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Parent = gui
    
    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(1, 0, 0.35, 0)
    distanceLabel.Position = UDim2.new(0, 0, 0.65, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text = "0m"
    distanceLabel.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    distanceLabel.TextScaled = false
    distanceLabel.TextSize = 7
    distanceLabel.Font = Enum.Font.SourceSans
    distanceLabel.TextStrokeTransparency = 0.4
    distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distanceLabel.Parent = gui
    
    return {
        gui = gui,
        nameLabel = nameLabel,
        distanceLabel = distanceLabel,
        object = obj,
        mainPart = mainPart
    }
end

local function updateWeaponESP(espData)
    if not espData.object or not espData.object.Parent then
        return false
    end
    
    if not espData.mainPart or not espData.mainPart.Parent then
        return false
    end
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return true
    end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    local objectPos = espData.mainPart.Position
    local distance = (playerPos - objectPos).Magnitude
    
    if distance > MAX_DISTANCE then
        espData.gui.Enabled = false
        return true
    end
    
    local eyePos = player.Character.Head.Position
    local objectPos = espData.mainPart.Position
    
    if not hasLineOfSight(eyePos, objectPos) then
        espData.gui.Enabled = false
        return true
    end
    
    espData.gui.Enabled = espEnabled
    espData.distanceLabel.Text = math.floor(distance) .. "m"
    espData.nameLabel.TextColor3 = espColor
    
    local alpha = math.max(0.5, 1 - distance/MAX_DISTANCE)
    espData.nameLabel.TextTransparency = 1 - alpha
    espData.distanceLabel.TextTransparency = 1 - (alpha * 0.8)
    
    return true
end

local function scanWeapons()
    local debris = Workspace:FindFirstChild("Debris")
    if not debris then return end
    
    for _, obj in pairs(debris:GetChildren()) do
        local objId = tostring(obj)
        local alreadyExists = false
        
        for _, espData in pairs(espObjects) do
            if espData.object == obj then
                alreadyExists = true
                break
            end
        end
        
        if not alreadyExists and isWeapon(obj) then
            local espData = createWeaponESP(obj)
            if espData then
                table.insert(espObjects, espData)
            end
        end
    end
end

local function mainUpdate()
    local currentTime = tick()
    if currentTime - lastUpdate < UPDATE_INTERVAL then return end
    lastUpdate = currentTime
    
    for i = #espObjects, 1, -1 do
        local espData = espObjects[i]
        if not updateWeaponESP(espData) then
            if espData.gui and espData.gui.Parent then
                espData.gui:Destroy()
            end
            table.remove(espObjects, i)
        end
    end
    
    scanWeapons()
end

local function clearAllESPs()
    for _, espData in pairs(espObjects) do
        if espData.gui and espData.gui.Parent then
            espData.gui:Destroy()
        end
    end
    espObjects = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "WeaponESP" then
            pcall(function() obj:Destroy() end)
        end
    end
end

local function updateAllColors(newColor)
    espColor = newColor
    for _, espData in pairs(espObjects) do
        if espData.nameLabel then
            espData.nameLabel.TextColor3 = newColor
        end
    end
end

local function toggleESP(enabled)
    espEnabled = enabled
    
    if enabled then
        scanWeapons()
    else
        for _, espData in pairs(espObjects) do
            if espData.gui then
                espData.gui.Enabled = false
            end
        end
    end
end

local connection = RunService.Heartbeat:Connect(mainUpdate)

scanWeapons()

CounterBloxTabEsp:CreateToggle({
    Name = "ESP ARMAS",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        toggleESP(Value)
    end,
})

CounterBloxTabEsp:CreateColorPicker({
    Name = "ALTERAR COR ESP ARMAS",
    Color = Color3.fromRGB(255, 255, 255),
    Flag = "ColorPicker1",
    Callback = function(Value)
        updateAllColors(Value)
    end
})

local debris = Workspace:FindFirstChild("Debris")
if debris then
    debris.ChildAdded:Connect(function(child)
        wait(0.05)
        if isWeapon(child) then
            local espData = createWeaponESP(child)
            if espData then
                table.insert(espObjects, espData)
            end
        end
    end)
    
    debris.ChildRemoved:Connect(function(child)
        for i = #espObjects, 1, -1 do
            if espObjects[i].object == child then
                if espObjects[i].gui then
                    espObjects[i].gui:Destroy()
                end
                table.remove(espObjects, i)
                break
            end
        end
    end)
end

--ESP PLAYER
CounterBloxTabEsp:CreateParagraph({
    Title = "Sistema de ESP para Jogadores",
    Content = "Ative este recurso para visualizar os inimigos através das paredes, facilitando a localização e o acompanhamento durante a partida."
})

local ESPEnabled = false
local EnemyColor = Color3.fromRGB(255, 50, 50)
local Highlights = {}

local function IsSameTeam(player1, player2)
    if not player1 or not player2 then return false end
    if player1.Team and player2.Team then
        return player1.Team == player2.Team
    end
    return false
end

local function CreateESP(player)
    if not player.Character or player == game.Players.LocalPlayer then return end
    if IsSameTeam(player, game.Players.LocalPlayer) then return end

    if Highlights[player] then Highlights[player]:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.FillColor = EnemyColor
    highlight.OutlineColor = EnemyColor

    Highlights[player] = highlight
end

local function UpdateESP()
    for player, highlight in pairs(Highlights) do
        if highlight then highlight:Destroy() end
    end
    Highlights = {}

    if not ESPEnabled then return end
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            CreateESP(player)
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then task.wait(1) CreateESP(player) end
    end)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if ESPEnabled then task.wait(0.5) UpdateESP() end
    end)
end)

for _, player in ipairs(game.Players:GetPlayers()) do
    if player.Character then
        player.CharacterAdded:Connect(function()
            if ESPEnabled then task.wait(1) CreateESP(player) end
        end)
    end
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if ESPEnabled then task.wait(0.5) UpdateESP() end
    end)
end

game.Players.LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    if ESPEnabled then task.wait(0.5) UpdateESP() end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if ESPEnabled then UpdateESP() end
end)

CounterBloxTabEsp:CreateToggle({
    Name = "ESP PLAYERS",
    CurrentValue = false,
    Flag = "ESP_CS",
    Callback = function(Value)
        ESPEnabled = Value
        UpdateESP()
    end,
})

CounterBloxTabEsp:CreateColorPicker({
    Name = "ALTERAR ESP PLAYER",
    Color = EnemyColor,
    Flag = "EnemyColor_CS",
    Callback = function(Value)
        EnemyColor = Value
        UpdateESP()
        Rayfield:Notify({
           Title = "ESP Atualizado",
           Content = "Cor dos inimigos alterada!",
           Duration = 3,
           Image = 4483362458,
        })
    end,
})

-- Página Configuração
local CounterBloxTabConfig = Window:CreateTab("Configuração - Counter Blox")

CounterBloxTabConfig:CreateButton({
    Name = "Otimizar para desempenho máximo",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        local SoundService = game:GetService("SoundService")
        local Workspace = game:GetService("Workspace")
        local RunService = game:GetService("RunService")

        -- Desliga todos os sons
        for _, sound in ipairs(SoundService:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
                sound:Stop()
            end
        end

        -- Texturas estilo Minecraft: substitui materiais por Plastic e cores sólidas
        local function SimplifyParts(parent)
            for _, part in ipairs(parent:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    if not part.Locked then
                        part.Color = Color3.fromRGB(
                            math.floor(part.Color.R * 255 + 0.5),
                            math.floor(part.Color.G * 255 + 0.5),
                            math.floor(part.Color.B * 255 + 0.5)
                        )
                    end
                    -- Remove decal/textures
                    for _, decal in ipairs(part:GetChildren()) do
                        if decal:IsA("Decal") or decal:IsA("Texture") then
                            decal:Destroy()
                        end
                    end
                elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Smoke") then
                    part.Enabled = false
                elseif part:IsA("Folder") or part:IsA("Model") then
                    SimplifyParts(part)
                end
            end
        end

        SimplifyParts(Workspace)

        -- Remove sombras e efeitos pesados
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(180, 180, 180)

        -- Otimização de câmera
        local camera = Workspace.CurrentCamera
        camera.FieldOfView = 70
        camera.MaxDistance = 1000

        -- Remove partículas ao longo do tempo (se tiver)
        RunService.Heartbeat:Connect(function()
            for _, effect in ipairs(Workspace:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Smoke") then
                    effect.Enabled = false
                end
            end
        end)

        Rayfield:Notify({
            Title = "Otimização",
            Content = "Sons desligados, texturas simplificadas e efeitos reduzidos para melhor desempenho!",
            Duration = 4,
            Image = 4483362458,
        })
    end,
})

CounterBloxTabConfig:CreateButton({
    Name = "Copiar link do Discord Eco Hub",
    Callback = function()
        setclipboard("https://discord.gg/abygGhvRCG")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Link do Discord copiado para a área de transferência!",
            Duration = 3
        })
    end
})
