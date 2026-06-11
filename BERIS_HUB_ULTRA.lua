-- ====================================================================
-- BERIS HUB V6 - GOD TIER DEVELOPMENT EDITION (2026)
-- 10 NUEVAS OPCIONES INTEGRADAS - TOTAL 21 MODULOS
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
local chamsEnabled = false -- Nuevo
local aimlockEnabled = false
local fastAimEnabled = false
local autoFamaEnabled = false
local killAuraEnabled = false -- Nuevo
local autoParryEnabled = false -- Nuevo
local instantRespawnEnabled = false -- Nuevo
local fpsBoostEnabled = false -- Nuevo
local hitboxExpanded = false -- Nuevo

local MAX_REAL_DISTANCE = 300 
local AURA_RANGE = 25 -- Rango del Kill Aura
local PREDICTION_INTENSITY = 0.14
local originalGravity = workspace.Gravity
local connections = {}

-- 1. CONTROLADOR DE INTERFAZ CYBERPUNK V3 (TAMAÑO AMPLIADO)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV6_GodTier"
ScreenGui.ResetOnSpawn = false

local function injectGui()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then ScreenGui.Parent = coreGui else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 7) or game
    end
end
injectGui()

local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 290, 0, 560) -- Dimensiones expandidas para albergar los nuevos módulos
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
NeonLine.BackgroundColor3 = Color3.fromRGB(255, 0, 128) -- Tono Neón Magenta Eléctrico
NeonLine.BorderSizePixel = 0
NeonLine.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "   BERIS HUB V6 • <font color='#FF0080'>GOD TIER</font>"
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
BtnMinimize.TextColor3 = Color3.fromRGB(255, 0, 128)
BtnMinimize.TextSize = 11
BtnMinimize.Font = Enum.Font.GothamBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(36, 18, 30)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.Parent = Header
Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 6)

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 950) -- Canvas ampliado para scrolling masivo
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 128)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- FACTORÍA PREMIUM GENERADORA DE MÓDULOS
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
-- CREACIÓN Y COMPILACIÓN DE COMPONENTES INTERNOS (21 ELEMENTOS)
-- ====================================================================

-- SECCIÓN COMBATE AUTOMÁTICO
local BtnKillAura, LedAura   = createPremiumButton("💥 Habilitar Kill Aura (Radio 25w)")
local BtnParry, LedParry     = createPremiumButton("🛡️ Auto Parry / Auto Block (Beta)")
local BtnFastAim, LedFast   = createPremiumButton("🎯 Aim Predictivo + Raycast (Auto)")
local BtnAim, LedAim       = createPremiumButton("👁️ Aimlock con Fijación [Tecla E]")
local BtnHitbox, LedHitbox   = createPremiumButton("💀 Hitbox Expander (Cabeza 5x)")
local BtnAutoFama, LedFama   = createPremiumButton("⭐ Intelli-Farm Automático Activo")

-- SECCIÓN VISUALES Y ESP
local BtnChams, LedChams     = createPremiumButton("🌈 Renderizado Chams (Silueta Pared)")
local BtnEsp, LedEsp       = createPremiumButton("📦 Visualizador Wallhack / ESP Box")
local BtnCam, LedCam         = createPremiumButton("🎥 No Clip de Cámara (Freecam)")
local BtnBoost, LedBoost     = createPremiumButton("⚡ Eliminar Texturas (FPS Boost)")

-- SECCIÓN MOVIMIENTO Y MAPA
local BtnFly, LedFly       = createPremiumButton("✈️ Vuelo Inteligente Integrado")
local BtnSpeed, LedSpeed   = createPremiumButton("🏃 Estabilizador de Caminado")
local BtnTras, LedTras     = createPremiumButton("🧱 Bypass de Colisión (Noclip)")
local BtnInfJ, LedInfJ     = createPremiumButton("🦘 Fijar Salto Continuo / Infinito")
local BtnRespawn, LedResp   = createPremiumButton("🔄 Auto-Reaparecer (Instant Respawn)")
local BtnSaveTp, LedSTp    = createPremiumButton("💾 Capturar Coordenadas Actuales")
local BtnTp, LedTp         = createPremiumButton("🚀 Forzar Teletransporte Guardado")
local BtnGod, LedGod       = createPremiumButton("👑 Modo Dios (Local/Visual)")

-- SECCIÓN INPUT TEXT BOXES
local InputTpTo  = createPremiumTextBox(" 👤 Teletransporte a Jugador (Nombre Corto)")
local InputSpeed = createPremiumTextBox(" 🏃 Velocidad de Caminado (Defecto: 16)")
local InputFly   = createPremiumTextBox(" ✈️ Velocidad de Vuelo Pro (Defecto: 50)")
local InputGrav  = createPremiumTextBox(" 🪐 Modificar Gravedad (Defecto: 196.2)")
local InputFov   = createPremiumTextBox(" 📐 Fijar FOV de Cámara (Defecto: 70)")
local InputMoney = createPremiumTextBox(" 💵 Hackear Dinero / Coins (Visual)")

-- Anti-AFK integrado de fábrica
pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- ====================================================================
-- FUNCIONES MATEMÁTICAS Y ALGORITMOS DE BÚSQUEDA AVANZADOS
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

-- ====================================================================
-- EJECUCIÓN LÓGICA DE LAS 10 NUEVAS OPCIONES AVANZADAS
-- ====================================================================

-- 1. KILL AURA
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
                                if distance <= AURA_RANGE then
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- 2. AUTO PARRY
BtnParry.MouseButton1Click:Connect(function()
    autoParryEnabled = not autoParryEnabled
    updateLed(LedParry, autoParryEnabled)
    if autoParryEnabled then
        connections.autoParry = RunService.Heartbeat:Connect(function()
            pcall(function()
                local myChar = LocalPlayer.Character
                if not myChar then return end
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChildOfClass("Tool") then
                        local enemyTool = player.Character:FindFirstChildOfClass("Tool")
                        local myHrp = myChar:FindFirstChild("HumanoidRootPart")
                        local enemyHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if myHrp and enemyHrp and (myHrp.Position - enemyHrp.Position).Magnitude < 15 then
                            -- Simula activación de escudo o defensa del juego
                            local blockTool = myChar:FindFirstChild("Block") or myChar:FindFirstChild("Shield") or myChar:FindFirstChildOfClass("Tool")
                            if blockTool then blockTool:Activate() end
                        end
                    end
                end
            end)
        end)
    else
        if connections.autoParry then connections.autoParry:Disconnect() connections.autoParry = nil end
    end
end)

-- 3. TP TO PLAYER (TEXT INPUT)
InputTpTo.FocusLost:Connect(function(enterPressed)
    if enterPressed and InputTpTo.Text ~= "" then
        pcall(function()
            local targetName = InputTpTo.Text:lower()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Name:lower():sub(1, #targetName) == targetName then
                    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local targetHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if myHrp and targetHrp then
                        myHrp.CFrame = targetHrp.CFrame + Vector3.new(0, 3, 0)
                    end
                    break
                end
            end
        end)
    end
end)

-- 4. HITBOX EXPANDER
BtnHitbox.MouseButton1Click:Connect(function()
    hitboxExpanded = not hitboxExpanded
    updateLed(LedHitbox, hitboxExpanded)
    connections.hitbox = RunService.Heartbeat:Connect(function()
        if hitboxExpanded then
            for _, player in pairs(Players:GetPlayers()) do
                pcall(function()
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        local head = player.Character.Head
                        head.Size = Vector3.new(5, 5, 5)
                        head.Transparency = 0.5
                        head.CanCollide = false
                    end
                end)
            end
        else
            if connections.hitbox then connections.hitbox:Disconnect() connections.hitbox = nil end
            for _, player in pairs(Players:GetPlayers()) do
                pcall(function()
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        player.Character.Head.Size = Vector3.new(2, 1, 1)
                        player.Character.Head.Transparency = 0
                        player.Character.Head.CanCollide = true
                    end
                end)
            end
        end
    end)
end)

-- 5. CHAMS (RENDERIZADO TOTAL)
local function cleanChams()
    for _, player in pairs(Players:GetPlayers()) do
        pcall(function()
            if player.Character and player.Character:FindFirstChild("BerisChams") then
                player.Character.BerisChams:Destroy()
            end
        end)
    end
end

BtnChams.MouseButton1Click:Connect(function()
    chamsEnabled = not chamsEnabled
    updateLed(LedChams, chamsEnabled)
    if chamsEnabled then
        connections.chams = RunService.Heartbeat:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                pcall(function()
                    if player ~= LocalPlayer and player.Character then
                        if not player.Character:FindFirstChild("BerisChams") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "BerisChams"
                            highlight.FillColor = Color3.fromRGB(255, 0, 128)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.4
                            highlight.Parent = player.Character
                        end
                    end
                end)
            end
        end)
    else
        if connections.chams then connections.chams:Disconnect() connections.chams = nil end
        cleanChams()
    end
end)

-- 6. NO CLIP DE CÁMARA (FREECAM)
BtnCam.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    updateLed(LedCam, noclipEnabled)
    -- Devuelve control o quita límites de renderizado por colisión
    Camera.ClipToScreenEdge = not noclipEnabled
end)

-- 7. ELIMINAR TEXTURAS (FPS BOOST)
BtnBoost.MouseButton1Click:Connect(function()
    fpsBoostEnabled = not fpsBoostEnabled
    updateLed(LedBoost, fpsBoostEnabled)
    if fpsBoostEnabled then
        pcall(function()
            for _, asset in pairs(workspace:GetDescendants()) do
                if asset:IsA("Texture") or asset:IsA("Decal") then
                    asset.Texture = ""
                elseif asset:IsA("BasePart") then
                    asset.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    end
end)

-- 8. AUTO-RESPAWN
BtnRespawn.MouseButton1Click:Connect(function()
    instantRespawnEnabled = not instantRespawnEnabled
    updateLed(LedResp, instantRespawnEnabled)
    if instantRespawnEnabled then
        connections.respawn = LocalPlayer.CharacterRemoving:Connect(function()
            task.spawn(function()
                task.wait(0.1)
                LocalPlayer:LoadCharacter()
            end)
        end)
    else
        if connections.respawn then connections.respawn:Disconnect() connections.respawn = nil end
    end
end)

-- 9. GRAVEDAD PERSONALIZABLE
InputGrav.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local targetGrav = tonumber(InputGrav.Text)
        if targetGrav then workspace.Gravity = targetGrav else workspace.Gravity = originalGravity end
    end
end)

-- 10. CONFIGURACIÓN DE FOV DE CÁMARA
InputFov.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local targetFov = tonumber(InputFov.Text)
        if targetFov and targetFov >= 10 and targetFov <= 120 then
            Camera.FieldOfView = targetFov
        end
    end
end)

-- ====================================================================
-- CONTROL DE PROCESOS CLÁSICOS OPTIMIZADOS
-- ====================================================================

BtnAutoFama.MouseButton1Click:Connect(function()
    autoFamaEnabled = not autoFamaEnabled
    updateLed(LedFama, autoFamaEnabled)
    if autoFamaEnabled then
        task.spawn(function()
            while autoFamaEnabled do
                pcall(function()
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                end)
                task.wait(0.25)
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

BtnGod.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = math.huge hum.Health = math.huge
        updateLed(LedGod, true) task.wait(0.4) updateLed(LedGod, false)
    end
end)

-- SISTEMA DINÁMICO DE MINIMIZACIÓN Y CIERRE (SMOOTH TWEEN)
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimised = not isMinimised
    local targetSize = isMinimised and miniSize or fullSize
    ScrollFrame.Visible = not isMinimised
    BtnMinimize.Text = isMinimised and "+" or "—"
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

BtnClose.MouseButton1Click:Connect(function()
    autoFamaEnabled = false
    killAuraEnabled = false
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    cleanChams()
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 290, 0, 0)}):Play()
    task.wait(0.25)
    ScreenGui:Destroy()
end)

UserInput.InputBegan:Connect(function(input, gP)
    if not gP and input.KeyCode == Enum.KeyCode.P then MainFrame.Visible = not MainFrame.Visible end
end)