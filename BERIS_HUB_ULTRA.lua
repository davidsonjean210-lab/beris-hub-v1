-- [ BERIS HUB - KERNEL ELITE EDITION V3 ]
-- Force Respawn Supremo y UI Táctil

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Variables Globales
local waypointCFrame = nil
local espActivo = false
local noclipActivo = false
local antiFlingActivo = false
local ancladoActivo = false
local aimbotActivo = false

-- ==========================================
-- 1. SISTEMA DE WAYPOINTS & RESPAWN SUPREMO
-- ==========================================
local function MarcarPosicion()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        waypointCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end

local function TeletransportarAMarca()
    if waypointCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = waypointCFrame
    end
end

local function ForzarRespawn()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        
        -- Intento 1: Matar directamente
        if humanoid then humanoid.Health = 0 end
        
        -- Intento 2: Destruir uniones
        char:BreakJoints()
        
        -- Intento 3: Teletransportar al vacío (Bypass para juegos que bloquean la muerte)
        if rootPart then
            rootPart.CFrame = CFrame.new(0, workspace.FallenPartsDestroyHeight - 50, 0)
        end
    end
end

-- ==========================================
-- 2. ESP & AIMBOT
-- ==========================================
local function ToggleESP(estado)
    espActivo = estado
    if espActivo then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "BerisESP"
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(0, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("BerisESP") then
                player.Character.BerisESP:Destroy()
            end
        end
    end
end

local function ObtenerObjetivoMasCercano()
    local target, shortestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                target = player
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    if aimbotActivo then
        local objetivo = ObtenerObjetivoMasCercano()
        if objetivo and objetivo.Character and objetivo.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, objetivo.Character.Head.Position)
        end
    end
end)

local function ToggleAimbot(estado) aimbotActivo = estado end

-- ==========================================
-- 3. DEFENSA Y ROBO DE ROPA (Solo visible en Cliente/FE)
-- ==========================================
RunService.Stepped:Connect(function()
    if noclipActivo and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if antiFlingActivo and LocalPlayer.Character then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end
end)

local function ToggleNoclip(estado) noclipActivo = estado end
local function ToggleAntiFling(estado) antiFlingActivo = estado end
local function ToggleAnclaje(estado)
    ancladoActivo = estado
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = ancladoActivo
    end
end

local function CopiarRopa(targetName)
    if targetName == "" or targetName == "Nombre del jugador" then return end
    local target = nil
    for _, player in pairs(Players:GetPlayers()) do
        if string.sub(string.lower(player.Name), 1, string.len(targetName)) == string.lower(targetName) then
            target = player
            break
        end
    end
    -- Nota: Esto siempre será Client-Side debido al FilteringEnabled de Roblox
    if target and target.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local targetDesc = target.Character:WaitForChild("Humanoid"):GetAppliedDescription()
        LocalPlayer.Character.Humanoid:ApplyDescription(targetDesc)
    end
end

-- ==========================================
-- 4. INTERFAZ GRÁFICA (TÁCTIL)
-- ==========================================
local BerisHub = Instance.new("ScreenGui")
BerisHub.Name = "BerisHubV3"
BerisHub.Parent = CoreGui 

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = BerisHub
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true 

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Titulo = Instance.new("TextLabel")
Titulo.Name = "Titulo"
Titulo.Parent = MainFrame
Titulo.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Titulo.Size = UDim2.new(1, 0, 0, 45)
Titulo.Font = Enum.Font.GothamBlack
Titulo.Text = "BERIS HUB ELITE"
Titulo.TextColor3 = Color3.fromRGB(0, 255, 255)
Titulo.TextSize = 18

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Titulo

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, -10, 1, -95) 
ScrollFrame.Position = UDim2.new(0, 5, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Botones y Toggles
local function CrearBotonAccion(texto, colorBase, funcion)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.BackgroundColor3 = colorBase
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Font = Enum.Font.GothamBold
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(funcion)
end

local function CrearToggle(texto, funcion)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "❌ " .. texto
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    local encendido = false
    btn.MouseButton1Click:Connect(function()
        encendido = not encendido
        if encendido then
            btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            btn.Text = "✅ " .. texto
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            btn.Text = "❌ " .. texto
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        funcion(encendido)
    end)
end

CrearBotonAccion("💀 Forzar Renacer (Void)", Color3.fromRGB(150, 0, 200), ForzarRespawn)
CrearBotonAccion("📍 Guardar Posición", Color3.fromRGB(60, 60, 180), MarcarPosicion)
CrearBotonAccion("⚡ Teletransportar", Color3.fromRGB(180, 120, 0), TeletransportarAMarca)

CrearToggle("Auto-Apuntado (Aimbot)", ToggleAimbot)
CrearToggle("Visión Rayos X (ESP)", ToggleESP)
CrearToggle("Atravesar Paredes (Noclip)", ToggleNoclip)
CrearToggle("Anti-Empujes (Anti-Fling)", ToggleAntiFling)
CrearToggle("Modo Estatua (Anclarse)", ToggleAnclaje)

local FrameRopa = Instance.new("Frame")
FrameRopa.Parent = ScrollFrame
FrameRopa.BackgroundTransparency = 1
FrameRopa.Size = UDim2.new(1, -10, 0, 80)

local InputRopa = Instance.new("TextBox")
InputRopa.Parent = FrameRopa
InputRopa.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
InputRopa.Size = UDim2.new(1, 0, 0, 35)
InputRopa.Font = Enum.Font.Gotham
InputRopa.Text = "Escribe un nombre..."
InputRopa.TextColor3 = Color3.fromRGB(200, 200, 200)
InputRopa.TextSize = 13
InputRopa.ClearTextOnFocus = true
local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = InputRopa

local BtnCopiarRopa = Instance.new("TextButton")
BtnCopiarRopa.Parent = FrameRopa
BtnCopiarRopa.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
BtnCopiarRopa.Size = UDim2.new(1, 0, 0, 35)
BtnCopiarRopa.Position = UDim2.new(0, 0, 0, 40)
BtnCopiarRopa.Font = Enum.Font.GothamBold
BtnCopiarRopa.Text = "👕 Robar (Solo Cliente)"
BtnCopiarRopa.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCopiarRopa.TextSize = 13
local BtnCopiarCorner = Instance.new("UICorner")
BtnCopiarCorner.CornerRadius = UDim.new(0, 8)
BtnCopiarCorner.Parent = BtnCopiarRopa

BtnCopiarRopa.MouseButton1Click:Connect(function()
    CopiarRopa(InputRopa.Text)
end)

local BtnCerrar = Instance.new("TextButton")
BtnCerrar.Parent = MainFrame
BtnCerrar.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
BtnCerrar.Size = UDim2.new(1, -20, 0, 35)
BtnCerrar.Position = UDim2.new(0, 10, 1, -40)
BtnCerrar.Font = Enum.Font.GothamBold
BtnCerrar.Text = "Cerrar Panel"
BtnCerrar.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCerrar.TextSize = 14
local CerrarCorner = Instance.new("UICorner")
CerrarCorner.CornerRadius = UDim.new(0, 8)
CerrarCorner.Parent = BtnCerrar

BtnCerrar.MouseButton1Click:Connect(function()
    BerisHub:Destroy()
end)