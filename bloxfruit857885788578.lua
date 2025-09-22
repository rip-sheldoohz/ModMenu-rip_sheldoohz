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
local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Otimizar NPCs e Remover NPCs - Blox Fruit",
    Style = 1
})

local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Remover NPCs (Update)",
    Description = "Remove todos os itens da pasta especificada",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local itemFolder = workspace:FindFirstChild("NPCs")
            if itemFolder and itemFolder:IsA("Folder") then
                for _, item in ipairs(itemFolder:GetChildren()) do
                    item:Destroy()
                end
                print("[EcoHub] Todos os itens foram removidos da pasta.")
            else
                print("[EcoHub] Pasta não encontrada no Workspace.")
            end
        end
    end
})


local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Remover NPCs (New)",
    Description = "Remove visuais e animações dos NPCs na pasta especificada",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local npcFolder = workspace:FindFirstChild("NPCs")
            if npcFolder and npcFolder:IsA("Folder") then
                for _, npc in ipairs(npcFolder:GetDescendants()) do
                    if npc:IsA("Decal") or npc:IsA("Texture") or npc:IsA("Shirt") or npc:IsA("Pants") or npc:IsA("ShirtGraphic") then
                        npc:Destroy()
                    end
                    if npc:IsA("Animator") or npc:IsA("AnimationController") then
                        npc:Destroy()
                    end
                    if npc:IsA("Humanoid") then
                        for _, track in ipairs(npc:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                    end
                end
                print("[EcoHub] NPCs atualizados: texturas e animações removidas.")
            else
                print("[EcoHub] Pasta não encontrada no Workspace.")
            end
        end
    end
})

--Remover Characters
local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Otimizar Characters e Remover Characters - Blox Fruit",
    Style = 1
})

local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Remover Characters (Update)",
    Description = "Remove todos os itens da pasta especificada",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local itemFolder = workspace:FindFirstChild("Characters")
            if itemFolder and itemFolder:IsA("Folder") then
                for _, item in ipairs(itemFolder:GetChildren()) do
                    item:Destroy()
                end
                print("[EcoHub] Todos os itens foram removidos da pasta.")
            else
                print("[EcoHub] Pasta não encontrada no Workspace.")
            end
        end
    end
})


local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Remover Characters (New)",
    Description = "Remove visuais e animações dos Characters na pasta especificada",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local npcFolder = workspace:FindFirstChild("Characters")
            if npcFolder and npcFolder:IsA("Folder") then
                for _, npc in ipairs(npcFolder:GetDescendants()) do
                    if npc:IsA("Decal") or npc:IsA("Texture") or npc:IsA("Shirt") or npc:IsA("Pants") or npc:IsA("ShirtGraphic") then
                        npc:Destroy()
                    end
                    if npc:IsA("Animator") or npc:IsA("AnimationController") then
                        npc:Destroy()
                    end
                    if npc:IsA("Humanoid") then
                        for _, track in ipairs(npc:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                    end
                end
                print("[EcoHub] Characters atualizados: texturas e animações removidas.")
            else
                print("[EcoHub] Pasta não encontrada no Workspace.")
            end
        end
    end
})

--Boats
local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Otimizar Boats e Remover Boats - Blox Fruit",
    Style = 1
})

local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Remover Boats (Update)",
    Description = "Remove todos os itens da pasta especificada",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local itemFolder = workspace:FindFirstChild("Boats")
            if itemFolder and itemFolder:IsA("Folder") then
                for _, item in ipairs(itemFolder:GetChildren()) do
                    item:Destroy()
                end
                print("[EcoHub] Todos os itens foram removidos da pasta.")
            else
                print("[EcoHub] Pasta não encontrada no Workspace.")
            end
        end
    end
})


local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Remover Boats (New)",
    Description = "Remove visuais e animações dos Boats na pasta especificada",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local npcFolder = workspace:FindFirstChild("Boats")
            if npcFolder and npcFolder:IsA("Folder") then
                for _, npc in ipairs(npcFolder:GetDescendants()) do
                    if npc:IsA("Decal") or npc:IsA("Texture") or npc:IsA("Shirt") or npc:IsA("Pants") or npc:IsA("ShirtGraphic") then
                        npc:Destroy()
                    end
                    if npc:IsA("Animator") or npc:IsA("AnimationController") then
                        npc:Destroy()
                    end
                    if npc:IsA("Humanoid") then
                        for _, track in ipairs(npc:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                    end
                end
                print("[EcoHub] Boats atualizados: texturas e animações removidas.")
            else
                print("[EcoHub] Pasta não encontrada no Workspace.")
            end
        end
    end
})

--BauModels
local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Otimizar BauModels e Remover BauModels - Blox Fruit",
    Style = 1
})

local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Remover BauModels (Update)",
    Description = "Remove todos os itens da pasta especificada",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local itemFolder = workspace:FindFirstChild("BauModels")
            if itemFolder and itemFolder:IsA("Folder") then
                for _, item in ipairs(itemFolder:GetChildren()) do
                    item:Destroy()
                end
                print("[EcoHub] Todos os itens foram removidos da pasta.")
            else
                print("[EcoHub] Pasta não encontrada no Workspace.")
            end
        end
    end
})

local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Remover BauModels (New)",
    Description = "Remove visuais e animações dos BauModels na pasta especificada",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local npcFolder = workspace:FindFirstChild("BauModels")
            if npcFolder and npcFolder:IsA("Folder") then
                for _, npc in ipairs(npcFolder:GetDescendants()) do
                    if npc:IsA("Decal") or npc:IsA("Texture") or npc:IsA("Shirt") or npc:IsA("Pants") or npc:IsA("ShirtGraphic") then
                        npc:Destroy()
                    end
                    if npc:IsA("Animator") or npc:IsA("AnimationController") then
                        npc:Destroy()
                    end
                    if npc:IsA("Humanoid") then
                        for _, track in ipairs(npc:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                    end
                end
                print("[EcoHub] BauModels atualizados: texturas e animações removidas.")
            else
                print("[EcoHub] Pasta não encontrada no Workspace.")
            end
        end
    end
})

--_WorldOrigin
local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Otimizar _WorldOrigin e Remover _WorldOrigin - Blox Fruit",
    Style = 1
})

local runService = game:GetService("RunService")
local itemFolder = workspace:WaitForChild("_WorldOrigin")

local removerTudoAtivo = false
local removerVisuaisAtivo = false

-- Toggle para remover tudo em tempo real
local ToggleRemoverTudo = otimizacaosea1Tab:CreateToggle({
    Name = "Remover tudo _WorldOrigin (Tempo Real)",
    Description = "Remove todos os itens que surgirem na pasta _WorldOrigin automaticamente",
    CurrentValue = false,
    Callback = function(value)
        removerTudoAtivo = value
        if value then
            print("[EcoHub] Remoção em tempo real ativada para _WorldOrigin.")
        else
            print("[EcoHub] Remoção em tempo real desativada para _WorldOrigin.")
        end
    end
})

-- Toggle para remover texturas, roupas e animações uma única vez
local ToggleRemoverVisuais = otimizacaosea1Tab:CreateToggle({
    Name = "Remover visuais e animações _WorldOrigin",
    Description = "Remove texturas, roupas e para animações dentro de _WorldOrigin",
    CurrentValue = false,
    Callback = function(value)
        removerVisuaisAtivo = value
        if value then
            if itemFolder then
                for _, npc in ipairs(itemFolder:GetDescendants()) do
                    if npc:IsA("Decal") or npc:IsA("Texture") or npc:IsA("Shirt") or npc:IsA("Pants") or npc:IsA("ShirtGraphic") then
                        npc:Destroy()
                    elseif npc:IsA("Animator") or npc:IsA("AnimationController") then
                        npc:Destroy()
                    elseif npc:IsA("Humanoid") then
                        for _, track in ipairs(npc:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                    end
                end
                print("[EcoHub] Texturas e animações removidas de _WorldOrigin.")
            else
                print("[EcoHub] Pasta '_WorldOrigin' não encontrada no Workspace.")
            end
            ToggleRemoverVisuais:Set(false)
        end
    end
})

-- Loop para remoção em tempo real
runService.Heartbeat:Connect(function()
    if removerTudoAtivo and itemFolder then
        for _, child in ipairs(itemFolder:GetChildren()) do
            child:Destroy()
        end
    end
end)

--Otimização
local Paragraph = otimizacaosea1Tab:CreateParagraph({
    Title = "Gerenciador Otimização - Blox Fruits",
    Text = "Ferramenta eficiente para otimizar o desempenho do jogo removendo elementos visuais e objetos desnecessários no mapa. Melhore sua experiência reduzindo lag e aumentando a fluidez no Blox Fruits."
})

local Label = otimizacaosea1Tab:CreateLabel({
    Text = "Otimização Completa - Blox Fruit",
    Style = 2
})

local RunService = game:GetService("RunService")

local toggleAtivo = false

local Toggle = otimizacaosea1Tab:CreateToggle({
    Name = "Limpar Workspace (texturas, animações, objetos)",
    Description = "Remove texturas, animações e destrói objetos dentro de todas as pastas no Workspace",
    CurrentValue = false,
    Callback = function(value)
        toggleAtivo = value
        if value then
            print("[EcoHub] Limpeza da Workspace ativada.")
        else
            print("[EcoHub] Limpeza da Workspace desativada.")
        end
    end
})

local function limparObjeto(obj)
    if obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
        obj:Destroy()
    elseif obj:IsA("Animator") or obj:IsA("AnimationController") then
        obj:Destroy()
    elseif obj:IsA("Humanoid") then
        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    elseif obj:IsA("Model") or obj:IsA("Folder") or obj:IsA("Part") then
        for _, child in ipairs(obj:GetChildren()) do
            limparObjeto(child)
        end
        obj:Destroy()
    end
end

RunService.Heartbeat:Connect(function()
    if toggleAtivo then
        for _, folder in ipairs(workspace:GetChildren()) do
            if folder:IsA("Folder") or folder:IsA("Model") then
                for _, obj in ipairs(folder:GetDescendants()) do
                    limparObjeto(obj)
                end
            end
        end
    end
end)
