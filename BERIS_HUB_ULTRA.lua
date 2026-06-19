--====================================================================
-- HUB NAME: beris hub (Versión Cyber-Glow Premium v4)
-- Características: Minimizar Menú, Saltos Infinitos, Filtro NPC, Anti-Lag
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiador de interfaces obsoletas
if PlayerGui:FindFirstChild("BerisHubCyber") then
    PlayerGui.BerisHubCyber:Destroy()
end

-- Contenedor Principal UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubCyber"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ==========================================
-- DISEÑO: INTERFAZ MINIMIZADA (BOTÓN FLOTANTE)
-- ==========================================
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 45, 0, 45)
OpenButton.Position = UDim2.new(0.05, 0, 0.2, 0) -- Aparece discretamente a la izquierda
OpenButton.BackgroundColor3 = Color3.fromRGB(11, 12, 15)
OpenButton.BorderSizePixel = 0
OpenButton.Text = "b"
OpenButton.TextColor3 = Color3.fromRGB(118, 60, 230)
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false -- Oculto por defecto hasta que minimices
OpenButton.Active = true
OpenButton.Draggable = true -- Lo puedes mover con el dedo si te estorba
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(118, 60, 230)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenButton

-- ==========================================
-- DISEÑO: INTERFAZ PRINCIPAL (PANEL)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 340)
MainFrame.Position = UDim2.new(0.3, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 12, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(118, 60, 230)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.2
UIStroke.Parent = MainFrame

-- Título del Menú
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 0, 42)
Title.BackgroundTransparency = 1
Title.Text = "  BERIS HUB // V4 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Botón Minimizar Integrado en la Esquina Superior Derecha
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.85, 0, 0, 6)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame

-- Contenedor Deslizable para Botones
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(0.92, 0, 0.74, 0)
ScrollFrame.Position = UDim2.new(0.04, 0, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 560) -- Espacio aumentado para el nuevo botón
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(118, 60, 230)
ScrollFrame.Parent = MainFrame

-- Estado Inferior
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = " System: Ready to inject"
StatusLabel.TextColor3 = Color3.fromRGB(100, 105, 115)
StatusLabel.TextSize = 10
StatusLabel.Font = Enum.Font.Code
StatusLabel.Parent = MainFrame

-- Variables de Estado Globales
_G.SpeedEnabled = false
_G.ImmuneEnabled = false
_G.NpcOneHitEnabled = false
_G.AntiVoidEnabled = false
_G.AutoCollectResources = false
_G.InfiniteJumpEnabled = false
local puntoDeRetornoMuerte = nil

-- Creador de Botones Menú
local function crearBotonMenu(texto, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    btn.BorderSizePixel = 0
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(200, 200, 205)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

-- ==========================================
-- INTERRUPTOR DE VISIBILIDAD (MINIMIZAR/MAXIMIZAR)
-- ==========================================
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
    StatusLabel.Text = "System: Panel Minimizado"
end)

OpenButton.MouseButton1Click:Connect(function()
    OpenButton.Visible = false
    MainFrame.Visible = true
    StatusLabel.Text = "System: Panel Desplegado"
end)

-- ==========================================
-- LISTA DE OPCIONES DEL MENÚ MÓVIL
-- ==========================================
local BtnJump       = crearBotonMenu("🦘 Saltos Infinitos: OFF", 0)
local BtnOneHit     = crearBotonMenu("💥 Instakill (Solo NPCs): OFF", 42)
local BtnCollect    = crearBotonMenu("🎒 Auto-Recoger Recursos: OFF", 84)
local BtnChestESP   = crearBotonMenu("👁️ Marcar Cofres (ESP)", 126)
local BtnAntiFall   = crearBotonMenu("🛡️ Anti-Caída al Vacío: OFF", 168)
local BtnAntiLag    = crearBotonMenu("⚙️ Modo Anti-Ultra Lag", 210)
local BtnSpeed      = crearBotonMenu("⚡ Súper Velocidad: OFF", 252)
local BtnImmune     = crearBotonMenu("🔰 Inmune a Golpes: OFF", 294)
local BtnTP1        = crearBotonMenu("📍 Teleport Zona 1 (TP)", 336)
local BtnTP2        = crearBotonMenu("📍 Teleport Zona 2 (TP2)", 378)
local BtnRevive     = crearBotonMenu("🔄 Revivir Instantáneo", 420)

-- ==========================================
-- LÓGICA DE LAS NUEVAS OPCIONES
-- ==========================================

-- 1. MOTOR DE SALTOS INFINITOS
BtnJump.MouseButton1Click:Connect(function()
    _G.InfiniteJumpEnabled = not _G.InfiniteJumpEnabled
    if _G.InfiniteJumpEnabled then
        BtnJump.Text = "🦘 Saltos Infinitos: ON"
        BtnJump.BackgroundColor3 = Color3.fromRGB(118, 60, 230) -- Morado Neón activo
        StatusLabel.Text = "System: Salto aéreo infinito desbloqueado"
    else
        BtnJump.Text = "🦘 Saltos Infinitos: OFF"
        BtnJump.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    end
end)

-- Conexión de entrada táctil/salto para saltos continuos
UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled then
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 2. INSTAKILL FILTRADO SÓLO PARA NPCs
BtnOneHit.MouseButton1Click:Connect(function()
    _G.NpcOneHitEnabled = not _G.NpcOneHitEnabled
    if _G.NpcOneHitEnabled then
        BtnOneHit.Text = "💥 Instakill (Solo NPCs): ON"
        BtnOneHit.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
    else
        BtnOneHit.Text = "💥 Instakill (Solo NPCs): OFF"
        BtnOneHit.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    end
end)

-- 3. RECOLECTOR AUTOMÁTICO DE RECURSOS (Casco, Chaleco, etc.)
BtnCollect.MouseButton1Click:Connect(function()
    _G.AutoCollectResources = not _G.AutoCollectResources
    if _G.AutoCollectResources then
        BtnCollect.Text = "🎒 Auto-Recoger Recursos: ON"
        BtnCollect.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
    else
        BtnCollect.Text = "🎒 Auto-Recoger Recursos: OFF"
        BtnCollect.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.8)
        local char = LocalPlayer.Character
        if _G.AutoCollectResources and char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            for _, objeto in pairs(Workspace:GetDescendants()) do
                if objeto:IsA("Tool") or (objeto:IsA("BasePart") and objeto.Parent:IsA("Tool")) then
                    local nombre = objeto.Name:lower()
                    if nombre:find("chaleco") or nombre:find("casco") or nombre:find("espada") or nombre:find("vest") or nombre:find("helmet") or nombre:find("sword") or nombre:find("armor") then
                        pcall(function()
                            if objeto:IsA("Tool") and objeto:FindFirstChild("Handle") then
                                objeto.Handle.CFrame = root.CFrame
                            elseif objeto:IsA("BasePart") then
                                objeto.CFrame = root.CFrame
                            end
                        end)
                    end
                end
            end
        end
    end
end)

-- 4. ESP DE COFRES
BtnChestESP.MouseButton1Click:Connect(function()
    local contador = 0
    for _, objeto in pairs(Workspace:GetDescendants()) do
        if objeto:IsA("BasePart") and (objeto.Name:lower():find("chest") or objeto.Name:lower():find("cofre") or objeto.Name:lower():find("box")) then
            if not objeto:FindFirstChild("BerisGlow") then
                local adornment = Instance.new("BoxHandleAdornment")
                adornment.Name = "BerisGlow"
                adornment.Size = objeto.Size + Vector3.new(0.2, 0.2, 0.2)
                adornment.AlwaysOnTop = true
                adornment.ZIndex = 6
                adornment.Color3 = Color3.fromRGB(255, 180, 0)
                adornment.Transparency = 0.4
                adornment.Adornee = objeto
                adornment.Parent = objeto
                contador = contador + 1
            end
        end
    end
    StatusLabel.Text = "System: " .. contador .. " cofres marcados"
end)

-- 5. ANTI-CAÍDA AL VACÍO
BtnAntiFall.MouseButton1Click:Connect(function()
    _G.AntiVoidEnabled = not _G.AntiVoidEnabled
    if _G.AntiVoidEnabled then
        BtnAntiFall.Text = "🛡️ Anti-Caída al Vacío: ON"
        BtnAntiFall.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
    else
        BtnAntiFall.Text = "🛡️ Anti-Caída al Vacío: OFF"
        BtnAntiFall.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.4)
        if _G.AntiVoidEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if hrp.Position.Y < -30 then
                hrp.Velocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(hrp.Position.X, 25, hrp.Position.Z)
            end
        end
    end
end)

-- 6. MODO ANTI-LAG EXTREMO
BtnAntiLag.MouseButton1Click:Connect(function()
    StatusLabel.Text = "System: Optimizando rendimiento..."
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        if Lighting:FindFirstChild("Blur") then Lighting.Blur:Destroy() end
        
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Texture") or item:IsA("Decal") or item:IsA("ParticleEmitter") or item:IsA("Sparkles") or item:IsA("Trail") then
                item:Destroy()
            elseif item:IsA("BasePart") and not item.Parent:FindFirstChildOfClass("Humanoid") then
                item.Material = Enum.Material.SmoothPlastic
                item.Reflectance = 0
            end
        end
    end)
    StatusLabel.Text = "System: Anti-Lag Inyectado Correctamente"
end)

-- RESTO DE LOGICAS DE SOPORTE (Velocidad, Inmunidad, TPs, Revivir)
BtnSpeed.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    if _G.SpeedEnabled then
        BtnSpeed.Text = "⚡ Súper Velocidad: ON"
        BtnSpeed.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
    else
        BtnSpeed.Text = "⚡ Súper Velocidad: OFF"
        BtnSpeed.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    end
end)

BtnImmune.MouseButton1Click:Connect(function()
    _G.ImmuneEnabled = not _G.ImmuneEnabled
    if _G.ImmuneEnabled then
        BtnImmune.Text = "🔰 Inmune a Golpes: ON"
        BtnImmune.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
    else
        BtnImmune.Text = "🔰 Inmune a Golpes: OFF"
        BtnImmune.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    end
end)

BtnTP1.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 15, 0)
    end
end)

BtnTP2.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(80, 15, 80)
    end
end)

BtnRevive.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        puntoDeRetornoMuerte = char.HumanoidRootPart.CFrame
        char.Humanoid.Health = 0
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if puntoDeRetornoMuerte then
        local hrp = newChar:WaitForChild("HumanoidRootPart", 6)
        if hrp then
            task.wait(0.3)
            hrp.CFrame = puntoDeRetornoMuerte
            puntoDeRetornoMuerte = nil
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char and _G.ImmuneEnabled and not char:FindFirstChildOfClass("ForceField") then
        Instance.new("ForceField", char)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        local char = LocalPlayer.Character
        if char then
            if _G.SpeedEnabled and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 75
            end
            
            if _G.NpcOneHitEnabled then
                local weapon = char:FindFirstChildOfClass("Tool")
                if weapon and weapon:FindFirstChild("Handle") then
                    if not weapon.Handle:FindFirstChild("BerisSecureTag") then
                        weapon.Handle.Touched:Connect(function(hit)
                            if _G.NpcOneHitEnabled and hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid") then
                                local targetHum = hit.Parent:FindFirstChildOfClass("Humanoid")
                                local targetIsPlayer = Players:GetPlayerFromCharacter(hit.Parent)
                                if not targetIsPlayer and targetHum.Health > 0 then
                                    targetHum.Health = 0
                                end
                            end
                        end)
                        local tag = Instance.new("BoolValue", weapon.Handle)
                        tag.Name = "BerisSecureTag"
                    end
                end
            end
        end
    end
end)