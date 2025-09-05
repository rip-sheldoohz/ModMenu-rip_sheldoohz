-- EcoHub - Otimização V2 Melhorada
-- Sistema automático com interface moderna e otimizações avançadas

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local PANEL_NAME = "EcoHubV2_GUI"

-- Estados globais
local estados = {
    fpsBooster = false,
    removeParticulas = false,
    desativarSom = false,
    removeTexturas = false,
    otimizarMeshes = false,
    limparWorkspace = false
}

-- Remover GUI antiga
if PlayerGui:FindFirstChild(PANEL_NAME) then
    PlayerGui[PANEL_NAME]:Destroy()
end

-- ===== INTERFACE MODERNA =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Name = PANEL_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- Frame principal com design moderno
local MainFrame = Instance.new("Frame")
MainFrame.Size = isMobile and UDim2.new(0, 320, 0, 450) or UDim2.new(0, 380, 0, 480)
MainFrame.Position = isMobile and UDim2.new(0.5, -160, 0.5, -225) or UDim2.new(0.5, -190, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = not isMobile
MainFrame.Parent = ScreenGui

-- Gradiente de fundo
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Bordas arredondadas
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

-- Borda brilhante
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 2
Stroke.Transparency = 0.7
Stroke.Parent = MainFrame

-- Header com título
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Header.BackgroundTransparency = 0.9
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 16)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚀 EcoHub V2 - Otimização"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = isMobile and 16 or 20
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Status indicator
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Size = UDim2.new(0, 12, 0, 12)
StatusIndicator.Position = UDim2.new(1, -60, 0.5, -6)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
StatusIndicator.Parent = Header

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusIndicator

-- Botão minimizar moderno
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = Header
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
MinimizeBtn.Text = "−"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.AutoButtonColor = false

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- Container principal de conteúdo
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -80)
ContentFrame.Position = UDim2.new(0, 10, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ScrollingFrame para botões
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollFrame

-- Ajustar tamanho do canvas automaticamente
local function updateCanvasSize()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

-- ===== FUNÇÕES DE OTIMIZAÇÃO AVANÇADAS =====
local processedObjects = {}
local optimizationActive = false

local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("EcoHub Error:", result)
    end
    return success and result
end

-- FPS Booster Avançado
local function aplicarFPSBooster()
    safeCall(function()
        -- Configurações de qualidade
        local settings = UserSettings():GetService("UserGameSettings")
        settings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
        settings.MasterVolume = 0.1
        
        -- Lighting otimizado
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 0
        Lighting.Brightness = 2
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        
        -- Som otimizado
        SoundService.AmbientReverb = Enum.ReverbType.NoReverb
        SoundService.DistanceFactor = 0.1
        SoundService.DopplerScale = 0
        
        -- Remover efeitos visuais
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or 
               effect:IsA("Sky") or effect:IsA("Clouds") or effect:IsA("SunRaysEffect") then
                effect:Destroy()
            end
        end
    end)
end

-- Otimizar objeto individual
local function otimizarObjeto(obj)
    if not obj or not obj.Parent or processedObjects[obj] then return end
    processedObjects[obj] = true
    
    safeCall(function()
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
            obj.Reflectance = 0
            obj.TopSurface = Enum.SurfaceType.Smooth
            obj.BottomSurface = Enum.SurfaceType.Smooth
            
        elseif obj:IsA("MeshPart") then
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
            obj.RenderFidelity = Enum.RenderFidelity.Performance
            obj.Reflectance = 0
            
        elseif obj:IsA("UnionOperation") then
            obj.Material = Enum.Material.Plastic
            obj.UsePartColor = true
            obj.CastShadow = false
            
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            if estados.removeParticulas then
                obj.Enabled = false
            end
            
        elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            if estados.removeParticulas then
                obj:Destroy()
            end
            
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            if estados.removeTexturas then
                obj.Transparency = 1
            end
            
        elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
            if estados.limparWorkspace then
                obj.Enabled = false
            end
        end
    end)
end

-- Otimização em lote com yield
local function otimizacaoLote()
    if optimizationActive then return end
    optimizationActive = true
    
    task.spawn(function()
        local objetos = Workspace:GetDescendants()
        local total = #objetos
        
        for i, obj in ipairs(objetos) do
            otimizarObjeto(obj)
            
            -- Yield a cada 100 objetos para não travar
            if i % 100 == 0 then
                RunService.Heartbeat:Wait()
            end
        end
        
        optimizationActive = false
        print("EcoHub: Otimização concluída -", total, "objetos processados")
    end)
end

-- ===== SISTEMA DE BOTÕES AUTOMÁTICOS =====
local function createModernToggle(name, icon, description, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Parent = ScrollFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 12)
    BtnCorner.Parent = Button
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = Color3.fromRGB(70, 70, 80)
    BtnStroke.Thickness = 1
    BtnStroke.Parent = Button
    
    -- Ícone
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Position = UDim2.new(0, 15, 0.5, -15)
    Icon.BackgroundTransparency = 1
    Icon.Text = icon
    Icon.Font = Enum.Font.GothamBold
    Icon.TextColor3 = Color3.fromRGB(200, 200, 200)
    Icon.TextSize = 18
    Icon.Parent = Button
    
    -- Texto principal
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -100, 0, 20)
    Label.Position = UDim2.new(0, 55, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.GothamBold
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    -- Descrição
    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -100, 0, 15)
    Desc.Position = UDim2.new(0, 55, 0, 28)
    Desc.BackgroundTransparency = 1
    Desc.Text = description
    Desc.Font = Enum.Font.Gotham
    Desc.TextColor3 = Color3.fromRGB(180, 180, 180)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Button
    
    -- Toggle indicator
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(0, 40, 0, 20)
    Toggle.Position = UDim2.new(1, -50, 0.5, -10)
    Toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Toggle.Parent = Button
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = Toggle
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Size = UDim2.new(0, 16, 0, 16)
    ToggleButton.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Parent = Toggle
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 8)
    ToggleBtnCorner.Parent = ToggleButton
    
    -- Estado do toggle
    local isToggled = false
    
    -- Animações
    local function animateToggle(state)
        local toggleColor = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(100, 100, 100)
        local togglePos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        
        TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = toggleColor}):Play()
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {Position = togglePos}):Play()
        
        local strokeColor = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(70, 70, 80)
        TweenService:Create(BtnStroke, TweenInfo.new(0.3), {Color = strokeColor}):Play()
    end
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
    end)
    
    -- Click handler
    Button.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        animateToggle(isToggled)
        
        -- Feedback visual de clique
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}):Play()
        wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
        
        -- Executar callback
        safeCall(callback, isToggled)
    end)
    
    updateCanvasSize()
    return Button
end

-- ===== CRIANDO BOTÕES DE OTIMIZAÇÃO =====
createModernToggle(
    "FPS Booster Automático",
    "⚡",
    "Otimiza qualidade gráfica e performance",
    function(active)
        estados.fpsBooster = active
        if active then
            aplicarFPSBooster()
            otimizacaoLote()
            StatusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        else
            StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
)

createModernToggle(
    "Remover Partículas",
    "✨",
    "Desativa todos os efeitos de partículas",
    function(active)
        estados.removeParticulas = active
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled = not active
            elseif (obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles")) and active then
                obj:Destroy()
            end
        end
    end
)

createModernToggle(
    "Controle de Som",
    "🔊",
    "Reduz volume para melhor performance",
    function(active)
        estados.desativarSom = active
        SoundService.MasterVolume = active and 0 or 0.5
    end
)

createModernToggle(
    "Remover Texturas",
    "🖼️",
    "Torna decals e texturas invisíveis",
    function(active)
        estados.removeTexturas = active
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = active and 1 or 0
            end
        end
    end
)

createModernToggle(
    "Otimizar Meshes",
    "🔧",
    "Reduz qualidade de rendering de meshes",
    function(active)
        estados.otimizarMeshes = active
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("MeshPart") then
                obj.RenderFidelity = active and Enum.RenderFidelity.Performance or Enum.RenderFidelity.Automatic
            end
        end
    end
)

createModernToggle(
    "Limpeza Workspace",
    "🧹",
    "Desativa GUIs desnecessárias",
    function(active)
        estados.limparWorkspace = active
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                obj.Enabled = not active
            end
        end
    end
)

-- Botão de otimização completa
local CompleteOptBtn = Instance.new("TextButton")
CompleteOptBtn.Size = UDim2.new(1, 0, 0, 40)
CompleteOptBtn.Position = UDim2.new(0, 0, 1, -35)
CompleteOptBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
CompleteOptBtn.Text = "🚀 OTIMIZAÇÃO COMPLETA"
CompleteOptBtn.Font = Enum.Font.GothamBold
CompleteOptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CompleteOptBtn.TextSize = 16
CompleteOptBtn.AutoButtonColor = false
CompleteOptBtn.Parent = ContentFrame

local CompleteBtnCorner = Instance.new("UICorner")
CompleteBtnCorner.CornerRadius = UDim.new(0, 12)
CompleteBtnCorner.Parent = CompleteOptBtn

CompleteOptBtn.MouseButton1Click:Connect(function()
    -- Ativar todas as otimizações
    for key, _ in pairs(estados) do
        estados[key] = true
    end
    
    aplicarFPSBooster()
    otimizacaoLote()
    SoundService.MasterVolume = 0
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    
    -- Feedback visual
    TweenService:Create(CompleteOptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 150)}):Play()
    wait(0.3)
    TweenService:Create(CompleteOptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
end)

-- ===== MINIMIZAR/MAXIMIZAR =====
local isMinimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, 280, 0, 60)

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = minimizedSize}):Play()
        ContentFrame.Visible = false
        MinimizeBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = originalSize}):Play()
        ContentFrame.Visible = true
        MinimizeBtn.Text = "−"
    end
end)

-- ===== SISTEMA DE MONITORAMENTO AUTOMÁTICO =====
RunService.Heartbeat:Connect(function()
    if estados.fpsBooster then
        -- Monitorar novos objetos automaticamente
        for _, obj in pairs(Workspace:GetDescendants()) do
            if not processedObjects[obj] then
                otimizarObjeto(obj)
            end
        end
    end
end)

print("EcoHub V2 - Otimização carregada com sucesso! 🚀")
print("Interface moderna com sistema automático ativado.")
