-- HUB NAME: beris
-- Descripción: Hub de teletransportación con guardado de posición.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Crear la Pantalla Principal (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Crear el Marco del Menú (Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 165, 0) -- Borde Naranja
MainFrame.Active = true
MainFrame.Draggable = true -- Permite mover el hub por la pantalla
MainFrame.Parent = ScreenGui

-- Título del Hub
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "beris"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Variable para almacenar la ubicación
local savedPosition = nil

-- BOTÓN 1: TP (Guardar Ubicación)
local ButtonTP1 = Instance.new("TextButton")
ButtonTP1.Size = UDim2.new(0.9, 0, 0, 35)
ButtonTP1.Position = UDim2.new(0.05, 0, 0.3, 0)
ButtonTP1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ButtonTP1.Text = "TP: Guardar Ubicación"
ButtonTP1.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTP1.TextSize = 14
ButtonTP1.Font = Enum.Font.SourceSans
ButtonTP1.Parent = MainFrame

-- BOTÓN 2: TP2 (Teletransportar)
local ButtonTP2 = Instance.new("TextButton")
ButtonTP2.Size = UDim2.new(0.9, 0, 0, 35)
ButtonTP2.Position = UDim2.new(0.05, 0, 0.65, 0)
ButtonTP2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ButtonTP2.Text = "TP2: Teletransportar"
ButtonTP2.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTP2.TextSize = 14
ButtonTP2.Font = Enum.Font.SourceSans
ButtonTP2.Parent = MainFrame

--- LÓGICA DE LOS BOTONES ---

-- Función para Guardar Posición
ButtonTP1.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.CFrame
        ButtonTP1.Text = "¡Ubicación Guardada!"
        task.wait(1.5)
        ButtonTP1.Text = "TP: Guardar Ubicación"
    else
        ButtonTP1.Text = "Error: Personaje no encontrado"
    end
end)

-- Función para Teletransportarse
ButtonTP2.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if savedPosition then
            character.HumanoidRootPart.CFrame = savedPosition
        else
            ButtonTP2.Text = "Primero guarda una ubicación"
            task.wait(1.5)
            ButtonTP2.Text = "TP2: Teletransportar"
        end
    else
        ButtonTP2.Text = "Error: Personaje no encontrado"
    end
end)