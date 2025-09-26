local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/Libraries/main/Shaman/Library.lua'))()

local Window = Library:Window({
    Text = "ARSENAL - ECO HUB"
})

--PAGINA AIMBOT
local AimbotTab = Window:Tab({
    Text = "arsenal"
})

--Categoria Aimbot
local AimbotSection = AimbotTab:Section({
    Text = "Categoria Aimbot"
})

--aimbot
local AimbotConfig = {
    MaxDistance = 150,
    SmoothFactor = 0.4,
    CheckInterval = 0.05,
    TargetPart = "Head",
    TargetParts = {"Head", "UpperTorso", "Torso"}
}

_G.SilentAimbotEnabled = false
_G.AimbotConnection = nil
_G.LastTargetCheck = 0

local Toggle = AimbotSection:Toggle({
    Text = "Aimbot Legit",
    Callback = function(Value)
        if Value then
            _G.SilentAimbotEnabled = true
            
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local Camera = workspace.CurrentCamera
            local LocalPlayer = Players.LocalPlayer
            
            local function isValidTarget(player)
                if not player or player == LocalPlayer then
                    return false
                end
                
                if LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
                    return false
                end
                
                if not (player.Character and player.Character:FindFirstChild("Humanoid")) then
                    return false
                end
                
                if player.Character.Humanoid.Health <= 0 then
                    return false
                end
                
                return true
            end
            
            local function getTargetPart(character)
                if AimbotConfig.TargetPart == "Random" then
                    local availableParts = {}
                    for _, partName in ipairs(AimbotConfig.TargetParts) do
                        local part = character:FindFirstChild(partName)
                        if part then
                            table.insert(availableParts, part)
                        end
                    end
                    if #availableParts > 0 then
                        return availableParts[math.random(1, #availableParts)]
                    end
                else
                    local part = character:FindFirstChild(AimbotConfig.TargetPart)
                    if part then
                        return part
                    end
                    
                    for _, partName in ipairs(AimbotConfig.TargetParts) do
                        local fallbackPart = character:FindFirstChild(partName)
                        if fallbackPart then
                            return fallbackPart
                        end
                    end
                end
                return nil
            end
            
            local function hasLineOfSight(targetPosition)
                local rayOrigin = Camera.CFrame.Position
                local rayDirection = (targetPosition - rayOrigin).Unit * (targetPosition - rayOrigin).Magnitude
                
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                
                local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                if not raycastResult then
                    return true
                end
                
                local hitPart = raycastResult.Instance
                return hitPart and hitPart.Parent and Players:GetPlayerFromCharacter(hitPart.Parent)
            end
            
            local function getTargetUnderCrosshair()
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local closestTarget = nil
                local closestDistance = math.huge
                
                for _, player in pairs(Players:GetPlayers()) do
                    if isValidTarget(player) then
                        local targetPart = getTargetPart(player.Character)
                        
                        if targetPart then
                            local partScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            
                            if onScreen and partScreenPos.Z > 0 then
                                local partPos2D = Vector2.new(partScreenPos.X, partScreenPos.Y)
                                local distanceFromCenter = (partPos2D - screenCenter).Magnitude
                                
                                if distanceFromCenter < AimbotConfig.MaxDistance and distanceFromCenter < closestDistance then
                                    if hasLineOfSight(targetPart.Position) then
                                        closestTarget = player
                                        closestDistance = distanceFromCenter
                                    end
                                end
                            end
                        end
                    end
                end
                
                return closestTarget
            end
            
            _G.AimbotConnection = RunService.Heartbeat:Connect(function()
                if not _G.SilentAimbotEnabled then
                    return
                end
                
                local currentTime = tick()
                if currentTime - _G.LastTargetCheck < AimbotConfig.CheckInterval then
                    return
                end
                _G.LastTargetCheck = currentTime
                
                local target = getTargetUnderCrosshair()
                if target and target.Character then
                    local targetPart = getTargetPart(target.Character)
                    
                    if targetPart then
                        local targetPosition = targetPart.Position
                        local newCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPosition)
                        
                        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, AimbotConfig.SmoothFactor)
                    end
                end
            end)
            
            print("[EcoHub] Aimbot Legit ativado - Alvo: " .. AimbotConfig.TargetPart)
            
        else
            _G.SilentAimbotEnabled = false
            
            if _G.AimbotConnection then
                _G.AimbotConnection:Disconnect()
                _G.AimbotConnection = nil
            end
            
            _G.LastTargetCheck = 0
            
            print("[EcoHub] Aimbot Legit desativado")
        end
    end
})

local dropdown = AimbotSection:Dropdown({
    Text = "Parte do Corpo",
    List = {"Head", "Torso", "Random"},
    Flag = "TargetPart",
    Callback = function(selectedPart)
        if selectedPart == "Torso" then
            AimbotConfig.TargetPart = "UpperTorso"
        else
            AimbotConfig.TargetPart = selectedPart
        end
        print("[EcoHub] Alvo alterado para: " .. selectedPart)
    end
})

AimbotSection:Slider({
    Text = "Suavidade",
    Default = 40,
    Minimum = 1,
    Maximum = 100,
    Flag = "Smoothness",
    Callback = function(value)
        AimbotConfig.SmoothFactor = value / 100
        print("[EcoHub] Suavidade: " .. value .. "%")
    end
})

AimbotSection:Slider({
    Text = "Distância Máxima",
    Default = 150,
    Minimum = 50,
    Maximum = 500,
    Flag = "MaxDistance",
    Callback = function(value)
        AimbotConfig.MaxDistance = value
        print("[EcoHub] Distância máxima: " .. value .. "px")
    end
})

--auto-aim
local AimbotConfig = {
    MaxDistance = 500,
    SmoothFactor = 1.0,
    CheckInterval = 0.01,
    TargetPart = "Head",
    TargetParts = {"Head", "UpperTorso", "Torso"},
    FOV = 200,
    PredictionEnabled = true,
    PredictionMultiplier = 0.15,
    WallCheck = false
}

_G.AutoAimEnabled = false
_G.AutoAimConnection = nil
_G.LastTargetCheck = 0
_G.CurrentTarget = nil

local Toggle = AimbotSection:Toggle({
    Text = "Auto-Aim",
    Callback = function(Value)
        if Value then
            _G.AutoAimEnabled = true
            
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local Camera = workspace.CurrentCamera
            local LocalPlayer = Players.LocalPlayer
            
            local function isValidTarget(player)
                if not player or player == LocalPlayer then
                    return false
                end
                
                if LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
                    return false
                end
                
                if not (player.Character and player.Character:FindFirstChild("Humanoid")) then
                    return false
                end
                
                if player.Character.Humanoid.Health <= 0 then
                    return false
                end
                
                return true
            end
            
            local function getTargetPart(character)
                if AimbotConfig.TargetPart == "Random" then
                    local availableParts = {}
                    for _, partName in ipairs(AimbotConfig.TargetParts) do
                        local part = character:FindFirstChild(partName)
                        if part then
                            table.insert(availableParts, part)
                        end
                    end
                    if #availableParts > 0 then
                        return availableParts[math.random(1, #availableParts)]
                    end
                else
                    local part = character:FindFirstChild(AimbotConfig.TargetPart)
                    if part then
                        return part
                    end
                    
                    for _, partName in ipairs(AimbotConfig.TargetParts) do
                        local fallbackPart = character:FindFirstChild(partName)
                        if fallbackPart then
                            return fallbackPart
                        end
                    end
                end
                return nil
            end
            
            local function hasLineOfSight(targetPosition)
                if not AimbotConfig.WallCheck then
                    return true
                end
                
                local rayOrigin = Camera.CFrame.Position
                local rayDirection = (targetPosition - rayOrigin).Unit * (targetPosition - rayOrigin).Magnitude
                
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                
                local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                if not raycastResult then
                    return true
                end
                
                local hitPart = raycastResult.Instance
                return hitPart and hitPart.Parent and Players:GetPlayerFromCharacter(hitPart.Parent)
            end
            
            local function predictPosition(player, targetPart)
                if not AimbotConfig.PredictionEnabled then
                    return targetPart.Position
                end
                
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    return targetPart.Position
                end
                
                local velocity = humanoidRootPart.Velocity
                local distance = (Camera.CFrame.Position - targetPart.Position).Magnitude
                local timeToTarget = distance / 1000
                
                local prediction = velocity * timeToTarget * AimbotConfig.PredictionMultiplier
                return targetPart.Position + prediction
            end
            
            local function isInFOV(targetPosition)
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPosition)
                
                if not onScreen or targetScreenPos.Z <= 0 then
                    return false
                end
                
                local targetPos2D = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                local distance = (targetPos2D - screenCenter).Magnitude
                
                return distance <= AimbotConfig.FOV
            end
            
            local function getNearestTarget()
                local closestTarget = nil
                local closestDistance = math.huge
                
                for _, player in pairs(Players:GetPlayers()) do
                    if isValidTarget(player) then
                        local targetPart = getTargetPart(player.Character)
                        
                        if targetPart then
                            local targetPosition = predictPosition(player, targetPart)
                            
                            if isInFOV(targetPosition) and hasLineOfSight(targetPosition) then
                                local distance = (Camera.CFrame.Position - targetPosition).Magnitude
                                
                                if distance < closestDistance then
                                    closestTarget = player
                                    closestDistance = distance
                                end
                            end
                        end
                    end
                end
                
                return closestTarget
            end
            
            local function smoothAim(targetPosition)
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPosition)
                
                if AimbotConfig.SmoothFactor >= 1 then
                    Camera.CFrame = targetCFrame
                else
                    Camera.CFrame = currentCFrame:Lerp(targetCFrame, AimbotConfig.SmoothFactor)
                end
            end
            
            _G.AutoAimConnection = RunService.Heartbeat:Connect(function()
                if not _G.AutoAimEnabled then
                    return
                end
                
                local currentTime = tick()
                if currentTime - _G.LastTargetCheck < AimbotConfig.CheckInterval then
                    if _G.CurrentTarget and _G.CurrentTarget.Character then
                        local targetPart = getTargetPart(_G.CurrentTarget.Character)
                        if targetPart then
                            local predictedPosition = predictPosition(_G.CurrentTarget, targetPart)
                            if isInFOV(predictedPosition) and hasLineOfSight(predictedPosition) then
                                smoothAim(predictedPosition)
                            else
                                _G.CurrentTarget = nil
                            end
                        end
                    end
                    return
                end
                
                _G.LastTargetCheck = currentTime
                _G.CurrentTarget = getNearestTarget()
                
                if _G.CurrentTarget and _G.CurrentTarget.Character then
                    local targetPart = getTargetPart(_G.CurrentTarget.Character)
                    if targetPart then
                        local predictedPosition = predictPosition(_G.CurrentTarget, targetPart)
                        smoothAim(predictedPosition)
                    end
                end
            end)
            
            print("[EcoHub] Auto-Aim ativado - FOV: " .. AimbotConfig.FOV .. " | Suavidade: " .. (AimbotConfig.SmoothFactor * 100) .. "%")
            
        else
            _G.AutoAimEnabled = false
            
            if _G.AutoAimConnection then
                _G.AutoAimConnection:Disconnect()
                _G.AutoAimConnection = nil
            end
            
            _G.LastTargetCheck = 0
            _G.CurrentTarget = nil
            
            print("[EcoHub] Auto-Aim desativado")
        end
    end
})

local dropdown = AimbotSection:Dropdown({
    Text = "Parte do Corpo",
    List = {"Head", "Torso", "Random"},
    Flag = "TargetPart",
    Callback = function(selectedPart)
        if selectedPart == "Torso" then
            AimbotConfig.TargetPart = "UpperTorso"
        else
            AimbotConfig.TargetPart = selectedPart
        end
        print("[EcoHub] Alvo alterado para: " .. selectedPart)
    end
})

AimbotSection:Slider({
    Text = "Suavidade",
    Default = 100,
    Minimum = 1,
    Maximum = 100,
    Flag = "Smoothness",
    Callback = function(value)
        AimbotConfig.SmoothFactor = value / 100
        print("[EcoHub] Suavidade: " .. value .. "%")
    end
})

AimbotSection:Slider({
    Text = "Campo de Visão (FOV)",
    Default = 200,
    Minimum = 50,
    Maximum = 1000,
    Flag = "FOV",
    Callback = function(value)
        AimbotConfig.FOV = value
        print("[EcoHub] FOV: " .. value .. "px")
    end
})

AimbotSection:Slider({
    Text = "Predição",
    Default = 15,
    Minimum = 0,
    Maximum = 50,
    Flag = "Prediction",
    Callback = function(value)
        AimbotConfig.PredictionMultiplier = value / 100
        AimbotConfig.PredictionEnabled = value > 0
        print("[EcoHub] Predição: " .. value .. "%")
    end
})

AimbotSection:Toggle({
    Text = "Verificar Paredes",
    Callback = function(Value)
        AimbotConfig.WallCheck = Value
        local status = Value and "ativada" or "desativada"
        print("[EcoHub] Verificação de paredes " .. status)
    end
})

--aim assist
local AimAssistConfig = {
    AssistStrength = 0.3,
    MagnetRadius = 100,
    StickyRadius = 150,
    SlowdownFactor = 0.6,
    TargetPart = "Head",
    TargetParts = {"Head", "UpperTorso", "Torso"},
    RequireAiming = true,
    MinimumDistance = 10,
    MaximumDistance = 2000,
    SmoothTransition = true,
    TrackingSpeed = 0.8
}

_G.AimAssistEnabled = false
_G.AimAssistConnection = nil
_G.CurrentAssistTarget = nil
_G.LastMousePosition = nil
_G.MouseMoving = false
_G.MouseMoveCheck = 0

local Toggle = AimbotSection:Toggle({
    Text = "Aim Assist",
    Callback = function(Value)
        if Value then
            _G.AimAssistEnabled = true
            
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local UserInputService = game:GetService("UserInputService")
            local Camera = workspace.CurrentCamera
            local LocalPlayer = Players.LocalPlayer
            local Mouse = LocalPlayer:GetMouse()
            
            local function isValidTarget(player)
                if not player or player == LocalPlayer then
                    return false
                end
                
                if LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
                    return false
                end
                
                if not (player.Character and player.Character:FindFirstChild("Humanoid")) then
                    return false
                end
                
                if player.Character.Humanoid.Health <= 0 then
                    return false
                end
                
                return true
            end
            
            local function getTargetPart(character)
                if AimAssistConfig.TargetPart == "Random" then
                    local availableParts = {}
                    for _, partName in ipairs(AimAssistConfig.TargetParts) do
                        local part = character:FindFirstChild(partName)
                        if part then
                            table.insert(availableParts, part)
                        end
                    end
                    if #availableParts > 0 then
                        return availableParts[math.random(1, #availableParts)]
                    end
                else
                    local part = character:FindFirstChild(AimAssistConfig.TargetPart)
                    if part then
                        return part
                    end
                    
                    for _, partName in ipairs(AimAssistConfig.TargetParts) do
                        local fallbackPart = character:FindFirstChild(partName)
                        if fallbackPart then
                            return fallbackPart
                        end
                    end
                end
                return nil
            end
            
            local function detectMouseMovement()
                local currentMousePos = Vector2.new(Mouse.X, Mouse.Y)
                
                if _G.LastMousePosition then
                    local mouseDelta = (currentMousePos - _G.LastMousePosition).Magnitude
                    _G.MouseMoving = mouseDelta > 2
                    if _G.MouseMoving then
                        _G.MouseMoveCheck = tick()
                    end
                else
                    _G.MouseMoving = false
                end
                
                _G.LastMousePosition = currentMousePos
                
                if tick() - _G.MouseMoveCheck > 0.1 then
                    _G.MouseMoving = false
                end
            end
            
            local function isPlayerAiming()
                if not AimAssistConfig.RequireAiming then
                    return true
                end
                
                return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or _G.MouseMoving
            end
            
            local function getTargetInRadius(radius)
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local closestTarget = nil
                local closestDistance = math.huge
                
                for _, player in pairs(Players:GetPlayers()) do
                    if isValidTarget(player) then
                        local targetPart = getTargetPart(player.Character)
                        
                        if targetPart then
                            local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            
                            if onScreen and targetScreenPos.Z > 0 then
                                local targetPos2D = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                                local distance = (targetPos2D - mousePos).Magnitude
                                local worldDistance = (Camera.CFrame.Position - targetPart.Position).Magnitude
                                
                                if distance <= radius and worldDistance >= AimAssistConfig.MinimumDistance and worldDistance <= AimAssistConfig.MaximumDistance then
                                    if distance < closestDistance then
                                        closestTarget = player
                                        closestDistance = distance
                                    end
                                end
                            end
                        end
                    end
                end
                
                return closestTarget, closestDistance
            end
            
            local function applyStickyAim(target)
                if not target or not target.Character then
                    return
                end
                
                local targetPart = getTargetPart(target.Character)
                if not targetPart then
                    return
                end
                
                local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if not onScreen or targetScreenPos.Z <= 0 then
                    return
                end
                
                local targetPos2D = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local direction = (targetPos2D - mousePos).Unit
                local distance = (targetPos2D - mousePos).Magnitude
                
                if distance > 5 then
                    local pullStrength = AimAssistConfig.AssistStrength * math.min(distance / 50, 1)
                    local newDirection = direction * pullStrength
                    
                    if AimAssistConfig.SmoothTransition then
                        newDirection = newDirection * AimAssistConfig.TrackingSpeed
                    end
                    
                    local currentCFrame = Camera.CFrame
                    local targetDirection = (targetPart.Position - currentCFrame.Position).Unit
                    local currentDirection = currentCFrame.LookVector
                    
                    local blendDirection = currentDirection:lerp(targetDirection, pullStrength * 0.5)
                    local newCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + blendDirection)
                    
                    Camera.CFrame = newCFrame
                end
            end
            
            local function applySlowdown()
                if _G.CurrentAssistTarget and _G.CurrentAssistTarget.Character then
                    local targetPart = getTargetPart(_G.CurrentAssistTarget.Character)
                    if targetPart then
                        local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen and targetScreenPos.Z > 0 then
                            local targetPos2D = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                            local distance = (targetPos2D - mousePos).Magnitude
                            
                            if distance <= AimAssistConfig.StickyRadius then
                                Camera.CFrame = Camera.CFrame:lerp(Camera.CFrame, AimAssistConfig.SlowdownFactor)
                            end
                        end
                    end
                end
            end
            
            _G.AimAssistConnection = RunService.Heartbeat:Connect(function()
                if not _G.AimAssistEnabled then
                    return
                end
                
                detectMouseMovement()
                
                if not isPlayerAiming() then
                    _G.CurrentAssistTarget = nil
                    return
                end
                
                local magnetTarget, magnetDistance = getTargetInRadius(AimAssistConfig.MagnetRadius)
                local stickyTarget, stickyDistance = getTargetInRadius(AimAssistConfig.StickyRadius)
                
                if _G.CurrentAssistTarget and stickyTarget and _G.CurrentAssistTarget == stickyTarget then
                    applyStickyAim(_G.CurrentAssistTarget)
                    applySlowdown()
                elseif magnetTarget then
                    _G.CurrentAssistTarget = magnetTarget
                    applyStickyAim(magnetTarget)
                else
                    _G.CurrentAssistTarget = nil
                end
            end)
            
            print("[EcoHub] Aim Assist ativado - Força: " .. (AimAssistConfig.AssistStrength * 100) .. "% | Raio: " .. AimAssistConfig.MagnetRadius .. "px")
            
        else
            _G.AimAssistEnabled = false
            
            if _G.AimAssistConnection then
                _G.AimAssistConnection:Disconnect()
                _G.AimAssistConnection = nil
            end
            
            _G.CurrentAssistTarget = nil
            _G.LastMousePosition = nil
            _G.MouseMoving = false
            _G.MouseMoveCheck = 0
            
            print("[EcoHub] Aim Assist desativado")
        end
    end
})

local dropdown = AimbotSection:Dropdown({
    Text = "Parte do Corpo",
    List = {"Head", "Torso", "Random"},
    Flag = "TargetPart",
    Callback = function(selectedPart)
        if selectedPart == "Torso" then
            AimAssistConfig.TargetPart = "UpperTorso"
        else
            AimAssistConfig.TargetPart = selectedPart
        end
        print("[EcoHub] Alvo alterado para: " .. selectedPart)
    end
})

AimbotSection:Slider({
    Text = "Força da Assistência",
    Default = 30,
    Minimum = 5,
    Maximum = 100,
    Flag = "AssistStrength",
    Callback = function(value)
        AimAssistConfig.AssistStrength = value / 100
        print("[EcoHub] Força da assistência: " .. value .. "%")
    end
})

AimbotSection:Slider({
    Text = "Raio de Atração",
    Default = 100,
    Minimum = 30,
    Maximum = 300,
    Flag = "MagnetRadius",
    Callback = function(value)
        AimAssistConfig.MagnetRadius = value
        print("[EcoHub] Raio de atração: " .. value .. "px")
    end
})

AimbotSection:Slider({
    Text = "Raio de Aderência",
    Default = 150,
    Minimum = 50,
    Maximum = 400,
    Flag = "StickyRadius",
    Callback = function(value)
        AimAssistConfig.StickyRadius = value
        print("[EcoHub] Raio de aderência: " .. value .. "px")
    end
})

AimbotSection:Slider({
    Text = "Desaceleração",
    Default = 60,
    Minimum = 10,
    Maximum = 90,
    Flag = "Slowdown",
    Callback = function(value)
        AimAssistConfig.SlowdownFactor = value / 100
        print("[EcoHub] Desaceleração: " .. value .. "%")
    end
})

AimbotSection:Toggle({
    Text = "Requer Mira (Botão Direito)",
    Callback = function(Value)
        AimAssistConfig.RequireAiming = Value
        local status = Value and "ativado" or "desativado"
        print("[EcoHub] Requer mira " .. status)
    end
})

--esp
local WallhackerSection = AimbotTab:Section({
    Text = "Categoria Wallhacker",
	Side = "Right"
})

local Toggle = WallhackerSection:Toggle({
    Text = "Wallhacker Player",
    Callback = function(Value)
        if Value then
            _G.WallhackerEnabled = true
            
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer
            local espBoxes = {}
            
            local function createESP(player)
                if player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                if espBoxes[player] and espBoxes[player].billboardGui then
                    espBoxes[player].billboardGui:Destroy()
                end
                
                local character = player.Character
                local humanoidRootPart = character.HumanoidRootPart
                
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "ESPBox"
                billboardGui.Adornee = humanoidRootPart
                billboardGui.Size = UDim2.new(4, 0, 6, 0)
                billboardGui.StudsOffset = Vector3.new(0, 0, 0)
                billboardGui.AlwaysOnTop = true
                billboardGui.Parent = humanoidRootPart
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 1, 0)
                frame.BackgroundTransparency = 0.7
                frame.BorderSizePixel = 2
                frame.Parent = billboardGui
                
                local teamColor = player.Team and player.Team.TeamColor.Color or Color3.new(1, 1, 1)
                frame.BackgroundColor3 = teamColor
                frame.BorderColor3 = teamColor
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
                nameLabel.Position = UDim2.new(0, 0, -0.3, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = "[" .. player.Name .. "]"
                nameLabel.TextColor3 = teamColor
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.SourceSans
                nameLabel.TextStrokeTransparency = 0.5
                nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                nameLabel.Parent = billboardGui
                
                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Size = UDim2.new(1, 0, 0.2, 0)
                distanceLabel.Position = UDim2.new(0, 0, 1.05, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.TextColor3 = teamColor
                distanceLabel.TextScaled = true
                distanceLabel.Font = Enum.Font.SourceSans
                distanceLabel.TextStrokeTransparency = 0.5
                distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                distanceLabel.Parent = billboardGui
                
                espBoxes[player] = {
                    billboardGui = billboardGui,
                    frame = frame,
                    nameLabel = nameLabel,
                    distanceLabel = distanceLabel
                }
            end
            
            local lastUpdateTime = 0
            local updateInterval = 0.1
            
            local function updateESP()
                if not _G.WallhackerEnabled then return end
                
                local currentTime = tick()
                if currentTime - lastUpdateTime < updateInterval then
                    return
                end
                lastUpdateTime = currentTime
                
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local localPosition = LocalPlayer.Character.HumanoidRootPart.Position
                
                for player, espData in pairs(espBoxes) do
                    if not player or not player.Parent or not espData or not espData.billboardGui or not espData.billboardGui.Parent then
                        espBoxes[player] = nil
                        continue
                    end
                    
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - localPosition).Magnitude
                        espData.distanceLabel.Text = math.floor(distance) .. "m"
                        
                        local teamColor = player.Team and player.Team.TeamColor.Color or Color3.new(1, 1, 1)
                        espData.frame.BackgroundColor3 = teamColor
                        espData.frame.BorderColor3 = teamColor
                        espData.nameLabel.Text = "[" .. player.Name .. "]"
                        espData.nameLabel.TextColor3 = teamColor
                        espData.distanceLabel.TextColor3 = teamColor
                    end
                end
            end
            
            local function onPlayerAdded(player)
                if not _G.WallhackerEnabled then return end
                
                local function onCharacterAdded()
                    if _G.WallhackerEnabled then
                        task.wait(0.5)
                        createESP(player)
                    end
                end
                
                if player.Character then
                    onCharacterAdded()
                end
                
                player.CharacterAdded:Connect(onCharacterAdded)
            end
            
            local function onPlayerRemoving(player)
                if espBoxes[player] then
                    if espBoxes[player].billboardGui and espBoxes[player].billboardGui.Parent then
                        espBoxes[player].billboardGui:Destroy()
                    end
                    espBoxes[player] = nil
                end
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    onPlayerAdded(player)
                end
            end
            
            _G.PlayerAddedConnection = Players.PlayerAdded:Connect(onPlayerAdded)
            _G.PlayerRemovingConnection = Players.PlayerRemoving:Connect(onPlayerRemoving)
            _G.ESPUpdateConnection = RunService.Heartbeat:Connect(updateESP)
            
            print("[EcoHub] Wallhacker Player ativado")
            
        else
            _G.WallhackerEnabled = false
            
            for player, espData in pairs(espBoxes or {}) do
                if espData and espData.billboardGui and espData.billboardGui.Parent then
                    espData.billboardGui:Destroy()
                end
            end
            espBoxes = {}
            
            if _G.PlayerAddedConnection then
                _G.PlayerAddedConnection:Disconnect()
                _G.PlayerAddedConnection = nil
            end
            if _G.PlayerRemovingConnection then
                _G.PlayerRemovingConnection:Disconnect()
                _G.PlayerRemovingConnection = nil
            end
            if _G.ESPUpdateConnection then
                _G.ESPUpdateConnection:Disconnect()
                _G.ESPUpdateConnection = nil
            end
            
            print("[EcoHub] Wallhacker Player desativado")
        end
    end
})

--Debris
local DebrisToggle = WallhackerSection:Toggle({
    Text = "Wallhacker Debris",
    Callback = function(Value)
        if Value then
            _G.DebrisWallhackerEnabled = true
            
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer
            local debrisESP = {}
            
            local function createDebrisESP(obj)
                if not obj or not obj.Parent then return end
                
                if debrisESP[obj] and debrisESP[obj].billboardGui then
                    debrisESP[obj].billboardGui:Destroy()
                end
                
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "DebrisESP"
                billboardGui.Adornee = obj
                billboardGui.Size = UDim2.new(0, 100, 0, 40)
                billboardGui.StudsOffset = Vector3.new(0, 0, 0)
                billboardGui.AlwaysOnTop = false
                billboardGui.Parent = obj
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
                nameLabel.Position = UDim2.new(0, 0, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = obj.Name
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.TextScaled = true
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                nameLabel.Parent = billboardGui
                
                local distanceLabel = Instance.new("TextLabel")
                distanceLabel.Size = UDim2.new(1, 0, 0.4, 0)
                distanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
                distanceLabel.BackgroundTransparency = 1
                distanceLabel.Text = "0 metros"
                distanceLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
                distanceLabel.TextScaled = true
                distanceLabel.Font = Enum.Font.SourceSans
                distanceLabel.TextStrokeTransparency = 0
                distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                distanceLabel.Parent = billboardGui
                
                debrisESP[obj] = {
                    billboardGui = billboardGui,
                    nameLabel = nameLabel,
                    distanceLabel = distanceLabel
                }
            end
            
            local function scanDebrisFolder()
                if not _G.DebrisWallhackerEnabled then return end
                
                local debrisFolder = workspace:FindFirstChild("Debris")
                if not debrisFolder then return end
                
                for _, obj in pairs(debrisFolder:GetDescendants()) do
                    if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("MeshPart") or obj:IsA("Part") then
                        if not debrisESP[obj] and obj.Name ~= "DebrisESP" then
                            createDebrisESP(obj)
                        end
                    end
                end
            end
            
            local lastUpdateTime = 0
            local updateInterval = 0.2
            
            local function updateDebrisESP()
                if not _G.DebrisWallhackerEnabled then return end
                
                local currentTime = tick()
                if currentTime - lastUpdateTime < updateInterval then
                    return
                end
                lastUpdateTime = currentTime
                
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local localPosition = LocalPlayer.Character.HumanoidRootPart.Position
                
                for obj, espData in pairs(debrisESP) do
                    if not obj or not obj.Parent or not espData or not espData.billboardGui or not espData.billboardGui.Parent then
                        debrisESP[obj] = nil
                        continue
                    end
                    
                    local objPosition
                    if obj:IsA("Model") and obj.PrimaryPart then
                        objPosition = obj.PrimaryPart.Position
                    elseif obj:IsA("Part") or obj:IsA("MeshPart") then
                        objPosition = obj.Position
                    elseif obj:IsA("Folder") then
                        local firstChild = obj:FindFirstChildOfClass("Part") or obj:FindFirstChildOfClass("MeshPart")
                        if firstChild then
                            objPosition = firstChild.Position
                        end
                    end
                    
                    if objPosition then
                        local distance = (objPosition - localPosition).Magnitude
                        espData.distanceLabel.Text = math.floor(distance) .. " metros"
                        
                        local maxSize = 100
                        local minSize = 60
                        local maxDistance = 300
                        local scale = math.max(minSize, maxSize - (distance / maxDistance * (maxSize - minSize)))
                        
                        espData.billboardGui.Size = UDim2.new(0, scale, 0, 40)
                    end
                end
            end
            
            local function onDebrisAdded(obj)
                if not _G.DebrisWallhackerEnabled then return end
                
                if obj:IsA("Folder") or obj:IsA("Model") or obj:IsA("MeshPart") or obj:IsA("Part") then
                    if obj.Name ~= "DebrisESP" then
                        task.wait(0.1)
                        createDebrisESP(obj)
                    end
                end
            end
            
            local function onDebrisRemoved(obj)
                if debrisESP[obj] then
                    if debrisESP[obj].billboardGui and debrisESP[obj].billboardGui.Parent then
                        debrisESP[obj].billboardGui:Destroy()
                    end
                    debrisESP[obj] = nil
                end
            end
            
            scanDebrisFolder()
            
            local debrisFolder = workspace:FindFirstChild("Debris")
            if debrisFolder then
                _G.DebrisAddedConnection = debrisFolder.DescendantAdded:Connect(onDebrisAdded)
                _G.DebrisRemovedConnection = debrisFolder.DescendantRemoving:Connect(onDebrisRemoved)
            end
            
            _G.DebrisUpdateConnection = RunService.Heartbeat:Connect(updateDebrisESP)
            
            print("[EcoHub] Wallhacker Debris ativado")
            
        else
            _G.DebrisWallhackerEnabled = false
            
            for obj, espData in pairs(debrisESP or {}) do
                if espData and espData.billboardGui and espData.billboardGui.Parent then
                    espData.billboardGui:Destroy()
                end
            end
            debrisESP = {}
            
            if _G.DebrisAddedConnection then
                _G.DebrisAddedConnection:Disconnect()
                _G.DebrisAddedConnection = nil
            end
            if _G.DebrisRemovedConnection then
                _G.DebrisRemovedConnection:Disconnect()
                _G.DebrisRemovedConnection = nil
            end
            if _G.DebrisUpdateConnection then
                _G.DebrisUpdateConnection:Disconnect()
                _G.DebrisUpdateConnection = nil
            end
            
            print("[EcoHub] Wallhacker Debris desativado")
        end
    end
})

--Categoria
local OtimizSection = AimbotTab:Section({
    Text = "Misc",
	Side = "Right"
})

--Fov  Aumentar/dimunuir
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer

local FOVConfig = {
    Default = 70,
    Min = 10,
    Max = 120,
    Step = 5,
    SmoothTransition = true,
    TransitionTime = 0.3
}

local CurrentFOV = FOVConfig.Default
local IsEnabled = true
local TweenInfo = TweenInfo.new(FOVConfig.TransitionTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local FOVConnection

local function MaintainFOV()
    if FOVConnection then
        FOVConnection:Disconnect()
    end
    
    FOVConnection = RunService.Heartbeat:Connect(function()
        if IsEnabled and Camera then
            if Camera.FieldOfView ~= CurrentFOV then
                Camera.FieldOfView = CurrentFOV
            end
        end
    end)
end

local function ApplyFOV(targetFOV, smooth)
    if not Camera then return end
    
    targetFOV = math.clamp(targetFOV, FOVConfig.Min, FOVConfig.Max)
    CurrentFOV = targetFOV
    
    if smooth and FOVConfig.SmoothTransition then
        local tween = TweenService:Create(Camera, TweenInfo, {FieldOfView = targetFOV})
        tween:Play()
        tween.Completed:Connect(function()
            MaintainFOV()
        end)
    else
        Camera.FieldOfView = targetFOV
        MaintainFOV()
    end
end

local function IncreaseFOV()
    if not IsEnabled then return end
    local newFOV = CurrentFOV + FOVConfig.Step
    ApplyFOV(newFOV, true)
end

local function DecreaseFOV()
    if not IsEnabled then return end
    local newFOV = CurrentFOV - FOVConfig.Step
    ApplyFOV(newFOV, true)
end

local function ResetFOV()
    if not IsEnabled then return end
    ApplyFOV(FOVConfig.Default, true)
end

local function SetFOV(fov)
    if not IsEnabled then return end
    ApplyFOV(fov, true)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Equal or input.KeyCode == Enum.KeyCode.Plus then
        IncreaseFOV()
    elseif input.KeyCode == Enum.KeyCode.Minus then
        DecreaseFOV()
    elseif input.KeyCode == Enum.KeyCode.R and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        ResetFOV()
    elseif input.KeyCode == Enum.KeyCode.F and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        IsEnabled = not IsEnabled
        if IsEnabled then
            print("[EcoHub] Sistema FOV ativado")
        else
            print("[EcoHub] Sistema FOV desativado")
        end
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if gameProcessed or not IsEnabled then return end
    
    if input.UserInputType == Enum.UserInputType.MouseWheel and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        if input.Position.Z > 0 then
            IncreaseFOV()
        else
            DecreaseFOV()
        end
    end
end)

OtimizSection:Slider({
    Text = "FOV",
    Min = FOVConfig.Min,
    Max = FOVConfig.Max,
    Default = FOVConfig.Default,
    Flag = "FOV_Value",
    Callback = function(value)
        SetFOV(value)
    end
})

OtimizSection:Toggle({
    Text = "Ativar FOV",
    Default = true,
    Flag = "FOV_Toggle",
    Callback = function(enabled)
        IsEnabled = enabled
        if not enabled then
            ResetFOV()
            print("[EcoHub] Sistema FOV desativado")
        else
            print("[EcoHub] Sistema FOV ativado")
        end
    end
})

OtimizSection:Button({
    Text = "Resetar FOV",
    Flag = "FOV_Reset",
    Callback = function()
        ResetFOV()
    end
})

MaintainFOV()

--discord.gg/ecohub
OtimizSection:Button({
    Text = "Discord Server",
    Flag = "Discord_Button",
    Callback = function()
        setclipboard("https://discord.gg/abygGhvRCG")
        print("[EcoHub] Link do Discord copiado para área de transferência")
    end
})

--random servidor 
OtimizSection:Button({
    Text = "Server Hop",
    Flag = "Server_Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local JobId = game.JobId
        
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId)
        print("[EcoHub] Procurando novo servidor...")
    end
})

OtimizSection:Button({
    Text = "server rejoin",
    Flag = "Full_Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local PlaceId = game.PlaceId
        
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
        end)
        
        if success and servers and servers.data then
            for _, server in pairs(servers.data) do
                if server.playing and server.maxPlayers then
                    if server.playing >= server.maxPlayers - 3 and server.playing < server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(PlaceId, server.id)
                        print("[EcoHub] Entrando em servidor quase cheio (" .. server.playing .. "/" .. server.maxPlayers .. ")")
                        return
                    end
                end
            end
            print("[EcoHub] Nenhum servidor quase cheio encontrado")
        else
            print("[EcoHub] Erro ao buscar servidores")
        end
    end
})
