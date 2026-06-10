-- BERIS HUB COMPLETO (VERSIÓN FINAL)
-- LocalScript (StarterPlayerScripts)

local player = game.Players.LocalPlayer

-- VARIABLES
local savedPosition = nil
local noclip = false
local speedOn = false
local autoCollect = false
local godMode = false
local minimized = false

local normalSpeed = 16
local fastSpeed = 50
local range = 12

-- 💰 MULTIPLICADOR DINERO
local moneyMode = 1
local modes = {1, 2, 5, 10}
local modeIndex = 1

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BerisHub"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 420)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = gui

-- BOTÓN CREADOR
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Parent = frame
    return btn
end

-- TOGGLE VISUAL
local function setToggle(btn, state, name)
    if state then
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        btn.Text = name .. ": ON"
    else
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = name .. ": OFF"
    end
end

-- BOTONES
local btnSave = createButton("Tp (Guardar)", 5)
local btnTp = createButton("Tp2 (Teleport)", 50)
local btnNoclip = createButton("Tras: OFF", 95)
local btnSpeed = createButton("Velocidad: OFF", 140)
local btnRegen = createButton("Regen", 185)
local btnAuto = createButton("Auto Collect", 230)
local btnGod = createButton("Vida Infinita", 275)
local btnMoney = createButton("Ingreso x1", 320)

-- MINIMIZAR
local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0, 50, 0, 25)
btnMin.Position = UDim2.new(1, -55, 0, 5)
btnMin.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnMin.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMin.Text = "MIN"
btnMin.Parent = frame

btnMin.MouseButton1Click:Connect(function()
    minimized = not minimized

    for _, v in pairs(frame:GetChildren()) do
        if v:IsA("TextButton") and v ~= btnMin then
            v.Visible = not minimized
        end
    end

    if minimized then
        frame.Size = UDim2.new(0, 200, 0, 35)
        btnMin.Text = "OPEN"
    else
        frame.Size = UDim2.new(0, 200, 0, 420)
        btnMin.Text = "MIN"
    end
end)

-- FUNCIÓN PERSONAJE
local function getChar()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    return char, hrp, hum
end

-- TP GUARDAR
btnSave.MouseButton1Click:Connect(function()
    local _, hrp = getChar()
    savedPosition = hrp.Position
    btnSave.Text = "Guardado ✔"
    task.wait(1)
    btnSave.Text = "Tp (Guardar)"
end)

-- TELEPORT
btnTp.MouseButton1Click:Connect(function()
    if savedPosition then
        local _, hrp = getChar()
        hrp.CFrame = CFrame.new(savedPosition + Vector3.new(0, 3, 0))
    else
        btnTp.Text = "No hay posición"
        task.wait(1)
        btnTp.Text = "Tp2 (Teleport)"
    end
end)

-- NOCLIP
btnNoclip.MouseButton1Click:Connect(function()
    noclip = not noclip
    setToggle(btnNoclip, noclip, "Tras")
end)

-- VELOCIDAD
btnSpeed.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    local _, _, hum = getChar()

    hum.WalkSpeed = speedOn and fastSpeed or normalSpeed
    setToggle(btnSpeed, speedOn, "Velocidad")
end)

-- REGEN
btnRegen.MouseButton1Click:Connect(function()
    local _, _, hum = getChar()
    hum.Health = hum.MaxHealth

    btnRegen.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    btnRegen.Text = "Regen ✔"

    task.wait(1)

    btnRegen.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btnRegen.Text = "Regen"
end)

-- AUTO COLLECT
btnAuto.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    setToggle(btnAuto, autoCollect, "Auto Collect")
end)

-- GOD MODE
btnGod.MouseButton1Click:Connect(function()
    godMode = not godMode
    setToggle(btnGod, godMode, "Vida Infinita")
end)

-- MONEY MODE (x1 x2 x5 x10)
btnMoney.MouseButton1Click:Connect(function()
    modeIndex = modeIndex + 1
    if modeIndex > #modes then
        modeIndex = 1
    end

    moneyMode = modes[modeIndex]
    btnMoney.Text = "Ingreso x" .. moneyMode
    btnMoney.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end)

-- LOOPS
game:GetService("RunService").Stepped:Connect(function()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp then return end

    -- NOCLIP
    if noclip then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    -- GOD MODE
    if godMode and hum then
        hum.Health = hum.MaxHealth
    end

    -- AUTO COLLECT
    if autoCollect then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                if v.Name == "Coin" or v.Name == "Collect" or v.Name == "Drop" then
                    if (v.Position - hrp.Position).Magnitude <= range then
                        v:Destroy()
                    end
                end
            end
        end
    end
end)

-- 💰 FUNCIÓN DINERO (USAR EN TU JUEGO)
function addMoney(amount)
    local stats = player:FindFirstChild("leaderstats")
    if stats and stats:FindFirstChild("Coins") then
        stats.Coins.Value += (amount * moneyMode)
    end
end