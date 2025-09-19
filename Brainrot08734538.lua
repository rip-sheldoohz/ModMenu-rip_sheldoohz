local Luna = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/luna", true))()

local Window = Luna:CreateWindow({
    Name = "EcoHub - Roube Um Brainrot",
    Subtitle = nil,
    LogoID = "82795327169782",
    LoadingEnabled = true,
    LoadingTitle = "Otimização Carregando...",
    LoadingSubtitle = "by rip_sheldoohz",

    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "EcoHub"
    },

    KeySystem = false,
    KeySettings = {
        Title = "EcoHub - System Key",
        Subtitle = "Key System",
        Note = "",
        SaveInRoot = false,
        SaveKey = true,
        Key = {"BrainrotV1"},
        SecondAction = {
            Enabled = true,
            Type = "Link",
            Parameter = "https://discord.gg/CuycQDvxMt"
        }
    }
})

--Evento configuração
local ConfigEventoTab = Window:CreateTab({
    Name = "Configuração",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

--Bypass
local Label = ConfigEventoTab:CreateLabel({
    Text = "STATUS: MAIS OU MENOS (PODE TER TRAVAMENTOS & MUITO LAG)",
    Style = 3
})

local Paragraph = ConfigEventoTab:CreateParagraph({
    Title = "Bypass System",
    Text = "Sistema avançado de bypass e proteção anti-detecção"
})

local Toggle = ConfigEventoTab:CreateToggle({
    Name = "Bypass",
    Description = "Mantenha-se invisível ao sistema anti-cheat",
    CurrentValue = true,
    Callback = function(Value)
        if Value then
            print("[EcoHub] Sistema de proteção ativado")
            print("[EcoHub] Painel protegido contra detecção")
            print("[EcoHub] Anti-cheat bypass iniciado")
            
            local function obfuscateName()
                local chars = {"Game", "Ui", "System", "Tool", "Helper", "Manager", "Handler", "Controller", "Service", "Module", "Core", "Main"}
                local nums = tostring(math.random(1000, 9999))
                local extras = {"_" .. tostring(tick()):sub(-3), "_Secure", "_Protected", "_Hidden"}
                return chars[math.random(#chars)] .. nums .. extras[math.random(#extras)]
            end

            print("[EcoHub] Nomes aleatórios gerados para proteção")

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
                GuiService = safeGetService("GuiService"),
                CoreGui = safeGetService("CoreGui"),
                HttpService = safeGetService("HttpService")
            }
            
            print("[EcoHub] " .. tostring(#Services) .. " serviços carregados com segurança")

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
                print("[EcoHub] Iniciando remoção de sistemas de detecção")
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
                
                if #objectsToRemove > 0 then
                    print("[EcoHub] " .. #objectsToRemove .. " objetos suspeitos eliminados")
                else
                    print("[EcoHub] Nenhum sistema de detecção encontrado")
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
                print("[EcoHub] Sistema de proteção ativo")
                print("[EcoHub] Verificação contínua habilitada")
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
                                wait(0.03)
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
                            wait(0.1)
                        end
                        
                        if #suspiciousObjects > 0 then
                            print("[EcoHub] " .. #suspiciousObjects .. " novos sistemas detectados e removidos")
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
                                                       string.find(lowerGuiName, "detect", 1, true) or
                                                       string.find(lowerGuiName, "anti", 1, true) then
                                                        safeDestroy(gui)
                                                        print("[EcoHub] GUI suspeita removida: " .. gui.Name)
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
                    wait(10)
                    pcall(function()
                        if player and player.PlayerGui then
                            for _, gui in pairs(player.PlayerGui:GetChildren()) do
                                if gui.Name:find("Rayfield") or gui.Name:find("EcoHub") then
                                    if gui:FindFirstChild("Main") then
                                        gui.Main.Visible = true
                                    end
                                end
                            end
                        end
                        print("[EcoHub] Painel protegido e funcionando")
                    end)
                end
            end)
            
        else
            print("[EcoHub] Sistema de bypass desativado")
        end
    end
})

--Servidor Random
local Label = ConfigEventoTab:CreateLabel({
    Text = "Sistema de Servidor Funcionando",
    Style = 2
})

local Paragraph = ConfigEventoTab:CreateParagraph({
    Title = "Sistema de Troca de Servidor", 
    Text = "Rejoin volta pro mesmo servidor. Procurar Servidor tenta achar outro servidor pra entrar com menos players."
})

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService") 
local Players = game:GetService("Players")

local function procurarServidor()
    spawn(function()
        local success, servers = pcall(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            local response
            
            if syn and syn.request then
                response = syn.request({Url = url, Method = "GET"})
            elseif request then
                response = request({Url = url, Method = "GET"})
            elseif http and http.request then
                response = http.request({Url = url, Method = "GET"})
            else
                return nil
            end
            
            if response and response.Body then
                local data = HttpService:JSONDecode(response.Body)
                return data.data or {}
            end
            return {}
        end)
        
        if success and servers and #servers > 0 then
            local melhoresServidores = {}
            
            for _, server in pairs(servers) do
                if server.id ~= game.JobId and server.playing > 0 and server.playing < server.maxPlayers then
                    table.insert(melhoresServidores, {
                        id = server.id,
                        players = server.playing
                    })
                end
            end
            
            if #melhoresServidores > 0 then
                table.sort(melhoresServidores, function(a, b)
                    return a.players < b.players
                end)
                
                local melhorServidor = melhoresServidores[1]
                print("Encontrado servidor com " .. melhorServidor.players .. " players")
                
                TeleportService:TeleportToPlaceInstance(game.PlaceId, melhorServidor.id, Players.LocalPlayer)
            else
                print("Nenhum servidor melhor encontrado, entrando em qualquer um")
                TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
            end
        else
            print("Erro ao buscar servidores, usando teleport normal")
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        end
    end)
end

local Button1 = ConfigEventoTab:CreateButton({
    Name = "Rejoin",
    Description = "Volta pro mesmo servidor",
    Callback = function()
        if game.JobId and game.JobId ~= "" then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
        else
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        end
    end
})

local Button2 = ConfigEventoTab:CreateButton({
    Name = "Procurar Servidor",
    Description = "Acha servidor com menos players",
    Callback = function()
        procurarServidor()
    end
})

--Configurar
local MainPanel = Window.MainPanel or ConfigEventoTab

local Label = ConfigEventoTab:CreateLabel({
    Text = "Configurar Painel",
    Style = 1
})

local Bind = ConfigEventoTab:CreateBind({
    Name = "Interface Bind",
    Description = nil,
    CurrentBind = "K",
    HoldToInteract = false,
    Callback = function()
        if MainPanel then
            if type(MainPanel.SetVisible) == "function" and type(MainPanel.IsVisible) == "function" then
                MainPanel:SetVisible(not MainPanel:IsVisible())
            elseif MainPanel.Visible ~= nil then
                MainPanel.Visible = not MainPanel.Visible
            else
                print("Painel não suporta método ou propriedade para visibilidade.")
            end
        else
            print("Painel não encontrado.")
        end
    end,
    OnChangedCallback = function(Bind)
        Window.Bind = Bind
    end,
})

--Evento Script
local EventoScriptTab = Window:CreateTab({
    Name = "Evento Script Premium",
    Icon = "code",
    ImageSource = "Material",
    ShowTitle = true
})

--Lennon Hub
local Label = EventoScriptTab:CreateLabel({
    Text = "Status: Lennon Hub Online",
    Style = 2
})

local Paragraph = EventoScriptTab:CreateParagraph({
    Title = "Informações do Script",
    Text = "Este script ativa o Lennon Hub, uma ferramenta avançada de automação e otimização. Certifique-se de estar em um ambiente compatível antes de executar."
})

local Button = EventoScriptTab:CreateButton({
    Name = "Ativar Lennon Hub",
    Description = "Executa o script premium do Lennon Hub.",
    Callback = function()
        Luna:Notification({
            Title = "EcoHub - Script",
            Icon = "terminal",
            ImageSource = "Material",
            Content = "Executando Lennon Hub... Aguarde"
        })

        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/MJw2J4T6/raw"))()
        end)

        if success then
            Luna:Notification({
                Title = "EcoHub - Sucesso",
                Icon = "check_circle",
                ImageSource = "Material",
                Content = "Lennon Hub ativado com sucesso"
            })
        else
            Luna:Notification({
                Title = "EcoHub - Erro",
                Icon = "error",
                ImageSource = "Material",
                Content = "Falha ao executar o script: " .. tostring(err)
            })
        end
    end
})

--Miranda Hub
local Label = EventoScriptTab:CreateLabel({
    Text = "Status: Miranda Hub Online",
    Style = 2
})

local Paragraph = EventoScriptTab:CreateParagraph({
    Title = "Informações do Script",
    Text = "Este botão executa o Miranda Hub, um script poderoso focado em automação, otimização e melhorias de gameplay. Use com responsabilidade."
})

local Button = EventoScriptTab:CreateButton({
    Name = "Ativar Miranda Hub",
    Description = "Executa o script premium do Miranda Hub.",
    Callback = function()
        Luna:Notification({
            Title = "EcoHub - Script",
            Icon = "terminal",
            ImageSource = "Material",
            Content = "Executando Miranda Hub... Aguarde"
        })

        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/JJVhs3rK/raw"))()
        end)

        if success then
            Luna:Notification({
                Title = "EcoHub - Sucesso",
                Icon = "check_circle",
                ImageSource = "Material",
                Content = "Miranda Hub ativado com sucesso"
            })
        else
            Luna:Notification({
                Title = "EcoHub - Erro",
                Icon = "error",
                ImageSource = "Material",
                Content = "Falha ao executar o script: " .. tostring(err)
            })
        end
    end
})

--Evento Status
local EventoStatusTab = Window:CreateTab({
    Name = "Status do Evento",
    Icon = "timeline",
    ImageSource = "Material",
    ShowTitle = true
})


--Status Jogador
local tempoInicio = tick()
local rodando = true

local player = game.Players.LocalPlayer
local username = player.Name
local displayName = player.DisplayName
local userId = player.UserId
local accountAge = player.AccountAge

local function obterTempoFormatado(segundos)
    local horas = math.floor(segundos / 3600)
    local minutos = math.floor((segundos % 3600) / 60)
    local segs = segundos % 60

    if horas > 0 then
        return string.format("%dh %dm %ds", horas, minutos, segs)
    elseif minutos > 0 then
        return string.format("%dm %ds", minutos, segs)
    else
        return string.format("%ds", segs)
    end
end

local statusParagraph = EventoStatusTab:CreateParagraph({
    Title = "Status do Jogador",
    Text = "Carregando status..."
})

task.spawn(function()
    while rodando do
        local tempoDeUso = math.floor(tick() - tempoInicio)

        local statusTexto = string.format(
            "Tempo de Uso: %s\nUsuário: %s\nNome Exibido: %s\nID do Usuário: %d\nIdade da Conta: %d dias\nServidor: %s\nJogadores Online: %d/%d",
            obterTempoFormatado(tempoDeUso),
            username,
            displayName,
            userId,
            accountAge,
            game.JobId ~= "" and game.JobId or "Privado/Desconhecido",
            #game.Players:GetPlayers(),
            game.Players.MaxPlayers
        )

        statusParagraph:Set({
            Title = "Status do Jogador",
            Text = statusTexto
        })
        
        task.wait(1)
    end
end)

--Status Evento
local tempoInicio = tick()
local rodando = true

local player = game.Players.LocalPlayer
local workspace = game.Workspace

local function obterTempoFormatado(segundos)
    local horas = math.floor(segundos / 3600)
    local minutos = math.floor((segundos % 3600) / 60)
    local segs = segundos % 60

    if horas > 0 then
        return string.format("%dh %dm %ds", horas, minutos, segs)
    elseif minutos > 0 then
        return string.format("%dm %ds", minutos, segs)
    else
        return string.format("%ds", segs)
    end
end

local function verificarEventos()
    local eventsFolder = workspace:FindFirstChild("Events")
    local statusEventos = {}
    
    if not eventsFolder then
        return {"Pasta Events não encontrada na Workspace"}
    end
    
    local children = eventsFolder:GetChildren()
    
    if #children == 0 then
        return {"Pasta Events está vazia"}
    end
    
    for _, objeto in ipairs(children) do
        local tipoObjeto = ""
        local info = ""
        
        if objeto:IsA("Model") then
            tipoObjeto = "Model"
            local parts = {}
            local scripts = {}
            
            for _, child in ipairs(objeto:GetDescendants()) do
                if child:IsA("Part") or child:IsA("MeshPart") then
                    table.insert(parts, child.Name)
                elseif child:IsA("Script") or child:IsA("LocalScript") then
                    table.insert(scripts, child.Name)
                end
            end
            
            info = string.format("Parts: %d | Scripts: %d", #parts, #scripts)
            
        elseif objeto:IsA("Folder") then
            tipoObjeto = "Folder"
            local childCount = #objeto:GetChildren()
            info = string.format("Itens: %d", childCount)
            
        elseif objeto:IsA("Part") or objeto:IsA("MeshPart") then
            tipoObjeto = "Part"
            info = string.format("Pos: %.1f,%.1f,%.1f", objeto.Position.X, objeto.Position.Y, objeto.Position.Z)
            
        elseif objeto:IsA("Script") or objeto:IsA("LocalScript") then
            tipoObjeto = "Script"
            info = "Ativo: " .. (objeto.Enabled and "Sim" or "Nao")
            
        else
            tipoObjeto = objeto.ClassName
            info = "Tipo desconhecido"
        end
        
        table.insert(statusEventos, string.format("[%s] %s\n   %s", tipoObjeto, objeto.Name, info))
    end
    
    return statusEventos
end

local statusParagraph = EventoStatusTab:CreateParagraph({
    Title = "Status dos Eventos",
    Text = "Carregando informações dos eventos..."
})

task.spawn(function()
    while rodando do
        local tempoDeUso = math.floor(tick() - tempoInicio)
        local eventosInfo = verificarEventos()
        
        local statusTexto = string.format(
            "Tempo de Verificação: %s\nJogador: %s\n\nEVENTOS ATIVOS:\n\n%s",
            obterTempoFormatado(tempoDeUso),
            player.DisplayName or player.Name,
            table.concat(eventosInfo, "\n\n")
        )

        statusParagraph:Set({
            Title = "Status dos Eventos - Roube um Brainrot",
            Text = statusTexto
        })
        
        task.wait(2)
    end
end)

local function pararMonitoramento()
    rodando = false
end

--Evento Otimização
local OtimizacaoTab = Window:CreateTab({
    Name = "Evento Otimização",
    Icon = "speed",
    ImageSource = "Material",
    ShowTitle = true
})

local Label = OtimizacaoTab:CreateLabel({
    Text = "STATUS: ONLINE",
    Style = 2
})

--Remover Áudio
local Paragraph = OtimizacaoTab:CreateParagraph({
    Title = "Gerenciador de Áudio",
    Text = "Remove todos os sons localizados na pasta 'Sounds' da Workspace, ajudando a melhorar o desempenho e a concentração durante o jogo."
})

local isSoundsRemovalActive = false

local Toggle = OtimizacaoTab:CreateToggle({
    Name = "Remover Sounds (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local folderName = "Sounds"
        isSoundsRemovalActive = state
        
        if state then
            spawn(function()
                while isSoundsRemovalActive do
                    local folder = ws:FindFirstChild(folderName)
                    if folder and folder:IsA("Folder") then
                        for i, obj in pairs(folder:GetChildren()) do
                            if not isSoundsRemovalActive then break end
                            if i % 10 == 0 then
                                wait(0.1)
                            end
                            pcall(function()
                                print("[EcoHub] Removido: " .. obj.Name .. " (" .. obj.ClassName .. ")")
                                obj:Destroy()
                            end)
                        end
                    end
                    wait(1)
                end
            end)
        end
    end
})

--Remover GalaxySpinWheels
local Paragraph = OtimizacaoTab:CreateParagraph({
    Title = "Gerenciador de GalaxySpinWheels",
    Text = "Remove automaticamente todos os objetos encontrados dentro da pasta 'GalaxySpinWheels' na Workspace para melhorar o desempenho e evitar distrações."
})

local isGalaxyRemovalActive = false

local Toggle = OtimizacaoTab:CreateToggle({
    Name = "Remover GalaxySpinWheels (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local folderName = "GalaxySpinWheels"
        isGalaxyRemovalActive = state
        
        if state then
            spawn(function()
                while isGalaxyRemovalActive do
                    local folder = ws:FindFirstChild(folderName)
                    if folder and folder:IsA("Folder") then
                        for i, obj in pairs(folder:GetChildren()) do
                            if not isGalaxyRemovalActive then break end
                            if i % 10 == 0 then
                                wait(0.1)
                            end
                            pcall(function()
                                print("[EcoHub] Removido: " .. obj.Name .. " (" .. obj.ClassName .. ")")
                                obj:Destroy()
                            end)
                        end
                    end
                    wait(1)
                end
            end)
        end
    end
})

--Remover Road
local Paragraph = OtimizacaoTab:CreateParagraph({
    Title = "Gerenciador de Estradas",
    Text = "Remove todos os objetos presentes na pasta 'Road' da Workspace para otimizar o desempenho do jogo e reduzir elementos visuais desnecessários."
})

local isRoadRemovalActive = false

local Toggle = OtimizacaoTab:CreateToggle({
    Name = "Remover Road (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local folderName = "Road"
        isRoadRemovalActive = state
        
        if state then
            spawn(function()
                while isRoadRemovalActive do
                    local folder = ws:FindFirstChild(folderName)
                    if folder and folder:IsA("Folder") then
                        for i, obj in pairs(folder:GetChildren()) do
                            if not isRoadRemovalActive then break end
                            if i % 10 == 0 then
                                wait(0.1)
                            end
                            pcall(function()
                                print("[EcoHub] Removido: " .. obj.Name .. " (" .. obj.ClassName .. ")")
                                obj:Destroy()
                            end)
                        end
                    end
                    wait(1)
                end
            end)
        end
    end
})

--PathfindingRegions
local Paragraph = OtimizacaoTab:CreateParagraph({
    Title = "Gerenciador de PathfindingRegions",
    Text = "Remove todos os objetos presentes na pasta 'PathfindingRegions' da Workspace para otimizar o desempenho do jogo e reduzir elementos desnecessários."
})

local isPathfindingRemovalActive = false

local Toggle = OtimizacaoTab:CreateToggle({
    Name = "Remover PathfindingRegions (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local folderName = "PathfindingRegions"
        isPathfindingRemovalActive = state
        
        if state then
            spawn(function()
                while isPathfindingRemovalActive do
                    local folder = ws:FindFirstChild(folderName)
                    if folder and folder:IsA("Folder") then
                        for i, obj in pairs(folder:GetChildren()) do
                            if not isPathfindingRemovalActive then break end
                            if i % 10 == 0 then
                                wait(0.1)
                            end
                            pcall(function()
                                print("[EcoHub] Removido: " .. obj.Name .. " (" .. obj.ClassName .. ")")
                                obj:Destroy()
                            end)
                        end
                    end
                    wait(1)
                end
            end)
        end
    end
})

--Events
local Paragraph = OtimizacaoTab:CreateParagraph({
    Title = "Gerenciador de Events",
    Text = "Remove todos os objetos presentes na pasta 'Events' da Workspace para otimizar o desempenho do jogo e reduzir elementos desnecessários."
})

local isEventsRemovalActive = false

local Toggle = OtimizacaoTab:CreateToggle({
    Name = "Remover Events (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local folderName = "Events"
        isEventsRemovalActive = state
        
        if state then
            spawn(function()
                while isEventsRemovalActive do
                    local folder = ws:FindFirstChild(folderName)
                    if folder and folder:IsA("Folder") then
                        for i, obj in pairs(folder:GetChildren()) do
                            if not isEventsRemovalActive then break end
                            if i % 10 == 0 then
                                wait(0.1)
                            end
                            pcall(function()
                                print("[EcoHub] Removido: " .. obj.Name .. " (" .. obj.ClassName .. ")")
                                obj:Destroy()
                            end)
                        end
                    end
                    wait(1)
                end
            end)
        else
            print("[EcoHub] Remoção de Events desativada")
        end
    end
})

--Otimização V2 - Versão Otimizada
local Paragraph = OtimizacaoTab:CreateParagraph({
    Title = "Otimização Visual do Mapa",
    Text = "Remove todas as texturas aplicadas aos objetos dentro da pasta 'Map' na Workspace e substitui por uma textura estilo Minecraft, melhorando o desempenho e dando um visual mais limpo ao jogo."
})

local Toggle = OtimizacaoTab:CreateToggle({
    Name = "Aplica Otimização Visual (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local RunService = game:GetService("RunService")
        local folderName = "Map"
        local processedObjects = {}
        local connection
        
        if state then
            connection = RunService.Heartbeat:Connect(function()
                local folder = ws:FindFirstChild(folderName)
                if not folder then return end
                
                local descendants = folder:GetDescendants()
                local batchSize = 5
                local processed = 0
                
                for _, obj in ipairs(descendants) do
                    if processed >= batchSize then break end
                    if processedObjects[obj] then continue end
                    
                    local success = pcall(function()
                        if obj:IsA("AnimationController") then
                            obj:Destroy()
                        elseif obj:IsA("MeshPart") then
                            obj.TextureID = "rbxassetid://9479481323"
                            obj.RenderFidelity = Enum.RenderFidelity.Performance
                            obj.CastShadow = false
                        elseif obj:IsA("Part") then
                            obj.CastShadow = false
                            obj.Material = Enum.Material.Granite
                            
                            for _, child in ipairs(obj:GetChildren()) do
                                if child:IsA("Texture") or child:IsA("Decal") then
                                    child:Destroy()
                                end
                            end

                            local newTexture = Instance.new("Texture")
                            newTexture.Texture = "rbxassetid://9479481323"
                            newTexture.Face = Enum.NormalId.Top
                            newTexture.StudsPerTileU = 4
                            newTexture.StudsPerTileV = 4
                            newTexture.Parent = obj
                        elseif obj:IsA("SurfaceAppearance") or obj:IsA("ParticleEmitter") or 
                               obj:IsA("Trail") or obj:IsA("Beam") then
                            obj:Destroy()
                        elseif obj:IsA("Sound") then
                            obj.Volume = 0
                        elseif obj:IsA("Light") then
                            obj.Enabled = false
                        end
                    end)
                    
                    if success then
                        processedObjects[obj] = true
                        processed = processed + 1
                    end
                end
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
            processedObjects = {}
        end
    end
})

local Toggle2 = OtimizacaoTab:CreateToggle({
    Name = "Aplica Otimização Brainrot (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local RunService = game:GetService("RunService")
        local folderName = "RenderedMovingAnimals"
        local connection
        local processedObjects = {}
        
        if state then
            connection = RunService.Heartbeat:Connect(function()
                local folder = ws:FindFirstChild(folderName)
                if not folder then return end
                
                local descendants = folder:GetDescendants()
                local batchSize = 3
                local processed = 0
                
                for _, obj in ipairs(descendants) do
                    if processed >= batchSize then break end
                    if processedObjects[obj] then continue end
                    
                    local success = pcall(function()
                        if obj:IsA("MeshPart") then
                            obj.TextureID = ""
                            obj.MeshId = ""
                            obj.RenderFidelity = Enum.RenderFidelity.Performance
                            obj.CastShadow = false
                            obj.Material = Enum.Material.SmoothPlastic
                            obj.Reflectance = 0
                        elseif obj:IsA("Part") then
                            obj.CastShadow = false
                            obj.Material = Enum.Material.SmoothPlastic
                            obj.Reflectance = 0
                        elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") or
                               obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                            obj:Destroy()
                        elseif obj:IsA("Light") then
                            obj.Enabled = false
                        elseif obj:IsA("Sound") then
                            obj.Volume = 0
                        end
                    end)
                    
                    if success then
                        processedObjects[obj] = true
                        processed = processed + 1
                    end
                end
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
            processedObjects = {}
        end
    end
})

local Toggle3 = OtimizacaoTab:CreateToggle({
    Name = "Aplica Otimização Base (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local RunService = game:GetService("RunService")
        local folderName = "Plots"
        local connection
        local processedObjects = {}
        
        if state then
            connection = RunService.Heartbeat:Connect(function()
                local folder = ws:FindFirstChild(folderName)
                if not folder or not folder:IsA("Folder") then return end
                
                local batchSize = 4
                local processed = 0
                
                for _, model in ipairs(folder:GetChildren()) do
                    if processed >= batchSize then break end
                    if not model:IsA("Model") then continue end
                    
                    local descendants = model:GetDescendants()
                    
                    for _, obj in ipairs(descendants) do
                        if processed >= batchSize then break end
                        if processedObjects[obj] then continue end
                        
                        local success = pcall(function()
                            if obj:IsA("MeshPart") then
                                obj.TextureID = ""
                                obj.MeshId = ""
                                obj.RenderFidelity = Enum.RenderFidelity.Performance
                                obj.CastShadow = false
                                obj.Material = Enum.Material.SmoothPlastic
                                obj.Reflectance = 0
                                obj.TopSurface = Enum.SurfaceType.Smooth
                                obj.BottomSurface = Enum.SurfaceType.Smooth
                            elseif obj:IsA("Part") then
                                obj.CastShadow = false
                                obj.Material = Enum.Material.SmoothPlastic
                                obj.Reflectance = 0
                                obj.TopSurface = Enum.SurfaceType.Smooth
                                obj.BottomSurface = Enum.SurfaceType.Smooth
                            elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") or
                                   obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or
                                   obj:IsA("Sound") then
                                obj:Destroy()
                            elseif obj:IsA("Light") then
                                obj.Enabled = false
                            end
                        end)
                        
                        if success then
                            processedObjects[obj] = true
                            processed = processed + 1
                        end
                    end
                end
            end)
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
            processedObjects = {}
        end
    end
})

--Evento Galaxy
local EventoGalaxyTab = Window:CreateTab({
    Name = "Evento Galaxy",
    Icon = "blur_on",
    ImageSource = "Material",
    ShowTitle = true 
})

local Label = EventoGalaxyTab:CreateLabel({
    Text = "STATUS: ONLINE",
    Style = 2
})

--Galaxy
local Paragraph = EventoGalaxyTab:CreateParagraph({
    Title = "Gerenciador de Galaxy",
    Text = "Remove todos os objetos das pastas GalaxyWeather e GalaxyMap para otimizar o jogo e reduzir lag."
})

local Toggle = EventoGalaxyTab:CreateToggle({
    Name = "Remover GalaxyWeather (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local folderName = "GalaxyWeather"
        local isRunning = state

        if state then
            print("[EcoHub] Remoção de GalaxyWeather iniciada")
            task.spawn(function()
                while isRunning do
                    local folder = ws:FindFirstChild(folderName)
                    if folder and folder:IsA("Folder") then
                        for i, obj in pairs(folder:GetChildren()) do
                            if not isRunning then break end
                            if i % 10 == 0 then task.wait(0.1) end
                            pcall(function()
                                obj:Destroy()
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            print("[EcoHub] Remoção de GalaxyWeather encerrada")
        end
    end
})

local Toggle = EventoGalaxyTab:CreateToggle({
    Name = "Remover GalaxyMap (NEW)",
    Description = nil,
    CurrentValue = false,
    Callback = function(state)
        local ws = game:GetService("Workspace")
        local folderName = "GalaxyMap"
        local isRunning = state

        if state then
            print("[EcoHub] Remoção de GalaxyMap iniciada")
            task.spawn(function()
                while isRunning do
                    local folder = ws:FindFirstChild(folderName)
                    if folder and folder:IsA("Folder") then
                        for i, obj in pairs(folder:GetChildren()) do
                            if not isRunning then break end
                            if i % 10 == 0 then task.wait(0.1) end

                            pcall(function()
                                if obj:IsA("Model") then
                                    local parts = obj:GetDescendants()
                                    local partCount = 0
                                    for _, p in pairs(parts) do
                                        if p:IsA("BasePart") then
                                            partCount += 1
                                        end
                                    end

                                    if partCount <= 3 then
                                        obj:Destroy()
                                        print("[EcoHub] Model pequeno removido: " .. obj.Name)
                                    end
                                end
                            end)
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            print("[EcoHub] Remoção de GalaxyMap encerrada")
        end
    end
})
