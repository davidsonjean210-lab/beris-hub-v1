--====================================================================
-- HUB NAME: beris hub (V8 - Soluciones Físicas y TP Cofres)
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("BerisHubCyber") then
    PlayerGui.BerisHubCyber:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubCyber"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ==========================================
-- BOTÓN FLOTANTE
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

-- ==========================================
-- PANEL PRINCIPAL
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 360)
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
Title.Text = "  BERIS HUB // SURVIVAL 🏝️"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
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
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
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

-- Variables Globales
_G.HitboxGigante = false
_G.RepelerAnimales = false
_G.ChestEspEnabled = false
_G.AutoCollectResources = false
_G.SpeedEnabled = false

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

MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenButton.Visible = true end)
OpenButton.MouseButton1Click:Connect(function() OpenButton.Visible = false; MainFrame.Visible = true end)

-- ==========================================
-- BOTONES
-- ==========================================
local BtnHitbox      = crearBotonMenu("🎯 Hitbox Animales Gigante: OFF", 0)
local BtnRepeler     = crearBotonMenu("🛡️ Campo Repeler Animales: OFF", 40)
local BtnTPCofre     = crearBotonMenu("🚀 TP al Cofre Más Cercano", 80)
local BtnChestESP    = crearBotonMenu("👁️ Marcar Cofres (ESP): OFF", 120)
local BtnCollect     = crearBotonMenu("🎒 Atraer Items/Comida: OFF", 160)
local BtnSpeed       = crearBotonMenu("⚡ Súper Velocidad: OFF", 200)

-- ==========================================
-- LÓGICAS DE LOS BOTONES
-- ==========================================

-- 1. TP AL COFRE MÁS CERCANO
BtnTPCofre.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local miPosicion = char.HumanoidRootPart.Position
    
    local cofreMasCercano = nil
    local distanciaMinima = math.huge
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("chest") or obj.Name:lower():find("cofre") or obj.Name:lower():find("box")) then
            local distancia = (obj.Position - miPosicion).Magnitude
            if distancia < distanciaMinima then
                distanciaMinima = distancia
                cofreMasCercano = obj
            end
        end
    end
    
    if cofreMasCercano then
        -- Te teletransporta 3 metros arriba del cofre para evitar quedarte atascado
        char.HumanoidRootPart.CFrame = cofreMasCercano.CFrame + Vector3.new(0, 3, 0)
        StatusLabel.Text = "TP Exitoso al cofre!"
    else
        StatusLabel.Text = "No se encontraron cofres."
    end
end)

-- 2. HITBOX GIGANTE (Para matar fácil y obtener el loot)
BtnHitbox.MouseButton1Click:Connect(function()
    _G.HitboxGigante = not _G.HitboxGigante
    BtnHitbox.Text = _G.HitboxGigante and "🎯 Hitbox Animales Gigante: ON" or "🎯 Hitbox Animales Gigante: OFF"
    BtnHitbox.BackgroundColor3 = _G.HitboxGigante and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

-- 3. CAMPO PARA REPELER ANIMALES (Reemplazo de la vida infinita)
BtnRepeler.MouseButton1Click:Connect(function()
    _G.RepelerAnimales = not _G.RepelerAnimales
    BtnRepeler.Text = _G.RepelerAnimales and "🛡️ Campo Repeler Animales: ON" or "🛡️ Campo Repeler Animales: OFF"
    BtnRepeler.BackgroundColor3 = _G.RepelerAnimales and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnChestESP.MouseButton1Click:Connect(function()
    _G.ChestEspEnabled = not _G.ChestEspEnabled
    BtnChestESP.Text = _G.ChestEspEnabled and "👁️ Marcar Cofres (ESP): ON" or "👁️ Marcar Cofres (ESP): OFF"
    BtnChestESP.BackgroundColor3 = _G.ChestEspEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
    
    if _G.ChestEspEnabled then
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
        for _, objeto in pairs(Workspace:GetDescendants()) do
            if objeto:IsA("BasePart") and objeto:FindFirstChild("BerisGlow") then
                objeto.BerisGlow:Destroy()
            end
        end
    end
end)

BtnCollect.MouseButton1Click:Connect(function()
    _G.AutoCollectResources = not _G.AutoCollectResources
    BtnCollect.Text = _G.AutoCollectResources and "🎒 Atraer Items/Comida: ON" or "🎒 Atraer Items/Comida: OFF"
    BtnCollect.BackgroundColor3 = _G.AutoCollectResources and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnSpeed.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    BtnSpeed.Text = _G.SpeedEnabled and "⚡ Súper Velocidad: ON" or "⚡ Súper Velocidad: OFF"
    BtnSpeed.BackgroundColor3 = _G.SpeedEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

-- ==========================================
-- BUCLES DE FUNCIONAMIENTO CONTINUO
-- ==========================================

task.spawn(function()
    while true do
        task.wait(0.1)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            
            if _G.SpeedEnabled and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 75
            end
            
            -- ATRAER OBJETOS
            if _G.AutoCollectResources then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Tool") or (obj:IsA("BasePart") and obj.Parent:IsA("Tool") or obj:IsA("ClickDetector")) then
                        local n = obj.Name:lower()
                        if n:find("food") or n:find("water") or n:find("meat") or n:find("apple") or n:find("wood") then
                            pcall(function()
                                if obj:IsA("BasePart") then obj.CFrame = root.CFrame end
                            end)
                        end
                    end
                end
            end
            
            -- LÓGICA DE ENEMIGOS: REPELER Y HITBOX GIGANTE
            for _, entidad in pairs(Workspace:GetDescendants()) do
                if entidad:IsA("Humanoid") and entidad.Parent and entidad.Parent:FindFirstChild("HumanoidRootPart") then
                    local targetChar = entidad.Parent
                    
                    -- Verifica que no seas tú ni otro jugador
                    if targetChar.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(targetChar) then
                        local targetRoot = targetChar.HumanoidRootPart
                        local distancia = (targetRoot.Position - root.Position).Magnitude
                        
                        -- 1. REPELER (Si está activo y se acercan a menos de 15 studs, los empuja lejos)
                        if _G.RepelerAnimales and distancia < 15 then
                            -- Calcula la dirección opuesta a ti y los empuja con fuerza
                            local direccionEmpuje = (targetRoot.Position - root.Position).Unit
                            targetRoot.Velocity = direccionEmpuje * 100 
                        end
                        
                        -- 2. HITBOX GIGANTE (Si está activo, infla a los enemigos para pegarles fácil)
                        if _G.HitboxGigante then
                            targetRoot.Size = Vector3.new(15, 15, 15)
                            targetRoot.Transparency = 0.7
                            targetRoot.CanCollide = false
                        end
                    end
                end
            end
            
        end
    end
end)