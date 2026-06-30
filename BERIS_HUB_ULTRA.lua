-- [ BERIS HUB - KERNEL ELITE EDITION ]
-- UI Premium con ScrollingFrame, Aimbot, Copiar Ropa y Módulos Defensivos

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
-- 1. SISTEMA DE WAYPOINTS
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
    end
end

-- ==========================================
-- 4. ROBO DE IDENTIDAD VISUAL (Copiar Ropa)
-- ==========================================
local function CopiarRopa(targetName)
    if targetName == "" or targetName == "Nombre del jugador" then return end
    
    -- Busca al jugador sin necesidad de escribir el nombre completo
    local target = nil
    for _, player in pairs(Players:GetPlayers()) do
        if string.sub(string.lower(player.Name), 1, string.len(targetName)) == string.lower(targetName) then
            target = player
            break
        end
    end

    if target and target.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local targetDesc = target.Character:WaitForChild("Humanoid"):GetAppliedDescription()
        LocalPlayer.Character.Humanoid:ApplyDescription(targetDesc)
    end
end

-- ==========================================
-- 5. AUTO-APUNTADO (Prioridad: Más Cercano)
-- ==========================================
local function ObtenerObjetivoMasCercano()
    local target = nil
    local shortestDistance = math.huge
    
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
            -- Fija la cámara en la cabeza del jugador más cercano
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, objetivo.Character.Head.Position)
        end
    end
end)

local function ToggleAimbot()
    aimbotActivo = not aimbotActivo
end

-- ==========================================
-- 6. PROTECCIONES DE ENTORNO (Noclip, Anti-Fling, Anclaje)
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

local function ToggleNoclip() noclipActivo = not noclipActivo end
local function ToggleAntiFling() antiFlingActivo = not antiFlingActivo end
local function ToggleAnclaje()
    ancladoActivo = not ancladoActivo
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = ancladoActivo
    end
end

-- ==========================================
-- 7. INTERFAZ GRÁFICA (UI PREMIUM CON SCROLL)
-- ==========================================
local BerisHub = Instance.new("ScreenGui")
BerisHub.Name = "BerisHub"
BerisHub.Parent = CoreGui 

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = BerisHub
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 360)
MainFrame.Active = true
MainFrame.Draggable = true 

local Titulo = Instance.new("TextLabel")
Titulo.Name = "Titulo"
Titulo.Parent = MainFrame
Titulo.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Titulo.Size = UDim2.new(1, 0, 0, 35)
Titulo.Font = Enum.Font.GothamBold
Titulo.Text = "BERIS HUB ELITE"
Titulo.TextColor3 = Color3.fromRGB(0, 255, 255)
Titulo.TextSize = 16

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Parent = MainFrame
ScrollFrame.Size = UDim2.new(1, 0, 1, -70) 
ScrollFrame.Position = UDim2.new(0, 0, 0, 35)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local spacer = Instance.new("Frame")
spacer.Parent = ScrollFrame
spacer.BackgroundTransparency = 1
spacer.Size = UDim2.new(1, 0, 0, 2)

-- Creador de Botones
local function CrearBoton(texto, funcion)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollFrame
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Size = UDim2.new(1, -10, 0, 38)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    
    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45) end)
    btn.MouseButton1Click:Connect(funcion)
end

-- ==========================================
-- 8. GENERACIÓN DE BOTONES Y CONTROLES
-- ==========================================
CrearBoton("📍 Marcar Posición", MarcarPosicion)
CrearBoton("⚡ TP a Posición", TeletransportarAMarca)
CrearBoton("🎯 Activar/Apagar Auto-Apuntado", ToggleAimbot)
CrearBoton("👁️ Activar/Apagar ESP", ToggleESP)
CrearBoton("🛡️ God Mode (FE)", ActivarModoDios)
CrearBoton("👻 Activar/Apagar Noclip", ToggleNoclip)
CrearBoton("🚫 Anti-Fling (Anti-Empujes)", ToggleAntiFling)
CrearBoton("🗿 Anclar Personaje (Estatua)", ToggleAnclaje)

-- Input para Robar Ropa
local FrameRopa = Instance.new("Frame")
FrameRopa.Parent = ScrollFrame
FrameRopa.BackgroundTransparency = 1
FrameRopa.Size = UDim2.new(1, -10, 0, 70)

local InputRopa = Instance.new("TextBox")
InputRopa.Parent = FrameRopa
InputRopa.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
InputRopa.Size = UDim2.new(1, 0, 0, 30)
InputRopa.Font = Enum.Font.Gotham
InputRopa.Text = "Nombre del jugador"
InputRopa.TextColor3 = Color3.fromRGB(150, 150, 150)
InputRopa.TextSize = 12
InputRopa.ClearTextOnFocus = true

local BtnCopiarRopa = Instance.new("TextButton")
BtnCopiarRopa.Parent = FrameRopa
BtnCopiarRopa.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
BtnCopiarRopa.Size = UDim2.new(1, 0, 0, 35)
BtnCopiarRopa.Position = UDim2.new(0, 0, 0, 35)
BtnCopiarRopa.Font = Enum.Font.GothamBold
BtnCopiarRopa.Text = "👕 Robar Ropa"
BtnCopiarRopa.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCopiarRopa.TextSize = 14
BtnCopiarRopa.MouseButton1Click:Connect(function()
    CopiarRopa(InputRopa.Text)
end)

-- Botón maestro para cerrar (fuera del scroll, siempre visible al fondo)
local BtnCerrar = Instance.new("TextButton")
BtnCerrar.Parent = MainFrame
BtnCerrar.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
BtnCerrar.Size = UDim2.new(1, 0, 0, 35)
BtnCerrar.Position = UDim2.new(0, 0, 1, -35)
BtnCerrar.Font = Enum.Font.GothamBold
BtnCerrar.Text = "Cerrar Hub"
BtnCerrar.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCerrar.TextSize = 14
BtnCerrar.MouseButton1Click:Connect(function()
    BerisHub:Destroy()
end)