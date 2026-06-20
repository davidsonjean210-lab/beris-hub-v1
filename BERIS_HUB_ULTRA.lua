--====================================================================
-- HUB NAME: beris hub (Versión Cyber-Glow Premium v5)
-- Correcciones: Reset de ESP, Retorno Seguro, Aura Daño NPC y GodMode Real
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
-- DISEÑO: BOTÓN FLOTANTE (MINIMIZAR)
-- ==========================================
local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.new(0, 45, 0, 45)
OpenButton.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenButton.BackgroundColor3 = Color3.fromRGB(11, 12, 15)
OpenButton.BorderSizePixel = 0
OpenButton.Text = "b"
OpenButton.TextColor3 = Color3.fromRGB(118, 60, 230)
OpenButton.TextSize = 22
OpenButton.Font = Enum.Font.GothamBold
OpenButton.Visible = false
OpenButton.Active = true
OpenButton.Draggable = true
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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.8, 0, 0, 42)
Title.BackgroundTransparency = 1
Title.Text = "  BERIS HUB // V5 ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.85, 0, 0, 6)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(0.92, 0, 0.74, 0)
ScrollFrame.Position = UDim2.new(0.04, 0, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 560)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(118, 60, 230)
ScrollFrame.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = " System: Fixes Injected"
StatusLabel.TextColor3 = Color3.fromRGB(100, 105, 115)
StatusLabel.TextSize = 10
StatusLabel.Font = Enum.Font.Code
StatusLabel.Parent = MainFrame

-- Variables de Control Actualizadas
_G.SpeedEnabled = false
_G.ImmuneEnabled = false
_G.NpcOneHitEnabled = false
_G.AntiVoidEnabled = false
_G.AutoCollectResources = false
_G.InfiniteJumpEnabled = false
_G.NoclipEnabled = false
_G.ChestEspEnabled = false
local puntoDeRetornoMuerte = nil

local function crearBotonMenu(texto, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
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

-- Sistema de Minimizar
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() OpenButton.Visible = false; MainFrame.Visible = true end)

-- ==========================================
-- LISTA DE OPCIONES DEL MENÚ MÓVIL (V5)
-- ==========================================
local BtnNoclip      = crearBotonMenu("👻 Traspasar Paredes: OFF", 0)
local BtnImmune      = crearBotonMenu("🔰 Inmune a Golpes: OFF", 40)
local BtnOneHit      = crearBotonMenu("💥 Instakill Aura (NPCs): OFF", 80)
local BtnChestESP    = crearBotonMenu("👁️ Marcar Cofres: OFF", 120)
local BtnJump        = crearBotonMenu("🦘 Saltos Infinitos: OFF", 160)
local BtnCollect     = crearBotonMenu("🎒 Auto-Recoger Recursos: OFF", 200)
local BtnAntiFall    = crearBotonMenu("🛡️ Anti-Caída al Vacío: OFF", 240)
local BtnSpeed       = crearBotonMenu("⚡ Súper Velocidad: OFF", 280)
local BtnAntiLag     = crearBotonMenu("⚙️ Modo Anti-Ultra Lag", 320)
local BtnTP1         = crearBotonMenu("📍 Teleport Zona 1 (TP)", 360)
local BtnTP2         = crearBotonMenu("📍 Teleport Zona 2 (TP2)", 400)
local BtnRevive      = crearBotonMenu("🔄 Revivir Instantáneo", 440)

-- ==========================================
-- CONTROLADORES CORREGIDOS
-- ==========================================

-- 1. SOLUCIÓN: TRASPASAR PAREDES
BtnNoclip.MouseButton1Click:Connect(function()
    _G.NoclipEnabled = not _G.NoclipEnabled
    if _G.NoclipEnabled then
        BtnNoclip.Text = "👻 Traspasar Paredes: ON"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
    else
        BtnNoclip.Text = "👻 Traspasar Paredes: OFF"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    end
end)

-- 2. SOLUCIÓN: INMUNE REAL A GOLPES DE ANIMALES
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

-- 3. SOLUCIÓN: INSTAKILL POR AURA CONTRA ANIMALES/NPCs
BtnOneHit.MouseButton1Click:Connect(function()
    _G.NpcOneHitEnabled = not _G.NpcOneHitEnabled
    if _G.NpcOneHitEnabled then
        BtnOneHit.Text = "💥 Instakill Aura (NPCs): ON"
        BtnOneHit.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
    else
        BtnOneHit.Text = "💥 Instakill Aura (NPCs): OFF"
        BtnOneHit.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
    end
end)

-- 4. SOLUCIÓN: COFRES CON INTERRUPTOR APAGAR/ENCENDER REAL
BtnChestESP.MouseButton1Click:Connect(function()
    _G.ChestEspEnabled = not _G.ChestEspEnabled
    if _G.ChestEspEnabled then
        BtnChestESP.Text = "👁️ Marcar Cofres: ON"
        BtnChestESP.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
        
        for _, objeto in pairs(Workspace:GetDescendants()) do
            if objeto:IsA("BasePart") and (objeto.Name:lower():find("chest") or objeto.Name:lower():find("cofre") or objeto.Name:lower():find("box")) then
                if not objeto:FindFirstChild("BerisGlow") then
                    local adornment = Instance.new("BoxHandleAdornment")
                    adornment.Name = "BerisGlow"
                    adornment.Size = objeto.Size + Vector3.new(0.3, 0.3, 0.3)
                    adornment.AlwaysOnTop = true
                    adornment.ZIndex = 6
                    adornment.Color3 = Color3.fromRGB(255, 180, 0)
                    adornment.Transparency = 0.4
                    adornment.Adornee = objeto
                    adornment.Parent = objeto
                end
            end
        end
    else
        BtnChestESP.Text = "👁️ Marcar Cofres: OFF"
        BtnChestESP.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
        -- Limpieza absoluta de marcas existentes
        for _, objeto in pairs(Workspace:GetDescendants()) do
            if objeto:IsA("BasePart") and objeto:FindFirstChild("BerisGlow") then
                objeto.BerisGlow:Destroy()
            end
        end
    end
end)

-- 5. SOLUCIÓN: REVIVIR SIN VOLVER A MORIR
BtnRevive.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        puntoDeRetornoMuerte = char.HumanoidRootPart.CFrame
        char.Humanoid.Health = 0
        StatusLabel.Text = "System: Resucitando con seguro activo..."
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if puntoDeRetornoMuerte then
        local hrp = newChar:WaitForChild("HumanoidRootPart", 10)
        if hrp then
            task.wait(1.5) -- Tiempo seguro corregido para evitar la doble muerte en móvil
            hrp.CFrame = puntoDeRetornoMuerte
            puntoDeRetornoMuerte = nil
            StatusLabel.Text = "System: Reaparecido a salvo"
        end
    end
end)

-- Opciones estándar remanentes
BtnJump.MouseButton1Click:Connect(function()
    _G.InfiniteJumpEnabled = not _G.InfiniteJumpEnabled
    BtnJump.Text = _G.InfiniteJumpEnabled and "🦘 Saltos Infinitos: ON" or "🦘 Saltos Infinitos: OFF"
    BtnJump.BackgroundColor3 = _G.InfiniteJumpEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

BtnCollect.MouseButton1Click:Connect(function()
    _G.AutoCollectResources = not _G.AutoCollectResources
    BtnCollect.Text = _G.AutoCollectResources and "🎒 Auto-Recoger Recursos: ON" or "🎒 Auto-Recoger Recursos: OFF"
    BtnCollect.BackgroundColor3 = _G.AutoCollectResources and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnAntiFall.MouseButton1Click:Connect(function()
    _G.AntiVoidEnabled = not _G.AntiVoidEnabled
    BtnAntiFall.Text = _G.AntiVoidEnabled and "🛡️ Anti-Caída al Vacío: ON" or "🛡️ Anti-Caída al Vacío: OFF"
    BtnAntiFall.BackgroundColor3 = _G.AntiVoidEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnSpeed.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    BtnSpeed.Text = _G.SpeedEnabled and "⚡ Súper Velocidad: ON" or "⚡ Súper Velocidad: OFF"
    BtnSpeed.BackgroundColor3 = _G.SpeedEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnAntiLag.MouseButton1Click:Connect(function()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        for _, item in pairs(Workspace:GetDescendants()) do
            if item:IsA("Texture") or item:IsA("Decal") or item:IsA("ParticleEmitter") then item:Destroy() end
        end
    end)
end)

BtnTP1.MouseButton1Click:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 15, 0) end end)
BtnTP2.MouseButton1Click:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(80, 15, 80) end end)

-- ==========================================
-- BUCLES PRINCIPALES (SISTEMAS REPARADOS)
-- ==========================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    
    -- Traspasar paredes activo continuo
    if _G.NoclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    -- Inmune por bloqueo de HP forzado
    if _G.ImmuneEnabled and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        hum.Health = hum.MaxHealth
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            
            -- Súper velocidad continua
            if _G.SpeedEnabled and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 75
            end
            
            -- AUTO-RECOGER ITEMS MASIVO
            if _G.AutoCollectResources then
                for _, objeto in pairs(Workspace:GetDescendants()) do
                    if objeto:IsA("Tool") or (objeto:IsA("BasePart") and objeto.Parent:IsA("Tool")) then
                        local n = objeto.Name:lower()
                        if n:find("chaleco") or n:find("casco") or n:find("espada") or n:find("vest") or n:find("helmet") or n:find("sword") or n:find("armor") then
                            pcall(function()
                                if objeto:IsA("Tool") and objeto:FindFirstChild("Handle") then objeto.Handle.CFrame = root.CFrame
                                elseif objeto:IsA("BasePart") then objeto.CFrame = root.CFrame end
                            </pcall>
                        end
                    end
                end
            end
            
            -- INSTAKILL CONTRA ANIMALES/NPCs (Aura de Proximidad Inteligente)
            if _G.NpcOneHitEnabled then
                for _, entidad in pairs(Workspace:GetDescendants()) do
                    if entidad:IsA("Humanoid") and entidad.Parent and entidad.Parent:FindFirstChild("HumanoidRootPart") then
                        local targetChar = entidad.Parent
                        -- Verificamos que esté cerca (menos de 25 metros) y que NO sea un jugador real ni tú
                        if targetChar.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(targetChar) then
                            local distancia = (targetChar.HumanoidRootPart.Position - root.Position).Magnitude
                            if distancia < 25 and entidad.Health > 0 then
                                entidad.Health = 0 -- Lo destruye en el servidor automáticamente
                            end
                        end
                    end
                end
            end
            
            -- ANTI-VOID
            if _G.AntiVoidEnabled and root.Position.Y < -30 then
                root.Velocity = Vector3.new(0, 0, 0)
                root.CFrame = CFrame.new(root.Position.X, 25, root.Position.Z)
            end
        end
    end
end)