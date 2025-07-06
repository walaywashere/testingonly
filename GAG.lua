-- ✅ FULL SCRIPT with working GIFT_LIMIT, cancel, dropdown, gifting loop, and total fruit count

local GIFT_LIMIT = _G.GIFT_LIMIT or 999

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cancel = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitGiftingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 440)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "🍎 Fruit Gifter"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

local FruitList = Instance.new("ScrollingFrame")
FruitList.Size = UDim2.new(1, -20, 0.30, 0)
FruitList.Position = UDim2.new(0, 10, 0, 40)
FruitList.CanvasSize = UDim2.new(0, 0, 5, 0)
FruitList.ScrollBarThickness = 4
FruitList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FruitList.BorderSizePixel = 0
FruitList.Parent = MainFrame

local FruitCountLabel = Instance.new("TextLabel")
FruitCountLabel.Size = UDim2.new(1, -20, 0, 20)
FruitCountLabel.Position = UDim2.new(0, 10, 0.31, 0)
FruitCountLabel.BackgroundTransparency = 1
FruitCountLabel.TextColor3 = Color3.new(1, 1, 1)
FruitCountLabel.Font = Enum.Font.Gotham
FruitCountLabel.TextSize = 13
FruitCountLabel.Text = "Total Fruits: 0"
FruitCountLabel.TextXAlignment = Enum.TextXAlignment.Left
FruitCountLabel.Parent = MainFrame

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Size = UDim2.new(1, -20, 0, 30)
PlayerDropdown.Position = UDim2.new(0, 10, 0.36, 0)
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 120)
PlayerDropdown.TextColor3 = Color3.new(1, 1, 1)
PlayerDropdown.Font = Enum.Font.GothamSemibold
PlayerDropdown.TextSize = 14
PlayerDropdown.Text = "Select Player"
PlayerDropdown.AutoButtonColor = false
PlayerDropdown.BorderSizePixel = 0
PlayerDropdown.Parent = MainFrame

local DropdownFrame = Instance.new("ScrollingFrame")
DropdownFrame.Size = UDim2.new(1, -20, 0, 90)
DropdownFrame.Position = UDim2.new(0, 10, 0.44, 0)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
DropdownFrame.Visible = false
DropdownFrame.ScrollBarThickness = 4
DropdownFrame.BorderSizePixel = 0
DropdownFrame.Parent = MainFrame

local UICorner2 = UICorner:Clone()
UICorner2.Parent = PlayerDropdown

local UICorner3 = UICorner:Clone()
UICorner3.Parent = DropdownFrame

local SelectedPlayer = nil

PlayerDropdown.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
end)

local function refreshPlayerList()
    DropdownFrame:ClearAllChildren()
    local y = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.Position = UDim2.new(0, 0, 0, y)
            y = y + 28
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 13
            btn.Text = player.Name
            btn.AutoButtonColor = false
            btn.BorderSizePixel = 0
            btn.Parent = DropdownFrame

            local corner = UICorner:Clone()
            corner.Parent = btn

            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)

            btn.MouseButton1Click:Connect(function()
                SelectedPlayer = player
                PlayerDropdown.Text = "To: " .. player.Name
                DropdownFrame.Visible = false
            end)
        end
    end
    DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

local function getFruitTools()
    local fruits = {}
    local function checkAndAdd(container)
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("Weight") then
                table.insert(fruits, item)
            end
        end
    end
    checkAndAdd(Backpack)
    if LocalPlayer.Character then
        checkAndAdd(LocalPlayer.Character)
    end
    return fruits
end

local function triggerPrompt(player)
    if not player or not player.Character then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or (hrp.Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude > 10 then return false end
    for _, child in ipairs(hrp:GetChildren()) do
        if child:IsA("ProximityPrompt") and child.Enabled then
            fireproximityprompt(child)
            return true
        end
    end
    return false
end

local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(1, -20, 0, 30)
ButtonFrame.Position = UDim2.new(0, 10, 0.58, 0)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonFrame

local function styledButton(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.5, -4, 1, 0)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Text = text
    btn.AutoButtonColor = true
    btn.BorderSizePixel = 0
    local corner = UICorner:Clone()
    corner.Parent = btn
    return btn
end

local RefreshBtn = styledButton("🔁 Refresh", Color3.fromRGB(90, 90, 140))
RefreshBtn.Parent = ButtonFrame

local GiftAllBtn = styledButton("🏷 Gift All", Color3.fromRGB(140, 60, 60))
GiftAllBtn.Parent = ButtonFrame

local selectedFruitButton = nil
local selectedFruit = nil

local function refreshFruitList()
    FruitList:ClearAllChildren()
    local fruits = getFruitTools()
    FruitCountLabel.Text = "Total Fruits: " .. tostring(#fruits)
    for i, fruit in ipairs(fruits) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.Position = UDim2.new(0, 0, 0, (i - 1) * 28)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Text = fruit.Name
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Parent = FruitList

        local corner = UICorner:Clone()
        corner.Parent = btn
    end
end

GiftAllBtn.MouseButton1Click:Connect(function()
    if not SelectedPlayer then return end
    local fruits = getFruitTools()
    cancel = false

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 20)
    statusLabel.Position = UDim2.new(0, 10, 0.87, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 13
    statusLabel.Text = ""
    statusLabel.Parent = MainFrame

    local cancelButton = styledButton("✖ Cancel", Color3.fromRGB(100, 30, 30))
    cancelButton.Size = UDim2.new(1, -20, 0, 30)
    cancelButton.Position = UDim2.new(0, 10, 0.80, 0)
    cancelButton.Parent = MainFrame

    cancelButton.MouseButton1Click:Connect(function()
        cancel = true
    end)

    task.spawn(function()
        local gifted = 0
        for _, fruit in ipairs(fruits) do
            if cancel or gifted >= GIFT_LIMIT then break end
            statusLabel.Text = "Gifting (" .. tostring(gifted + 1) .. "/" .. tostring(math.min(#fruits, GIFT_LIMIT)) .. ")..."

            pcall(function()
                selectedFruit = fruit
                selectedFruitButton = nil
                fruit.Parent = LocalPlayer.Character
                task.wait(0.35)
                triggerPrompt(SelectedPlayer)
                task.wait(0.1)
                triggerPrompt(SelectedPlayer)

                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid:UnequipTools() end

                local timeout = 0.3
                while (Backpack:FindFirstChild(fruit.Name) or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(fruit.Name))) and timeout > 0 do
                    task.wait(0.05)
                    timeout -= 0.05
                end

                selectedFruit = nil
                selectedFruitButton = nil
            end)

            gifted += 1
        end
        statusLabel.Text = cancel and "Gifting cancelled." or ("Gifted " .. tostring(gifted) .. " fruit(s).")
        cancelButton:Destroy()
        task.wait(1)
        statusLabel:Destroy()
        refreshFruitList()
    end)
end)

Backpack.ChildAdded:Connect(refreshFruitList)
Backpack.ChildRemoved:Connect(refreshFruitList)
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

refreshFruitList()
refreshPlayerList()
