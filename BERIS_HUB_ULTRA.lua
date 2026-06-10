-- BERIS HUB ULTRA DIOS 😈🔥

local player = game.Players.LocalPlayer

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BerisHubUltra"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 220, 0, 320)
frame.Position = UDim2.new(0.05, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local function crearBoton(texto, posicionY)
    local boton = Instance.new("TextButton")
    boton.Parent = frame
    boton.Size = UDim2.new(1, 0, 0, 35)
    boton.Position = UDim2.new(0, 0, posicionY, 0)
    boton.Text = texto
    boton.BackgroundColor3 = Color3.fromRGB(45,45,45)
    boton.TextColor3 = Color3.fromRGB(255,255,255)
    return boton
end

-- BOTONES
local tp = crearBoton("TP (Guardar)", 0)
local tp2 = crearBoton("TP2 (Ir)", 0.1)
local tras = crearBoton("TRAS (Noclip)", 0.2)
local regenBtn = crearBoton("REGEN VIDA", 0.3)
local moneyBtn = crearBoton("INGRESOS +", 0.4)
local dupBtn = crearBoton("DUPLICAR INGRESOS", 0.5)
local autoBtn = crearBoton("AUTO RECOGER", 0.6)

-- VARIABLES
local savedPosition = nil
local noclip = false
local regen = false
local moneyBoost = false
local dupMoney = false
local autoFarm = false

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

-- FUNCIONES

-- Guardar posición
tp.MouseButton1Click:Connect(function()
    local character = getCharacter()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPosition = hrp.Position
    end
end)

-- Teleport
tp2.MouseButton1Click:Connect(function()
    local character = getCharacter()
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp and savedPosition then
        hrp.CFrame = CFrame.new(savedPosition)
    end
end)

-- Noclip
tras.MouseButton1Click:Connect(function()
    noclip = not noclip
end)

-- Regen vida
regenBtn.MouseButton1Click:Connect(function()
    regen = not regen
end)

-- Aumentar ingresos
moneyBtn.MouseButton1Click:Connect(function()
    moneyBoost = not moneyBoost
end)

-- Duplicar ingresos
dupBtn.MouseButton1Click:Connect(function()
    dupMoney = not dupMoney
end)

-- Auto recoger
autoBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
end)

-- LOOP PRINCIPAL
game:GetService("RunService").RenderStepped:Connect(function()
    local character = player.Character
    if character then

        -- Noclip
        if noclip then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        -- Regen
        if regen then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = math.min(humanoid.Health + 1, humanoid.MaxHealth)
            end
        end

        -- Dinero
        local stats = player:FindFirstChild("leaderstats")
        if stats then
            for _, stat in pairs(stats:GetChildren()) do
                if stat:IsA("IntValue") then

                    if moneyBoost then
                        stat.Value = stat.Value + 1
                    end

                    if dupMoney then
                        stat.Value = stat.Value * 2
                    end

                end
            end
        end

        -- Auto recoger (TP a objetos cercanos)
        if autoFarm then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Part") and obj.Name:lower():find("coin") then
                    character:MoveTo(obj.Position)
                end
            end
        end

    end
end)