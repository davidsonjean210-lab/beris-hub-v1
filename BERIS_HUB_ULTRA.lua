-- ====================================================================
-- BERIS HUB V2 - ROBLOX SCRIPT (TOTALMENTE CORREGIDO)
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

-- 1. CREACIÓN DE LA INTERFAZ VISUAL (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV2"
ScreenGui.ResetOnSpawn = false

-- Asegurar que se inserte en el CoreGui (si usas executor) o en PlayerGui
local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
if success and coreGui then
    ScreenGui.Parent = coreGui
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 410)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Título del Hub
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BERIS HUB V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- FUNCIÓN GENERADORA DE BOTONES
local function createButton(name, text, yPos, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 180, 0, 35)
    button.Position = UDim2.new(0, 20, 0, yPos)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 15
    button.Font = Enum.Font.SourceSansSemibold
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = button
    
    return button
end

-- CREACIÓN DE LAS Opciones
local BtnSaveTp = createButton("BtnSaveTp", "Guardar TP", 55, Color3.fromRGB(0, 120, 255))
local BtnTp     = createButton("BtnTp", "Teletransportar", 95, Color3.fromRGB(0, 180, 100))
local BtnTras   = createButton("BtnTras", "Tras (Noclip): OFF", 135, Color3.fromRGB(180, 50, 50))
local BtnSpeed  = createButton("BtnSpeed", "Velocidad: Normal", 185, Color3.fromRGB(140, 20, 180))
local BtnJump   = createButton("BtnJump", "Salto: Normal", 225, Color3.fromRGB(200, 100, 0))
local BtnInfJ   = createButton("BtnInfJ", "Salto Infinito: OFF", 265, Color3.fromRGB(100, 100, 100))
local BtnFly    = createButton("BtnFly", "Vuelo (Fly): OFF", 315, Color3.fromRGB(0, 150, 200))

-- Nota informativa abajo
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -30)
Credits.Text = "Presiona 'P' para ocultar"
Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
Credits.TextSize = 12
Credits.BackgroundTransparency = 1
Credits.Parent = MainFrame

-- ====================================================================
-- LÓGICA Y FUNCIONALIDAD
-- ====================================================================

-- Ocultar/Mostrar Hub con la tecla P
UserInput.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- 1. Guardar Ubicación
BtnSaveTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        BtnSaveTp.Text = "¡Guardado!"
        task.wait(0.8)
        BtnSaveTp.Text = "Guardar TP"
    end
end)

-- 2. Teletransportar
BtnTp.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if savedPosition then
            char.HumanoidRootPart.CFrame = savedPosition
        else
            BtnTp.Text = "❌ Sin ubicación"
            task.wait(1)
            BtnTp.Text = "Teletransportar"
        end
    end
end)

-- 3. Tras (Noclip)
BtnTras.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    BtnTras.Text = noclipEnabled and "Tras (Noclip): ON" or "Tras (Noclip): OFF"
    BtnTras.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- 4. Súper Velocidad (Ciclo)
local speedMode = 0
BtnSpeed.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        speedMode = (speedMode + 1) % 3
        if speedMode == 0 then
            hum.WalkSpeed = 16
            BtnSpeed.Text = "Velocidad: Normal"
        elseif speedMode == 1 then
            hum.WalkSpeed = 60
            BtnSpeed.Text = "Velocidad: Rápido"
        else
            hum.WalkSpeed = 150
            BtnSpeed.Text = "Velocidad: Flash"
        end
    end
end)

-- 5. Súper Salto (Ciclo)
local jumpMode = 0
BtnJump.MouseButton1Click:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        jumpMode = (jumpMode + 1) % 3
        hum.UseJumpPower = true
        if jumpMode == 0 then
            hum.JumpPower = 50
            BtnJump.Text = "Salto: Normal"
        elseif jumpMode == 1 then
            hum.JumpPower = 120
            BtnJump.Text = "Salto: Alto"
        else
            hum.JumpPower = 250
            BtnJump.Text = "Salto: Lunar"
        end
    end
end)

-- 6. Salto Infinito
BtnInfJ.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    BtnInfJ.Text = infJumpEnabled and "Salto Infinito: ON" or "Salto Infinito: OFF"
    BtnInfJ.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(100, 100, 100)
end)

UserInput.InputBegan:Connect(function(input, gameProcessed)
    if infJumpEnabled and not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 7. Sistema de Vuelo (Fly)
local bodyVelocity, bodyGyro
BtnFly.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    BtnFly.Text = flyEnabled and "Vuelo (Fly): ON" or "Vuelo (Fly): OFF"
    BtnFly.BackgroundColor3 = flyEnabled and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(0, 150, 200)
    
    local torso = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("UpperTorso") or LocalPlayer.Character:FindFirstChild("Torso"))
    if not torso then return end
    
    if flyEnabled then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = torso
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        bodyGyro.CFrame = torso.CFrame
        bodyGyro.Parent = torso
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
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
            
            if direction.Magnitude > 0 then
                bodyVelocity.Velocity = direction.Unit * flySpeed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
            end
            bodyGyro.CFrame = camera.CFrame
        end
    end
end)