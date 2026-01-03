-- Blox Fruits Script (Para fins educacionais)
-- Não use isso para trapacear em jogos online

-- Configuração inicial
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

-- Interface gráfica
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits Script", "Sentinel")

-- Abas principais
local MainTab = Window:NewTab("Principal")
local FarmingTab = Window:NewTab("Farm Automático")
local TeleportTab = Window:NewTab("Teleportes")
local PlayerTab = Window:NewTab("Player")

-- Seções
local MainSection = MainTab:NewSection("Funções Principais")
local FarmSection = FarmingTab:NewSection("Configurações de Farm")
local TeleportSection = TeleportTab:NewSection("Locais para Teleporte")
local PlayerSection = PlayerTab:NewSection("Ajustes do Player")

-- Variáveis
local AutoFarm = false
local AutoCollectFruits = false
local AutoRedeemCodes = false

-- Função de farm automático
MainSection:NewToggle("Farm Automático", "Farm automaticamente os inimigos", function(state)
    AutoFarm = state
    
    if state then
        while AutoFarm do
            wait(0.5)
            -- Lógica para farm (apenas exemplo)
            pcall(function()
                local nearestEnemy = findNearestEnemy()
                if nearestEnemy then
                    Player.Character.HumanoidRootPart.CFrame = nearestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    attackEnemy(nearestEnemy)
                end
            end)
        end
    end
end)

-- Coletar frutas automático
MainSection:NewToggle("Coletar Frutas", "Coleta frutas automaticamente", function(state)
    AutoCollectFruits = state
    
    if state then
        spawn(function()
            while AutoCollectFruits do
                wait(1)
                collectFruits()
            end
        end)
    end
end)

-- Resgatar códigos
MainSection:NewButton("Resgatar Códigos", "Resgata todos os códigos disponíveis", function()
    local codes = {
        "KITT_RESET",
        "SUB2GAMERROBOT_RESET1",
        "SUB2NOOBMASTER123",
        "Sub2Daigrock"
    }
    
    for _, code in pairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
        wait(1)
    end
end)

-- Farm de inimigos específicos
FarmSection:NewDropdown("Selecionar Inimigo", "Escolha qual inimigo farmar", 
    {"Bandido", "Marinha", "Chefe Pirata", "Chefe da Ilha"}, function(selected)
    -- Lógica para farm do inimigo selecionado
    print("Farmando: " .. selected)
end)

-- Teleportes para ilhas
local islands = {
    ["Ilha Inicial"] = CFrame.new(100, 50, 100),
    ["Vila Pirata"] = CFrame.new(-800, 50, 1500),
    ["Marine Base"] = CFrame.new(2500, 50, -800),
    ["Sky Island"] = CFrame.new(5000, 5000, 0)
}

for islandName, position in pairs(islands) do
    TeleportSection:NewButton(islandName, "Teleporte para " .. islandName, function()
        Player.Character.HumanoidRootPart.CFrame = position
    end)
end)

-- Ajustes do player
PlayerSection:NewSlider("Velocidade de Caminhada", "Ajusta a velocidade", 100, 16, function(s)
    Player.Character.Humanoid.WalkSpeed = s
end)

PlayerSection:NewSlider("Força do Pulo", "Ajusta a altura do pulo", 100, 50, function(s)
    Player.Character.Humanoid.JumpPower = s
end)

-- Noclip
local noclip = false
PlayerSection:NewToggle("Noclip", "Atravessa paredes", function(state)
    noclip = state
    
    if state then
        spawn(function()
            while noclip do
                wait()
                pcall(function()
                    for _, part in pairs(Player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
            end
        end)
    else
        pcall(function()
            for _, part in pairs(Player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end)
    end
end)

-- Funções auxiliares (exemplo)
function findNearestEnemy()
    local nearest = nil
    local nearestDistance = math.huge
    
    for _, enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
            local distance = (Player.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearest = enemy
                nearestDistance = distance
            end
        end
    end
    
    return nearest
end

function collectFruits()
    for _, fruit in pairs(game:GetService("Workspace"):GetChildren()) do
        if fruit.Name:find("Fruit") and fruit:FindFirstChild("Handle") then
            Player.Character.HumanoidRootPart.CFrame = fruit.Handle.CFrame
            wait(0.5)
        end
    end
end

-- Notificação inicial
Library:Notification("Script Carregado", "Pressione Insert para abrir/fechar", "OK")
