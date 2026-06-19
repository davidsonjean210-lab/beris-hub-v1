--====================================================================
-- HUB NAME: beris hub (Versión Premium Expandida)
-- Optimizado al 100% para Ejecutores de Celular (Touch Friendly)
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

-- Limpiador de interfaces viejas
if PlayerGui:FindFirstChild("BerisHubPremium") then
    PlayerGui.BerisHubPremium:Destroy()
end

-- GUI Contenedor Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 320)
MainFrame.Position = UDim2.new(0.35, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Línea Neon Superior Blue
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 4)
AccentLine.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame

local AccentCorner = Instance.new("UICorner")
AccentCorner.CornerRadius = UDim.new(0, 12)
AccentCorner.Parent = AccentLine

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "  beris hub v2 🛠️"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- CONTENEDOR DESLIZABLE (Para soportar muchos botones en celular)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(0.92, 0, 0.72, 0)
ScrollFrame.Position = UDim2.new(0.04, 0, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 460) -- Espacio total para deslizar hacia abajo
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
ScrollFrame.Parent = MainFrame

-- Barra de Estado Inferior
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Estado: beris listo"
StatusLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Variables de Estado del Servidor/Local
_G.SpeedEnabled = false
_G.ImmuneEnabled = false
_G.OneHitKillEnabled = false
_G.NoclipEnabled = false
local guardarPosicionMuerte = nil

-- Creador Automatizado de Botones Estilizados
local function crearBoton(texto, posY, colorBase)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = colorBase
    btn.BorderSizePixel = 0
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = ScrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    return btn
end

-- ==========================================
-- INSTANCIACIÓN DE BOTONES (LISTA DEL MENÚ)
-- ==========================================
local BtnTP1     = crearBoton("📍 Teleport 1 (TP)", 0, Color3.fromRGB(35, 105, 200))
local BtnTP2     = crearBoton("📍 Teleport 2 (TP2)", 45, Color3.fromRGB(35, 105, 200))
local BtnSpeed   = crearBoton("⚡ Súper Velocidad: OFF", 90, Color3.fromRGB(45, 45, 55))
local BtnImmune  = crearBoton("🛡️ Inmune a Golpes: OFF", 135, Color3.fromRGB(45, 45, 55))
local BtnOneHit  = crearBoton("💥 Un Solo Golpe (Daño Max): OFF", 180, Color3.fromRGB(45, 45, 55))
local BtnRevive  = crearBoton("🔄 Revivir Instantáneo", 225, Color3.fromRGB(120, 40, 140))
local BtnNoclip  = crearBoton("👻 Traspasar Paredes: OFF", 270, Color3.fromRGB(45, 45, 55))

-- ==========================================
-- LÓGICA DE LAS NUEVAS FUNCIONES
-- ==========================================

-- 1 y 2. TELEPORTS AJUSTABLES (TP Y TP2)
-- Nota: Puedes cambiar Vector3.new(X, Y, Z) por las coordenadas que quieras de tu mapa
BtnTP1.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0) -- Cambia estos números si deseas un punto exacto
        StatusLabel.Text = "Teletransportado a Zona 1"
    end
end)

BtnTP2.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(100, 50, 100) -- Coordenadas preestablecidas para TP2
        StatusLabel.Text = "Teletransportado a Zona 2"
    end
end)

-- 3. VELOCIDAD
BtnSpeed.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    if _G.SpeedEnabled then
        BtnSpeed.Text = "⚡ Súper Velocidad: ON"
        BtnSpeed.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        BtnSpeed.Text = "⚡ Súper Velocidad: OFF"
        BtnSpeed.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- 4. INMUNE A LOS GOLPES (Fuerza de Escudo Continuo)
BtnImmune.MouseButton1Click:Connect(function()
    _G.ImmuneEnabled = not _G.ImmuneEnabled
    if _G.ImmuneEnabled then
        BtnImmune.Text = "🛡️ Inmune a Golpes: ON"
        BtnImmune.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Escudo antibalas y golpes activado"
    else
        BtnImmune.Text = "🛡️ Inmune a Golpes: OFF"
        BtnImmune.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("ForceField") then
            LocalPlayer.Character:FindFirstChildOfClass("ForceField"):Destroy()
        end
    end
end)

-- 5. UN SOLO GOLPE / DAÑO MÁXIMO (Inyección en Herramientas)
BtnOneHit.MouseButton1Click:Connect(function()
    _G.OneHitKillEnabled = not _G.OneHitKillEnabled
    if _G.OneHitKillEnabled then
        BtnOneHit.Text = "💥 Un Solo Golpe: ON"
        BtnOneHit.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Armas modificadas con Instakill"
    else
        BtnOneHit.Text = "💥 Un Solo Golpe: OFF"
        BtnOneHit.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- 6. BOTÓN REVIVIR (Resucitar y volver a tu posición exacta de inmediato)
BtnRevive.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        StatusLabel.Text = "Forzando reaparición..."
        -- Guardamos donde estabas parado antes de forzar la reaparición
        if char:FindFirstChild("HumanoidRootPart") then
            guardarPosicionMuerte = char.HumanoidRootPart.CFrame
        end
        char.Humanoid.Health = 0 -- Forzar el respawn legal del motor
    else
        StatusLabel.Text = "Error al intentar revivir"
    end
end)

-- 7. TRASPASAR PAREDES (NOCLIP)
BtnNoclip.MouseButton1Click:Connect(function()
    _G.NoclipEnabled = not _G.NoclipEnabled
    if _G.NoclipEnabled then
        BtnNoclip.Text = "👻 Traspasar Paredes: ON"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        BtnNoclip.Text = "👻 Traspasar Paredes: OFF"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- ==========================================
-- BUCLES EN SEGUNDO PLANO (MOTORES AUTOMÁTICOS)
-- ==========================================

-- Sistema de Retorno automático al usar el botón Revivir
LocalPlayer.CharacterAdded:Connect(function(nuevoPersonaje)
    if guardarPosicionMuerte then
        local hrp = nuevoPersonaje:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            task.wait(0.2) -- Espera técnica para evitar errores de carga
            hrp.CFrame = guardarPosicionMuerte
            guardarPosicionMuerte = nil
            StatusLabel.Text = "¡Revivido y regresado a tu sitio!"
        end
    end
end)

-- Monitores continuos (Velocidad, Inmunidad, OneHit, Noclip)
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Lógica Inmune
    if _G.ImmuneEnabled then
        if not char:FindFirstChildOfClass("ForceField") then
            Instance.new("ForceField", char)
        end
    end
    
    -- Lógica Traspasar Paredes
    if _G.NoclipEnabled then
        local parts = char:GetDescendants()
        for i = 1, #parts do
            if parts[i]:IsA("BasePart") then
                parts[i].CanCollide = false
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        local char = LocalPlayer.Character
        if char then
            -- Forzar velocidad continua
            if _G.SpeedEnabled and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 80
            end
            
            -- Vincular súper daño a cualquier herramienta o espada que tengas en la mano
            if _G.OneHitKillEnabled then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    if not tool.Handle:FindFirstChild("BerisDamageTag") then
                        tool.Handle.Touched:Connect(function(hit)
                            if _G.OneHitKillEnabled and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid") then
                                local enemigo = hit.Parent:FindFirstChildOfClass("Humanoid")
                                if hit.Parent.Name ~= LocalPlayer.Name then
                                    enemigo.Health = 0 -- Mata o destruye de un solo golpe
                                end
                            end
                        end)
                        local tag = Instance.new("BoolValue", tool.Handle)
                        tag.Name = "BerisDamageTag"
                    end
                end
            end
        end
    end
end)