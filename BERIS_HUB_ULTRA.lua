-- ====================================================================
-- BERIS HUB V6 - ROBLOX SCRIPT (EDICIÓN DEFINITIVA CON ESP Y AIM)
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de estado
local savedPosition = nil
local noclipEnabled = false
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local isMinimised = false
local espEnabled = false
local aimlockEnabled = false

-- Conexiones de bucles
local flyConnection = nil
local infJumpConnection = nil
local espConnection = nil
local aimlockConnection = nil

-- 1. CREACIÓN DE LA INTERFAZ VISUAL (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV6"
ScreenGui.ResetOnSpawn = false

local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
if success and coreGui then ScreenGui.Parent = coreGui else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Marco Principal
local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 250, 0, 450)
local miniSize = UDim2.new(0, 250, 0, 40)

MainFrame.Name = "MainFrame"
MainFrame.Size = fullSize
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Título del Hub
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "     BERIS HUB V6"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Botón Cerrar/Destruir (X)
local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 25, 0, 25)
BtnClose.Position = UDim2.new(0, 10, 0, 7)
BtnClose.Text = "X"
BtnClose.TextColor3 = Color3.fromRGB(255, 100, 100)
BtnClose.TextSize = 14
BtnClose.Font = Enum.Font.SourceSansBold
BtnClose.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
BtnClose.BorderSizePixel = 0
BtnClose.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = BtnClose

-- Botón Minimizar (-)
local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 25, 0, 25)
BtnMinimize.Position = UDim2.new(1, -35, 0, 7)
BtnMinimize.Text = "-"
BtnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMinimize.TextSize = 16
BtnMinimize.Font = Enum.Font.SourceSansBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.ZIndex = 3
BtnMinimize.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = BtnMinimize

-- CONTENEDOR CON SCROLLBAR (Para meter infinitas opciones de forma cómoda)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -45)
ScrollFrame.Position = UDim2.new(0, 0, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 680) -- Altura del contenido deslizable
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

-- AUTOMATIZACIÓN DE DISEÑO EN LISTA
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- GENERADORES DE COMPONENTES
local function createButton(text, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 210, 0, 35)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.SourceSansSemibold
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Parent = ScrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    return button
end

local function createTextBox(placeholder, color)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 210, 0, 35)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    textBox.TextSize = 14
    textBox.Font = Enum.Font.SourceSans
    textBox.BackgroundColor3 = color or Color3.fromRGB(35, 35, 35)
    textBox.BorderSizePixel = 0
    textBox.Parent = ScrollFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = textBox
    return textBox
end

-- --- CREACIÓN DE LAS 11 OPCIONES EN ORDEN ---
local BtnSaveTp = createButton("Guardar TP", Color3.fromRGB(0, 110, 220))
local BtnTp     = createButton("Teletransportar", Color3.fromRGB(0, 160, 90))
local BtnTras   = createButton("Tras (Noclip): OFF", Color3.fromRGB(160, 40, 40))
local BtnInfJ   = createButton("Salto Infinito: OFF", Color3.fromRGB(80, 80, 80))
local BtnFly    = createButton("Vuelo (Fly): OFF", Color3.fromRGB(0, 130, 180))
local BtnEsp    = createButton("Wallhack / ESP: OFF", Color3.fromRGB(130, 30, 160))
local BtnAim    = createButton("Aimlock (Tecla E): OFF", Color3.fromRGB(200, 120, 0))
local BtnGod    = createButton("God Mode Visual", Color3.fromRGB(40, 140, 140))

local InputSpeed = createTextBox("Ingresar Velocidad")
local InputJump  = createTextBox("Ingresar Salto")
local InputFly   = createTextBox("Ingresar Vel. Vuelo")
local InputMoney = createTextBox("Ingresar Money ($)", Color3.fromRGB(60, 50, 15))

-- ====================================================================
-- SISTEMA 1: WALLHACK (ESP) COORDENADAS VISUALES
-- ====================================================================
local function applyESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not plr.Character:FindFirstChild("BerisESP") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "BerisESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
                highlight.Parent = plr.Character
            end
        end
    end
end

BtnEsp.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    BtnEsp.Text = espEnabled and "Wallhack / ESP: ON" or "Wallhack / ESP: OFF"
    BtnEsp.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(130, 30, 160)
    
    if espEnabled then
        espConnection = RunService.Heartbeat:Connect(applyESP)
    else
        if espConnection then espConnection:Disconnect() espConnection = nil end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("BerisESP") then
                plr.Character.BerisESP:Destroy()
            end
        end
    end
end)

-- ====================================================================
-- SISTEMA 2: AIMLOCK LIGERO (TECLA E)
-- ====================================================================
local function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                closest = plr
                shortestDistance = distance
            end
        end
    end
    return closest
end

BtnAim.MouseButton1Click:Connect(function()
    aimlockEnabled = not aimlockEnabled
    BtnAim.Text = aimlockEnabled and "Aimlock: ACTIVO [E]" or "Aimlock (Tecla E): OFF"
    BtnAim.BackgroundColor3 = aimlockEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 120, 0)
    
    if aimlockEnabled then
        aimlockConnection = RunService.RenderStepped:Connect(function()
            if UserInput:IsKeyDown(Enum.KeyCode.E) then
                local target = getClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("Head") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
                end
            end
        end)
    else
        if aimlockConnection then aimlockConnection:Disconnect() aimlockConnection = nil end
    end
end)

-- ====================================================================
-- SISTEMA 3: GOD MODE VISUAL
-- ====================================================================
BtnGod.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        BtnGod.Text = "¡God Mode Listo!"
        task.wait(1)
        BtnGod.Text = "God Mode Visual"
    end
end)

-- ====================================================================
-- LÓGICA DE MINIMIZAR, OCULTAR Y CERRAR
-- ====================================================================
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimised = not isMinimised
    if isMinimised then
        MainFrame.Size = miniSize
        ScrollFrame.Visible = false
        BtnMinimize.Text = "+"
    else
        MainFrame.Size = fullSize
        ScrollFrame.Visible = true
        BtnMinimize.Text = "-"
    end
end)

BtnClose.MouseButton1Click:Connect(function()
    -- Limpieza total antes de autodestruirse
    if flyConnection then flyConnection:Disconnect() end
    if infJumpConnection then infJumpConnection:Disconnect() end
    if espConnection then espConnection:Disconnect() end
    if aimlockConnection then aimlockConnection:Disconnect() end
    ScreenGui:Destroy()
end)

UserInput.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then MainFrame.Visible = not MainFrame.Visible end
end)

-- ====================================================================
-- SECCIÓN DE MOVIMIENTO Y MECÁNICAS PREVIAS (CORREGIDAS)
-- ====================================================================

-- Guardar TP
BtnSaveTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        BtnSaveTp.Text = "¡Guardado!"
        task.wait(0.6)
        BtnSaveTp.Text = "Guardar TP"
    end
end)

-- Teletransportar
BtnTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if savedPosition then char.HumanoidRootPart.CFrame = savedPosition else
            BtnTp.Text = "❌ Sin datos" task.wait(1) BtnTp.Text = "Teletransportar"
        end
    end
end)

-- Tras (Noclip)
BtnTras.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    BtnTras.Text = noclipEnabled and "Tras (Noclip): ON" or "Tras (Noclip): OFF"
    BtnTras.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(160, 40, 40)
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

-- Salto Infinito
BtnInfJ.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    BtnInfJ.Text = infJumpEnabled and "Salto Infinito: ON" or "Salto Infinito: OFF"
    BtnInfJ.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(80, 80, 80)
    if infJumpEnabled then
        if not infJumpConnection then
            infJumpConnection = UserInput.JumpRequest:Connect(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    else
        if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
    end
end)

-- Vuelo (Fly)
BtnFly.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    BtnFly.Text = flyEnabled and "Vuelo (Fly): ON" or "Vuelo (Fly): OFF"
    BtnFly.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(0, 130, 180)
    
    if flyEnabled then
        flyConnection = RunService.RenderStepped:Connect(function(deltaTime)
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            local currentHrp = LocalPlayer.Character.HumanoidRootPart
            local camera = workspace.CurrentCamera
            currentHrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            
            local moveDirection = Vector3.new(0,0,0)
            if UserInput:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
            if UserInput:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
            if UserInput:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
            
            if moveDirection.Magnitude > 0 then
                currentHrp.CFrame = currentHrp.CFrame + (moveDirection.Unit * flySpeed * deltaTime)
            end
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    end
end)

-- Inputs de Texto (FocusLost)
InputSpeed.FocusLost:Connect(function(ep)
    if ep then
        local v = tonumber(InputSpeed.Text)
        if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
        end
    end
end)

InputJump.FocusLost:Connect(function(ep)
    if ep then
        local v = tonumber(InputJump.Text)
        if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").UseJumpPower = true
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
        end
    end
end)

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