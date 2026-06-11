-- ====================================================================
-- BERIS HUB V5 - ROBLOX SCRIPT (CON OPCIÓN DE MINIMIZAR)
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Variables de estado
local savedPosition = nil
local noclipEnabled = false
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local isMinimised = false -- Estado del menú

-- 1. CREACIÓN DE LA INTERFAZ VISUAL (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV5"
ScreenGui.ResetOnSpawn = false

local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
if success and coreGui then ScreenGui.Parent = coreGui else ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Marco Principal
local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 240, 0, 525)      -- Tamaño normal
local miniSize = UDim2.new(0, 240, 0, 40)       -- Tamaño minimizado (solo el título)

MainFrame.Name = "MainFrame"
MainFrame.Size = fullSize
MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true -- Crucial para ocultar el contenido al minimizar
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Título del Hub
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "  BERIS HUB V5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- NUEVO: Botón de Minimizar ("-" / "+")
local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Name = "BtnMinimize"
BtnMinimize.Size = UDim2.new(0, 30, 0, 30)
BtnMinimize.Position = UDim2.new(1, -35, 0, 5)
BtnMinimize.Text = "-"
BtnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMinimize.TextSize = 20
BtnMinimize.Font = Enum.Font.SourceSansBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.ZIndex = 3 -- Asegura que esté por encima del título
BtnMinimize.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = BtnMinimize

-- Contenedor de las opciones (Para ocultarlas/mostrarlas limpiamente)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- GENERADORES DE BOTONES Y TEXTBOXES (Ahora hijos de ContentFrame)
local function createButton(name, text, yPos, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 35)
    button.Position = UDim2.new(0, 20, 0, yPos - 40) -- Ajuste de posición por el contenedor
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 15
    button.Font = Enum.Font.SourceSansSemibold
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Parent = ContentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    return button
end

local function createTextBox(name, placeholder, yPos, color)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 200, 0, 35)
    textBox.Position = UDim2.new(0, 20, 0, yPos - 40)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.TextSize = 14
    textBox.Font = Enum.Font.SourceSans
    textBox.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    textBox.BorderSizePixel = 0
    textBox.Parent = ContentFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = textBox
    return textBox
end

-- Instanciar elementos dentro del contenedor
local BtnSaveTp = createButton("BtnSaveTp", "Guardar TP", 55, Color3.fromRGB(0, 120, 255))
local BtnTp     = createButton("BtnTp", "Teletransportar", 95, Color3.fromRGB(0, 180, 100))
local BtnTras   = createButton("BtnTras", "Tras (Noclip): OFF", 135, Color3.fromRGB(180, 50, 50))
local BtnInfJ   = createButton("BtnInfJ", "Salto Infinito: OFF", 175, Color3.fromRGB(100, 100, 100))
local BtnFly    = createButton("BtnFly", "Vuelo (Fly): OFF", 215, Color3.fromRGB(0, 150, 200))

local InputSpeed = createTextBox("InputSpeed", "Ingresar Velocidad", 265)
local InputJump  = createTextBox("InputJump", "Ingresar Salto", 310)
local InputFly   = createTextBox("InputFly", "Ingresar Vel. Vuelo", 355)
local InputMoney = createTextBox("InputMoney", "Ingresar Money ($)", 410, Color3.fromRGB(70, 60, 20))

local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -30)
Credits.Text = "Presiona 'P' para ocultar por completo"
Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
Credits.TextSize = 11
Credits.BackgroundTransparency = 1
Credits.Parent = ContentFrame

-- ====================================================================
-- LÓGICA DE MINIMIZAR / MAXIMIZAR
-- ====================================================================
BtnMinimize.MouseButton1Click:Connect(function()
    isMinimised = not isMinimised
    if isMinimised then
        MainFrame.Size = miniSize
        ContentFrame.Visible = false
        BtnMinimize.Text = "+"
        BtnMinimize.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Verde al estar minimizado
    else
        MainFrame.Size = fullSize
        ContentFrame.Visible = true
        BtnMinimize.Text = "-"
        BtnMinimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Gris normal
    end
end)

-- ====================================================================
-- LÓGICA GENERAL DE FUNCIONES
-- ====================================================================

UserInput.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then MainFrame.Visible = not MainFrame.Visible end
end)

BtnSaveTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        BtnSaveTp.Text = "¡Guardado!"
        task.wait(0.7)
        BtnSaveTp.Text = "Guardar TP"
    end
end)

BtnTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if savedPosition then char.HumanoidRootPart.CFrame = savedPosition else
            BtnTp.Text = "❌ Sin ubicación"
            task.wait(1)
            BtnTp.Text = "Teletransportar"
        end
    end
end)

BtnTras.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    BtnTras.Text = noclipEnabled and "Tras (Noclip): ON" or "Tras (Noclip): OFF"
    BtnTras.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

BtnInfJ.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    BtnInfJ.Text = infJumpEnabled and "Salto Infinito: ON" or "Salto Infinito: OFF"
    BtnInfJ.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(100, 100, 100)
end)

UserInput.InputBegan:Connect(function(input, gameProcessed)
    if infJumpEnabled and not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

InputSpeed.FocusLost:Connect(function(ep)
    if ep then
        local v = tonumber(InputSpeed.Text)
        if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
            InputSpeed.Text = "Velocidad: " .. v
        else InputSpeed.Text = "" end
    end
end)

InputJump.FocusLost:Connect(function(ep)
    if ep then
        local v = tonumber(InputJump.Text)
        if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").UseJumpPower = true
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
            InputJump.Text = "Salto: " .. v
        else InputJump.Text = "" end
    end
end)

InputFly.FocusLost:Connect(function(ep)
    if ep then
        local v = tonumber(InputFly.Text)
        if v then flySpeed = v InputFly.Text = "Vel. Vuelo: " .. v else InputFly.Text = "" end
    end
end)

InputMoney.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local ammount = tonumber(InputMoney.Text)
        if ammount then
            local stats = LocalPlayer:FindFirstChild("leaderstats")
            local moneyObj = stats and (stats:FindFirstChild("Money") or stats:FindFirstChild("Cash") or stats:FindFirstChild("Coins") or stats:FindFirstChild("Gold"))
            if moneyObj then
                moneyObj.Value = ammount
                InputMoney.Text = "Money local editado"
            else
                InputMoney.Text = "Visual: $" .. ammount
            end
            task.wait(1.5)
            InputMoney.Text = ""
        else InputMoney.Text = "" end
    end
end)

-- VUELO (FLY)
local bodyVelocity, bodyGyro
BtnFly.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    BtnFly.Text = flyEnabled and "Vuelo (Fly): ON" or "Vuelo (Fly): OFF"
    BtnFly.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(0, 150, 200)
    local torso = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("UpperTorso") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not torso then return end
    if flyEnabled then
        bodyVelocity = Instance.new("BodyVelocity") bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0) bodyVelocity.Parent = torso
        bodyGyro = Instance.new("BodyGyro") bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        bodyGyro.CFrame = torso.CFrame bodyGyro.Parent = torso
    else
        if bodyVelocity then bodyVelocity:Destroy() end if bodyGyro then bodyGyro:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flyEnabled and LocalPlayer.Character then
        local torso = LocalPlayer.Character:FindFirstChild("UpperTorso") or LocalPlayer.Character:FindFirstChild("Torso")
        local camera = workspace.CurrentCamera
        if torso and camera and bodyVelocity and bodyGyro then
            local direction = Vector3.new(0,0,0)
            if UserInput:IsKeyDown(Enum.KeyCode.W) then direction = direction + camera.CFrame.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.S) then direction = direction - camera.CFrame.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
            if UserInput:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
            if direction.Magnitude > 0 then bodyVelocity.Velocity = direction.Unit * flySpeed else bodyVelocity.Velocity = Vector3.new(0, 0.1, 0) end
            bodyGyro.CFrame = camera.CFrame
        end
    end
end)