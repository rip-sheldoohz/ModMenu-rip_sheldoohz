local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ModMenu - EcoHub 0.1V",
   Icon = 0,
   LoadingTitle = "EcoHub carregando",
   LoadingSubtitle = "by rip_sheldoohz",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "EcoHub"
   },

   Discord = {
      Enabled = true,
      Invite = "https://discord.gg/abygGhvRCG",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "ModMenu - EcoHub",
      Subtitle = "Key System",
      Note = "Use a chave para acessar o painel",
      FileName = "EcoHubKey",
      SaveKey = true,
      GrabKeyFromSite = true,
      Key = {"modmenu0.1v"}
   }
})


local BloxFruitTab = Window:CreateTab("BloxFruit - Scripts", 140494991404106)

--Solix Hub 
BloxFruitTab:CreateButton({
    Name = "Solix Hub - BloxFruit",
    Callback = function()
        Rayfield:Notify({
            Title = "Executando Script",
            Content = "Solix Hub - BloxFruit está sendo carregado...",
            Duration = 5,
            Image = 140494991404106
        })

        local success, err = pcall(function()
            local scriptURL = "https://raw.githubusercontent.com/debunked69/Solixreworkkeysystem/refs/heads/main/solix%20new%20keyui.lua"
            local response = game:HttpGet(scriptURL)
            assert(response, "Falha ao obter o script do servidor.")
            loadstring(response)()
        end)

        if not success then
            Rayfield:Notify({
                Title = "Erro",
                Content = "Não foi possível executar o script: " .. tostring(err),
                Duration = 5,
                Image = 140494991404106
            })
        end
    end,
})

-- W Azure
BloxFruitTab:CreateButton({
    Name = "W Azure - BloxFruit",
    Callback = function()
        Rayfield:Notify({
            Title = "Executando Script",
            Content = "W Azure - BloxFruit está sendo carregado...",
            Duration = 5,
            Image = 140494991404106
        })

        local success, err = pcall(function()
            local scriptURL = "https://api.luarmor.net/files/v3/loaders/3b2169cf53bc6104dabe8e19562e5cc2.lua"
            local response = game:HttpGet(scriptURL)
            assert(response, "Falha ao obter o script do servidor.")
            loadstring(response)()
        end)

        if not success then
            Rayfield:Notify({
                Title = "Erro",
                Content = "Não foi possível executar o script: " .. tostring(err),
                Duration = 5,
                Image = 140494991404106
            })
        end
    end,
})

--VSripts
BloxFruitTab:CreateButton({
    Name = "VSripts - BloxFruit",
    Callback = function()
        Rayfield:Notify({
            Title = "Executando Script",
            Content = "VSripts - BloxFruit está sendo carregado...",
            Duration = 5,
            Image = 140494991404106
        })

        local success, err = pcall(function()
            local scriptURL = "https://raw.githubusercontent.com/KevinGithubUsers/KevinGithubUsers/refs/heads/main/VScript(Blox%20Fruits).txt"
            local response = game:HttpGet(scriptURL)
            assert(response, "Falha ao obter o script do servidor.")
            loadstring(response)()
        end)

        if not success then
            Rayfield:Notify({
                Title = "Erro",
                Content = "Não foi possível executar o script: " .. tostring(err),
                Duration = 5,
                Image = 140494991404106
            })
        end
    end,
})

--Redz Hub
BloxFruitTab:CreateButton({
    Name = "Redz Hub - BloxFruit",
    Callback = function()
        spawn(function()
            if Rayfield and Rayfield.Notify then
                Rayfield:Notify({
                    Title = "Executando Script",
                    Content = "Redz Hub - BloxFruit está sendo carregado...",
                    Duration = 5,
                    Image = 140494991404106
                })
            end
            
            task.wait(0.5)
            
            local success, err = pcall(function()
                local scriptURL = "https://raw.githubusercontent.com/newredz/BloxFruits/main/Source.lua"
                local script = game:HttpGet(scriptURL, true)
                
                local func = loadstring(script)
                if func then
                    if Settings then
                        func(Settings)
                    else
                        func()
                    end
                else
                    error("Script compilation failed")
                end
            end)
            
            if success then
                if Rayfield and Rayfield.Notify then
                    Rayfield:Notify({
                        Title = "Sucesso",
                        Content = "Script carregado com sucesso!",
                        Duration = 3,
                        Image = 140494991404106
                    })
                end
            else
                if Rayfield and Rayfield.Notify then
                    Rayfield:Notify({
                        Title = "Erro",
                        Content = "Falha ao carregar o script",
                        Duration = 5,
                        Image = 140494991404106
                    })
                end
            end
        end)
    end,
})

--Xero Hub
BloxFruitTab:CreateButton({
    Name = "Xero Hub - BloxFruit",
    Callback = function()
        Rayfield:Notify({
            Title = "Executando Script",
            Content = "Xero Hub - BloxFruit está sendo carregado...",
            Duration = 5,
            Image = 140494991404106
        })

        local success, err = pcall(function()
            local scriptURL = "https://raw.githubusercontent.com/Xero2409/XeroHub/refs/heads/main/main.lua"
            local response = game:HttpGet(scriptURL)
            assert(response, "Falha ao obter o script do servidor.")
            loadstring(response)()
        end)

        if not success then
            Rayfield:Notify({
                Title = "Erro",
                Content = "Não foi possível executar o script: " .. tostring(err),
                Duration = 5,
                Image = 140494991404106
            })
        end
    end,
})

--Astral Hub
BloxFruitTab:CreateButton({
    Name = "Astral Hub - BloxFruit",
    Callback = function()
        Rayfield:Notify({
            Title = "Executando Script",
            Content = "Astral Hub- BloxFruit está sendo carregado...",
            Duration = 5,
            Image = 140494991404106
        })

        local success, err = pcall(function()
            local scriptURL = "https://rawscripts.net/raw/Blox-Fruits-ASTRAL-29222"
            local response = game:HttpGet(scriptURL)
            assert(response, "Falha ao obter o script do servidor.")
            loadstring(response)()
        end)

        if not success then
            Rayfield:Notify({
                Title = "Erro",
                Content = "Não foi possível executar o script: " .. tostring(err),
                Duration = 5,
                Image = 140494991404106
            })
        end
    end,
})

--Configuração
BloxFruitTab:CreateParagraph({Title = "Servidor Blox Fruits", Content = "Clique no botão abaixo para procurar e entrar em um servidor aleatório do Blox Fruits de qualquer região disponível."})
BloxFruitTab:CreateButton({
    Name = "Random - Servidor",
    Callback = function()
        spawn(function()
            if Rayfield and Rayfield.Notify then
                Rayfield:Notify({
                    Title = "Procurando Servidor",
                    Content = "Procurando servidor aleatório do Blox Fruits...",
                    Duration = 3,
                    Image = 140494991404106
                })
            end
            
            local success, err = pcall(function()
                local Http = game:GetService("HttpService")
                local TPS = game:GetService("TeleportService")
                local Api = "https://games.roblox.com/v1/games/"
                
                local _place = game.PlaceId
                local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
                
                local function ListServers(cursor)
                    local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
                    return Http:JSONDecode(Raw)
                end
                
                local Server, Next
                repeat
                    local Servers = ListServers(Next)
                    Server = Servers.data[math.random(1, #Servers.data)]
                    Next = Servers.nextPageCursor
                until Server
                
                if Server then
                    TPS:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
                else
                    error("Nenhum servidor encontrado")
                end
            end)
            
            if not success then
                if Rayfield and Rayfield.Notify then
                    Rayfield:Notify({
                        Title = "Erro",
                        Content = "Falha ao encontrar servidor aleatório",
                        Duration = 5,
                        Image = 140494991404106
                    })
                end
            end
        end)
    end,
})
