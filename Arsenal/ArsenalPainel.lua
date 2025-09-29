--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ARSENAL - ECOHUB",
   Icon = 0, 
   LoadingTitle = "ARSENAL CARREEGANDO...",
   LoadingSubtitle = "by rip_sheldoohz",
   ShowText = "EcoHub",
   Theme = "Dark Blue", 

   ToggleUIKeybind = "K", 

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "Eco Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink", 
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key", 
      SaveKey = true, 
      GrabKeyFromSite = false, 
      Key = {"Hello"} 
   }
})

--Teste
local systemTab = Window:CreateTab(
	"Categoria Aimbot"
)

--aimbot legit
local Section = systemTab:CreateSection("AIM BOT LEGIT - ARSENAL")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotConfig = {
    MaxDistance = 150,
    SmoothFactor = 0.4,
    CheckInterval = 0.05,
    TargetPart = "Head",
    TargetParts = {"Head", "UpperTorso", "Torso"},
    TeamCheck = true,
    WallCheck = true
}

local AimbotState = {
    Enabled = false,
    Connection = nil,
    LastTargetCheck = 0,
    CurrentTarget = nil
}

local function isValidTarget(player)
    if not player or player == LocalPlayer then
        return false
    end
    
    if AimbotConfig.TeamCheck and LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
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
    local rayDirection = (targetPosition - rayOrigin)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.IgnoreWater = true
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if not raycastResult then
        return true
    end
    
    local hitPart = raycastResult.Instance
    if hitPart and hitPart.Parent then
        local hitPlayer = Players:GetPlayerFromCharacter(hitPart.Parent)
        return hitPlayer ~= nil
    end
    
    return false
end

local function getTargetUnderCrosshair()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestTarget = nil
    local closestDistance = AimbotConfig.MaxDistance
    
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local targetPart = getTargetPart(player.Character)
            
            if targetPart then
                local partScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen and partScreenPos.Z > 0 then
                    local partPos2D = Vector2.new(partScreenPos.X, partScreenPos.Y)
                    local distanceFromCenter = (partPos2D - screenCenter).Magnitude
                    
                    if distanceFromCenter < closestDistance then
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

local function smoothAim(targetPosition)
    local currentCFrame = Camera.CFrame
    local targetDirection = (targetPosition - currentCFrame.Position).Unit
    local targetCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + targetDirection)
    
    Camera.CFrame = currentCFrame:Lerp(targetCFrame, AimbotConfig.SmoothFactor)
end

local function startAimbot()
    if AimbotState.Connection then
        AimbotState.Connection:Disconnect()
    end
    
    AimbotState.Connection = RunService.Heartbeat:Connect(function()
        if not AimbotState.Enabled then
            return
        end
        
        local currentTime = tick()
        if currentTime - AimbotState.LastTargetCheck < AimbotConfig.CheckInterval then
            if AimbotState.CurrentTarget and AimbotState.CurrentTarget.Character then
                local targetPart = getTargetPart(AimbotState.CurrentTarget.Character)
                if targetPart and hasLineOfSight(targetPart.Position) then
                    smoothAim(targetPart.Position)
                else
                    AimbotState.CurrentTarget = nil
                end
            end
            return
        end
        
        AimbotState.LastTargetCheck = currentTime
        AimbotState.CurrentTarget = getTargetUnderCrosshair()
        
        if AimbotState.CurrentTarget and AimbotState.CurrentTarget.Character then
            local targetPart = getTargetPart(AimbotState.CurrentTarget.Character)
            if targetPart then
                smoothAim(targetPart.Position)
            end
        end
    end)
end

local function stopAimbot()
    if AimbotState.Connection then
        AimbotState.Connection:Disconnect()
        AimbotState.Connection = nil
    end
    AimbotState.CurrentTarget = nil
    AimbotState.LastTargetCheck = 0
end

local Toggle = systemTab:CreateToggle({
    Name = "Aimbot Legit",
    CurrentValue = false,
    Flag = "AimbotLegit_Toggle",
    Callback = function(Value)
        AimbotState.Enabled = Value
        if Value then
            startAimbot()
            print("[EcoHub] Aimbot Legit ativado")
        else
            stopAimbot()
            print("[EcoHub] Aimbot Legit desativado")
        end
    end,
})

local Dropdown = systemTab:CreateDropdown({
    Name = "Parte do Corpo",
    Options = {"Head", "UpperTorso", "Torso", "Random"},
    CurrentOption = "Head",
    Flag = "AimbotLegit_TargetPart",
    Callback = function(Option)
        AimbotConfig.TargetPart = Option
        print("[EcoHub] Alvo: " .. Option)
    end,
})

local SmoothSlider = systemTab:CreateSlider({
    Name = "Suavidade",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 40,
    Flag = "AimbotLegit_Smoothness",
    Callback = function(Value)
        AimbotConfig.SmoothFactor = Value / 100
        print("[EcoHub] Suavidade: " .. Value .. "%")
    end,
})

local DistanceSlider = systemTab:CreateSlider({
    Name = "Distância Máxima",
    Range = {50, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "AimbotLegit_MaxDistance",
    Callback = function(Value)
        AimbotConfig.MaxDistance = Value
        print("[EcoHub] Distância: " .. Value .. "px")
    end,
})

local TeamCheckToggle = systemTab:CreateToggle({
    Name = "Verificar Time",
    CurrentValue = true,
    Flag = "AimbotLegit_TeamCheck",
    Callback = function(Value)
        AimbotConfig.TeamCheck = Value
        print("[EcoHub] Verificar time: " .. (Value and "ativado" or "desativado"))
    end,
})

local WallCheckToggle = systemTab:CreateToggle({
    Name = "Verificar Paredes",
    CurrentValue = true,
    Flag = "AimbotLegit_WallCheck",
    Callback = function(Value)
        AimbotConfig.WallCheck = Value
        print("[EcoHub] Verificar paredes: " .. (Value and "ativado" or "desativado"))
    end,
})

--auto aim 
local Section = systemTab:CreateSection("AUTO AIM - ARSENAL")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotConfig = {
    MaxDistance = 1000,
    SmoothFactor = 0.15,
    CheckInterval = 0.005,
    TargetPart = "Head",
    TargetParts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"},
    FOV = 150,
    PredictionEnabled = true,
    PredictionMultiplier = 0.2,
    WallCheck = true,
    TeamCheck = true,
    VisibilityCheck = true,
    MouseHoldMode = false
}

local AimbotState = {
    Enabled = false,
    Connection = nil,
    LastTargetCheck = 0,
    CurrentTarget = nil,
    MouseDown = false
}

local function isValidTarget(player)
    if not player or player == LocalPlayer then
        return false
    end
    
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then
        return false
    end
    
    if player.Character.Humanoid.Health <= 0 then
        return false
    end
    
    if AimbotConfig.TeamCheck and LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
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
    local rayDirection = (targetPosition - rayOrigin)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.IgnoreWater = true
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if not raycastResult then
        return true
    end
    
    local hitPart = raycastResult.Instance
    if hitPart and hitPart.Parent then
        local hitPlayer = Players:GetPlayerFromCharacter(hitPart.Parent)
        return hitPlayer ~= nil
    end
    
    return false
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
    local timeToTarget = distance / 2000
    
    local prediction = velocity * timeToTarget * AimbotConfig.PredictionMultiplier
    return targetPart.Position + prediction
end

local function isInFOV(targetPosition)
    if not AimbotConfig.VisibilityCheck then
        return true
    end
    
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
    local closestDistance = AimbotConfig.MaxDistance
    
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local targetPart = getTargetPart(player.Character)
            
            if targetPart then
                local targetPosition = predictPosition(player, targetPart)
                local distance = (Camera.CFrame.Position - targetPosition).Magnitude
                
                if distance <= AimbotConfig.MaxDistance and distance < closestDistance then
                    if isInFOV(targetPosition) and hasLineOfSight(targetPosition) then
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
    local targetDirection = (targetPosition - currentCFrame.Position).Unit
    local targetCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + targetDirection)
    
    Camera.CFrame = currentCFrame:Lerp(targetCFrame, AimbotConfig.SmoothFactor)
end

local function startAimbot()
    if AimbotState.Connection then
        AimbotState.Connection:Disconnect()
    end
    
    AimbotState.Connection = RunService.Heartbeat:Connect(function()
        if not AimbotState.Enabled then
            return
        end
        
        if AimbotConfig.MouseHoldMode and not AimbotState.MouseDown then
            return
        end
        
        local currentTime = tick()
        if currentTime - AimbotState.LastTargetCheck < AimbotConfig.CheckInterval then
            if AimbotState.CurrentTarget and AimbotState.CurrentTarget.Character then
                local targetPart = getTargetPart(AimbotState.CurrentTarget.Character)
                if targetPart then
                    local predictedPosition = predictPosition(AimbotState.CurrentTarget, targetPart)
                    if isInFOV(predictedPosition) and hasLineOfSight(predictedPosition) then
                        smoothAim(predictedPosition)
                    else
                        AimbotState.CurrentTarget = nil
                    end
                end
            end
            return
        end
        
        AimbotState.LastTargetCheck = currentTime
        AimbotState.CurrentTarget = getNearestTarget()
        
        if AimbotState.CurrentTarget and AimbotState.CurrentTarget.Character then
            local targetPart = getTargetPart(AimbotState.CurrentTarget.Character)
            if targetPart then
                local predictedPosition = predictPosition(AimbotState.CurrentTarget, targetPart)
                smoothAim(predictedPosition)
            end
        end
    end)
end

local function stopAimbot()
    if AimbotState.Connection then
        AimbotState.Connection:Disconnect()
        AimbotState.Connection = nil
    end
    AimbotState.CurrentTarget = nil
    AimbotState.LastTargetCheck = 0
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        AimbotState.MouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        AimbotState.MouseDown = false
    end
end)

local Toggle = systemTab:CreateToggle({
    Name = "Auto-Aim",
    CurrentValue = false,
    Flag = "AutoAim_Toggle",
    Callback = function(Value)
        AimbotState.Enabled = Value
        if Value then
            startAimbot()
            print("[EcoHub] Auto-Aim ativado")
        else
            stopAimbot()
            print("[EcoHub] Auto-Aim desativado")
        end
    end,
})

local Dropdown = systemTab:CreateDropdown({
    Name = "Parte do Corpo",
    Options = {"Head", "UpperTorso", "Torso", "Random"},
    CurrentOption = "Head",
    Flag = "TargetPart_Dropdown",
    Callback = function(Option)
        AimbotConfig.TargetPart = Option
        print("[EcoHub] Alvo: " .. Option)
    end,
})

local SmoothSlider = systemTab:CreateSlider({
    Name = "Suavidade",
    Range = {1, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 15,
    Flag = "Smoothness_Slider",
    Callback = function(Value)
        AimbotConfig.SmoothFactor = Value / 100
        print("[EcoHub] Suavidade: " .. Value .. "%")
    end,
})

local FOVSlider = systemTab:CreateSlider({
    Name = "Campo de Visão",
    Range = {50, 500},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOV_Slider",
    Callback = function(Value)
        AimbotConfig.FOV = Value
        print("[EcoHub] FOV: " .. Value)
    end,
})

local PredictionSlider = systemTab:CreateSlider({
    Name = "Predição",
    Range = {0, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 20,
    Flag = "Prediction_Slider",
    Callback = function(Value)
        AimbotConfig.PredictionMultiplier = Value / 100
        AimbotConfig.PredictionEnabled = Value > 0
        print("[EcoHub] Predição: " .. Value .. "%")
    end,
})

local DistanceSlider = systemTab:CreateSlider({
    Name = "Distância Máxima",
    Range = {500, 5000},
    Increment = 100,
    Suffix = "studs",
    CurrentValue = 1000,
    Flag = "MaxDistance_Slider",
    Callback = function(Value)
        AimbotConfig.MaxDistance = Value
        print("[EcoHub] Distância: " .. Value)
    end,
})

local WallCheckToggle = systemTab:CreateToggle({
    Name = "Verificar Paredes",
    CurrentValue = true,
    Flag = "WallCheck_Toggle",
    Callback = function(Value)
        AimbotConfig.WallCheck = Value
        print("[EcoHub] Verificação de paredes: " .. (Value and "ativada" or "desativada"))
    end,
})

local TeamCheckToggle = systemTab:CreateToggle({
    Name = "Verificar Time",
    CurrentValue = true,
    Flag = "TeamCheck_Toggle",
    Callback = function(Value)
        AimbotConfig.TeamCheck = Value
        print("[EcoHub] Verificação de time: " .. (Value and "ativada" or "desativada"))
    end,
})

local MouseHoldToggle = systemTab:CreateToggle({
    Name = "Só com Mouse Pressionado",
    CurrentValue = false,
    Flag = "MouseHold_Toggle",
    Callback = function(Value)
        AimbotConfig.MouseHoldMode = Value
        print("[EcoHub] Modo mouse: " .. (Value and "ativado" or "desativado"))
    end,
})

--aim assist
local Section = systemTab:CreateSection("AIM ASSIST - ARSENAL")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local AimAssistConfig = {
    AssistStrength = 0.25,
    MagnetRadius = 80,
    StickyRadius = 120,
    SlowdownFactor = 0.7,
    TargetPart = "Head",
    TargetParts = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"},
    RequireAiming = false,
    MinimumDistance = 15,
    MaximumDistance = 1500,
    SmoothTransition = true,
    TrackingSpeed = 0.65,
    TeamCheck = true,
    MouseSensitivity = 2,
    DeadZone = 5
}

local AimAssistState = {
    Enabled = false,
    Connection = nil,
    CurrentTarget = nil,
    LastMousePosition = nil,
    MouseMoving = false,
    MouseMoveTime = 0,
    IsAiming = false,
    LastTargetCheck = 0
}

local function isValidTarget(player)
    if not player or player == LocalPlayer then
        return false
    end
    
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then
        return false
    end
    
    if player.Character.Humanoid.Health <= 0 then
        return false
    end
    
    if AimAssistConfig.TeamCheck and LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
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

local function updateMouseMovement()
    local currentMousePos = Vector2.new(Mouse.X, Mouse.Y)
    local currentTime = tick()
    
    if AimAssistState.LastMousePosition then
        local mouseDelta = (currentMousePos - AimAssistState.LastMousePosition).Magnitude
        if mouseDelta > AimAssistConfig.MouseSensitivity then
            AimAssistState.MouseMoving = true
            AimAssistState.MouseMoveTime = currentTime
        end
    end
    
    if currentTime - AimAssistState.MouseMoveTime > 0.15 then
        AimAssistState.MouseMoving = false
    end
    
    AimAssistState.LastMousePosition = currentMousePos
end

local function isPlayerAiming()
    if not AimAssistConfig.RequireAiming then
        return true
    end
    
    local rightClick = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    return rightClick or AimAssistState.MouseMoving
end

local function getDistance3D(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function getDistance2D(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function getTargetInRadius(radius, prioritizeClosest)
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local bestTarget = nil
    local bestScore = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            local targetPart = getTargetPart(player.Character)
            
            if targetPart then
                local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                
                if onScreen and targetScreenPos.Z > 0 then
                    local targetPos2D = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                    local screenDistance = getDistance2D(targetPos2D, mousePos)
                    local worldDistance = getDistance3D(Camera.CFrame.Position, targetPart.Position)
                    
                    if screenDistance <= radius and 
                       worldDistance >= AimAssistConfig.MinimumDistance and 
                       worldDistance <= AimAssistConfig.MaximumDistance then
                        
                        local score = prioritizeClosest and worldDistance or screenDistance
                        if score < bestScore then
                            bestTarget = player
                            bestScore = score
                        end
                    end
                end
            end
        end
    end
    
    return bestTarget, bestScore
end

local function calculateAssistVector(target)
    if not target or not target.Character then
        return Vector2.new(0, 0)
    end
    
    local targetPart = getTargetPart(target.Character)
    if not targetPart then
        return Vector2.new(0, 0)
    end
    
    local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen or targetScreenPos.Z <= 0 then
        return Vector2.new(0, 0)
    end
    
    local targetPos2D = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local direction = targetPos2D - mousePos
    local distance = direction.Magnitude
    
    if distance <= AimAssistConfig.DeadZone then
        return Vector2.new(0, 0)
    end
    
    local normalizedDirection = direction.Unit
    local assistStrength = AimAssistConfig.AssistStrength
    
    local distanceFactor = math.min(distance / 100, 1)
    local finalStrength = assistStrength * distanceFactor
    
    return normalizedDirection * finalStrength
end

local function applyAimAssist(assistVector)
    if assistVector.Magnitude < 0.001 then
        return
    end
    
    local currentCFrame = Camera.CFrame
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local adjustedCenter = screenCenter + (assistVector * 50)
    
    local worldDirection = Camera:ScreenPointToRay(adjustedCenter.X, adjustedCenter.Y).Direction
    local targetPosition = currentCFrame.Position + worldDirection
    
    local newCFrame = CFrame.lookAt(currentCFrame.Position, targetPosition)
    
    if AimAssistConfig.SmoothTransition then
        Camera.CFrame = currentCFrame:Lerp(newCFrame, AimAssistConfig.TrackingSpeed * 0.016 * 60)
    else
        Camera.CFrame = newCFrame
    end
end

local function applySlowdown()
    if not AimAssistState.CurrentTarget or not AimAssistState.CurrentTarget.Character then
        return
    end
    
    local targetPart = getTargetPart(AimAssistState.CurrentTarget.Character)
    if not targetPart then
        return
    end
    
    local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen or targetScreenPos.Z <= 0 then
        return
    end
    
    local targetPos2D = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local distance = getDistance2D(targetPos2D, mousePos)
    
    if distance <= AimAssistConfig.StickyRadius then
        local slowdownStrength = 1 - ((distance / AimAssistConfig.StickyRadius) * (1 - AimAssistConfig.SlowdownFactor))
        UserInputService.MouseDeltaSensitivity = slowdownStrength
    else
        UserInputService.MouseDeltaSensitivity = 1
    end
end

local function startAimAssist()
    if AimAssistState.Connection then
        AimAssistState.Connection:Disconnect()
    end
    
    AimAssistState.Connection = RunService.Heartbeat:Connect(function()
        if not AimAssistState.Enabled then
            return
        end
        
        updateMouseMovement()
        AimAssistState.IsAiming = isPlayerAiming()
        
        if not AimAssistState.IsAiming then
            AimAssistState.CurrentTarget = nil
            UserInputService.MouseDeltaSensitivity = 1
            return
        end
        
        local magnetTarget = getTargetInRadius(AimAssistConfig.MagnetRadius, false)
        local stickyTarget = getTargetInRadius(AimAssistConfig.StickyRadius, true)
        
        if AimAssistState.CurrentTarget and stickyTarget and AimAssistState.CurrentTarget == stickyTarget then
            local assistVector = calculateAssistVector(AimAssistState.CurrentTarget)
            applyAimAssist(assistVector)
            applySlowdown()
        elseif magnetTarget then
            AimAssistState.CurrentTarget = magnetTarget
            local assistVector = calculateAssistVector(magnetTarget)
            applyAimAssist(assistVector)
            applySlowdown()
        else
            AimAssistState.CurrentTarget = nil
            UserInputService.MouseDeltaSensitivity = 1
        end
    end)
end

local function stopAimAssist()
    if AimAssistState.Connection then
        AimAssistState.Connection:Disconnect()
        AimAssistState.Connection = nil
    end
    
    AimAssistState.CurrentTarget = nil
    AimAssistState.LastMousePosition = nil
    AimAssistState.MouseMoving = false
    AimAssistState.MouseMoveTime = 0
    UserInputService.MouseDeltaSensitivity = 1
end

local Toggle = systemTab:CreateToggle({
    Name = "Aim Assist",
    CurrentValue = false,
    Flag = "AimAssist_Toggle",
    Callback = function(Value)
        AimAssistState.Enabled = Value
        if Value then
            startAimAssist()
            print("[EcoHub] Aim Assist ativado")
        else
            stopAimAssist()
            print("[EcoHub] Aim Assist desativado")
        end
    end,
})

local Dropdown = systemTab:CreateDropdown({
    Name = "Parte do Corpo",
    Options = {"Head", "UpperTorso", "Torso", "Random"},
    CurrentOption = "Head",
    Flag = "AimAssist_TargetPart",
    Callback = function(Option)
        AimAssistConfig.TargetPart = Option
        print("[EcoHub] Alvo: " .. Option)
    end,
})

local StrengthSlider = systemTab:CreateSlider({
    Name = "Força da Assistência",
    Range = {5, 80},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 25,
    Flag = "AimAssist_Strength",
    Callback = function(Value)
        AimAssistConfig.AssistStrength = Value / 100
        print("[EcoHub] Força: " .. Value .. "%")
    end,
})

local MagnetRadiusSlider = systemTab:CreateSlider({
    Name = "Raio de Atração",
    Range = {30, 200},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 80,
    Flag = "AimAssist_MagnetRadius",
    Callback = function(Value)
        AimAssistConfig.MagnetRadius = Value
        print("[EcoHub] Raio atração: " .. Value)
    end,
})

local StickyRadiusSlider = systemTab:CreateSlider({
    Name = "Raio de Aderência",
    Range = {50, 300},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 120,
    Flag = "AimAssist_StickyRadius",
    Callback = function(Value)
        AimAssistConfig.StickyRadius = Value
        print("[EcoHub] Raio aderência: " .. Value)
    end,
})

local TrackingSpeedSlider = systemTab:CreateSlider({
    Name = "Velocidade de Tracking",
    Range = {20, 100},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 65,
    Flag = "AimAssist_TrackingSpeed",
    Callback = function(Value)
        AimAssistConfig.TrackingSpeed = Value / 100
        print("[EcoHub] Velocidade tracking: " .. Value .. "%")
    end,
})

local SlowdownSlider = systemTab:CreateSlider({
    Name = "Desaceleração",
    Range = {20, 95},
    Increment = 1,
    Suffix = "%",
    CurrentValue = 70,
    Flag = "AimAssist_Slowdown",
    Callback = function(Value)
        AimAssistConfig.SlowdownFactor = Value / 100
        print("[EcoHub] Desaceleração: " .. Value .. "%")
    end,
})

local MaxDistanceSlider = systemTab:CreateSlider({
    Name = "Distância Máxima",
    Range = {500, 3000},
    Increment = 100,
    Suffix = "studs",
    CurrentValue = 1500,
    Flag = "AimAssist_MaxDistance",
    Callback = function(Value)
        AimAssistConfig.MaximumDistance = Value
        print("[EcoHub] Distância máxima: " .. Value)
    end,
})

local RequireAimingToggle = systemTab:CreateToggle({
    Name = "Requer Botão Direito",
    CurrentValue = false,
    Flag = "AimAssist_RequireAiming",
    Callback = function(Value)
        AimAssistConfig.RequireAiming = Value
        print("[EcoHub] Requer mira: " .. (Value and "ativado" or "desativado"))
    end,
})

local TeamCheckToggle = systemTab:CreateToggle({
    Name = "Verificar Time",
    CurrentValue = true,
    Flag = "AimAssist_TeamCheck",
    Callback = function(Value)
        AimAssistConfig.TeamCheck = Value
        print("[EcoHub] Verificar time: " .. (Value and "ativado" or "desativado"))
    end,
})

--Adicionar circulo Verde na mira
local Section = systemTab:CreateSection("CIRCULO VERDE - ARSENAL")

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local CircleConfig = {
    Enabled = false,
    Color = Color3.fromRGB(0, 255, 0),
    Size = 50,
    Thickness = 2,
    Transparency = 0.5,
    Filled = false
}

local CircleState = {
    Circle = nil,
    Connection = nil
}

local function createCircle()
    if CircleState.Circle then
        CircleState.Circle:Remove()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EcoHubCircle"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    
    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.Parent = screenGui
    circle.BackgroundTransparency = 1
    circle.Size = UDim2.new(0, CircleConfig.Size, 0, CircleConfig.Size)
    circle.Position = UDim2.new(0.5, -CircleConfig.Size/2, 0.5, -CircleConfig.Size/2)
    circle.AnchorPoint = Vector2.new(0, 0)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = circle
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = CircleConfig.Color
    stroke.Thickness = CircleConfig.Thickness
    stroke.Transparency = CircleConfig.Transparency
    stroke.Parent = circle
    
    if CircleConfig.Filled then
        circle.BackgroundColor3 = CircleConfig.Color
        circle.BackgroundTransparency = 0.8
    end
    
    CircleState.Circle = screenGui
    return screenGui
end

local function updateCircle()
    if not CircleState.Circle or not CircleConfig.Enabled then
        return
    end
    
    local circle = CircleState.Circle:FindFirstChild("Circle")
    if circle then
        circle.Size = UDim2.new(0, CircleConfig.Size, 0, CircleConfig.Size)
        circle.Position = UDim2.new(0.5, -CircleConfig.Size/2, 0.5, -CircleConfig.Size/2)
        
        local stroke = circle:FindFirstChild("UIStroke")
        if stroke then
            stroke.Color = CircleConfig.Color
            stroke.Thickness = CircleConfig.Thickness
            stroke.Transparency = CircleConfig.Transparency
        end
        
        if CircleConfig.Filled then
            circle.BackgroundColor3 = CircleConfig.Color
            circle.BackgroundTransparency = 0.8
        else
            circle.BackgroundTransparency = 1
        end
    end
end

local function startCircle()
    if CircleConfig.Enabled then
        createCircle()
        print("[EcoHub] Círculo verde ativado")
    else
        if CircleState.Circle then
            CircleState.Circle:Destroy()
            CircleState.Circle = nil
        end
        print("[EcoHub] Círculo verde desativado")
    end
end

local Toggle = systemTab:CreateToggle({
    Name = "Ativar Círculo",
    CurrentValue = false,
    Flag = "CircleToggle",
    Callback = function(Value)
        CircleConfig.Enabled = Value
        startCircle()
    end,
})

local ColorPicker = systemTab:CreateColorPicker({
    Name = "Cor do Círculo",
    Color = Color3.fromRGB(0, 255, 0),
    Flag = "CircleColor",
    Callback = function(Value)
        CircleConfig.Color = Value
        updateCircle()
        print("[EcoHub] Cor alterada")
    end
})

local SizeSlider = systemTab:CreateSlider({
    Name = "Tamanho",
    Range = {10, 200},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 50,
    Flag = "CircleSize",
    Callback = function(Value)
        CircleConfig.Size = Value
        updateCircle()
        print("[EcoHub] Tamanho: " .. Value)
    end,
})

local ThicknessSlider = systemTab:CreateSlider({
    Name = "Espessura",
    Range = {1, 10},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 2,
    Flag = "CircleThickness",
    Callback = function(Value)
        CircleConfig.Thickness = Value
        updateCircle()
        print("[EcoHub] Espessura: " .. Value)
    end,
})

local TransparencySlider = systemTab:CreateSlider({
    Name = "Transparência",
    Range = {0, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "CircleTransparency",
    Callback = function(Value)
        CircleConfig.Transparency = Value / 100
        updateCircle()
        print("[EcoHub] Transparência: " .. Value .. "%")
    end,
})

local FilledToggle = systemTab:CreateToggle({
    Name = "Círculo Preenchido",
    CurrentValue = false,
    Flag = "CircleFilled",
    Callback = function(Value)
        CircleConfig.Filled = Value
        updateCircle()
        print("[EcoHub] Preenchido: " .. (Value and "ativado" or "desativado"))
    end,
})


--Categoria Teleporte
local TeleportTab = Window:CreateTab(
	"Categoria Teleporte"
)

--SISTEMA TELEPORTE
local Section = TeleportTab:CreateSection("TELEPORTE PLAYER - ARSENAL")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local TeleportConfig = {
    Enabled = false,
    TeleportDistance = 8,
    TeamCheck = true,
    IgnoreDead = true,
    AutoShoot = false
}

local TeleportState = {
    Connection = nil,
    ShootConnection = nil,
    CurrentTarget = nil,
    TargetHealth = {},
    KillCount = 0,
    LastShootTime = 0
}

local function isValidTarget(player)
    if not player or player == LocalPlayer then
        return false
    end
    
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then
        return false
    end
    
    if TeleportConfig.IgnoreDead and player.Character.Humanoid.Health <= 0 then
        return false
    end
    
    if TeleportConfig.TeamCheck and LocalPlayer.Team and player.Team and player.Team == LocalPlayer.Team then
        return false
    end
    
    return true
end

local function getEnemyPlayers()
    local enemies = {}
    for _, player in pairs(Players:GetPlayers()) do
        if isValidTarget(player) then
            table.insert(enemies, player)
        end
    end
    return enemies
end

local function getClosestEnemy()
    local enemies = getEnemyPlayers()
    local closestEnemy = nil
    local shortestDistance = math.huge
    
    local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then
        return nil
    end
    
    for _, enemy in pairs(enemies) do
        if enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (enemy.Character.HumanoidRootPart.Position - localRoot.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestEnemy = enemy
            end
        end
    end
    
    return closestEnemy
end

local function teleportBehindPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return false
    end
    
    local targetHumanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local localHumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    if not targetHumanoidRootPart or not localHumanoidRootPart then
        return false
    end
    
    local targetPosition = targetHumanoidRootPart.Position
    local targetLookDirection = targetHumanoidRootPart.CFrame.LookVector
    local behindPosition = targetPosition - (targetLookDirection * TeleportConfig.TeleportDistance)
    behindPosition = behindPosition + Vector3.new(0, 1, 0)
    
    localHumanoidRootPart.CFrame = CFrame.new(behindPosition, targetPosition)
    
    return true
end

local function isEnemyInSight(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        return false
    end
    
    local targetHead = targetPlayer.Character:FindFirstChild("Head")
    if not targetHead then
        return false
    end
    
    local screenPoint, onScreen = Camera:WorldToScreenPoint(targetHead.Position)
    
    if not onScreen then
        return false
    end
    
    local viewportSize = Camera.ViewportSize
    local centerX = viewportSize.X / 2
    local centerY = viewportSize.Y / 2
    local distance = math.sqrt((screenPoint.X - centerX)^2 + (screenPoint.Y - centerY)^2)
    
    if distance > 250 then
        return false
    end
    
    return true
end

local function shootAtHead(targetPlayer)
    if not TeleportConfig.AutoShoot or not targetPlayer or not targetPlayer.Character then
        return
    end
    
    if not isEnemyInSight(targetPlayer) then
        return
    end
    
    local currentTime = tick()
    if currentTime - TeleportState.LastShootTime < 0.1 then
        return
    end
    
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then
        return
    end
    
    local headPosition = head.Position
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, headPosition)
    
    mouse1press()
    task.wait(0.05)
    mouse1release()
    
    TeleportState.LastShootTime = currentTime
end

local function isTargetDead(player)
    if not player or not player.Character then
        return true
    end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return true
    end
    
    return false
end

local function checkTargetDamage(player)
    if not player or not player.Character then
        return false
    end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then
        return false
    end
    
    local currentHealth = humanoid.Health
    local lastHealth = TeleportState.TargetHealth[player.UserId] or currentHealth
    
    TeleportState.TargetHealth[player.UserId] = currentHealth
    
    if lastHealth - currentHealth >= 100 then
        return true
    end
    
    return false
end

local function getNextTarget()
    if TeleportState.CurrentTarget and not isTargetDead(TeleportState.CurrentTarget) then
        if checkTargetDamage(TeleportState.CurrentTarget) then
            print("[EcoHub] Alvo tomou muito dano, mudando para mais proximo...")
            return getClosestEnemy()
        end
    end
    
    local enemies = getEnemyPlayers()
    
    if #enemies == 0 then
        return nil
    end
    
    return getClosestEnemy()
end

local function startTeleportKill()
    if TeleportState.Connection then
        TeleportState.Connection:Disconnect()
    end
    
    if TeleportState.ShootConnection then
        TeleportState.ShootConnection:Disconnect()
    end
    
    TeleportState.Connection = RunService.Heartbeat:Connect(function()
        if not TeleportConfig.Enabled then
            return
        end
        
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        if not TeleportState.CurrentTarget or isTargetDead(TeleportState.CurrentTarget) then
            if TeleportState.CurrentTarget and isTargetDead(TeleportState.CurrentTarget) then
                TeleportState.KillCount = TeleportState.KillCount + 1
                TeleportState.TargetHealth[TeleportState.CurrentTarget.UserId] = nil
                print("[EcoHub] Alvo eliminado! Total de kills: " .. TeleportState.KillCount)
                print("[EcoHub] Procurando novo alvo...")
            end
            
            TeleportState.CurrentTarget = getNextTarget()
            
            if TeleportState.CurrentTarget then
                print("[EcoHub] Novo alvo selecionado: " .. TeleportState.CurrentTarget.Name)
                local humanoid = TeleportState.CurrentTarget.Character and TeleportState.CurrentTarget.Character:FindFirstChild("Humanoid")
                if humanoid then
                    TeleportState.TargetHealth[TeleportState.CurrentTarget.UserId] = humanoid.Health
                end
                task.wait(0.3)
            else
                print("[EcoHub] Nenhum inimigo disponivel")
                task.wait(1)
                return
            end
        end
        
        if TeleportState.CurrentTarget and not isTargetDead(TeleportState.CurrentTarget) then
            if checkTargetDamage(TeleportState.CurrentTarget) then
                print("[EcoHub] Alvo tomou 100+ de dano! Mudando para alvo mais proximo...")
                TeleportState.CurrentTarget = getClosestEnemy()
                if TeleportState.CurrentTarget then
                    print("[EcoHub] Novo alvo: " .. TeleportState.CurrentTarget.Name)
                end
            end
            
            teleportBehindPlayer(TeleportState.CurrentTarget)
        end
    end)
    
    if TeleportConfig.AutoShoot then
        TeleportState.ShootConnection = RunService.Heartbeat:Connect(function()
            if not TeleportConfig.Enabled or not TeleportConfig.AutoShoot then
                return
            end
            
            if TeleportState.CurrentTarget and not isTargetDead(TeleportState.CurrentTarget) then
                shootAtHead(TeleportState.CurrentTarget)
            end
        end)
    end
end

local function stopTeleportKill()
    if TeleportState.Connection then
        TeleportState.Connection:Disconnect()
        TeleportState.Connection = nil
    end
    
    if TeleportState.ShootConnection then
        TeleportState.ShootConnection:Disconnect()
        TeleportState.ShootConnection = nil
    end
    
    TeleportState.CurrentTarget = nil
    TeleportState.TargetHealth = {}
    
    print("[EcoHub] Teleport Kill desativado - Total de kills: " .. TeleportState.KillCount)
end

local Toggle = TeleportTab:CreateToggle({
    Name = "Auto Teleport Kill",
    CurrentValue = false,
    Flag = "TeleportKill_Toggle",
    Callback = function(Value)
        TeleportConfig.Enabled = Value
        if Value then
            TeleportState.KillCount = 0
            TeleportState.TargetHealth = {}
            startTeleportKill()
            print("[EcoHub] Teleport Kill ativado")
        else
            stopTeleportKill()
        end
    end,
})

local AutoShootToggle = systemTab:CreateToggle({
    Name = "Auto Shoot Head",
    CurrentValue = false,
    Flag = "AutoShoot_Toggle",
    Callback = function(Value)
        TeleportConfig.AutoShoot = Value
        if Value then
            if TeleportConfig.Enabled then
                startTeleportKill()
            end
            print("[EcoHub] Auto Shoot ativado")
        else
            if TeleportState.ShootConnection then
                TeleportState.ShootConnection:Disconnect()
                TeleportState.ShootConnection = nil
            end
            print("[EcoHub] Auto Shoot desativado")
        end
    end,
})

local DistanceSlider = TeleportTab:CreateSlider({
    Name = "Distancia Atras",
    Range = {3, 15},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 8,
    Flag = "TeleportDistance_Slider",
    Callback = function(Value)
        TeleportConfig.TeleportDistance = Value
        print("[EcoHub] Distancia definida: " .. Value .. " studs")
    end,
})

local TeamCheckToggle = TeleportTab:CreateToggle({
    Name = "Verificar Time",
    CurrentValue = true,
    Flag = "TeleportKill_TeamCheck",
    Callback = function(Value)
        TeleportConfig.TeamCheck = Value
        print("[EcoHub] Verificacao de time: " .. (Value and "ativada" or "desativada"))
    end,
})

local ResetKillsButton = TeleportTab:CreateButton({
    Name = "Reset Kill Counter",
    Callback = function()
        TeleportState.KillCount = 0
        TeleportState.TargetHealth = {}
        print("[EcoHub] Contador de kills resetado")
    end,
})

--Categoria Wallhacker
local wallhackerTab = Window:CreateTab(
	"Categoria WallHacker"
)

--WallHacker
local Section = wallhackerTab:CreateSection("WALLHACKER PLAYERS - ARSENAL")

local Toggle = wallhackerTab:CreateToggle({
   Name = "WALLHACKER PLAYERS",
   CurrentValue = false,
   Flag = "Toggle1", 
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

local Section = wallhackerTab:CreateSection("WALLHACKER DEBRIS - ARSENAL")

local Toggle = wallhackerTab:CreateToggle({
   Name = "WALLHACKER DEBRIS",
   CurrentValue = false,
   Flag = "Toggle1",
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

--Categoria Misc
local MiscTab = Window:CreateTab(
	"Misc"
)

--Random servidor
local Section = MiscTab:CreateSection("PROCURAR SERVIDOR - ARSENAL")

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ServerHopConfig = {
    IsHopping = false,
    IsSearchingFull = false,
    IsRejoining = false
}

local function getServerList()
    local success, result = pcall(function()
        local servers = {}
        local cursor = ""
        
        repeat
            local url = string.format(
                "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100&cursor=%s",
                game.PlaceId,
                cursor
            )
            
            local response = game:HttpGet(url)
            local data = HttpService:JSONDecode(response)
            
            if data and data.data then
                for _, server in pairs(data.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        table.insert(servers, server)
                    end
                end
            end
            
            cursor = data.nextPageCursor or ""
        until cursor == ""
        
        return servers
    end)
    
    if success then
        return result
    else
        return {}
    end
end

local function serverHopRandom()
    if ServerHopConfig.IsHopping then
        print("[EcoHub] Ja esta procurando servidor...")
        return
    end
    
    ServerHopConfig.IsHopping = true
    print("[EcoHub] Procurando servidor aleatorio...")
    
    local servers = getServerList()
    
    if #servers == 0 then
        print("[EcoHub] Nenhum servidor disponivel")
        ServerHopConfig.IsHopping = false
        return
    end
    
    local randomServer = servers[math.random(1, #servers)]
    
    print("[EcoHub] Servidor encontrado! Players: " .. randomServer.playing .. "/" .. randomServer.maxPlayers)
    print("[EcoHub] Conectando...")
    
    TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, LocalPlayer)
end

local function serverHopAlmostFull()
    if ServerHopConfig.IsSearchingFull then
        print("[EcoHub] Ja esta procurando servidor...")
        return
    end
    
    ServerHopConfig.IsSearchingFull = true
    print("[EcoHub] Procurando servidor quase cheio...")
    
    local servers = getServerList()
    
    if #servers == 0 then
        print("[EcoHub] Nenhum servidor disponivel")
        ServerHopConfig.IsSearchingFull = false
        return
    end
    
    table.sort(servers, function(a, b)
        return a.playing > b.playing
    end)
    
    local bestServer = servers[1]
    
    print("[EcoHub] Servidor encontrado! Players: " .. bestServer.playing .. "/" .. bestServer.maxPlayers)
    print("[EcoHub] Conectando...")
    
    TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer.id, LocalPlayer)
end

local function serverRejoin()
    if ServerHopConfig.IsRejoining then
        print("[EcoHub] Ja esta reconectando...")
        return
    end
    
    ServerHopConfig.IsRejoining = true
    print("[EcoHub] Reconectando ao servidor...")
    
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

local Toggle1 = MiscTab:CreateToggle({
    Name = "Server Hops",
    CurrentValue = false,
    Flag = "ServerHop_Toggle",
    Callback = function(Value)
        if Value then
            serverHopRandom()
        end
    end,
})

local Toggle2 = MiscTab:CreateToggle({
    Name = "Procurar Servidor (Quase Cheio)",
    CurrentValue = false,
    Flag = "ServerHopFull_Toggle",
    Callback = function(Value)
        if Value then
            serverHopAlmostFull()
        end
    end,
})

local Toggle3 = MiscTab:CreateToggle({
    Name = "Server Rejoin",
    CurrentValue = false,
    Flag = "ServerRejoin_Toggle",
    Callback = function(Value)
        if Value then
            serverRejoin()
        end
    end,
})

--Bypass
local Section = MiscTab:CreateSection("BYPASS - ARSENAL")

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

local BypassConfig = {
    Enabled = false,
    ObjectsRemoved = 0,
    IsRunning = false
}

local function safeDestroy(obj)
    pcall(function()
        if obj and obj.Parent then
            if obj.ClassName == "LocalScript" or obj.ClassName == "Script" or obj.ClassName == "ModuleScript" then
                obj.Disabled = true
                wait(0.1)
            end
            obj:Destroy()
            BypassConfig.ObjectsRemoved = BypassConfig.ObjectsRemoved + 1
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

local lastMonitorCheck = tick()
local MONITOR_INTERVAL = 20
local isCurrentlyMonitoring = false

local function lightweightMonitor()
    if not BypassConfig.Enabled then
        return
    end
    
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

local monitorConnection = nil

local function startBypass()
    if BypassConfig.IsRunning then
        return
    end
    
    BypassConfig.IsRunning = true
    BypassConfig.ObjectsRemoved = 0
    
    task.spawn(function()
        wait(1)
        pcall(cleanupDetection)
    end)
    
    if Services.RunService and not monitorConnection then
        monitorConnection = Services.RunService.Heartbeat:Connect(function()
            pcall(lightweightMonitor)
        end)
    end
    
    if Services.Players then
        Services.Players.PlayerAdded:Connect(function(newPlayer)
            if not BypassConfig.Enabled then
                return
            end
            
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
end

local function stopBypass()
    BypassConfig.IsRunning = false
    
    if monitorConnection then
        monitorConnection:Disconnect()
        monitorConnection = nil
    end
end

local Paragraph = MiscTab:CreateParagraph({
    Title = "Status Bypass:", 
    Content = "Desativado - 0 objetos removidos"
})

local Toggle = MiscTab:CreateToggle({
    Name = "Ativar Bypass Anticheat",
    CurrentValue = false,
    Flag = "Bypass_Toggle",
    Callback = function(Value)
        BypassConfig.Enabled = Value
        if Value then
            startBypass()
            Paragraph:Set({
                Title = "Status Bypass:",
                Content = "Ativado - Protecao ativa"
            })
        else
            stopBypass()
            Paragraph:Set({
                Title = "Status Bypass:",
                Content = "Desativado - " .. BypassConfig.ObjectsRemoved .. " objetos removidos"
            })
        end
    end,
})

task.spawn(function()
    while wait(5) do
        if BypassConfig.Enabled then
            Paragraph:Set({
                Title = "Status Bypass:",
                Content = "Ativo - " .. BypassConfig.ObjectsRemoved .. " objetos removidos"
            })
        end
    end
end)

--Discord
local Section = MiscTab:CreateSection("DISCORD - ECO HUB")

local Label = MiscTab:CreateLabel("BY RIP_SHELDOOHZ", 4483362458, Color3.fromRGB(255, 255, 255), false)

local Button = MiscTab:CreateButton({
    Name = "Discord Server",
    Callback = function()
        local discordLink = "https://discord.gg/abygGhvRCG"
        
        if setclipboard then
            setclipboard(discordLink)
            game.StarterGui:SetCore("SendNotification", {
                Title = "EcoHub",
                Text = "Link do Discord copiado!",
                Duration = 3
            })
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "Discord",
                Text = discordLink,
                Duration = 5
            })
        end
    end,
})
