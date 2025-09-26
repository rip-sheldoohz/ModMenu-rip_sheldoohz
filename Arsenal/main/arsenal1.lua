local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local ArsenalPlaceIds = {
    286090429,
    301549746,
    742848358
}

local function IsArsenal()
    local currentPlaceId = game.PlaceId
    for _, placeId in pairs(ArsenalPlaceIds) do
        if currentPlaceId == placeId then
            return true
        end
    end
    return false
end

local function KickPlayer()
    Player:Kick("EcoHub detectou que você não está jogando Arsenal. Este sistema foi projetado exclusivamente para Arsenal. Por favor, entre no Arsenal para usar o EcoHub.")
end

local function ExecuteArsenalScript()
    local success, error = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/rip-sheldoohz/menuscriptrip_sheldoohz/main/Arsenal/main/033567438422068.lua", true))()
    end)
    
    if success then
        print("[EcoHub] Script Arsenal carregado com sucesso")
    else
        print("[EcoHub] Erro ao carregar script Arsenal: " .. tostring(error))
    end
end

if IsArsenal() then
    print("[EcoHub] Arsenal detectado, carregando sistema...")
    ExecuteArsenalScript()
else
    print("[EcoHub] Jogo não autorizado detectado, iniciando kick...")
    KickPlayer()
end
