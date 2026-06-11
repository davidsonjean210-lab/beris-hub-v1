-- ====================================================================
-- BERIS HUB - ROBLOX SCRIPT
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables de estado
local savedPosition = nil
local noclipEnabled = false

-- 1. CREACIÓN DE LA INTERFAZ VISUAL (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Marco Principal (El Hub)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Permite mover el hub con el mouse
MainFrame.Parent = ScreenGui

-- Esquinas redondeadas para el Hub
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título del Hub
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BERIS HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- FUNCIÓN PARA CREAR BOTONES RÁPIDAMENTE
local function createButton(name, text, position, color)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 160, 0, 40)
    button.Position = position
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.SourceSans
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    return button
end

-- Crear los 3 botones solicitados
local BtnSaveTp = createButton("BtnSaveTp", "Guardar TP", UDim2.new(0, 20, 0, 55), Color3.fromRGB(0, 120, 255))
local BtnTp = createButton("BtnTp", "Teletransportar", UDim2.new(0, 20, 0, 105), Color3.fromRGB(0, 180, 100))
local BtnTras = createButton("BtnTras", "Tras (Noclip: OFF)", UDim2.new(0, 20, 0, 155), Color3.fromRGB(180, 50, 50))

-- ====================================================================
-- 2. LÓGICA Y FUNCIONALIDAD DE LOS BOTONES
-- ====================================================================

-- Opción 1: Guardar Ubicación
BtnSaveTp.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.CFrame
        BtnSaveTp.Text = "¡Ubicación Guardada!"
        task.wait(1)
        BtnSaveTp.Text = "Guardar TP"
    end
end)

-- Opción 2: Teletransportar a la ubicación guardada
BtnTp.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if savedPosition then
            character.HumanoidRootPart.CFrame = savedPosition
        else
            BtnTp.Text = "Primero guarda ubicación"
            task.wait(1.5)
            BtnTp.Text = "Teletransportar"
        end
    end
end)

-- Opción 3: Tras (Noclip / Traspasar paredes)
BtnTras.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        BtnTras.Text = "Tras (Noclip: ON)"
        BtnTras.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
    else
        BtnTras.Text = "Tras (Noclip: OFF)"
        BtnTras.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Bucle para hacer efectivo el traspaso de paredes (Noclip)
RunService.Stepped:Connect(function()
    if noclipEnabled then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)