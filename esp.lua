-- Создаем GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
local menuFrame = Instance.new("Frame")
local playerNameLabel = Instance.new("TextLabel")
local highlightButton = Instance.new("TextButton")
local deleteHighlightButton = Instance.new("TextButton")
local clearESPButton = Instance.new("TextButton")
local openButton = Instance.new("TextButton")
local closeButton = Instance.new("TextButton")
local playersList = Instance.new("ScrollingFrame")
local playersListLayout = Instance.new("UIListLayout")

-- Настройки GUI
screenGui.Parent = player:WaitForChild("PlayerGui")

menuFrame.Size = UDim2.new(0.6, 0, 0.8, 0)
menuFrame.Position = UDim2.new(0.2, 0, 0.1, 0)
menuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false -- Меню будет скрыто по умолчанию
menuFrame.Parent = screenGui

playerNameLabel.Size = UDim2.new(0.9, 0, 0.1, 0)
playerNameLabel.Position = UDim2.new(0.05, 0, 0.07, 0)
playerNameLabel.Text = "Введите ник игрока"
playerNameLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameLabel.Parent = menuFrame

highlightButton.Size = UDim2.new(0.9, 0, 0.1, 0)
highlightButton.Position = UDim2.new(0.05, 0, 0.15, 0)
highlightButton.Text = "Подсветить игрока"
highlightButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
highlightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
highlightButton.Parent = menuFrame

deleteHighlightButton.Size = UDim2.new(0.9, 0, 0.1, 0)
deleteHighlightButton.Position = UDim2.new(0.05, 0, 0.25, 0)
deleteHighlightButton.Text = "Удалить все подсветки"
deleteHighlightButton.BackgroundColor3 = Color3.fromRGB(255, 170, 85)
deleteHighlightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
deleteHighlightButton.Parent = menuFrame

clearESPButton.Size = UDim2.new(0.9, 0, 0.1, 0)
clearESPButton.Position = UDim2.new(0.05, 0, 0.35, 0)
clearESPButton.Text = "Очистить ESP"
clearESPButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
clearESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
clearESPButton.Parent = menuFrame

playersList.Size = UDim2.new(0.9, 0, 0.4, 0)
playersList.Position = UDim2.new(0.05, 0, 0.55, 0)
playersList.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
playersList.ScrollBarThickness = 10
playersList.Parent = menuFrame

local playersListLayout = Instance.new("UIListLayout")
playersListLayout.Parent = playersList
playersListLayout.FillDirection = Enum.FillDirection.Vertical
playersListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
playersListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
playersListLayout.Padding = UDim.new(0, 5)

local previousHighlightedPlayer

-- Функция обновления списка игроков
local function updatePlayerList()
    for _, child in pairs(playersList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, p in pairs(game.Players:GetPlayers()) do
        local playerButton = Instance.new("TextButton")
        playerButton.Size = UDim2.new(1, 0, 0, 30)
        playerButton.Text = p.Name
        playerButton.TextScaled = true
        playerButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerButton.Parent = playersList

        playerButton.MouseButton1Click:Connect(function()
            playerNameLabel.Text = p.Name -- Изменяем текст на имени игрока
        end)
    end
end

-- Подсветка игрока
highlightButton.MouseButton1Click:Connect(function()
    local targetPlayerName = playerNameLabel.Text
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)

    if targetPlayer and targetPlayer.Character then
        -- Удаляем предыдущую подсветку (если есть)
        if previousHighlightedPlayer then            local previousHighlight = workspace:FindFirstChild(previousHighlightedPlayer.Name .. "_Highlight")
            if previousHighlight then
                previousHighlight:Destroy()
            end
        end

        -- Создаем новую подсветку
        local highlight = Instance.new("Highlight")
        highlight.Name = targetPlayer.Name .. "_Highlight"
        highlight.Adornee = targetPlayer.Character
        highlight.Parent = workspace
        
        highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Цвет заполнения подсветки
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Цвет обводки подсветки

        previousHighlightedPlayer = targetPlayer -- Запоминаем текущего игрока для удаления подсветки

        print("Подсветка игрока " .. targetPlayerName .. " активирована.")
    else
        print("Игрок с ником '" .. targetPlayerName .. "' не найден или не имеет персонажа.")
    end
end)

-- Удаление всех подсветок
deleteHighlightButton.MouseButton1Click:Connect(function()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Highlight") then
            obj:Destroy()
        end
    end
    previousHighlightedPlayer = nil -- Сбрасываем предыдущего подсвеченного игрока
    print("Все подсветки удалены.")
end)

-- Кнопка "Открыть" в углу экрана
openButton.Size = UDim2.new(0.1, 0, 0.05, 0)
openButton.Position = UDim2.new(0.01, 0, 0.01, 0) -- Положение в левом верхнем углу
openButton.Text = "Открыть"
openButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Parent = screenGui

-- Кнопка "Закрыть" в углу экрана
closeButton.Size = UDim2.new(0.1, 0, 0.05, 0)
closeButton.Position = UDim2.new(0.12, 0, 0.01, 0) -- Положение рядом с кнопкой "Открыть"
closeButton.Text = "Закрыть"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = screenGui

-- Открытие меню
openButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = true
end)

-- Закрытие меню
closeButton.MouseButton1Click:Connect(function()
    menuFrame.Visible = false
end)

-- Обновляем список игроков при запуске и при изменении списка игроков
updatePlayerList()

game.Players.PlayerAdded:Connect(updatePlayerList) -- Обновление списка при добавлении нового игрока.
game.Players.PlayerRemoving:Connect(updatePlayerList) -- Обновление списка при удалении игрока.
