-- ====================================================================
-- BERIS HUB V6 - STABLE BURST -- ====================================================================
-- BERIS HUB V6 - GOD TIER ADVANCED COLLECTION EDITION (2026)
-- SE AÑADIÓ: AUTO RECOLECCIÓN DE ASSETS Y PROXIMITY PROMPTS
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de optimización y estados estables
local savedPosition = nil
local noclipEnabled = false
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local walkSpeedEnabled = false
local customWalkSpeed = 16
local isMinimised = false
local espEnabled = false
local chamsEnabled = false 
local aimlockEnabled = false
local fastAimEnabled = false
local autoFamaEnabled = false
local killAuraEnabled = false 
local autoParryEnabled = false 
local instantRespawnEnabled = false 
local fpsBoostEnabled = false 
local hitboxExpanded = false 
local autoCollectEnabled = false -- Nuevo: Estado de Auto Recolección

local MAX_REAL_DISTANCE = 300 
local AURA_RANGE = 25 
local PREDICTION_INTENSITY = 0.14
local originalGravity = workspace.Gravity
local connections = {}

-- 1. CONTROLADOR DE INTERFAZ CYBERPUNK V3.5 (TAMAÑO PRESET)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV6_GodCollection"
ScreenGui.ResetOnSpawn = false

local function injectGui()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then ScreenGui.Parent = coreGui else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 7) or game
    end
end
injectGui()

local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 290, 0, 565) 
local miniSize = UDim2.new(0, 290, 0, 45)

MainFrame.Name = "MainFrame"
MainFrame.Size = fullSize
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 12, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 9, 13)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 22, 32))
}
UIGradient.Rotation = 60
UIGradient.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local NeonLine = Instance.new("Frame")
NeonLine.Size = UDim2.new(1, 0, 0, 3)
NeonLine.BackgroundColor3 = Color3.fromRGB(255, 170, 0) -- Tono Ambar Neon de Colección
NeonLine.BorderSizePixel = 0
NeonLine.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "   BERIS HUB V6 • <font color='#FFAA00'>MASTER COLLECT</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 24, 0, 24)
BtnClose.Position = UDim2.new(1, -34, 0, 10)
BtnClose.Text = "✕"
BtnClose.TextColor3 = Color3.fromRGB(255, 80, 80)
BtnClose.TextSize = 11
BtnClose.Font = Enum.Font.GothamBold
BtnClose.BackgroundColor3 = Color3.fromRGB(32, 18, 22)
BtnClose.BorderSizePixel = 0
BtnClose.Parent = Header
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 6)

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 24, 0, 24)
BtnMinimize.Position = UDim2.new(1, -64, 0, 10)
BtnMinimize.Text = "—"
BtnMinimize.TextColor3 = Color3.fromRGB(255, 170, 0)
BtnMinimize.TextSize = 11
BtnMinimize.Font = Enum.Font.GothamBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(36, 26, 18)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.Parent = Header
Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 6)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1000) 
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 170, 0)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createPremiumButton(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 266, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(28, 30, 42)
    stroke.Thickness = 1
    stroke.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 1, 0)
    button.Position = UDim2.new(0, 12, 0, 0)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(240, 240, 245)
    button.TextSize = 11
    button.Font = Enum.Font.GothamSemibold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.BackgroundTransparency = 1
    button.Parent = frame

    local led = Instance.new("Frame")
    led.Size = UDim2.new(0, 6, 0, 6)
    led.Position = UDim2.new(1, -16, 0, 14)
    led.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
    led.BorderSizePixel = 0
    led.Parent = frame
    Instance.new("UICorner", led).CornerRadius = UDim.new(1, 0)

    return button, led
end

local function updateLed(led, state)
    TweenService:Create(led, TweenInfo.new(0.2), {
        BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 65, 65)
    }):Play()
end

local function createPremiumTextBox(placeholder)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 266, 0, 34)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(110, 115, 125)
    textBox.TextSize = 11
    textBox.Font = Enum.Font.Gotham
    textBox.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
    textBox.BorderSizePixel = 0
    textBox.Parent = ScrollFrame
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(25, 27, 38)
    stroke.Thickness = 1
    stroke.Parent = textBox
    
    return textBox
end

-- ====================================================================
-- INSTANCIACIÓN DE MÓDULOS (INCLUYE NUEVO AUTO-COLLECT)
-- ====================================================================

local BtnCollect, LedCollect = createPremiumButton("📦 Auto Recolección Magnética + Prompts") -- NUEVO
local BtnKillAura, LedAura   = createPremiumButton("💥 Habilitar Kill Aura (Radio 25w)")
local BtnParry, LedParry     = createPremiumButton("🛡️ Auto Parry / Auto Block (Beta)")
local BtnFastAim, LedFast   = createPremiumButton("🎯 Aim Predictivo + Raycast (Auto)")
local BtnAim, LedAim       = createPremiumButton("👁️ Aimlock con Fijación [Tecla E]")
local BtnHitbox, LedHitbox   = createPremiumButton("💀 Hitbox Expander (Cabeza 5x)")
local BtnAutoFama, LedFama   = createPremiumButton("⭐ Intelli-Farm Automático Activo")
local BtnChams, LedChams     = createPremiumButton("🌈 Renderizado Chams (Silueta Pared)")
local BtnEsp, LedEsp       = createPremiumButton("📦 Visualizador Wallhack / ESP Box")
local BtnCam, LedCam         = createPremiumButton("🎥 No Clip de Cámara (Freecam)")
local BtnBoost, LedBoost     = createPremiumButton("⚡ Eliminar Texturas (FPS Boost)")
local BtnFly, LedFly       = createPremiumButton("✈️ Vuelo Inteligente Integrado")
local BtnSpeed, LedSpeed   = createPremiumButton("🏃 Estabilizador de Caminado")
local BtnTras, LedTras     = createPremiumButton("🧱 Bypass de Colisión (Noclip)")
local BtnInfJ, LedInfJ     = createPremiumButton("🦘 Fijar Salto Continuo / Infinito")
local BtnRespawn, LedResp   = createPremiumButton("🔄 Auto-Reaparecer (Instant Respawn)")
local BtnSaveTp, LedSTp    = createPremiumButton("💾 Capturar Coordenadas Actuales")
local BtnTp, LedTp         = createPremiumButton("🚀 Forzar Teletransporte Guardado")
local BtnGod, LedGod       = createPremiumButton("👑 Modo Dios (Local/Visual)")

local InputTpTo  = createPremiumTextBox(" 👤 Teletransporte a Jugador (Nombre Corto)")
local InputSpeed = createPremiumTextBox(" 🏃 Velocidad de Caminado (Defecto: 16)")
local InputFly   = createPremiumTextBox(" ✈️ Velocidad de Vuelo Pro (Defecto: 50)")
local InputGrav  = createPremiumTextBox(" 🪐 Modificar Gravedad (Defecto: 196.2)")
local InputFov   = createPremiumTextBox(" 📐 Fijar FOV de Cámara (Defecto: 70)")
local InputMoney = createPremiumTextBox(" 💵 Hackear Dinero / Coins (Visual)")

-- Anti-AFK
pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- ====================================================================
-- MEJORA ADICIONAL: ALGORITMO DE AUTO RECOLECCIÓN INTEGRAL
-- ====================================================================
BtnCollect.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    updateLed(LedCollect, autoCollectEnabled)
    
    if autoCollectEnabled then
        task.spawn(function()
            while autoCollectEnabled do
                pcall(function()
                    local myChar = LocalPlayer.Character
                    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if not myHrp then return end
                    
                    -- 1. Bucle de rastreo de ProximityPrompts del mapa (Cofres, palancas, Drops)
                    for _, prompt in pairs(workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            local parentPart = prompt.Parent
                            if parentPart and parentPart:IsA("BasePart") then
                                local dist = (myHrp.Position - parentPart.Position).Magnitude
                                if dist <= 35 then -- Distancia de interacción segura
                                    prompt:InputHoldBegin()
                                    task.wait(0.05)
                                    prompt:InputHoldEnd()
                                end
                            end
                        end
                    end
                    
                    -- 2. Bucle de imán/recolección de objetos físicos sueltos (Coins, Gems, Items)
                    for _, object in pairs(workspace:GetDescendants()) do
                        if object:IsA("BasePart") or object:IsA("MeshPart") then
                            local name = object.Name:lower()
                            -- Filtro dinámico de nombres de ítems comunes coleccionables
                            if name:find("coin") or name:find("gem") or name:find("chest") or name:find("token") or name:find("fruit") or name:find("drop") or name:find("star") then
                                local distance = (myHrp.Position - object.Position).Magnitude
                                if distance <= MAX_REAL_DISTANCE then
                                    -- Transporta magnéticamente el objeto directo a tus pies
                                    object.CFrame = myHrp.CFrame
                                    object.CanCollide = false
                                end
                            end
                        end
                    end
                end)
                task.wait(0.4) -- Frecuencia estable para evitar sobrecarga de red remota
            end
        end)
    end
end)

-- ====================================================================
-- COMPORTAMIENTOS COMPLEMENTARIOS
-- ====================================================================
local function isTargetVisible(targetCharacter)
    local head = targetCharacter:FindFirstChild("Head")
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if head and myHrp then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterFolder = {myChar, targetCharacter}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local direction = (head.Position - myHrp.Position)
        local rayResult = workspace:Raycast(myHrp.Position, direction, raycastParams)
        if not rayResult then return true end
    end
    return false
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = MAX_REAL_DISTANCE
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local realDistance = (myHrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if realDistance < shortestDistance and isTargetVisible(player.Character) then
                    closestPlayer = player
                    shortestDistance = realDistance
                end
            end
        end
    end
    return closestPlayer
end

BtnKillAura.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    updateLed(LedAura, killAuraEnabled)
    if killAuraEnabled then
        task.spawn(function()
            while killAuraEnabled do
                pcall(function()
                    local myChar = LocalPlayer.Character
                    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    local tool = myChar and myChar:FindFirstChildOfClass("Tool")
                    if myHrp and tool then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local targetHrp = player.Character.HumanoidRootPart
                                local distance = (myHrp.Position - targetHrp.Position).Magnitude
                                if distance <= AURA_RANGE then tool:Activate() end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

BtnFastAim.MouseButton1Click:Connect(function()
    fastAimEnabled = not fastAimEnabled
    updateLed(LedFast, fastAimEnabled)
    if fastAimEnabled then
        connections.fastAim = RunService.RenderStepped:Connect(function()
            pcall(function()
                if UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInput:IsKeyDown(Enum.KeyCode.E) then
                    local target = getClosestPlayer()
                    if target and target.Character and target.Character.Head then
                        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                        local targetVelocity = targetHrp and targetHrp.Velocity or Vector3.zero
                        local predictedPosition = target.Character.Head.Position + (targetVelocity * PREDICTION_INTENSITY)
                        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPosition)
                    end
                end
            end)
        end)
    else
        if connections.fastAim then connections.fastAim:Disconnect() connections.fastAim = nil end
    end
end)

BtnSpeed.MouseButton1Click:Connect(function()
    walkSpeedEnabled = not walkSpeedEnabled
    updateLed(LedSpeed, walkSpeedEnabled)
    if walkSpeedEnabled then
        connections.walkSpeed = RunService.Heartbeat:Connect(function()
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = customWalkSpeed end
            end)
        end)
    else
        if connections.walkSpeed then connections.walkSpeed:Disconnect() connections.walkSpeed = nil end
    end
end)

InputSpeed.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputSpeed.Text) if v then customWalkSpeed = v end end end)

BtnFly.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    updateLed(LedFly, flyEnabled)
    if flyEnabled then
        connections.fly = RunService.RenderStepped:Connect(function(deltaTime)
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local dir = Vector3.zero
                if UserInput:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInput:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInput:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInput:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                if UserInput:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                if dir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (dir.Unit * flySpeed * deltaTime) end
            end)
        end)
    else
        if connections.fly then connections.fly:Disconnect() connections.fly = nil end
    end
end)

InputFly.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputFly.Text) if v then flySpeed = v end end end)

BtnTras.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    updateLed(LedTras, noclipEnabled)
    if noclipEnabled then
        connections.noclip = RunService.Stepped:Connect(function()
            pcall(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end)
    else
        if connections.noclip then connections.noclip:Disconnect() connections.noclip = nil end
    end
end)

BtnInfJ.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    updateLed(LedInfJ, infJumpEnabled)
    if infJumpEnabled then
        connections.infJump = UserInput.JumpRequest:Connect(function()
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end)
    else
        if connections.infJump then connections.infJump:Disconnect() connections.infJump = nil end
    end
end)

BtnSaveTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        updateLed(LedSTp, true) task.wait(0.4) updateLed(LedSTp, false)
    end
end)

BtnTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and savedPosition then
        char.HumanoidRootPart.CFrame = savedPosition
        updateLed(LedTp, true) task.wait(0.4) updateLed(LedTp, false)
    end
end)

-- Resto de conectores de inputs nativos mapeados
BtnParry.MouseButton1Click:Connect(function()
    autoParryEnabled = not autoParryEnabled
    updateLed(LedParry, autoParryEnabled)
end)
BtnHitbox.MouseButton1Click:Connect(function()
    hitboxExpanded = not hitboxExpanded
    updateLed(LedHitbox, hitboxExpanded)
end)
BtnChams.MouseButton1Click:Connect(function()
    chamsEnabled = not chamsEnabled
    updateLed(LedChams, chamsEnabled)
end)
BtnEsp.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateLed(LedEsp, espEnabled)
end)
BtnCam.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    updateLed(LedCam, noclipEnabled)
end)
BtnBoost.MouseButton1Click:Connect(function()
    fpsBoostEnabled = not fpsBoostEnabled
    updateLed(LedBoost, fpsBoostEnabled)
end)
BtnRespawn.MouseButton1Click:Connect(function()
    instantRespawnEnabled = not instantRespawnEnabled
    updateLed(LedResp, instantRespawnEnabled)
end)
BtnGod.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.MaxHealth = math.huge hum.Health = math.huge updateLed(LedGod, true) task.wait(0.4) updateLed(LedGod, false) end
end)

InputTpTo.FocusLost:Connect(function(ep)
    if ep and InputTpTo.Text ~= "" then
        local name = InputTpTo.Text:lower()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Name:lower():sub(1,#name) == name and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

InputGrav.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputGrav.Text) workspace.Gravity = v or originalGravity end end)
InputFov.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputFov.Text) if v then Camera.FieldOfView = v end end end)

-- CONTROLES FINALES DE LA INTERFAZ (TWEEN ANIMATIONS)
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimised = not isMinimised
    local targetSize = isMinimised and miniSize or fullSize
    ScrollFrame.Visible = not isMinimised
    BtnMinimize.Text = isMinimised and "+" or "—"
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

BtnClose.MouseButton1Click:Connect(function()
    autoCollectEnabled = false
    autoFamaEnabled = false
    killAuraEnabled = false
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 290, 0, 0)}):Play()
    task.wait(0.25)
    ScreenGui:Destroy()
end)

UserInput.InputBegan:Connect(function(input, gP)
    if not gP and input.KeyCode == Enum.KeyCode.P then MainFrame.Visible = not MainFrame.Visible end
end) (2026 OFFICIAL PATCH)
-- DETECCIÓN DINÁMICA DE CARACTERES Y ASINCRONÍA PROTEGIDA
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de optimización y estados estables
local savedPosition = nil
local noclipEnabled = false
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local walkSpeedEnabled = false
local customWalkSpeed = 16
local isMinimised = false
local espEnabled = false
local chamsEnabled = false 
local aimlockEnabled = false
local fastAimEnabled = false
local autoFamaEnabled = false
local killAuraEnabled = false 
local autoParryEnabled = false 
local instantRespawnEnabled = false 
local fpsBoostEnabled = false 
local hitboxExpanded = false 
local autoCollectEnabled = false
local multiplierEnabled = false 
local hitMultiplierValue = 5   

local MAX_REAL_DISTANCE = 300 
local AURA_RANGE = 25 
local PREDICTION_INTENSITY = 0.14
local originalGravity = workspace.Gravity
local connections = {}

-- 1. CONTROLADOR DE INTERFAZ CYBERPUNK MULTI-TAB
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV6_Multiplier_Fixed"
ScreenGui.ResetOnSpawn = false

local function injectGui()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then ScreenGui.Parent = coreGui else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 7) or game
    end
end
injectGui()

local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 310, 0, 480) 
local miniSize = UDim2.new(0, 310, 0, 45)

MainFrame.Name = "MainFrame"
MainFrame.Size = fullSize
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 19)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 10, 14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 27, 36))
}
UIGradient.Rotation = 60
UIGradient.Parent = MainFrame

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local NeonLine = Instance.new("Frame")
NeonLine.Size = UDim2.new(1, 0, 0, 3)
NeonLine.BackgroundColor3 = Color3.fromRGB(255, 0, 85) 
NeonLine.BorderSizePixel = 0
NeonLine.Parent = MainFrame

-- ENCABEZADO
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "   BERIS HUB V6 • <font color='#FF0055'>STABLE BURST</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 24, 0, 24)
BtnClose.Position = UDim2.new(1, -34, 0, 10)
BtnClose.Text = "✕"
BtnClose.TextColor3 = Color3.fromRGB(255, 80, 80)
BtnClose.TextSize = 11
BtnClose.Font = Enum.Font.GothamBold
BtnClose.BackgroundColor3 = Color3.fromRGB(32, 18, 22)
BtnClose.BorderSizePixel = 0
BtnClose.Parent = Header
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 6)

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 24, 0, 24)
BtnMinimize.Position = UDim2.new(1, -64, 0, 10)
BtnMinimize.Text = "—"
BtnMinimize.TextColor3 = Color3.fromRGB(255, 0, 85)
BtnMinimize.TextSize = 11
BtnMinimize.Font = Enum.Font.GothamBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(36, 18, 26)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.Parent = Header
Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 6)

-- CONTENEDOR DE PESTAÑAS (TABS)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

-- CONTENEDOR DE PÁGINAS (PAGES)
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, 0, 1, -85)
PagesContainer.Position = UDim2.new(0, 0, 0, 85)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local pages = {}

local function createTab(name, order)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 54, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(140, 145, 160)
    tabBtn.TextSize = 10
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.LayoutOrder = order
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 470)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 85)
    page.Visible = false
    page.Parent = PagesContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    pages[name] = page
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do 
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(140, 145, 160) b.BackgroundColor3 = Color3.fromRGB(20, 22, 30) end 
        end
        page.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 85)
    end)
    
    return page
end

-- Generando las 5 secciones requeridas
local PageCombat   = createTab("Combat", 1)
local PageFarm     = createTab("Farm", 2)
local PageVisuals  = createTab("Visuals", 3)
local PageMovement = createTab("Movement", 4)
local PageConfig   = createTab("Config", 5)

-- Inicializa abriendo Combat
pages["Combat"].Visible = true
TabBar:FindFirstChildOfClass("TextButton").TextColor3 = Color3.fromRGB(255, 255, 255)
TabBar:FindFirstChildOfClass("TextButton").BackgroundColor3 = Color3.fromRGB(255, 0, 85)

-- COMPONENT FACTORY DE INTERFAZ MODULAR
local function createModuleButton(parentPage, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    frame.BorderSizePixel = 0
    frame.Parent = parentPage
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 1, 0)
    button.Position = UDim2.new(0, 12, 0, 0)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(235, 235, 240)
    button.TextSize = 11
    button.Font = Enum.Font.GothamSemibold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.BackgroundTransparency = 1
    button.Parent = frame

    local led = Instance.new("Frame")
    led.Size = UDim2.new(0, 6, 0, 6)
    led.Position = UDim2.new(1, -16, 0, 14)
    led.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
    led.BorderSizePixel = 0
    led.Parent = frame
    Instance.new("UICorner", led).CornerRadius = UDim.new(1, 0)

    return button, led
end

local function createModuleTextBox(parentPage, placeholder)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 280, 0, 34)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(110, 115, 125)
    textBox.TextSize = 11
    textBox.Font = Enum.Font.Gotham
    textBox.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
    textBox.BorderSizePixel = 0
    textBox.Parent = parentPage
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
    return textBox
end

local function updateLed(led, state)
    TweenService:Create(led, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 65, 65)}):Play()
end

-- ====================================================================
-- DISTRIBUCIÓN DE CONTROLES POR SECCIÓN
-- ====================================================================

-- SECCIÓN 1: COMBAT
local BtnMultiplier, LedMultiplier = createModuleButton(PageCombat, "⚡ Multiplicador de Golpes (Ráfaga Remota)")
local BtnKillAura, LedAura     = createModuleButton(PageCombat, "💥 Kill Aura Automatizado (Radio 25w)")
local BtnParry, LedParry       = createModuleButton(PageCombat, "🛡️ Auto Parry / Shield (Sincronizado)")
local BtnFastAim, LedFast     = createModuleButton(PageCombat, "🎯 Aim Predictivo + Raycast (Auto)")
local BtnAim, LedAim         = createModuleButton(PageCombat, "👁️ Aimlock Manual / Fijación [Tecla E]")
local BtnHitbox, LedHitbox     = createModuleButton(PageCombat, "💀 Hitbox Expander (Cabezas 5x)")

-- SECCIÓN 2: FARM
local BtnCollect, LedCollect = createModuleButton(PageFarm, "📦 Auto Recolección (Items & Prompts)")
local BtnAutoFama, LedFama   = createModuleButton(PageFarm, "⭐ Intelli-Farm Continuo (Herramientas)")

-- SECCIÓN 3: VISUALS
local BtnChams, LedChams = createModuleButton(PageVisuals, "🌈 Renderizado Chams (Silueta Pared)")
local BtnEsp, LedEsp     = createModuleButton(PageVisuals, "📦 Visualizador Wallhack / ESP Box")
local BtnCam, LedCam     = createModuleButton(PageVisuals, "🎥 No Clip de Cámara (Freecam Pro)")
local BtnBoost, LedBoost = createModuleButton(PageVisuals, "⚡ Eliminar Texturas (FPS Boost Pro)")

-- SECCIÓN 4: MOVEMENT
local BtnFly, LedFly     = createModuleButton(PageMovement, "✈️ Vuelo Inteligente Integrado")
local BtnSpeed, LedSpeed = createModuleButton(PageMovement, "🏃 Estabilizador de Velocidad")
local BtnTras, LedTras   = createModuleButton(PageMovement, "🧱 Bypass de Colisión (Noclip)")
local BtnInfJ, LedInfJ   = createModuleButton(PageMovement, "🦘 Fijar Salto Continuo / Infinito")
local BtnRespawn, LedResp = createModuleButton(PageMovement, "🔄 Auto-Reaparecer (Instant Respawn)")
local BtnSaveTp, LedSTp  = createModuleButton(PageMovement, "💾 Capturar Coordenadas Actuales")
local BtnTp, LedTp       = createModuleButton(PageMovement, "🚀 Forzar Teletransporte Guardado")
local BtnGod, LedGod     = createModuleButton(PageMovement, "👑 Modo Dios Simulado (Visual)")

-- SECCIÓN 5: CONFIG
local InputMultiplier = createModuleTextBox(PageConfig, " ⚡ Multiplicador de Golpes (Número, Ej: 10)")
local InputTpTo       = createModuleTextBox(PageConfig, " 👤 Teletransporte a Jugador (Nombre Corto)")
local InputSpeed      = createModuleTextBox(PageConfig, " 🏃 Fijar Velocidad WalkSpeed (Defecto: 16)")
local InputFly        = createModuleTextBox(PageConfig, " ✈️ Fijar Velocidad de Vuelo (Defecto: 50)")
local InputGrav       = createModuleTextBox(PageConfig, " 🪐 Modificar Gravedad del Mundo (Defecto: 196.2)")
local InputFov        = createModuleTextBox(PageConfig, " 📐 Configurar FOV de Pantalla (Defecto: 70)")

-- Anti-AFK integrado nativamente
pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- ====================================================================
-- SISTEMA LÓGICO Y CÓDIGO OPERACIONAL CORREGIDO
-- ====================================================================

-- ALGORITMO INTEGRADO AJUSTADO AUTOMÁTICO PARA HERRAMIENTAS ACTIVAS
local function hookTool(tool)
    if not tool:IsA("Tool") then return end
    tool.Activated:Connect(function()
        if not multiplierEnabled then return end
        local remote = tool:FindFirstChildOfClass("RemoteEvent") or tool:FindFirstChildOfClass("RemoteFunction")
        if remote then
            -- Genera ráfagas estables sin saturar el procesamiento paralelo
            for i = 1, math.clamp(hitMultiplierValue - 1, 1, 30) do
                task.spawn(function()
                    remote:FireServer()
                end)
            end
        end
    end)
end

BtnMultiplier.MouseButton1Click:Connect(function()
    multiplierEnabled = not multiplierEnabled
    updateLed(LedMultiplier, multiplierEnabled)
    
    if multiplierEnabled then
        -- Escucha el arma actual y las futuras de manera segura tras reapariciones
        if LocalPlayer.Character then
            for _, item in pairs(LocalPlayer.Character:GetChildren()) do hookTool(item) end
            connections.hitMultiplier = LocalPlayer.Character.ChildAdded:Connect(hookTool)
        end
        
        connections.characterResetHook = LocalPlayer.CharacterAdded:Connect(function(char)
            if connections.hitMultiplier then connections.hitMultiplier:Disconnect() end
            connections.hitMultiplier = char.ChildAdded:Connect(hookTool)
        end)
    else
        if connections.hitMultiplier then connections.hitMultiplier:Disconnect() connections.hitMultiplier = nil end
        if connections.characterResetHook then connections.characterResetHook:Disconnect() connections.characterResetHook = nil end
    end
end)

local function isTargetVisible(targetCharacter)
    local head = targetCharacter:FindFirstChild("Head")
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if head and myHrp then
        local raycastParams = RaycastParams.new()
        raycastParams.FilterFolder = {myChar, targetCharacter}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local direction = (head.Position - myHrp.Position)
        local rayResult = workspace:Raycast(myHrp.Position, direction, raycastParams)
        if not rayResult then return true end
    end
    return false
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = MAX_REAL_DISTANCE
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local realDistance = (myHrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if realDistance < shortestDistance and isTargetVisible(player.Character) then
                    closestPlayer = player
                    shortestDistance = realDistance
                end
            end
        end
    end
    return closestPlayer
end

-- OPERACIONES DE COMBATE COMPLEMENTARIAS
BtnKillAura.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    updateLed(LedAura, killAuraEnabled)
    if killAuraEnabled then
        task.spawn(function()
            while killAuraEnabled do
                pcall(function()
                    local myChar = LocalPlayer.Character
                    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    local tool = myChar and myChar:FindFirstChildOfClass("Tool")
                    if myHrp and tool then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local targetHrp = player.Character.HumanoidRootPart
                                if (myHrp.Position - targetHrp.Position).Magnitude <= AURA_RANGE then tool:Activate() end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

BtnFastAim.MouseButton1Click:Connect(function()
    fastAimEnabled = not fastAimEnabled
    updateLed(LedFast, fastAimEnabled)
    if fastAimEnabled then
        connections.fastAim = RunService.RenderStepped:Connect(function()
            pcall(function()
                if UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInput:IsKeyDown(Enum.KeyCode.E) then
                    local target = getClosestPlayer()
                    if target and target.Character and target.Character.Head then
                        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                        local targetVelocity = targetHrp and targetHrp.Velocity or Vector3.zero
                        local predictedPosition = target.Character.Head.Position + (targetVelocity * PREDICTION_INTENSITY)
                        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPosition)
                    end
                end
            end)
        end)
    else
        if connections.fastAim then connections.fastAim:Disconnect() connections.fastAim = nil end
    end
end)

-- OPERACIONES DE GRANJA (FARM)
BtnCollect.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    updateLed(LedCollect, autoCollectEnabled)
    if autoCollectEnabled then
        task.spawn(function()
            while autoCollectEnabled do
                pcall(function()
                    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not myHrp then return end
                    for _, prompt in pairs(workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Parent:IsA("BasePart") then
                            if (myHrp.Position - prompt.Parent.Position).Magnitude <= 35 then
                                prompt:InputHoldBegin() task.wait(0.05) prompt:InputHoldEnd()
                            end
                        end
                    end
                    for _, object in pairs(workspace:GetDescendants()) do
                        if object:IsA("BasePart") or object:IsA("MeshPart") then
                            local name = object.Name:lower()
                            if name:find("coin") or name:find("gem") or name:find("chest") or name:find("fruit") or name:find("drop") then
                                if (myHrp.Position - object.Position).Magnitude <= MAX_REAL_DISTANCE then
                                    object.CFrame = myHrp.CFrame
                                    object.CanCollide = false
                                end
                            end
                        end
                    end
                end)
                task.wait(0.4)
            end
        end)
    end
end)

-- OPERACIONES DE MOVIMIENTO
BtnSpeed.MouseButton1Click:Connect(function()
    walkSpeedEnabled = not walkSpeedEnabled
    updateLed(LedSpeed, walkSpeedEnabled)
    if walkSpeedEnabled then
        connections.walkSpeed = RunService.Heartbeat:Connect(function()
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = customWalkSpeed end
            end)
        end)
    else
        if connections.walkSpeed then connections.walkSpeed:Disconnect() connections.walkSpeed = nil end
    end
end)

BtnFly.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    updateLed(LedFly, flyEnabled)
    if flyEnabled then
        connections.fly = RunService.RenderStepped:Connect(function(deltaTime)
            pcall(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local dir = Vector3.zero
                if UserInput:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInput:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInput:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInput:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                if UserInput:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                if dir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (dir.Unit * flySpeed * deltaTime) end
            end)
        end)
    else
        if connections.fly then connections.fly:Disconnect() connections.fly = nil end
    end
end)

BtnTras.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    updateLed(LedTras, noclipEnabled)
    if noclipEnabled then
        connections.noclip = RunService.Stepped:Connect(function()
            pcall(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end)
    else
        if connections.noclip then connections.noclip:Disconnect() connections.noclip = nil end
    end
end)

-- MAPEADOS DE TEXTBOXES (SECCIÓN CONFIG)
InputMultiplier.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputMultiplier.Text) if v then hitMultiplierValue = math.clamp(v, 1, 30) end end end)
InputSpeed.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputSpeed.Text) if v then customWalkSpeed = v end end end)
InputFly.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputFly.Text) if v then flySpeed = v end end end)
InputGrav.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputGrav.Text) workspace.Gravity = v or originalGravity end end)
InputFov.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputFov.Text) if v then Camera.FieldOfView = v end end end)
InputTpTo.FocusLost:Connect(function(ep)
    if ep and InputTpTo.Text ~= "" then
        local name = InputTpTo.Text:lower()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Name:lower():sub(1,#name) == name and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

-- ENLACES COMPLEMENTARIOS DE BOTONES SIMPLE TRACCION
BtnAutoFama.MouseButton1Click:Connect(function() autoFamaEnabled = not autoFamaEnabled updateLed(LedFama, autoFamaEnabled) if autoFamaEnabled then task.spawn(function() while autoFamaEnabled do pcall(function() local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") if tool then tool:Activate() end VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(0, 0)) end) task.wait(0.25) end end) end end)
BtnAim.MouseButton1Click:Connect(function() aimlockEnabled = not aimlockEnabled updateLed(LedAim, aimlockEnabled) if aimlockEnabled then connections.aimlock = RunService.RenderStepped:Connect(function() if UserInput:IsKeyDown(Enum.KeyCode.E) then local target = getClosestPlayer() if target and target.Character and target.Character.Head then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end end end) else if connections.aimlock then connections.aimlock:Disconnect() connections.aimlock = nil end end end)
BtnInfJ.MouseButton1Click:Connect(function() infJumpEnabled = not infJumpEnabled updateLed(LedInfJ, infJumpEnabled) if infJumpEnabled then connections.infJump = UserInput.JumpRequest:Connect(function() pcall(function() local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end) end) else if connections.infJump then connections.infJump:Disconnect() connections.infJump = nil end end end)
BtnSaveTp.MouseButton1Click:Connect(function() local char = LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then savedPosition = char.HumanoidRootPart.CFrame updateLed(LedSTp, true) task.wait(0.4) updateLed(LedSTp, false) end end)
BtnTp.MouseButton1Click:Connect(function() local char = LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") and savedPosition then char.HumanoidRootPart.CFrame = savedPosition updateLed(LedTp, true) task.wait(0.4) updateLed(LedTp, false) end end)
BtnGod.MouseButton1Click:Connect(function() local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum then hum.MaxHealth = math.huge hum.Health = math.huge updateLed(LedGod, true) task.wait(0.4) updateLed(LedGod, false) end end)

-- CONECTORES DE CONFIGURACIÓN DIRECTA STUBS
BtnParry.MouseButton1Click:Connect(function() autoParryEnabled = not autoParryEnabled updateLed(LedParry, autoParryEnabled) end)
BtnHitbox.MouseButton1Click:Connect(function() hitboxExpanded = not hitboxExpanded updateLed(LedHitbox, hitboxExpanded) end)
BtnChams.MouseButton1Click:Connect(function() chamsEnabled = not chamsEnabled updateLed(LedChams, chamsEnabled) end)
BtnEsp.MouseButton1Click:Connect(function() espEnabled = not espEnabled updateLed(LedEsp, espEnabled) end)
BtnCam.MouseButton1Click:Connect(function() noclipEnabled = not noclipEnabled updateLed(LedCam, noclipEnabled) end)
BtnBoost.MouseButton1Click:Connect(function() fpsBoostEnabled = not fpsBoostEnabled updateLed(LedBoost, fpsBoostEnabled) end)
BtnRespawn.MouseButton1Click:Connect(function() instantRespawnEnabled = not instantRespawnEnabled updateLed(LedResp, instantRespawnEnabled) end)

-- CIERRE Y MINIMIZACIÓN DE INTERFAZ GENERAL
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimised = not isMinimised
    local targetSize = isMinimised and miniSize or fullSize
    PagesContainer.Visible = not isMinimised
    TabBar.Visible = not isMinimised
    BtnMinimize.Text = isMinimised and "+" or "—"
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

BtnClose.MouseButton1Click:Connect(function()
    autoCollectEnabled = false
    autoFamaEnabled = false
    killAuraEnabled = false
    multiplierEnabled = false
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 310, 0, 0)}):Play()
    task.wait(0.2)
    ScreenGui:Destroy()
end)

UserInput.InputBegan:Connect(function(input, gP)
    if not gP and input.KeyCode == Enum.KeyCode.P then MainFrame.Visible = not MainFrame.Visible end
end)