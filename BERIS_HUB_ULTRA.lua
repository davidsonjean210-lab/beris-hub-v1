-- ====================================================================
-- BERIS HUB V6 - HYPER CYBERPUNK 21-OPTION EDITION (2026)
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de estado globales
local savedPosition = nil
local noclipEnabled = false
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local walkSpeedEnabled = false
local customWalkSpeed = 16
local isMinimised = false
local espEnabled = false
local aimlockEnabled = false
local fastAimEnabled = false -- (SE MANTIENE INTACTO)
local regenEnabled = false
local autoFamaEnabled = false

-- NUEVAS VARIABLES DE ESTADO (10 OPCIONES)
local autoClickEnabled = false
local hitboxExpanded = false
local fpsBoostEnabled = false
local fullBrightEnabled = false
local camNoclipEnabled = false
local antiRagdollEnabled = false
local superFpsEnabled = false
local shiftLockEnabled = false
local originalShadows = Lighting.GlobalShadows

local MAX_REAL_DISTANCE = 300 
local connections = {}

-- 1. INYECTOR DE INTERFAZ PREMIUM
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV6_HyperUI"
ScreenGui.ResetOnSpawn = false

local function injectGui()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then ScreenGui.Parent = coreGui else
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 7)
        ScreenGui.Parent = playerGui or game
    end
end
injectGui()

-- CONTENEDOR PRINCIPAL REAJUSTADO (Más alto para las 21 opciones con Scroll)
local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 275, 0, 540)
local miniSize = UDim2.new(0, 275, 0, 45)

MainFrame.Name = "MainFrame"
MainFrame.Size = fullSize
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 13, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 27, 36))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local NeonLine = Instance.new("Frame")
NeonLine.Size = UDim2.new(1, 0, 0, 3)
NeonLine.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
NeonLine.BorderSizePixel = 0
NeonLine.Parent = MainFrame

-- TÍTULO Y ENCABEZADO
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "   BERIS HUB V6 • <font color='#00F0FF'>HYPER</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 22, 0, 22)
BtnClose.Position = UDim2.new(1, -32, 0, 11)
BtnClose.Text = "✕"
BtnClose.TextColor3 = Color3.fromRGB(255, 90, 90)
BtnClose.TextSize = 12
BtnClose.Font = Enum.Font.GothamBold
BtnClose.BackgroundColor3 = Color3.fromRGB(35, 20, 25)
BtnClose.BorderSizePixel = 0
BtnClose.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = BtnClose

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 22, 0, 22)
BtnMinimize.Position = UDim2.new(1, -60, 0, 11)
BtnMinimize.Text = "—"
BtnMinimize.TextColor3 = Color3.fromRGB(0, 240, 255)
BtnMinimize.TextSize = 12
BtnMinimize.Font = Enum.Font.GothamBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(20, 35, 45)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = BtnMinimize

-- CONTENEDOR DE SCROLL EXTENDIDO (Canvas más largo para albergar todo)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 960) -- Expandido para que no se corte nada
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 240, 255)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- DISEÑADOR PREMIUM CON LEDS DE ESTADO
local function createPremiumButton(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 252, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(28, 31, 42)
    frame.BorderSizePixel = 0
    frame.Parent = ScrollFrame
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = frame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 1, 0)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(230, 235, 245)
    button.TextSize = 12
    button.Font = Enum.Font.GothamSemibold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.BackgroundTransparency = 1
    button.Parent = frame

    local led = Instance.new("Frame")
    led.Size = UDim2.new(0, 8, 0, 8)
    led.Position = UDim2.new(1, -18, 0, 14)
    led.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    led.BorderSizePixel = 0
    led.Parent = frame

    local ledCorner = Instance.new("UICorner")
    ledCorner.CornerRadius = UDim.new(1, 0)
    ledCorner.Parent = led

    return button, led
end

local function updateLed(led, state)
    TweenService:Create(led, TweenInfo.new(0.3), {
        BackgroundColor3 = state and Color3.fromRGB(0, 255, 130) or Color3.fromRGB(255, 70, 70)
    }):Play()
end

local function createPremiumTextBox(placeholder)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 252, 0, 36)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(110, 115, 130)
    textBox.TextSize = 11
    textBox.Font = Enum.Font.Gotham
    textBox.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    textBox.BorderSizePixel = 0
    textBox.Parent = ScrollFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = textBox
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(35, 38, 50)
    stroke.Thickness = 1
    stroke.Parent = textBox
    
    return textBox
end

-- ====================================================================
-- CREACIÓN DE CONTROLES (SE MANTIENE CONFIGURACIÓN ANTERIOR)
-- ====================================================================
local BtnAutoFama, LedFama = createPremiumButton("⭐ Auto Fama / Farm Continuo")
local BtnFastAim, LedFast   = createPremiumButton("🎯 Auto Apuntado Cercano (Fijo)") -- MANTENIDO ORIGINAL
local BtnAim, LedAim       = createPremiumButton("🔒 Aimlock Tradicional [E]")
local BtnEsp, LedEsp       = createPremiumButton("👁️ Visualizador Wallhack / ESP Box")

-- NUEVOS 10 BOTONES AÑADIDOS
local BtnAutoClick, LedClick = createPremiumButton("🖱️ Auto Clicker Ultra Rápido")
local BtnHitbox, LedHit      = createPremiumButton("🦴 Hitbox Expander (Enemigo Grande)")
local BtnFps, LedFps         = createPremiumButton("📉 Desactivar Sombras (FPS Boost)")
local BtnBright, LedBright   = createPremiumButton("💡 Full Bright (Quitar Oscuridad)")
local BtnCamNoc, LedCamNoc   = createPremiumButton("🎥 No Clip de Cámara")
local BtnAntiRag, LedAntiRag = createPremiumButton("🧍 Anti-Ragdoll (Evitar Caídas)")
local BtnSupFps, LedSupFps   = createPremiumButton("⚡ Eliminar Texturas (Super Boost)")
local BtnShift, LedShift     = createPremiumButton("🔄 Forzar Shift Lock Virtual")
local BtnRandomTp, LedRandTp = createPremiumButton("🎲 Teleport a Jugador Aleatorio")
local BtnInstantRespawn, LedResp = createPremiumButton("🔄 Respawn Instantáneo Seguro")

-- BOTONES BASE RESTANTES
local BtnFly, LedFly       = createPremiumButton("✈️ Modo Vuelo Pro (Fly)")
local BtnSpeed, LedSpeed   = createPremiumButton("🏃 Modificador de Velocidad")
local BtnTras, LedTras     = createPremiumButton("🧱 Noclip (Atravesar Paredes)")
local BtnInfJ, LedInfJ     = createPremiumButton("🦘 Habilitar Salto Infinito")
local BtnSaveTp, LedSTp    = createPremiumButton("💾 Guardar Coordenadas TP")
local BtnTp, LedTp         = createPremiumButton("🌀 Ejecutar Teletransportación")
local BtnGod, LedGod       = createPremiumButton("🛡️ God Mode (Visual)")

local InputSpeed = createPremiumTextBox(" Fijar Velocidad de Caminado (Ej: 60)")
local InputFly   = createPremiumTextBox(" Fijar Velocidad de Vuelo (Ej: 75)")
local InputMoney = createPremiumTextBox(" Modificar Leaderstats Visualmente")

-- Anti-AFK integrado permanente
pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame) task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
end)

-- ====================================================================
-- MOTOR DE DETECCIÓN 3D EXACTO ORIGINAL (SIN CAMBIOS)
-- ====================================================================
local function getClosestPlayerToCharacter()
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
                if realDistance < shortestDistance then
                    local _, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                    if onScreen then
                        closestPlayer = player
                        shortestDistance = realDistance
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- ====================================================================
-- SISTEMAS Y DESARROLLO DE LAS 10 NUEVAS FUNCIONES
-- ====================================================================

-- 1. Auto Clicker Ultra Rápido
BtnAutoClick.MouseButton1Click:Connect(function()
    autoClickEnabled = not autoClickEnabled
    updateLed(LedClick, autoClickEnabled)
    if autoClickEnabled then
        task.spawn(function()
            while autoClickEnabled do
                VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame)
                task.wait(0.01)
                VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame)
                task.wait(0.01)
            end
        end)
    end
end)

-- 2. Hitbox Expander (Agrandar Enemigos)
BtnHitbox.MouseButton1Click:Connect(function()
    hitboxExpanded = not hitboxExpanded
    updateLed(LedHit, hitboxExpanded)
    connections.hitbox = RunService.Heartbeat:Connect(function()
        if hitboxExpanded then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                    p.Character.HumanoidRootPart.Transparency = 0.7
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        else
            if connections.hitbox then connections.hitbox:Disconnect() connections.hitbox = nil end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end)
end)

-- 3. Desactivar Sombras (FPS Boost)
BtnFps.MouseButton1Click:Connect(function()
    fpsBoostEnabled = not fpsBoostEnabled
    updateLed(LedFps, fpsBoostEnabled)
    Lighting.GlobalShadows = not fpsBoostEnabled
end)

-- 4. Full Bright (Quitar Oscuridad)
BtnBright.MouseButton1Click:Connect(function()
    fullBrightEnabled = not fullBrightEnabled
    updateLed(LedBright, fullBrightEnabled)
    if fullBrightEnabled then
        connections.bright = RunService.Heartbeat:Connect(function()
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        end)
    else
        if connections.bright then connections.bright:Disconnect() connections.bright = nil end
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    end
end)

-- 5. No Clip de Cámara
BtnCamNoc.MouseButton1Click:Connect(function()
    camNoclipEnabled = not camNoclipEnabled
    updateLed(LedCamNoc, camNoclipEnabled)
    LocalPlayer.DevComputerCameraMode = camNoclipEnabled and Enum.DevComputerCameraMode.Classic or Enum.DevComputerCameraMode.Classic
    if camNoclipEnabled then
        connections.camNoc = RunService.Heartbeat:Connect(function()
            pcall(function() Camera.CameraSubject = nil end)
        end)
    else
        if connections.camNoc then connections.camNoc:Disconnect() connections.camNoc = nil end
        pcall(function() Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end)
    end
end)

-- 6. Anti-Ragdoll (Evitar Caídas)
BtnAntiRag.MouseButton1Click:Connect(function()
    antiRagdollEnabled = not antiRagdollEnabled
    updateLed(LedAntiRag, antiRagdollEnabled)
    connections.antiRag = RunService.Heartbeat:Connect(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and antiRagdollEnabled then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end)
end)

-- 7. Eliminar Texturas (Super Boost FPS)
BtnSupFps.MouseButton1Click:Connect(function()
    superFpsEnabled = not superFpsEnabled
    updateLed(LedSupFps, superFpsEnabled)
    if superFpsEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") then obj:Destroy()
            elseif obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
        end
    end
end)

-- 8. Forzar Shift Lock Virtual
BtnShift.MouseButton1Click:Connect(function()
    shiftLockEnabled = not shiftLockEnabled
    updateLed(LedShift, shiftLockEnabled)
    LocalPlayer.DevEnableMouseLock = shiftLockEnabled
end)

-- 9. Teleport a Jugador Aleatorio
BtnRandomTp.MouseButton1Click:Connect(function()
    local allPlrs = Players:GetPlayers()
    local validPlrs = {}
    for _, p in pairs(allPlrs) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(validPlrs, p)
        end
    end
    if #validPlrs > 0 then
        local target = validPlrs[math.random(1, #validPlrs)]
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        updateLed(LedRandTp, true) task.wait(0.4) updateLed(LedRandTp, false)
    end
end)

-- 10. Respawn Instantáneo Seguro
BtnInstantRespawn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").Health = 0
        updateLed(LedResp, true) task.wait(0.4) updateLed(LedResp, false)
    end
end)

-- ====================================================================
-- ASIGNACIÓN DE FUNCIONES ORIGINALES (SIN MODIFICACIONES)
-- ====================================================================

BtnFastAim.MouseButton1Click:Connect(function()
    fastAimEnabled = not fastAimEnabled
    updateLed(LedFast, fastAimEnabled)
    if fastAimEnabled then
        connections.fastAim = RunService.RenderStepped:Connect(function()
            pcall(function()
                if UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInput:IsKeyDown(Enum.KeyCode.E) then
                    local target = getClosestPlayerToCharacter()
                    if target and target.Character and target.Character:FindFirstChild("Head") then
                        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Character.Head.Position)
                    end
                end
            end)
        end)
    else
        if connections.fastAim then connections.fastAim:Disconnect() connections.fastAim = nil end
    end
end)

BtnAutoFama.MouseButton1Click:Connect(function()
    autoFamaEnabled = not autoFamaEnabled
    updateLed(LedFama, autoFamaEnabled)
    if autoFamaEnabled then
        task.spawn(function()
            while autoFamaEnabled do
                pcall(function()
                    local char = LocalPlayer.Character
                    local tool = char and char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                    VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(0, 0))
                end)
                task.wait(0.3)
            end
        end)
    end
end)

BtnSpeed.MouseButton1Click:Connect(function()
    walkSpeedEnabled = not walkSpeedEnabled
    updateLed(LedSpeed, walkSpeedEnabled)
    if walkSpeedEnabled then
        connections.walkSpeed = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = customWalkSpeed end
            end)
        end)
    else
        if connections.walkSpeed then connections.walkSpeed:Disconnect() connections.walkSpeed = nil end
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
    end
end)

InputSpeed.FocusLost:Connect(function(ep)
    if ep then local v = tonumber(InputSpeed.Text) if v then customWalkSpeed = v end end
end)

local function cleanESP()
    for _, plr in pairs(Players:GetPlayers()) do
        pcall(function() if plr.Character and plr.Character:FindFirstChild("BerisBoxESP") then plr.Character.BerisBoxESP:Destroy() end end)
    end
end

BtnEsp.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateLed(LedEsp, espEnabled)
    if espEnabled then
        connections.esp = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                pcall(function()
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local char = plr.Character
                        local folder = char:FindFirstChild("BerisBoxESP") or Instance.new("Folder", char)
                        folder.Name = "BerisBoxESP"
                        local box = folder:FindFirstChild("Box") or Instance.new("BoxHandleAdornment", folder)
                        box.Name = "Box"
                        box.Color3 = Color3.fromRGB(0, 240, 255)
                        box.Transparency = 0.65
                        box.AlwaysOnTop = true
                        box.Adornee = char.HumanoidRootPart
                        box.Size = char:GetExtentsSize() + Vector3.new(0.2, 0.2, 0.2)
                    end
                end)
            end
        end)
    else
        if connections.esp then connections.esp:Disconnect() connections.esp = nil end
        cleanESP()
    end
end)

BtnAim.MouseButton1Click:Connect(function()
    aimlockEnabled = not aimlockEnabled
    updateLed(LedAim, aimlockEnabled)
    if aimlockEnabled then
        connections.aimlock = RunService.RenderStepped:Connect(function()
            if UserInput:IsKeyDown(Enum.KeyCode.E) then
                local target = getClosestPlayerToCharacter()
                if target and target.Character and target.Character.Head then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
                end
            end
        end)
    else
        if connections.aimlock then connections.aimlock:Disconnect() connections.aimlock = nil end
    end
end)

BtnFly.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    updateLed(LedFly, flyEnabled)
    if flyEnabled then
        connections.fly = RunService.RenderStepped:Connect(function(deltaTime)
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local moveDirection = Vector3.zero
                if UserInput:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Camera.CFrame.LookVector end
                if UserInput:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - Camera.CFrame.LookVector end
                if UserInput:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - Camera.CFrame.RightVector end
                if UserInput:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Camera.CFrame.RightVector end
                if UserInput:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
                if moveDirection.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (moveDirection.Unit * flySpeed * deltaTime) end
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

BtnInfJ.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    updateLed(LedInfJ, infJumpEnabled)
    if infJumpEnabled then
        connections.infJump = UserInput.JumpRequest:Connect(function()
            pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end)
    else
        if connections.infJump then connections.infJump:Disconnect() connections.infJump = nil end
    end
end)

BtnSaveTp.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        updateLed(LedSTp, true) task.wait(0.4) updateLed(LedSTp, false)
    end
end)

BtnTp.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and savedPosition then
        LocalPlayer.Character.HumanoidRootPart.CFrame = savedPosition
        updateLed(LedTp, true) task.wait(0.4) updateLed(LedTp, false)
    end
end)

BtnGod.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        LocalPlayer.Character.Humanoid.Health = math.huge
        updateLed(LedGod, true) task.wait(0.4) updateLed(LedGod, false)
    end
end)

InputFly.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputFly.Text) if v then flySpeed = v end end end)
InputMoney.FocusLost:Connect(function(ep)
    if ep then
        local ammount = tonumber(InputMoney.Text)
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        local mObj = stats and (stats:FindFirstChild("Money") or stats:FindFirstChild("Cash"))
        if mObj then mObj.Value = ammount end
    end
end)

-- CONTROLADORES DE ANIMACIONES DE INTERFAZ
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimised = not isMinimised
    local targetSize = isMinimised and miniSize or fullSize
    ScrollFrame.Visible = not isMinimised
    BtnMinimize.Text = isMinimised and "+" or "—"
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

BtnClose.MouseButton1Click:Connect(function()
    autoFamaEnabled = false
    autoClickEnabled = false
    Lighting.GlobalShadows = originalShadows
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    cleanESP()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 275, 0, 0)}):Play()
    task.wait(0.2)
    ScreenGui:Destroy()
end)

UserInput.InputBegan:Connect(function(input, gP)
    if not gP and input.KeyCode == Enum.KeyCode.P then MainFrame.Visible = not MainFrame.Visible end
end)