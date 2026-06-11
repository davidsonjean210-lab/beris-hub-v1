local Players = game:GetService("Players")
local player = Players.LocalPlayer

------------------------------------------------
-- CONFIG
------------------------------------------------
local incomeMode = "BASICO"

local config = {
    BASICO = {money = 100, delay = 2},
    PREMIUM = {money = 10000, delay = 1.5},
    PLUS = {money = 20000, delay = 1}
}

------------------------------------------------
-- UI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "IncomeTestUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0, 20, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,0,40)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Text = "Modo: BASICO"
label.Parent = frame

------------------------------------------------
-- BOTÓN CREATOR
------------------------------------------------
local function btn(text, y, mode)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-10,0,30)
    b.Position = UDim2.new(0,5,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Parent = frame

    b.MouseButton1Click:Connect(function()
        incomeMode = mode
        label.Text = "Modo: " .. mode
    end)

    return b
end

btn("BASICO", 45, "BASICO")
btn("PREMIUM", 80, "PREMIUM")
btn("PLUS", 115, "PLUS")

------------------------------------------------
-- DINERO (TEST SOLO LOCAL)
------------------------------------------------
local function giveMoney(amount)
    local stats = player:FindFirstChild("leaderstats")
    if not stats then return end

    for _, v in pairs(stats:GetChildren()) do
        if v:IsA("IntValue") then
            v.Value += amount
            return
        end
    end
end

task.spawn(function()
    while true do
        local data = config[incomeMode]

        giveMoney(data.money)
        task.wait(data.delay)
    end
end)