--// BERIS HUB FINAL PRO + MOBILE MODE

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

------------------------------------------------
-- PERSONAJE
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
local tpPoint

local noclip = false
local combatOn = false
local combatMode = "BASICO"

local autoRegen = true
local antiVoid = true
local autoRevive = true

local incomeMode = "BASICO"

local lastSafe

------------------------------------------------
-- UI PRINCIPAL
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "BerisHubFinal"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 460)
frame.Position = UDim2.new(0, 20, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Parent = gui

------------------------------------------------
-- 🔥 DRAG DEL HUB (FIX IMPORTANTE)
------------------------------------------------
do
    local dragging = false
    local dragStart
    local startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function()
        dragging = false
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

------------------------------------------------
-- BOTONES
------------------------------------------------
local function btn(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 32)
    b.Position = UDim2.new(0, 5, 0, y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Parent = frame
    return b
end

------------------------------------------------
-- TP
------------------------------------------------
btn("TP GUARDAR", 10).MouseButton1Click:Connect(function()
    tpPoint = hrp().CFrame
end)

btn("TP IR", 45).MouseButton1Click:Connect(function()
    if tpPoint then hrp().CFrame = tpPoint end
end)

------------------------------------------------
-- NOCLIP
------------------------------------------------
btn("NOCLIP", 80).MouseButton1Click:Connect(function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip then
        for _,v in ipairs(char():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

------------------------------------------------
-- COMBAT NPC
------------------------------------------------
btn("COMBAT", 115).MouseButton1Click:Connect(function()
    combatOn = not combatOn
end)

btn("CAMBIAR COMBATE", 150).MouseButton1Click:Connect(function()
    combatMode = (combatMode == "BASICO") and "MT" or "BASICO"
end)

task.spawn(function()
    while true do
        task.wait(0.25)

        if combatOn then
            local root = hrp()

            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v ~= char() then
                    local h = v:FindFirstChildOfClass("Humanoid")
                    local r = v:FindFirstChild("HumanoidRootPart")

                    if h and r and (root.Position - r.Position).Magnitude < 8 then
                        if combatMode == "BASICO" then
                            h:TakeDamage(8)
                        else
                            h:TakeDamage(25)
                        end
                    end
                end
            end
        end
    end
end)

------------------------------------------------
-- INGRESO
------------------------------------------------
local function giveMoney(amount)
    local stats = player:FindFirstChild("leaderstats")
    if not stats then return end

    for _,v in pairs(stats:GetChildren()) do
        if v:IsA("IntValue") then
            v.Value += amount
            return
        end
    end
end

local mult = {
    BASICO = 1,
    PREMIUM = 5,
    PLUS = 12
}

btn("INGRESO MODE", 185).MouseButton1Click:Connect(function()
    if incomeMode == "BASICO" then
        incomeMode = "PREMIUM"
    elseif incomeMode == "PREMIUM" then
        incomeMode = "PLUS"
    else
        incomeMode = "BASICO"
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        giveMoney(100 * mult[incomeMode])
    end
end)

------------------------------------------------
-- AUTO REGEN + ANTI VOID
------------------------------------------------
RunService.RenderStepped:Connect(function()
    local c = char()
    local h = c:FindFirstChild("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")

    if h and autoRegen and h.Health < h.MaxHealth then
        h.Health += 2
    end

    if r and r.Position.Y > 5 then
        lastSafe = r.CFrame
    end

    if antiVoid and r and r.Position.Y < -50 and lastSafe then
        r.CFrame = lastSafe + Vector3.new(0,5,0)
    end
end)

------------------------------------------------
-- AUTO REVIVE
------------------------------------------------
char():WaitForChild("Humanoid").Died:Connect(function()
    if autoRevive then
        task.wait(2)
        player:LoadCharacter()
    end
end)

------------------------------------------------
-- 📱 MODO MÓVIL (FLOATING ICON)
------------------------------------------------
local mobileMode = false
local hubOpen = true

local icon = Instance.new("ImageButton")
icon.Size = UDim2.new(0, 45, 0, 45)
icon.Position = UDim2.new(0, 10, 0.5, -22)
icon.BackgroundColor3 = Color3.fromRGB(40,40,40)
icon.Text = ""
icon.Parent = gui
icon.Visible = false
icon.ZIndex = 100

btn("MODO MOVIL", 220).MouseButton1Click:Connect(function()
    mobileMode = not mobileMode

    icon.Visible = mobileMode
    frame.Visible = not mobileMode
end)

icon.MouseButton1Click:Connect(function()
    hubOpen = not hubOpen
    frame.Visible = hubOpen
end)

------------------------------------------------
-- DRAG DEL ICONO (MÓVIL)
------------------------------------------------
do
    local dragging = false
    local dragStart
    local startPos

    icon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = icon.Position
        end
    end)

    icon.InputEnded:Connect(function()
        dragging = false
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart

            icon.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end