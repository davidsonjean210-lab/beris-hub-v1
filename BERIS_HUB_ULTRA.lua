--====================================================================
-- HUB NAME: beris hub (Versión Multifunción)
-- Características: Teleport, Velocidad, Inmortal, Traspasar Paredes
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiador para evitar pantallas duplicadas en celular
if PlayerGui:FindFirstChild("BerisHubMultifuncion") then
    PlayerGui.BerisHubMultifuncion:Destroy()
end

-- GUI Contenedor Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubMultifuncion"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Marco del Menú Móvil
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Te permite moverlo con el dedo por toda la pantalla
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Línea de Diseño Superior (Cyan)
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 4)
AccentLine.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame

local AccentCorner = Instance.new("UICorner")
AccentCorner.CornerRadius = UDim.new(0, 12)
AccentCorner.Parent = AccentLine

-- Título del Hub
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "  beris hub 🛠️"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Barra de Estado Inferior
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Estado: Esperando comando"
StatusLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Variables de Estado del Script
_G.SpeedEnabled = false
_G.GodModeEnabled = false
_G.NoclipEnabled = false

-- Función para construir botones táctiles grandes
local function crearBoton(texto, posY, colorBase)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = colorBase
    btn.BorderSizePixel = 0
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    return btn
end

-- Instanciación de los 4 Botones
local BtnTP = crearBoton("📍 Conseguir Herramienta TP", 45, Color3.fromRGB(35, 105, 200))
local BtnSpeed = crearBoton("⚡ Súper Velocidad: OFF", 95, Color3.fromRGB(45, 45, 55))
local BtnGod = crearBoton("🛡️ Modo Inmortal: OFF", 145, Color3.fromRGB(45, 45, 55))
local BtnNoclip = crearBoton("👻 Traspasar Paredes: OFF", 195, Color3.fromRGB(45, 45, 55))

-- 1. ACCIÓN: TELEPORT (Pensado para pantallas táctiles)
BtnTP.MouseButton1Click:Connect(function()
    local mouse = LocalPlayer:GetMouse()
    local tool = Instance.new("Tool")
    tool.Name = "Click Teleport 📍"
    tool.RequiresHandle = false
    
    tool.Activated:Connect(function()
        local pos = mouse.Hit.p
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Te mueve al lugar exacto donde toques + 3 unidades arriba para no enterrarte
            char.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            StatusLabel.Text = "¡Teletransportado!"
        end
    end)
    
    tool.Parent = LocalPlayer.Backpack
    StatusLabel.Text = "¡Herramienta TP añadida al inventario!"
end)

-- 2. ACCIÓN: VELOCIDAD
BtnSpeed.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    if _G.SpeedEnabled then
        BtnSpeed.Text = "⚡ Súper Velocidad: ON"
        BtnSpeed.BackgroundColor3 = Color3.fromRGB(46, 139, 87) -- Verde
        StatusLabel.Text = "Velocidad fijada en 60"
    else
        BtnSpeed.Text = "⚡ Súper Velocidad: OFF"
        BtnSpeed.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Velocidad normal"
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 60 -- Cambia este número si quieres ir más rápido
        end
    end
end)

-- 3. ACCIÓN: INMORTAL (GOD MODE LOOP)
BtnGod.MouseButton1Click:Connect(function()
    _G.GodModeEnabled = not _G.GodModeEnabled
    if _G.GodModeEnabled then
        BtnGod.Text = "🛡️ Modo Inmortal: ON"
        BtnGod.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Vida protegida al máximo"
    else
        BtnGod.Text = "🛡️ Modo Inmortal: OFF"
        BtnGod.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Inmortalidad apagada"
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.GodModeEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            hum.MaxHealth = 999999
            hum.Health = 999999
        end
    end
end)

-- 4. ACCIÓN: TRASPASAR PAREDES (NOCLIP)
BtnNoclip.MouseButton1Click:Connect(function()
    _G.NoclipEnabled = not _G.NoclipEnabled
    if _G.NoclipEnabled then
        BtnNoclip.Text = "👻 Traspasar Paredes: ON"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Colisiones desactivadas"
    else
        BtnNoclip.Text = "👻 Traspasar Paredes: OFF"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Colisiones normales"
    end
end)

RunService.Stepped:Connect(function()
    if _G.NoclipEnabled and LocalPlayer.Character then
        local parts = LocalPlayer.Character:GetDescendants()
        for i = 1, #parts do
            local part = parts[i]
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)