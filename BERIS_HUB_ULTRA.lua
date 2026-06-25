-- [ BERIS HUB - KERNEL ELITE EDITION ]
-- UI Premium sin fallos de scroll / Sin inputs de vel/salto

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Variables Globales
local waypointCFrame = nil
local _G_AimbotActive = false
local _G_MultiHit = false

-- ==========================================
-- 1. SISTEMA DE WAYPOINTS (TP1 y TP2)
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
    end
end

-- ==========================================
-- 2. ROBO DE IDENTIDAD VISUAL (Copiar Ropa)
-- ==========================================
local function CopiarRopa(targetName)
    local target = Players:FindFirstChild(targetName)
    if target and target.Character then
        local targetDesc = target.Character:WaitForChild("Humanoid"):GetAppliedDescription()
        LocalPlayer.Character.Humanoid:ApplyDescription(targetDesc)
    end
end

-- ==========================================
-- 3. SISTEMA DE VISIÓN (ESP - Ver a todos)
-- ==========================================
local function ActivarESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.FillColor = Color3.fromRGB(0, 255, 255) -- Cyan Cyberpunk
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        end
    end
end

-- ==========================================
-- 4. MODO DIOS (God Mode Básico FE)
-- ==========================================
local function ActivarModoDios()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local clone = char.Humanoid:Clone()
        clone.Parent = char
        char.Humanoid:Destroy()
        workspace.CurrentCamera.CameraSubject = char
        -- Nota: La efectividad depende de las protecciones del juego específico
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

-- ==========================================
-- 6. MULTI-HIT & ECONOMÍA GRATUITA
-- ==========================================
-- (Requiere intercepción de RemoteEvents específicos del juego)