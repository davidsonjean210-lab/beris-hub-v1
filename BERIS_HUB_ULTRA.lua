-- [ BERIS HUB - KERNEL ELITE EDITION ]
-- Corregido y estructurado con UI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variables Globales
local waypointCFrame = nil
local espActivo = false

-- ==========================================
-- 1. SISTEMA DE WAYPOINTS
-- ==========================================
local function MarcarPosicion()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        waypointCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        print("Posición marcada con éxito.")
    end
end

local function TeletransportarAMarca()
    if waypointCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = waypointCFrame
        print("Teletransportado a la marca.")
    end
end

-- ==========================================
-- 2. ESP (Visión a través de las paredes)
-- ==========================================
local function ToggleESP()
    espActivo = not espActivo
    if espActivo then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "BerisESP"
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Cyan Cyberpunk
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
        print("ESP Activado")
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("BerisESP") then
                player.Character.BerisESP:Destroy()
            end
        end
        print("ESP Desactivado")
    end
end

-- ==========================================
-- 3. MODO DIOS (Básico FE)
-- ==========================================
local function ActivarModoDios()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local clone = char.Humanoid:Clone()
        clone.Parent = char
        char.Humanoid:Destroy()
        workspace.CurrentCamera.CameraSubject = char
        print("Modo Dios ejecutado.")
    end
end

-- ==========================================
-- 4. INTERFAZ GRÁFICA (UI PREMIUM)
-- ==========================================
-- Crear la pantalla principal
local BerisHub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Titulo = Instance.new("TextLabel")
local UIListLayout = Instance.new("UIListLayout")

-- Configuración del Gui (Usamos CoreGui para evadir el anti-cheat básico)
BerisHub.Name = "BerisHub"
BerisHub.Parent = CoreGui 

MainFrame.Name = "MainFrame"
MainFrame.Parent = BerisHub
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Active = true
MainFrame.Draggable = true -- Permite arrastrar la ventana por la pantalla

Titulo.Name = "Titulo"
Titulo.Parent = MainFrame
Titulo.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Titulo.Size = UDim2.new(1, 0, 0, 35)
Titulo.Font = Enum.Font.GothamBold
Titulo.Text = "BERIS HUB ELITE"
Titulo.TextColor3 = Color3.fromRGB(0, 255, 255)
Titulo.TextSize = 16

UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Función puente para crear botones
local function CrearBoton(nombre, texto, funcion)
    local btn = Instance.new("TextButton")
    btn.Name = nombre
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    
    -- Efecto hover simple
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45) end)
    
    -- Conectar click a la función
    btn.MouseButton1Click:Connect(funcion)
end

-- Espaciador
local spacer = Instance.new("Frame")
spacer.Parent = MainFrame
spacer.BackgroundTransparency = 1
spacer.Size = UDim2.new(1, 0, 0, 5)

-- Conectar los botones a las funciones que ya tenías
CrearBoton("BtnMarcar", "📍 Marcar Posición", MarcarPosicion)
CrearBoton("BtnTP", "⚡ TP a Posición", TeletransportarAMarca)
CrearBoton("BtnESP", "👁️ Activar/Apagar ESP", ToggleESP)
CrearBoton("BtnGodMode", "🛡️ God Mode (Bypass)", ActivarModoDios)

-- Botón maestro para cerrar y destruir el hub
local BtnCerrar = Instance.new("TextButton")
BtnCerrar.Parent = MainFrame
BtnCerrar.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
BtnCerrar.Size = UDim2.new(1, 0, 0, 35)
BtnCerrar.Font = Enum.Font.GothamBold
BtnCerrar.Text = "Cerrar Hub"
BtnCerrar.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCerrar.TextSize = 14
BtnCerrar.MouseButton1Click:Connect(function()
    BerisHub:Destroy()
end)