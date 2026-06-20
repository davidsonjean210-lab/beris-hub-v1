--====================================================================
-- HUB NAME: beris hub (V10 - Pistola Mágica y TP Arreglado)
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
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
MainFrame.Size = UDim2.new(0, 250, 0, 380)
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
Title.Text = "  BERIS HUB // FULL 🏝️"
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
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 540) 
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(118, 60, 230)
ScrollFrame.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = " System: Update V10 Loaded"
StatusLabel.TextColor3 = Color3.fromRGB(100, 105, 115)
StatusLabel.TextSize = 10
StatusLabel.Font = Enum.Font.Code
StatusLabel.Parent = MainFrame

-- Variables Globales
_G.NoclipEnabled = false
_G.InfiniteJumpEnabled = false
_G.SpeedEnabled = false
_G.AntiVoidEnabled = false
_G.HitboxGigante = false
_G.RepelerAnimales = false
_G.ChestEspEnabled = false
_G.PartsEspEnabled = false
_G.AutoCollectResources = false
_G.HandGunEnabled = false

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
-- TODOS LOS BOTONES 
-- ==========================================
local BtnPistola     = crearBotonMenu("🔫 Pistola Mágica (Click): OFF", 0)
local BtnHitbox      = crearBotonMenu("🎯 Hitbox Animales Gigante: OFF", 40)
local BtnRepeler     = crearBotonMenu("🛡️ Campo Repeler Animales: OFF", 80)
local BtnTPCofre     = crearBotonMenu("🚀 TP al Cofre Más Cercano", 120)
local BtnPartsESP    = crearBotonMenu("🔍 Marcar Piezas de Escape: OFF", 160)
local BtnChestESP    = crearBotonMenu("👁️ Marcar Cofres (ESP): OFF", 200)
local BtnCollect     = crearBotonMenu("🎒 Atraer Items/Comida: OFF", 240)
local BtnNoclip      = crearBotonMenu("👻 Traspasar Paredes: OFF", 280)
local BtnJump        = crearBotonMenu("🦘 Saltos Infinitos: OFF", 320)
local BtnSpeed       = crearBotonMenu("⚡ Súper Velocidad: OFF", 360)
local BtnAntiFall    = crearBotonMenu("🛡️ Anti-Caída al Vacío: OFF", 400)
local BtnAntiLag     = crearBotonMenu("⚙️ Modo Anti-Ultra Lag", 440)
local BtnTPArriba    = crearBotonMenu("📍 Volar 50 metros arriba", 480)

-- ==========================================
-- LÓGICAS DE LOS BOTONES
-- ==========================================

-- SISTEMA DE PISTOLA DE MANO
BtnPistola.MouseButton1Click:Connect(function()
    _G.HandGunEnabled = not _G.HandGunEnabled
    BtnPistola.Text = _G.HandGunEnabled and "🔫 Pistola Mágica (Click): ON" or "🔫 Pistola Mágica (Click): OFF"
    BtnPistola.BackgroundColor3 = _G.HandGunEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

Mouse.Button1Down:Connect(function()
    if _G.HandGunEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local char = LocalPlayer.Character
        local originPos = char.HumanoidRootPart.Position
        
        -- Crear la bala
        local bullet = Instance.new("Part")
        bullet.Size = Vector3.new(0.5, 0.5, 2)
        bullet.BrickColor = BrickColor.new("Bright yellow")
        bullet.Material = Enum.Material.Neon
        bullet.CanCollide = false
        bullet.CFrame = CFrame.lookAt(originPos, Mouse.Hit.Position)
        bullet.Parent = Workspace
        
        -- Darle velocidad a la bala
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = bullet.CFrame.LookVector * 250 -- Velocidad de la bala
        bodyVel.Parent = bullet
        
        -- Detectar impactos
        bullet.Touched:Connect(function(hit)
            if hit.Parent and hit.Parent ~= char and hit.Parent:FindFirstChild("Humanoid") then
                hit.Parent.Humanoid.Health = 0 -- Intenta matar instantáneamente a lo que toque
                bullet:Destroy()
            end
        end)
        
        -- Destruir la bala después de 2 segundos para no laggear
        Debris:AddItem(bullet, 2)
    end
end)

-- SISTEMA DE TP A COFRE MEJORADO (Filtro Anti-Fogata)
BtnTPCofre.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local miPosicion = char.HumanoidRootPart.Position
    local cofreMasCercano = nil
    local distanciaMinima = math.huge
    
    -- Lista negra de palabras que NO queremos que confunda con cofres
    local palabrasIgnoradas = {"fire", "fogata", "hitbox", "camp"}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            -- Verificamos si parece un cofre
            if n:find("chest") or n:find("cofre") or n:find("box") then
                local esValido = true
                -- Comprobamos que no tenga palabras de la lista negra
                for _, ignorada in pairs(palabrasIgnoradas) do
                    if n:find(ignorada) then
                        esValido = false
                        break
                    end
                end
                
                if esValido then
                    local distancia = (obj.Position - miPosicion).Magnitude
                    if distancia < distanciaMinima then
                        distanciaMinima = distancia
                        cofreMasCercano = obj
                    end
                end
            end
        end
    end
    
    if cofreMasCercano then
        char.HumanoidRootPart.CFrame = cofreMasCercano.CFrame + Vector3.new(0, 3, 0)
        StatusLabel.Text = "TP Exitoso al cofre real!"
    else
        StatusLabel.Text = "No se encontraron cofres válidos."
    end
end)

BtnHitbox.MouseButton1Click:Connect(function()
    _G.HitboxGigante = not _G.HitboxGigante
    BtnHitbox.Text = _G.HitboxGigante and "🎯 Hitbox Animales Gigante: ON" or "🎯 Hitbox Animales Gigante: OFF"
    BtnHitbox.BackgroundColor3 = _G.HitboxGigante and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnRepeler.MouseButton1Click:Connect(function()
    _G.RepelerAnimales = not _G.RepelerAnimales
    BtnRepeler.Text = _G.RepelerAnimales and "🛡️ Campo Repeler Animales: ON" or "🛡️ Campo Repeler Animales: OFF"
    BtnRepeler.BackgroundColor3 = _G.RepelerAnimales and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnPartsESP.MouseButton1Click:Connect(function()
    _G.PartsEspEnabled = not _G.PartsEspEnabled
    if _G.PartsEspEnabled then
        BtnPartsESP.Text = "🔍 Marcar Piezas de Escape: ON"
        BtnPartsESP.BackgroundColor3 = Color3.fromRGB(118, 60, 230)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("wood") or obj.Name:lower():find("radio") or obj.Name:lower():find("compass") or obj.Name:lower():find("map") or obj.Name:lower():find("pieza")) then
                if not obj:FindFirstChild("BerisPartGlow") then
                    local hlt = Instance.new("BoxHandleAdornment")
                    hlt.Name = "BerisPartGlow"
                    hlt.Size = obj.Size + Vector3.new(0.5, 0.5, 0.5)
                    hlt.AlwaysOnTop = true; hlt.ZIndex = 10
                    hlt.Color3 = Color3.fromRGB(0, 255, 100); hlt.Transparency = 0.3
                    hlt.Adornee = obj; hlt.Parent = obj
                end
            end
        end
    else
        BtnPartsESP.Text = "🔍 Marcar Piezas de Escape: OFF"
        BtnPartsESP.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("BerisPartGlow") then obj.BerisPartGlow:Destroy() end
        end
    end
end)

BtnChestESP.MouseButton1Click:Connect(function()
    _G.ChestEspEnabled = not _G.ChestEspEnabled
    BtnChestESP.Text = _G.ChestEspEnabled and "👁️ Marcar Cofres (ESP): ON" or "👁️ Marcar Cofres (ESP): OFF"
    BtnChestESP.BackgroundColor3 = _G.ChestEspEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
    if _G.ChestEspEnabled then
        local palabrasIgnoradas = {"fire", "fogata", "hitbox", "camp"}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("chest") or obj.Name:lower():find("cofre") or obj.Name:lower():find("box")) then
                local esValido = true
                for _, ignorada in pairs(palabrasIgnoradas) do
                    if obj.Name:lower():find(ignorada) then esValido = false break end
                end
                
                if esValido and not obj:FindFirstChild("BerisGlow") then
                    local hlt = Instance.new("BoxHandleAdornment")
                    hlt.Name = "BerisGlow"
                    hlt.Size = obj.Size + Vector3.new(0.3, 0.3, 0.3)
                    hlt.AlwaysOnTop = true; hlt.ZIndex = 6
                    hlt.Color3 = Color3.fromRGB(255, 180, 0); hlt.Transparency = 0.4
                    hlt.Adornee = obj; hlt.Parent = obj
                end
            end
        end
    else
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("BerisGlow") then obj.BerisGlow:Destroy() end
        end
    end
end)

BtnCollect.MouseButton1Click:Connect(function()
    _G.AutoCollectResources = not _G.AutoCollectResources
    BtnCollect.Text = _G.AutoCollectResources and "🎒 Atraer Items/Comida: ON" or "🎒 Atraer Items/Comida: OFF"
    BtnCollect.BackgroundColor3 = _G.AutoCollectResources and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnNoclip.MouseButton1Click:Connect(function()
    _G.NoclipEnabled = not _G.NoclipEnabled
    BtnNoclip.Text = _G.NoclipEnabled and "👻 Traspasar Paredes: ON" or "👻 Traspasar Paredes: OFF"
    BtnNoclip.BackgroundColor3 = _G.NoclipEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

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

BtnSpeed.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    BtnSpeed.Text = _G.SpeedEnabled and "⚡ Súper Velocidad: ON" or "⚡ Súper Velocidad: OFF"
    BtnSpeed.BackgroundColor3 = _G.SpeedEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
end)

BtnAntiFall.MouseButton1Click:Connect(function()
    _G.AntiVoidEnabled = not _G.AntiVoidEnabled
    BtnAntiFall.Text = _G.AntiVoidEnabled and "🛡️ Anti-Caída al Vacío: ON" or "🛡️ Anti-Caída al Vacío: OFF"
    BtnAntiFall.BackgroundColor3 = _G.AntiVoidEnabled and Color3.fromRGB(118, 60, 230) or Color3.fromRGB(20, 22, 27)
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

BtnTPArriba.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 50, 0)
    end
end)

-- ==========================================
-- BUCLES DE FUNCIONAMIENTO CONTINUO
-- ==========================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    if _G.NoclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            
            if _G.SpeedEnabled and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 75 end
            if _G.AntiVoidEnabled and root.Position.Y < -30 then root.Velocity = Vector3.new(0, 0, 0); root.CFrame = CFrame.new(root.Position.X, 50, root.Position.Z) end
            
            if _G.AutoCollectResources then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Tool") or (obj:IsA("BasePart") and obj.Parent:IsA("Tool") or obj:IsA("ClickDetector")) then
                        local n = obj.Name:lower()
                        if n:find("food") or n:find("water") or n:find("meat") or n:find("apple") or n:find("wood") then
                            pcall(function() if obj:IsA("BasePart") then obj.CFrame = root.CFrame end end)
                        end
                    end
                end
            end
            
            for _, entidad in pairs(Workspace:GetDescendants()) do
                if entidad:IsA("Humanoid") and entidad.Parent and entidad.Parent:FindFirstChild("HumanoidRootPart") then
                    local targetChar = entidad.Parent
                    if targetChar.Name ~= LocalPlayer.Name and not Players:GetPlayerFromCharacter(targetChar) then
                        local targetRoot = targetChar.HumanoidRootPart
                        local distancia = (targetRoot.Position - root.Position).Magnitude
                        
                        if _G.RepelerAnimales and distancia < 15 then
                            local direccionEmpuje = (targetRoot.Position - root.Position).Unit
                            targetRoot.Velocity = direccionEmpuje * 100 
                        end
                        
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