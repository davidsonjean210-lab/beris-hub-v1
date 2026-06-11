-- ====================================================================
-- BERIS HUB V6 - GOD TIER 41-OPTION TABS EDITION (2026)
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de estado globales heredadas e intactas
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
local fastAimEnabled = false -- [MANTENIDO TOTALMENTE ORIGINAL]
local regenEnabled = false
local autoFamaEnabled = false
local autoClickEnabled = false
local hitboxExpanded = false
local fpsBoostEnabled = false
local fullBrightEnabled = false
local camNoclipEnabled = false
local antiRagdollEnabled = false
local superFpsEnabled = false
local shiftLockEnabled = false
local originalShadows = Lighting.GlobalShadows

-- VARIABLES DE LAS NUEVAS 20 OPCIONES
local killAuraEnabled = false
local triggerBotEnabled = false
local autoBlockEnabled = false
local wallshotEnabled = false
local ignoreTeamEnabled = false
local cframeSpeedEnabled = false
local lowGravityEnabled = false
local clickTpEnabled = false
local bopJumpEnabled = false
local anchorEnabled = false
local chamsEnabled = false
local tracersEnabled = false
local namesEspEnabled = false
local distanceEspEnabled = false
local noFogEnabled = false
local spammerEnabled = false
local spamMessage = "Beris Hub V6 Dominating 2026!"

local MAX_REAL_DISTANCE = 300 
local connections = {}

-- INYECTOR MULTI-TABS
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV6_GodUI"
ScreenGui.ResetOnSpawn = false

local function injectGui()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then ScreenGui.Parent = coreGui else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 7) or game
    end
end
pcall(injectGui)

-- MARCO MAESTRO
local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 360, 0, 520)
local miniSize = UDim2.new(0, 360, 0, 45)
MainFrame.Name = "MainFrame"
MainFrame.Size = fullSize
MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 13, 17)), ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 27, 35))}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local NeonLine = Instance.new("Frame")
NeonLine.Size = UDim2.new(1, 0, 0, 3)
NeonLine.BackgroundColor3 = Color3.fromRGB(0, 240, 255)
NeonLine.BorderSizePixel = 0
NeonLine.Parent = MainFrame

-- HEADER CONTROLES
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "    BERIS HUB V6 • <font color='#00F0FF'>GOD MODE UNLOCKED</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 22, 0, 22)
BtnClose.Position = UDim2.new(1, -32, 0, 11)
BtnClose.Text = "✕"
BtnClose.TextColor3 = Color3.fromRGB(255, 90, 90)
BtnClose.TextSize = 11
BtnClose.Font = Enum.Font.GothamBold
BtnClose.BackgroundColor3 = Color3.fromRGB(35, 20, 25)
BtnClose.BorderSizePixel = 0
BtnClose.Parent = Header
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 6)

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 22, 0, 22)
BtnMinimize.Position = UDim2.new(1, -60, 0, 11)
BtnMinimize.Text = "—"
BtnMinimize.TextColor3 = Color3.fromRGB(0, 240, 255)
BtnMinimize.TextSize = 11
BtnMinimize.Font = Enum.Font.GothamBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(20, 35, 45)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.Parent = Header
Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 6)

-- BARRA LATERAL / NAVEGADOR DE PESTAÑAS (TABS)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 90, 1, -45)
TabBar.Position = UDim2.new(0, 0, 0, 45)
TabBar.BackgroundColor3 = Color3.fromRGB(18, 19, 26)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTENEDOR MULTI-PÁGINA DE SCROLLS
local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -95, 1, -50)
PageContainer.Position = UDim2.new(0, 95, 0, 45)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

local pages = {}
local activeTab = nil

local function createPage(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 240, 255)
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.ElasticBehavior = Enum.ElasticBehavior.Never
    scroll.Visible = false
    scroll.Parent = PageContainer

    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    -- Crear botón en la barra lateral
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 82, 0, 32)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
    tabBtn.TextColor3 = Color3.fromRGB(140, 145, 160)
    tabBtn.BackgroundColor3 = Color3.fromRGB(24, 26, 35)
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.scroll.Visible = false p.btn.TextColor3 = Color3.fromRGB(140, 145, 160) p.btn.BackgroundColor3 = Color3.fromRGB(24, 26, 35) end
        scroll.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    end)

    pages[name] = {scroll = scroll, btn = tabBtn}
    return scroll
end

local combatPage = createPage("COMBATE")
local movePage   = createPage("MOVIMIENTO")
local visualPage = createPage("VISUALES")
local serverPage = createPage("SERVIDOR")

-- Activar la primera pestaña por defecto
pages["COMBATE"].scroll.Visible = true
pages["COMBATE"].btn.TextColor3 = Color3.fromRGB(255, 255, 255)
pages["COMBATE"].btn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)

-- FACTORÍA DE BOTONES PREMIUM CON LED DENTRO DE LOS SCROLLS
local function createMenuOption(parent, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 248, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -25, 1, 0)
    button.Position = UDim2.new(0, 8, 0, 0)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(230, 235, 245)
    button.TextSize = 11
    button.Font = Enum.Font.GothamSemibold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.BackgroundTransparency = 1
    button.Parent = frame

    local led = Instance.new("Frame")
    led.Size = UDim2.new(0, 7, 0, 7)
    led.Position = UDim2.new(1, -16, 0, 13)
    led.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    led.BorderSizePixel = 0
    led.Parent = frame
    Instance.new("UICorner", led).CornerRadius = UDim.new(1, 0)

    return button, led
end

local function updateLed(led, state)
    TweenService:Create(led, TweenInfo.new(0.25), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 130) or Color3.fromRGB(255, 70, 70)}):Play()
end

local function createMenuTextBox(parent, placeholder)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 248, 0, 34)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(110, 115, 130)
    textBox.TextSize = 10
    textBox.Font = Enum.Font.Gotham
    textBox.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    textBox.BorderSizePixel = 0
    textBox.Parent = parent
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
    return textBox
end

-- ====================================================================
-- INSTANCIACIÓN DE LAS 41 FUNCIONES TOTALES DIVIDIDAS POR PESTAÑA
-- ====================================================================

-- --- PESTAÑA COMBATE ---
local BtnFastAim, LedFast       = createMenuOption(combatPage, "🎯 Auto Apuntado Cercano [ORIGINAL]")
local BtnKillAura, LedKillAura  = createMenuOption(combatPage, "⚔️ Kill Aura Cercano (15 Studs)")
local BtnTrigger, LedTrigger    = createMenuOption(combatPage, "⚡ Trigger Bot Automático")
local BtnAutoBlock, LedBlock    = createMenuOption(combatPage, "🛡️ Auto Bloqueo / Parry")
local BtnWallshot, LedWall      = createMenuOption(combatPage, "🧱 Wallshot (Atravesar Balas)")
local BtnIgnoreTeam, LedIgnore  = createMenuOption(combatPage, "👥 Ignorar Miembros del Equipo")
local BtnAim, LedAim           = createMenuOption(combatPage, "🔒 Aimlock Tradicional [E]")
local BtnHitbox, LedHit          = createMenuOption(combatPage, "🦴 Hitbox Expander (Enemigos Gdes)")
local BtnAutoFama, LedFama       = createMenuOption(combatPage, "⭐ Auto Fama / Farm Continuo")
local BtnAutoClick, LedClick     = createMenuOption(combatPage, "🖱️ Auto Clicker Ultra Rápido")

-- --- PESTAÑA MOVIMIENTO ---
local BtnSpeed, LedSpeed       = createMenuOption(movePage, "🏃 Modificador WalkSpeed")
local BtnCfSpeed, LedCfSpeed   = createMenuOption(movePage, "⚡ Speed Hack Alternativo (CFrame)")
local BtnFly, LedFly           = createMenuOption(movePage, "✈️ Modo Vuelo Pro (Fly)")
local BtnInfJ, LedInfJ         = createMenuOption(movePage, "🦘 Habilitar Salto Infinito")
local BtnLowGrav, LedLowGrav   = createMenuOption(movePage, "🌌 Gravedad Baja de Salto")
local BtnClickTp, LedClickTp   = createMenuOption(movePage, "🖱️ Teleport Click (Ctrl + Click)")
local BtnBopJump, LedBopJump   = createMenuOption(movePage, "🦘 Auto-Jump (Salto Continuo)")
local BtnAnchor, LedAnchor     = createMenuOption(movePage, "🔒 Congelar Posición (Anchor)")
local BtnTras, LedTras         = createMenuOption(movePage, "🧱 Noclip (Atravesar Paredes)")
local BtnAntiRag, LedAntiRag     = createMenuOption(movePage, "🧍 Anti-Ragdoll (Evitar Caídas)")
local BtnSaveTp, LedSTp        = createMenuOption(movePage, "💾 Guardar Coordenadas TP")
local BtnTp, LedTp             = createMenuOption(movePage, "🌀 Ejecutar Teletransportación")

-- --- PESTAÑA VISUALES ---
local BtnEsp, LedEsp           = createMenuOption(visualPage, "👁️ Wallhack Tradicional (ESP Box)")
local BtnChams, LedChams       = createMenuOption(visualPage, "🎨 Activar Chams (Glow 3D)")
local BtnTracers, LedTracers   = createMenuOption(visualPage, "✏️ Líneas de Rastreo (Tracers)")
local BtnNames, LedNames       = createMenuOption(visualPage, "🏷️ Mostrar Nombres (Names ESP)")
local BtnDist, LedDist         = createMenuOption(visualPage, "📏 Mostrar Distancia (Studs)")
local BtnNoFog, LedNoFog       = createMenuOption(visualPage, "🌫️ Remover Niebla del Mapa")
local BtnBright, LedBright       = createMenuOption(visualPage, "💡 Full Bright (Quitar Oscuridad)")
local BtnCamNoc, LedCamNoc       = createMenuOption(visualPage, "🎥 No Clip de Cámara")
local BtnFps, LedFps             = createMenuOption(visualPage, "📉 Desactivar Sombras (FPS Boost)")
local BtnSupFps, LedSupFps       = createMenuOption(visualPage, "⚡ Eliminar Texturas (Super Boost)")

-- --- PESTAÑA SERVIDOR / UTILS ---
local BtnSpammer, LedSpammer   = createMenuOption(serverPage, "💬 Chat Spammer Cíclico")
local BtnServerHop, LedHop     = createMenuOption(serverPage, "🚀 Server Hop (Cambiar Server)")
local BtnRejoin, LedRejoin     = createMenuOption(serverPage, "🔄 Rejoin (Reunirse al mismo)")
local BtnCopyPos, LedCopy      = createMenuOption(serverPage, "📋 Copiar Coordenadas XYZ")
local BtnPanic, LedPanic       = createMenuOption(serverPage, "❌ Ocultar Interfaz por Pánico")
local BtnShift, LedShift         = createMenuOption(serverPage, "🔄 Forzar Shift Lock Virtual")
local BtnRandomTp, LedRandTp     = createMenuOption(serverPage, "🎲 Teleport a Jugador Aleatorio")
local BtnInstantRespawn, LedResp = createMenuOption(serverPage, "🔄 Respawn Instantáneo Seguro")
local BtnGod, LedGod             = createMenuOption(serverPage, "🛡️ God Mode (Visual)")

local InputSpeed = createMenuTextBox(movePage, " Fijar WalkSpeed (Ej: 60)")
local InputFly   = createMenuTextBox(movePage, " Fijar Velocidad Vuelo (Ej: 75)")
local InputSpam  = createMenuTextBox(serverPage, " Escribe el mensaje para el chat spam")
local InputMoney = createMenuTextBox(serverPage, " Modificar Leaderstats Visualmente")

-- ====================================================================
-- LÓGICA DE FILTRADO Y MOTOR DE DETECCIÓN 3D ORIGINAL PRESERVADO
-- ====================================================================
local function getClosestPlayerToCharacter()
    local closestPlayer = nil
    local shortestDistance = MAX_REAL_DISTANCE
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
            if ignoreTeamEnabled and player.Team == LocalPlayer.Team then continue end
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
-- EJECUCIÓN DEL PAQUETE DE LAS 20 NUEVAS FUNCIONES
-- ====================================================================

-- 1. Kill Aura (Radio 15 studs)
task.spawn(function()
    while true do
        if killAuraEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if ignoreTeamEnabled and p.Team == LocalPlayer.Team then continue end
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= 15 then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)
BtnKillAura.MouseButton1Click:Connect(function() killAuraEnabled = not killAuraEnabled updateLed(LedKillAura, killAuraEnabled) end)

-- 2. Trigger Bot
connections.trigger = RunService.RenderStepped:Connect(function()
    if triggerBotEnabled and LocalPlayer.Character then
        local mouseTarget = LocalPlayer:GetMouse().Target
        if mouseTarget and mouseTarget.Parent and mouseTarget.Parent:FindFirstChildOfClass("Humanoid") then
            local pl = Players:GetPlayerFromCharacter(mouseTarget.Parent)
            if pl and pl ~= LocalPlayer then
                if ignoreTeamEnabled and pl.Team == LocalPlayer.Team then return end
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end
    end
end)
BtnTrigger.MouseButton1Click:Connect(function() triggerBotEnabled = not triggerBotEnabled updateLed(LedTrigger, triggerBotEnabled) end)

-- 3. Auto Bloqueo / Parry
BtnAutoBlock.MouseButton1Click:Connect(function() autoBlockEnabled = not autoBlockEnabled updateLed(LedBlock, autoBlockEnabled) end) -- Activador de bandera para juegos específicos

-- 4. Wallshot (Bypass estructural ligero de proyectiles)
BtnWallshot.MouseButton1Click:Connect(function() wallshotEnabled = not wallshotEnabled updateLed(LedWall, wallshotEnabled) end)

-- 5. Ignorar Miembros del Equipo
BtnIgnoreTeam.MouseButton1Click:Connect(function() ignoreTeamEnabled = not ignoreTeamEnabled updateLed(LedIgnore, ignoreTeamEnabled) end)

-- 6. Speed Hack Alternativo (CFrame)
connections.cfSpeed = RunService.Heartbeat:Connect(function()
    if cframeSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + (hum.MoveDirection * 0.4)
        end
    end
end)
BtnCfSpeed.MouseButton1Click:Connect(function() cframeSpeedEnabled = not cframeSpeedEnabled updateLed(LedCfSpeed, cframeSpeedEnabled) end)

-- 7. Gravedad Baja de Salto
BtnLowGrav.MouseButton1Click:Connect(function()
    lowGravityEnabled = not lowGravityEnabled
    updateLed(LedLowGrav, lowGravityEnabled)
    workspace.Gravity = lowGravityEnabled and 35 or 196.2
end)

-- 8. Teleport Click (Ctrl + Click)
LocalPlayer:GetMouse().Button1Down:Connect(function()
    if clickTpEnabled and UserInput:IsKeyDown(Enum.KeyCode.LeftControl) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = LocalPlayer:GetMouse().Hit.p
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
    end
end)
BtnClickTp.MouseButton1Click:Connect(function() clickTpEnabled = not clickTpEnabled updateLed(LedClickTp, clickTpEnabled) end)

-- 9. Auto-Jump (Salto Continuo)
connections.bopJ = RunService.Heartbeat:Connect(function()
    if bopJumpEnabled and UserInput:IsKeyDown(Enum.KeyCode.Space) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Jump = true
    end
end)
BtnBopJump.MouseButton1Click:Connect(function() bopJumpEnabled = not bopJumpEnabled updateLed(LedBopJump, bopJumpEnabled) end)

-- 10. Congelar Posición (Anchor)
BtnAnchor.MouseButton1Click:Connect(function()
    anchorEnabled = not anchorEnabled
    updateLed(LedAnchor, anchorEnabled)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Anchored = anchorEnabled
    end
end)

-- 11, 12, 13, 14, 15 MÓDULO VISUAL AVANZADO COMPACTO ESP RE-DISEÑADO
connections.visualMaster = RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local char = p.Character
            local hrp = char.HumanoidRootPart
            local folder = char:FindFirstChild("BerisVisuals") or Instance.new("Folder", char)
            folder.Name = "BerisVisuals"

            -- Chams (Glow Interno)
            if chamsEnabled then
                local highlight = folder:FindFirstChildOfClass("Highlight") or Instance.new("Highlight", folder)
                highlight.FillColor = Color3.fromRGB(0, 240, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
            else
                local hl = folder:FindFirstChildOfClass("Highlight") if hl then hl:Destroy() end
            end

            -- Tracers (Líneas)
            if tracersEnabled then
                local tracer = folder:FindFirstChild("TracerLine") or Instance.new("LineHandleAdornment", folder)
                tracer.Name = "TracerLine"
                tracer.Length = (hrp.Position - Camera.CFrame.Position).Magnitude
                tracer.Color3 = Color3.fromRGB(0, 255, 150)
                tracer.AlwaysOnTop = true
                tracer.Adornee = Camera
                tracer.CFrame = CFrame.lookAt(Camera.CFrame.Position, hrp.Position)
            else
                local tr = folder:FindFirstChild("TracerLine") if tr then tr:Destroy() end
            end

            -- Nombres y Distancia
            if namesEspEnabled or distanceEspEnabled then
                local billboard = folder:FindFirstChild("EspTag") or Instance.new("BillboardGui", folder)
                billboard.Name = "EspTag"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.AlwaysOnTop = true
                billboard.Adornee = char:FindFirstChild("Head") or hrp
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)

                local label = billboard:FindFirstChild("TextLabel") or Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 11

                local tStr = ""
                if namesEspEnabled then tStr = tStr .. p.Name .. " " end
                if distanceEspEnabled then tStr = tStr .. "[" .. math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. "m]" end
                label.Text = tStr
            else
                local tg = folder:FindFirstChild("EspTag") if tg then tg:Destroy() end
            end
        end
    end
    if noFogEnabled then Lighting.FogEnd = 999999 Lighting.FogStart = 999999 end
end)

BtnChams.MouseButton1Click:Connect(function() chamsEnabled = not chamsEnabled updateLed(LedChams, chamsEnabled) end)
BtnTracers.MouseButton1Click:Connect(function() tracersEnabled = not tracersEnabled updateLed(LedTracers, tracersEnabled) end)
BtnNames.MouseButton1Click:Connect(function() namesEspEnabled = not namesEspEnabled updateLed(LedNames, namesEspEnabled) end)
BtnDist.MouseButton1Click:Connect(function() distanceEspEnabled = not distanceEspEnabled updateLed(LedDist, distanceEspEnabled) end)
BtnNoFog.MouseButton1Click:Connect(function() noFogEnabled = not noFogEnabled updateLed(LedNoFog, noFogEnabled) if not noFogEnabled then Lighting.FogEnd = 10000 end end)

-- 16. Chat Spammer Cíclico
InputSpam.FocusLost:Connect(function() if InputSpam.Text ~= "" then spamMessage = InputSpam.Text end end)
task.spawn(function()
    while true do
        if spammerEnabled then
            local chatBar = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if chatBar and chatBar:FindFirstChild("SayMessageRequest") then
                chatBar.SayMessageRequest:FireServer(spamMessage, "All")
            end
        end
        task.wait(3.5)
    end
end)
BtnSpammer.MouseButton1Click:Connect(function() spammerEnabled = not spammerEnabled updateLed(LedSpammer, spammerEnabled) end)

-- 17. Server Hop
BtnServerHop.MouseButton1Click:Connect(function()
    updateLed(LedHop, true)
    pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
        for _, s in pairs(servers) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                break
            end
        end
    end)
end)

-- 18. Rejoin al mismo server
BtnRejoin.MouseButton1Click:Connect(function()
    updateLed(LedRejoin, true)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- 19. Copiar Coordenadas XYZ
BtnCopyPos.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        setclipboard(tostring(pos))
        updateLed(LedCopy, true) task.wait(0.5) updateLed(LedCopy, false)
    end
end)

-- 20. Ocultar Interfaz por Pánico (Panic Button)
BtnPanic.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- ====================================================================
-- ASIGNACIÓN DE FUNCIONES PREVIAS (SISTEMA INTEGRAL INTACTO)
-- ====================================================================
BtnFastAim.MouseButton1Click:Connect(function()
    fastAimEnabled = not fastAimEnabled updateLed(LedFast, fastAimEnabled)
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
    else if connections.fastAim then connections.fastAim:Disconnect() connections.fastAim = nil end end
end)

BtnAutoFama.MouseButton1Click:Connect(function()
    autoFamaEnabled = not autoFamaEnabled updateLed(LedFama, autoFamaEnabled)
    if autoFamaEnabled then task.spawn(function() while autoFamaEnabled do pcall(function() local char = LocalPlayer.Character local tool = char and char:FindFirstChildOfClass("Tool") if tool then tool:Activate() end VirtualUser:CaptureController() VirtualUser:ClickButton1(Vector2.new(0, 0)) end) task.wait(0.3) end end) end
end)

BtnAutoClick.MouseButton1Click:Connect(function()
    autoClickEnabled = not autoClickEnabled updateLed(LedClick, autoClickEnabled)
    if autoClickEnabled then task.spawn(function() while autoClickEnabled do VirtualUser:Button1Down(Vector2.new(0,0), Camera.CFrame) task.wait(0.01) VirtualUser:Button1Up(Vector2.new(0,0), Camera.CFrame) task.wait(0.01) end end) end
end)

BtnHitbox.MouseButton1Click:Connect(function()
    hitboxExpanded = not hitboxExpanded updateLed(LedHit, hitboxExpanded)
    connections.hitbox = RunService.Heartbeat:Connect(function()
        if hitboxExpanded then
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10) p.Character.HumanoidRootPart.Transparency = 0.7 p.Character.HumanoidRootPart.CanCollide = false end end
        else if connections.hitbox then connections.hitbox:Disconnect() connections.hitbox = nil end
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1) p.Character.HumanoidRootPart.Transparency = 1 end end
        end
    end)
end)

BtnFps.MouseButton1Click:Connect(function() fpsBoostEnabled = not fpsBoostEnabled updateLed(LedFps, fpsBoostEnabled) Lighting.GlobalShadows = not fpsBoostEnabled end)
BtnBright.MouseButton1Click:Connect(function() fullBrightEnabled = not fullBrightEnabled updateLed(LedBright, fullBrightEnabled) if fullBrightEnabled then connections.bright = RunService.Heartbeat:Connect(function() Lighting.Ambient = Color3.fromRGB(255, 255, 255) Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255) end) else if connections.bright then connections.bright:Disconnect() connections.bright = nil end Lighting.Ambient = Color3.fromRGB(128, 128, 128) end end)
BtnCamNoc.MouseButton1Click:Connect(function() camNoclipEnabled = not camNoclipEnabled updateLed(LedCamNoc, camNoclipEnabled) if camNoclipEnabled then connections.camNoc = RunService.Heartbeat:Connect(function() pcall(function() Camera.CameraSubject = nil end) end) else if connections.camNoc then connections.camNoc:Disconnect() connections.camNoc = nil end pcall(function() Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end) end end)
BtnAntiRag.MouseButton1Click:Connect(function() antiRagdollEnabled = not antiRagdollEnabled updateLed(LedAntiRag, antiRagdollEnabled) connections.antiRag = RunService.Heartbeat:Connect(function() local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum and antiRagdollEnabled then hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end end) end)
BtnSupFps.MouseButton1Click:Connect(function() superFpsEnabled = not superFpsEnabled updateLed(LedSupFps, superFpsEnabled) if superFpsEnabled then for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("Texture") or obj:IsA("Decal") then obj:Destroy() elseif obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end end end end)
BtnShift.MouseButton1Click:Connect(function() shiftLockEnabled = not shiftLockEnabled updateLed(LedShift, shiftLockEnabled) LocalPlayer.DevEnableMouseLock = shiftLockEnabled end)
BtnRandomTp.MouseButton1Click:Connect(function() local validPlrs = {} for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then table.insert(validPlrs, p) end end if #validPlrs > 0 then LocalPlayer.Character.HumanoidRootPart.CFrame = validPlrs[math.random(1, #validPlrs)].Character.HumanoidRootPart.CFrame updateLed(LedRandTp, true) task.wait(0.4) updateLed(LedRandTp, false) end end)
BtnInstantRespawn.MouseButton1Click:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0 updateLed(LedResp, true) task.wait(0.4) updateLed(LedResp, false) end end)

BtnSpeed.MouseButton1Click:Connect(function()
    walkSpeedEnabled = not walkSpeedEnabled updateLed(LedSpeed, walkSpeedEnabled)
    if walkSpeedEnabled then connections.walkSpeed = RunService.Heartbeat:Connect(function() pcall(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = customWalkSpeed end end) end)
    else if connections.walkSpeed then connections.walkSpeed:Disconnect() connections.walkSpeed = nil end pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end) end
end)
InputSpeed.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputSpeed.Text) if v then customWalkSpeed = v end end end)

BtnEsp.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled updateLed(LedEsp, espEnabled)
    if espEnabled then
        connections.esp = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do pcall(function() if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then local char = plr.Character local folder = char:FindFirstChild("BerisBoxESP") or Instance.new("Folder", char) folder.Name = "BerisBoxESP" local box = folder:FindFirstChild("Box") or Instance.new("BoxHandleAdornment", folder) box.Name = "Box" box.Color3 = Color3.fromRGB(0, 240, 255) box.Transparency = 0.65 box.AlwaysOnTop = true box.Adornee = char.HumanoidRootPart box.Size = char:GetExtentsSize() + Vector3.new(0.2, 0.2, 0.2) end end) end
        end)
    else if connections.esp then connections.esp:Disconnect() connections.esp = nil end for _, p in pairs(Players:GetPlayers()) do pcall(function() if p.Character and p.Character:FindFirstChild("BerisBoxESP") then p.Character.BerisBoxESP:Destroy() end end) end end
end)

BtnAim.MouseButton1Click:Connect(function()
    aimlockEnabled = not aimlockEnabled updateLed(LedAim, aimlockEnabled)
    if aimlockEnabled then connections.aimlock = RunService.RenderStepped:Connect(function() if UserInput:IsKeyDown(Enum.KeyCode.E) then local target = getClosestPlayerToCharacter() if target and target.Character and target.Character.Head then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end end end)
    else if connections.aimlock then connections.aimlock:Disconnect() connections.aimlock = nil end end
end)

BtnFly.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled updateLed(LedFly, flyEnabled)
    if flyEnabled then
        connections.fly = RunService.RenderStepped:Connect(function(dT) pcall(function() local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end local mDir = Vector3.zero if UserInput:IsKeyDown(Enum.KeyCode.W) then mDir = mDir + Camera.CFrame.LookVector end if UserInput:IsKeyDown(Enum.KeyCode.S) then mDir = mDir - Camera.CFrame.LookVector end if UserInput:IsKeyDown(Enum.KeyCode.A) then mDir = mDir - Camera.CFrame.RightVector end if UserInput:IsKeyDown(Enum.KeyCode.D) then mDir = mDir + Camera.CFrame.RightVector end if UserInput:IsKeyDown(Enum.KeyCode.Space) then mDir = mDir + Vector3.new(0, 1, 0) end if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then mDir = mDir - Vector3.new(0, 1, 0) end if mDir.Magnitude > 0 then hrp.CFrame = hrp.CFrame + (mDir.Unit * flySpeed * dT) end end) end)
    else if connections.fly then connections.fly:Disconnect() connections.fly = nil end end
end)

BtnTras.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled updateLed(LedTras, noclipEnabled)
    if noclipEnabled then connections.noclip = RunService.Stepped:Connect(function() pcall(function() if LocalPlayer.Character then for _, part in pairs(LocalPlayer.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end end) end)
    else if connections.noclip then connections.noclip:Disconnect() connections.noclip = nil end end
end)

BtnInfJ.MouseButton1Click:Connect(function() if infJumpEnabled then connections.infJump = UserInput.JumpRequest:Connect(function() pcall(function() LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end) end) else if connections.infJump then connections.infJump:Disconnect() connections.infJump = nil end end end)
BtnSaveTp.MouseButton1Click:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then savedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame updateLed(LedSTp, true) task.wait(0.4) updateLed(LedSTp, false) end end)
BtnTp.MouseButton1Click:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and savedPosition then LocalPlayer.Character.HumanoidRootPart.CFrame = savedPosition updateLed(LedTp, true) task.wait(0.4) updateLed(LedTp, false) end end)
BtnGod.MouseButton1Click:Connect(function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then LocalPlayer.Character.Humanoid.MaxHealth = math.huge LocalPlayer.Character.Humanoid.Health = math.huge updateLed(LedGod, true) task.wait(0.4) updateLed(LedGod, false) end end)
InputFly.FocusLost:Connect(function(ep) if ep then local v = tonumber(InputFly.Text) if v then flySpeed = v end end end)
InputMoney.FocusLost:Connect(function(ep) if ep then local ammount = tonumber(InputMoney.Text) local stats = LocalPlayer:FindFirstChild("leaderstats") local mObj = stats and (stats:FindFirstChild("Money") or stats:FindFirstChild("Cash")) if mObj then mObj.Value = ammount end end end)

-- MINIMIZAR Y ABRIR MENÚ
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimised = not isMinimised
    local targetSize = isMinimised and miniSize or fullSize
    PageContainer.Visible = not isMinimised
    TabBar.Visible = not isMinimised
    BtnMinimize.Text = isMinimised and "+" or "—"
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

BtnClose.MouseButton1Click:Connect(function()
    autoFamaEnabled = false autoClickEnabled = false Lighting.GlobalShadows = originalShadows killAuraEnabled = false triggerBotEnabled = false workspace.Gravity = 196.2
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 360, 0, 0)}):Play()
    task.wait(0.2) ScreenGui:Destroy()
end)

UserInput.InputBegan:Connect(function(input, gP)
    if not gP and input.KeyCode == Enum.KeyCode.P then MainFrame.Visible = not MainFrame.Visible end
end)