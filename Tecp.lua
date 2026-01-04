-- Interface Básica Centralizada
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- Configurar ScreenGui
ScreenGui.Name = "BasicInfoGUI"
ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Configurar Frame Principal
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Adicionar sombra
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Parent = MainFrame
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Configurar Título
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "INFORMAÇÕES BÁSICAS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Configurar Botão de Fechar
CloseButton.Name = "CloseButton"
CloseButton.Parent = Title
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0.5, -12)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.ZIndex = 2

-- Configurar ScrollingFrame
ScrollingFrame.Parent = MainFrame
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)

-- Configurar UIListLayout
UIListLayout.Parent = ScrollingFrame
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Função para criar itens de informação
function createInfoItem(title, value, color)
    local ItemFrame = Instance.new("Frame")
    local TitleLabel = Instance.new("TextLabel")
    local ValueLabel = Instance.new("TextLabel")
    
    ItemFrame.Name = "ItemFrame"
    ItemFrame.Parent = ScrollingFrame
    ItemFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ItemFrame.BorderSizePixel = 0
    ItemFrame.Size = UDim2.new(1, 0, 0, 40)
    
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = ItemFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Size = UDim2.new(0.5, -10, 1, 0)
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.Text = "  " .. title
    TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    ValueLabel.Name = "ValueLabel"
    ValueLabel.Parent = ItemFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    ValueLabel.Size = UDim2.new(0.5, -10, 1, 0)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = color or Color3.fromRGB(100, 200, 255)
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    return ItemFrame
end

-- Atualizar tamanho do canvas
function updateCanvasSize()
    local totalHeight = 0
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight += child.AbsoluteSize.Y + UIListLayout.Padding.Offset
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Adicionar informações básicas
createInfoItem("Jogador", game.Players.LocalPlayer.Name)
createInfoItem("ID do Jogador", game.Players.LocalPlayer.UserId)
createInfoItem("Saldo (FPS)", game:GetService("Stats").Workspace.Memory.HeapSize:GetValue())
createInfoItem("Mapa", game:GetService("Workspace").Name)
createInfoItem("Servidor ID", game.JobId)
createInfoItem("Jogadores Online", #game.Players:GetPlayers())
createInfoItem("Tempo no Servidor", "00:00")

-- Atualizar tempo
local startTime = tick()
local TimeLabel = createInfoItem("Tempo Online", "Calculando...", Color3.fromRGB(255, 200, 100))

spawn(function()
    while ScreenGui.Parent do
        local elapsed = math.floor(tick() - startTime)
        local minutes = math.floor(elapsed / 60)
        local seconds = elapsed % 60
        TimeLabel.ValueLabel.Text = string.format("%02d:%02d", minutes, seconds)
        wait(1)
    end
end)

-- Adicionar informações do executor (se disponível)
if getgenv then
    createInfoItem("Executor", "Synapse X", Color3.fromRGB(0, 255, 150))
else
    createInfoItem("Executor", "Unknown", Color3.fromRGB(255, 100, 100))
end

-- Adicionar FPS
local FPSLabel = createInfoItem("FPS", "Calculando...", Color3.fromRGB(150, 255, 150))

spawn(function()
    local RunService = game:GetService("RunService")
    local fps = 0
    local frames = 0
    local lastTime = tick()
    
    while ScreenGui.Parent do
        frames += 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            fps = frames
            frames = 0
            lastTime = currentTime
            FPSLabel.ValueLabel.Text = tostring(fps)
        end
        RunService.RenderStepped:Wait()
    end
end)

-- Atualizar tamanho do canvas
updateCanvasSize()
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

-- Função para fechar
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tornar arrastável
local dragging = false
local dragInput, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Atalho de teclado para mostrar/esconder
local visible = true
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        MainFrame.Visible = visible
    end
end)

print("Interface carregada! Pressione RightControl para mostrar/esconder.")
