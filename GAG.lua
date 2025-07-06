local GIFT_LIMIT = _G.GIFT_LIMIT or 999

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local cancel = false
local SelectedPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitGiftingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 360)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 100)
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍎  Fruit Gifter"
Title.TextColor3 = Color3.fromRGB(230, 230, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextStrokeTransparency = 0.8
Title.Parent = MainFrame

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -20, 0, 1)
Divider.Position = UDim2.new(0, 10, 0, 32)
Divider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

local FruitList = Instance.new("ScrollingFrame")
FruitList.Size = UDim2.new(1, -20, 0, 90)
FruitList.Position = UDim2.new(0, 10, 0, 40)
FruitList.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
FruitList.BorderSizePixel = 0
FruitList.CanvasSize = UDim2.new(0, 0, 5, 0)
FruitList.ScrollBarThickness = 4
FruitList.Parent = MainFrame

local TotalCount = Instance.new("TextLabel")
TotalCount.Size = UDim2.new(1, -20, 0, 16)
TotalCount.Position = UDim2.new(0, 10, 0, 135)
TotalCount.BackgroundTransparency = 1
TotalCount.TextColor3 = Color3.fromRGB(190, 190, 255)
TotalCount.Font = Enum.Font.Gotham
TotalCount.TextSize = 12
TotalCount.Text = "Total Fruits: 0"
TotalCount.Parent = MainFrame

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Size = UDim2.new(1, -20, 0, 26)
PlayerDropdown.Position = UDim2.new(0, 10, 0, 155)
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 90)
PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDropdown.Font = Enum.Font.GothamSemibold
PlayerDropdown.TextSize = 13
PlayerDropdown.Text = "Select Player"
PlayerDropdown.BorderSizePixel = 0
PlayerDropdown.AutoButtonColor = true
PlayerDropdown.Parent = MainFrame

local DropdownFrame = Instance.new("ScrollingFrame")
DropdownFrame.Size = UDim2.new(1, -20, 0, 60)
DropdownFrame.Position = UDim2.new(0, 10, 0, 185)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
DropdownFrame.Visible = false
DropdownFrame.ScrollBarThickness = 3
DropdownFrame.BorderSizePixel = 0
DropdownFrame.Parent = MainFrame

local GiftBtn = Instance.new("TextButton")
GiftBtn.Size = UDim2.new(1, -20, 0, 28)
GiftBtn.Position = UDim2.new(0, 10, 0, 250)
GiftBtn.Text = "🏷 Gift All"
GiftBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 60)
GiftBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GiftBtn.Font = Enum.Font.GothamBold
GiftBtn.TextSize = 13
GiftBtn.BorderSizePixel = 0
GiftBtn.Parent = MainFrame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 16)
Status.Position = UDim2.new(0, 10, 0, 282)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.Text = ""
Status.Parent = MainFrame

local CancelBtn = Instance.new("TextButton")
CancelBtn.Size = UDim2.new(1, -20, 0, 26)
CancelBtn.Position = UDim2.new(0, 10, 0, 302)
CancelBtn.Text = "✖ Cancel"
CancelBtn.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
CancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelBtn.Font = Enum.Font.GothamBold
CancelBtn.TextSize = 13
CancelBtn.BorderSizePixel = 0
CancelBtn.Visible = false
CancelBtn.Parent = MainFrame

for _, element in ipairs({PlayerDropdown, DropdownFrame, GiftBtn, CancelBtn, FruitList}) do
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = element
end

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

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
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

local function refreshFruitList()
    FruitList:ClearAllChildren()
    local fruits = getFruitTools()
    TotalCount.Text = "Total Fruits: " .. tostring(#fruits)
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

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn
    end
end

local function teleportToPlayer(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
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

local function giftFruits()
    if not SelectedPlayer then return end
    local fruits = getFruitTools()
    cancel = false

    teleportToPlayer(SelectedPlayer)
    CancelBtn.Visible = true

    task.spawn(function()
        for i = 1, math.min(#fruits, GIFT_LIMIT) do
            if cancel then break end
            local fruit = fruits[i]
            Status.Text = "Gifting (" .. tostring(i) .. "/" .. tostring(math.min(#fruits, GIFT_LIMIT)) .. ")..."

            pcall(function()
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
            end)
        end
        Status.Text = cancel and "Gifting cancelled." or ("Gifted " .. tostring(math.min(#fruits, GIFT_LIMIT)) .. " fruit(s).")
        CancelBtn.Visible = false
        task.wait(1)
        Status.Text = ""
        refreshFruitList()
    end)
end

GiftBtn.MouseButton1Click:Connect(giftFruits)
CancelBtn.MouseButton1Click:Connect(function()
    cancel = true
end)

Backpack.ChildAdded:Connect(refreshFruitList)
Backpack.ChildRemoved:Connect(refreshFruitList)
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

refreshFruitList()
refreshPlayerList()
