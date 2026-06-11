-- ====================================================================
-- BERIS HUB V6 - ELITE OPTIMIZED EDITION (2026)
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de estado globales y optimizadas
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
local fastAimEnabled = false
local regenEnabled = false

-- Almacén central de conexiones limpias
local connections = {}

-- 1. CONTROL DE INYECCIÓN DE INTERFAZ ELITE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV6_Elite"
ScreenGui.ResetOnSpawn = false

local function injectGui()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then
        ScreenGui.Parent = coreGui
    else
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 7)
        if playerGui then ScreenGui.Parent = playerGui else ScreenGui.Parent = game end
    end
end
injectGui()

-- Estructuras de Diseño Avanzado
local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 260, 0, 495)
local miniSize = UDim2.new(0, 260, 0, 42)

MainFrame.Name = "MainFrame"
MainFrame.Size = fullSize
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 11, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local NeonBar = Instance.new("Frame")
NeonBar.Size = UDim2.new(1, 0, 0, 3)
NeonBar.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
NeonBar.BorderSizePixel = 0
NeonBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.Text = "      BERIS HUB V6 • ELITE PRO"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 24, 0, 24)
BtnClose.Position = UDim2.new(0, 12, 0, 9)
BtnClose.Text = "×"
BtnClose.TextColor3 = Color3.fromRGB(255, 80, 80)
BtnClose.TextSize = 20
BtnClose.Font = Enum.Font.GothamBold
BtnClose.BackgroundColor3 = Color3.fromRGB(30, 16, 18)
BtnClose.BorderSizePixel = 0
BtnClose.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = BtnClose

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 24, 0, 24)
BtnMinimize.Position = UDim2.new(1, -36, 0, 9)
BtnMinimize.Text = "−"
BtnMinimize.TextColor3 = Color3.fromRGB(220, 220, 220)
BtnMinimize.TextSize = 18
BtnMinimize.Font = Enum.Font.GothamBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(24, 26, 33)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.ZIndex = 3
BtnMinimize.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = BtnMinimize

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -48)
ScrollFrame.Position = UDim2.new(0, 0, 0, 48)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 560)
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createButton(text, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 230, 0, 34)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(245, 245, 245)
    button.TextSize = 12
    button.Font = Enum.Font.GothamSemibold
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Parent = ScrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = button
    return button
end

local function createTextBox(placeholder, color)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 230, 0, 34)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(120, 125, 135)
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.BackgroundColor3 = color or Color3.fromRGB(18, 20, 25)
    textBox.BorderSizePixel = 0
    textBox.Parent = ScrollFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 5)
    boxCorner.Parent = textBox
    return textBox
end

-- Generación de la Interfaz Avanzada
local BtnSaveTp  = createButton("Guardar Ubicación TP", Color3.fromRGB(22, 35, 59))
local BtnTp      = createButton("Teletransportar", Color3.fromRGB(18, 53, 36))
local BtnTras    = createButton("Noclip (Atravesar): OFF", Color3.fromRGB(50, 22, 22))
local BtnInfJ    = createButton("Salto Infinito: OFF", Color3.fromRGB(35, 38, 45))
local BtnFly     = createButton("Vuelo (Fly): OFF", Color3.fromRGB(15, 48, 63))
local BtnSpeed   = createButton("Velocidad de Caminar: OFF", Color3.fromRGB(30, 60, 60))
local BtnEsp     = createButton("Wallhack / ESP Box: OFF", Color3.fromRGB(48, 20, 56))
local BtnAim     = createButton("Aimlock (Mantener E): OFF", Color3.fromRGB(61, 41, 15))
local BtnFastAim = createButton("Auto Apuntado Inteligente: OFF", Color3.fromRGB(90, 35, 15))
local BtnGod     = createButton("God Mode (Visual)", Color3.fromRGB(20, 50, 50))
local BtnRegen   = createButton("Auto Regenerar Vida: OFF", Color3.fromRGB(40, 60, 20))

local InputSpeed = createTextBox("Fijar Velocidad Inteligente (Ej: 60)")
local InputFly   = createTextBox("Fijar Velocidad de Vuelo (Ej: 70)")
local InputMoney = createTextBox("Modificar Money / Cash Visual", Color3.fromRGB(33, 30, 16))

-- ====================================================================
-- BUSCADOR MATEMÁTICO INTEGRADO Y FILTRADO DE OBJETIVOS
-- ====================================================================
local function getClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInput:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- ====================================================================
-- MEJORA: MOTOR DE VELOCIDAD MEJORADO (ANTI-KICK/ANTI-TIRONES)
-- ====================================================================
BtnSpeed.MouseButton1Click:Connect(function()
    walkSpeedEnabled = not walkSpeedEnabled
    BtnSpeed.Text = walkSpeedEnabled and "Velocidad de Caminar: ON" or "Velocidad de Caminar: OFF"
    BtnSpeed.BackgroundColor3 = walkSpeedEnabled and Color3.fromRGB(0, 160, 160) or Color3.fromRGB(30, 60, 60)
    
    if walkSpeedEnabled then
        connections.walkSpeed = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = customWalkSpeed
                end
            end)
        end)
    else
        if connections.walkSpeed then connections.walkSpeed:Disconnect() connections.walkSpeed = nil end
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end)
    end
end)

InputSpeed.FocusLost:Connect(function(ep)
    if ep then 
        local v = tonumber(InputSpeed.Text) 
        if v then 
            customWalkSpeed = v 
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and walkSpeedEnabled then hum.WalkSpeed = customWalkSpeed end
        end 
    end
end)

-- ====================================================================
-- MEJORA: AUTO APUNTADO INTELIGENTE PRO (SILENT LOCK)
-- ====================================================================
BtnFastAim.MouseButton1Click:Connect(function()
    fastAimEnabled = not fastAimEnabled
    BtnFastAim.Text = fastAimEnabled and "Auto Apuntado Pro: ON" or "Auto Apuntado Inteligente: OFF"
    BtnFastAim.BackgroundColor3 = fastAimEnabled and Color3.fromRGB(245, 124, 0) or Color3.fromRGB(90, 35, 15)
    
    if fastAimEnabled then
        connections.fastAim = RunService.RenderStepped:Connect(function()
            pcall(function()
                if UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInput:IsKeyDown(Enum.KeyCode.E) then
                    local target = getClosestPlayerToCursor()
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

-- ====================================================================
-- SISTEMAS COMPLEMENTARIOS MEJORADOS
-- ====================================================================

-- Auto-Regen Eficiente
BtnRegen.MouseButton1Click:Connect(function()
    regenEnabled = not regenEnabled
    BtnRegen.Text = regenEnabled and "Auto Regenerar Vida: ON" or "Auto Regenerar Vida: OFF"
    BtnRegen.BackgroundColor3 = regenEnabled and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(40, 60, 20)
    
    if regenEnabled then
        connections.regen = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
        end)
    else
        if connections.regen then connections.regen:Disconnect() connections.regen = nil end
    end
end)

-- ESP Box Limpio
local function cleanESP()
    for _, plr in pairs(Players:GetPlayers()) do
        pcall(function()
            if plr.Character then
                local oldEsp = plr.Character:FindFirstChild("BerisBoxESP")
                if oldEsp then oldEsp:Destroy() end
            end
        end)
    end
end

local function applyInmuneESP()
    for _, plr in pairs(Players:GetPlayers()) do
        pcall(function()
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local char = plr.Character
                local hrp = char.HumanoidRootPart
                local folder = char:FindFirstChild("BerisBoxESP")
                
                if not folder then
                    folder = Instance.new("Folder")
                    folder.Name = "BerisBoxESP"
                    folder.Parent = char
                    
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "Box"
                    box.Color3 = Color3.fromRGB(0, 229, 255)
                    box.Transparency = 0.65
                    box.AlwaysOnTop = true
                    box.ZIndex = 6
                    box.Adornee = hrp
                    box.Parent = folder
                end
                folder.Box.Size = char:GetExtentsSize() + Vector3.new(0.2, 0.2, 0.2)
            end
        end)
    end
end

BtnEsp.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    BtnEsp.Text = espEnabled and "Wallhack / ESP Box: ON" or "Wallhack / ESP Box: OFF"
    BtnEsp.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 150, 136) or Color3.fromRGB(48, 20, 56)
    
    if espEnabled then
        connections.esp = RunService.Heartbeat:Connect(applyInmuneESP)
    else
        if connections.esp then connections.esp:Disconnect() connections.esp = nil end
        cleanESP()
    end
end)

-- Aimlock Clásico
BtnAim.MouseButton1Click:Connect(function()
    aimlockEnabled = not aimlockEnabled
    BtnAim.Text = aimlockEnabled and "Aimlock: ACTIVO [E]" or "Aimlock (Mantener E): OFF"
    BtnAim.BackgroundColor3 = aimlockEnabled and Color3.fromRGB(200, 110, 0) or Color3.fromRGB(61, 41, 15)
    
    if aimlockEnabled then
        connections.aimlock = RunService.RenderStepped:Connect(function()
            if UserInput:IsKeyDown(Enum.KeyCode.E) then
                local target = getClosestPlayerToCursor()
                if target and target.Character and target.Character.Head then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
                end
            end
        end)
    else
        if connections.aimlock then connections.aimlock:Disconnect() connections.aimlock = nil end
    end
end)

-- Vuelo Ultra Fluido
BtnFly.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    BtnFly.Text = flyEnabled and "Vuelo (Fly): ON" or "Vuelo (Fly): OFF"
    BtnFly.BackgroundColor3 = flyEnabled and Color3.fromRGB(0, 110, 180) or Color3.fromRGB(15, 48, 63)
    
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
                
                if moveDirection.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + (moveDirection.Unit * flySpeed * deltaTime)
                end
            end)
        end)
    else
        if connections.fly then connections.fly:Disconnect() connections.fly = nil end
    end
end)

-- Salto Infinito Seguro
BtnInfJ.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    BtnInfJ.Text = infJumpEnabled and "Salto Infinito: ON" or "Salto Infinito: OFF"
    BtnInfJ.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(46, 125, 50) or Color3.fromRGB(35, 38, 45)
    
    if infJumpEnabled then
        if not connections.infJump then
            connections.infJump = UserInput.JumpRequest:Connect(function()
                pcall(function()
                    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                end)
            end)
        end
    else
        if connections.infJump then connections.infJump:Disconnect() connections.infJump = nil end
    end
end)

-- Noclip Optimizador
BtnTras.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    BtnTras.Text = noclipEnabled and "Noclip (Atravesar): ON" or "Noclip (Atravesar): OFF"
    BtnTras.BackgroundColor3 = noclipEnabled and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(50, 22, 22)
    
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

-- Teletransporte y Datos Visuales
BtnSaveTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        BtnSaveTp.Text = "¡Ubicación Guardada!"
        task.wait(0.7)
        BtnSaveTp.Text = "Guardar Ubicación TP"
    end
end)

BtnTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if savedPosition then char.HumanoidRootPart.CFrame = savedPosition else
            BtnTp.Text = "❌ Sin Datos" task.wait(1) BtnTp.Text = "Teletransportar"
        end
    end
end)

BtnGod.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        BtnGod.Text = "¡Modo Dios Visual!"
        task.wait(1)
        BtnGod.Text = "God Mode (Visual)"
    end
end)

-- Inputs Avanzados de Configuración
InputFly.FocusLost:Connect(function(ep)
    if ep then local v = tonumber(InputFly.Text) if v then flySpeed = v end end
end)

InputMoney.FocusLost:Connect(function(ep)
    if ep then
        local ammount = tonumber(InputMoney.Text)
        if ammount then
            local stats = LocalPlayer:FindFirstChild("leaderstats")
            local moneyObj = stats and (stats:FindFirstChild("Money") or stats:FindFirstChild("Cash") or stats:FindFirstChild("Coins") or stats:FindFirstChild("Gold"))
            if moneyObj then moneyObj.Value = ammount end
        end
    end
end)

-- Controles de la Interfaz Base
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimised = not isMinimised
    MainFrame.Size = isMinimised and miniSize or fullSize
    ScrollFrame.Visible = not isMinimised
    BtnMinimize.Text = isMinimised and "+" or "−"
end)

BtnClose.MouseButton1Click:Connect(function()
    for _, conn in pairs(connections) do if conn then conn:Disconnect() end end
    cleanESP()
    ScreenGui:Destroy()
end)

UserInput.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then MainFrame.Visible = not MainFrame.Visible end
end)