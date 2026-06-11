-- BERIS HUB ULTRA FIXED (NO BLACK SCREEN)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

------------------------------------------------
-- SAFE CHARACTER
------------------------------------------------
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    local c = getChar()
    return c:WaitForChild("HumanoidRootPart")
end

------------------------------------------------
-- VARIABLES
------------------------------------------------
local tp1, tp3 = nil, nil

local noclip = false
local flying = false
local autoCollect = false
local safeMode = false

local incomeMode = "BASIC"
local loopDelay = 1

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "BerisHubUltra"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 420)
frame.Position = UDim2.new(0, 20, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local function btn(t, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 35)
    b.Position = UDim2.new(0, 5, 0, y)
    b.Text = t
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Parent = frame
    return b
end

------------------------------------------------
-- BUTTONS
------------------------------------------------
local tpSave = btn("TP SAVE", 10)
local tpGo = btn("TP GO", 50)
local tp3Save = btn("TP3 SAVE", 90)
local tp3Go = btn("TP3 GO", 130)

local flyBtn = btn("FLY", 170)
local noclipBtn = btn("TRAS", 210)
local collectBtn = btn("AUTO COLLECT", 250)
local incomeBtn = btn("INCOME", 290)
local safeBtn = btn("SAFE MODE", 330)

------------------------------------------------
-- TP SYSTEM
------------------------------------------------
tpSave.MouseButton1Click:Connect(function()
    tp1 = getHRP().CFrame
end)

tpGo.MouseButton1Click:Connect(function()
    if tp1 then getHRP().CFrame = tp1 end
end)

tp3Save.MouseButton1Click:Connect(function()
    tp3 = getHRP().CFrame
end)

tp3Go.MouseButton1Click:Connect(function()
    if tp3 then getHRP().CFrame = tp3 end
end)

------------------------------------------------
-- FLY (FIXED)
------------------------------------------------
local bv

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "FLY ON" or "FLY OFF"

    if flying then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bv.Parent = getHRP()
    else
        if bv then bv:Destroy() bv = nil end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and bv then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            dir += cam.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            dir -= cam.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            dir -= cam.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            dir += cam.CFrame.RightVector
        end

        bv.Velocity = dir * 60
    end
end)

------------------------------------------------
-- NOCLIP (FIXED)
------------------------------------------------
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "TRAS ON" or "TRAS OFF"
end)

RunService.Stepped:Connect(function()
    if noclip then
        for _, v in ipairs(getChar():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

------------------------------------------------
-- AUTO COLLECT (SAFE LOOP)
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.5)

        if autoCollect and not safeMode then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    fireproximityprompt(v)
                end
            end
        end
    end
end)

collectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    collectBtn.Text = autoCollect and "AUTO COLLECT ON" or "AUTO COLLECT OFF"
end)

------------------------------------------------
-- INCOME LOOP (FIXED NO BLACK SCREEN)
------------------------------------------------
local function giveMoney(amount)
    local stats = player:FindFirstChild("leaderstats")
    if not stats then return end

    for _, v in ipairs(stats:GetChildren()) do
        if v:IsA("IntValue") then
            local n = v.Name:lower()
            if n:find("cash") or n:find("money") or n:find("coin") then
                v.Value += amount
                return
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(loopDelay)

        if not safeMode then
            if incomeMode == "BASIC" then
                giveMoney(100)
            else
                giveMoney(1000)
            end
        end
    end
end)

incomeBtn.MouseButton1Click:Connect(function()
    incomeMode = (incomeMode == "BASIC") and "PREMIUM" or "BASIC"
    incomeBtn.Text = "INCOME: "..incomeMode
end)

------------------------------------------------
-- SAFE MODE
------------------------------------------------
local function enableSafe()
    noclip = false
    flying = false
    autoCollect = false

    local hum = getChar():FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = 16
        hum.JumpPower = 50
    end
end

safeBtn.MouseButton1Click:Connect(function()
    safeMode = not safeMode
    safeBtn.Text = safeMode and "SAFE ON" or "SAFE OFF"

    if safeMode then
        enableSafe()
    end
end)