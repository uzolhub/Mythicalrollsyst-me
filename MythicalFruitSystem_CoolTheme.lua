-- LocalScript (place in StarterPlayerScripts or StarterGui)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LuckToggleUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 160, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.BackgroundColor3 = Color3.fromRGB(140, 100, 200)
toggle.Text = "2x LUCK: OFF"
toggle.TextScaled = true
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.GothamBold
toggle.Parent = frame

local rollButton = Instance.new("TextButton")
rollButton.Size = UDim2.new(0, 160, 0, 30)
rollButton.Position = UDim2.new(0, 10, 0, 55)
rollButton.BackgroundColor3 = Color3.fromRGB(90, 130, 200)
rollButton.Text = "Roll (R)"
rollButton.TextScaled = true
rollButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rollButton.Font = Enum.Font.Gotham
rollButton.Parent = frame

local permButton = Instance.new("TextButton")
permButton.Size = UDim2.new(0, 160, 0, 20)
permButton.Position = UDim2.new(0, 10, 0, 90)
permButton.BackgroundColor3 = Color3.fromRGB(70, 170, 170)
permButton.Text = "Get All Mythical (P)"
permButton.TextScaled = true
permButton.TextColor3 = Color3.fromRGB(255, 255, 255)
permButton.Font = Enum.Font.Gotham
permButton.Parent = frame

local luckEnabled = false
toggle.MouseButton1Click:Connect(function()
    luckEnabled = not luckEnabled
    toggle.Text = luckEnabled and "2x LUCK: ON" or "2x LUCK: OFF"
    toggle.BackgroundColor3 = luckEnabled and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(140, 100, 200)
end)

-- RemoteEvent for rolling
local rollEvent = ReplicatedStorage:WaitForChild("RollMythicalFruit")

-- R key or button click triggers roll
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.R then
            rollEvent:FireServer(luckEnabled)
        elseif input.KeyCode == Enum.KeyCode.P then
            rollEvent:FireServer("giveAllPerms")
        end
    end
end)

rollButton.MouseButton1Click:Connect(function()
    rollEvent:FireServer(luckEnabled)
end)

permButton.MouseButton1Click:Connect(function()
    rollEvent:FireServer("giveAllPerms")
end)

-- ServerScript (place in ServerScriptService)
-- Separate script

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local rollEvent = ReplicatedStorage:FindFirstChild("RollMythicalFruit") or Instance.new("RemoteEvent")
rollEvent.Name = "RollMythicalFruit"
rollEvent.Parent = ReplicatedStorage

local allFruits = {"Bomb", "Spin", "Chop", "Spring", "Smoke", "Flame", "Ice", "Dark", "Light", "Sand"}
local mythicalFruits = {"Kitsune", "DragonEast", "DragonWest", "Yeti", "Gas"}

rollEvent.OnServerEvent:Connect(function(player, mode)
    if mode == "giveAllPerms" then
        for _, fruit in ipairs(mythicalFruits) do
            print(player.Name .. " was granted permanent: " .. fruit)
            -- Grant perm logic here
        end
        return
    end

    local fruitName
    if mode then
        fruitName = mythicalFruits[math.random(1, #mythicalFruits)]
    else
        local all = table.clone(allFruits)
        for _, myth in ipairs(mythicalFruits) do
            table.insert(all, myth)
        end
        fruitName = all[math.random(1, #all)]
    end

    print(player.Name .. " received fruit: " .. fruitName)
    -- Add fruit to player's Backpack logic here
end)
