-- BERIS HUB ULTRA COMPLETE

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

------------------------------------------------
-- CHARACTER
------------------------------------------------
local function char()
    return player.Character or player.CharacterAdded:Wait()
end

local function hrp()
    return char():WaitForChild("HumanoidRootPart")
end

------------------------------------------------
-- VARIABLES
------------------------------------------------
local tp1, tp3 = nil, nil

local noclip = false
local flying = false
local autoCollect = false

local incomeMode = "BASIC" -- BASIC / PREMIUM
local loopDelay = 1

local safeMode = false

------------------------------------------------
-- GUI PRINCIPAL
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
-- BOTONES
------------------------------------------------
local tpSave = btn("TP SAVE", 10)
local tpGo = btn("TP GO", 50)
local tp3Save = btn("TP3 SAVE", 90)
local tp3Go = btn("TP3 GO", 130)

local noclipBtn = btn("TRAS", 170)
local flyBtn = btn("FLY", 210)

local incomeBtn = btn("INCOME MODE", 250)
local safeBtn = btn("SAFE MODE", 290)

------------------------------------------------
-- TP SYSTEM
------------------------------------------------
tpSave.MouseButton1Click:Connect(function()
    tp1 = hrp().CFrame
end)

tpGo.MouseButton1Click:Connect(function()
    if tp1 then hrp().CFrame = tp1 end
end)

tp3Save.MouseButton1Click:Connect(function()
    tp3 = hrp().CFrame
end)

tp3Go.MouseButton1Click:Connect(function()
    if tp3 then hrp().CFrame = tp3 end
end)

------------------------------------------------
-- NOCLIP
------------------------------------------------
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip then
        for _, v in ipairs(char():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

------------------------------------------------
-- FLY SIMPLE
------------------------------------------------
local bv

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying

    if flying then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bv.Parent = hrp()
    else
        if bv then bv:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and bv then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            dir += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            dir -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            dir -= cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            dir += cam.CFrame.RightVector
        end

        bv.Velocity = dir * 60
    end
end)

------------------------------------------------
-- AUTO COLLECT
------------------------------------------------
local function collect()
    local root = hrp()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            fireproximityprompt(v)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if autoCollect then
        collect()
    end
end)

------------------------------------------------
-- INCOME SYSTEM (LIMITADO AL JUEGO)
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

RunService.RenderStepped:Connect(function()
    if safeMode then return end

    task.wait(loopDelay)

    if incomeMode == "BASIC" then
        giveMoney(100)
    elseif incomeMode == "PREMIUM" then
        giveMoney(1000)
    end
end)

incomeBtn.MouseButton1Click:Connect(function()
    if incomeMode == "BASIC" then
        incomeMode = "PREMIUM"
    else
        incomeMode = "BASIC"
    end
end)

------------------------------------------------
-- SAFE MODE
------------------------------------------------
local function enableSafe()
    noclip = false
    flying = false
    autoCollect = false

    local hum = char():FindFirstChild("Humanoid")
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