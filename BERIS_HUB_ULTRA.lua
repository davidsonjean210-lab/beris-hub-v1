-- HUB NAME: beris
-- Descripción: Hub con TP, TP2 y Magnet de Objetos.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Crear la Pantalla Principal (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Crear el Marco del Menú (Frame) - Ajustado el tamaño para 3 botones
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 190) -- Más alto para acomodar el nuevo botón
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 165, 0) -- Borde Naranja
MainFrame.Active = true
MainFrame.Draggable = true 
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
ButtonTP1.Position = UDim2.new(0.05, 0, 0.22, 0)
ButtonTP1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ButtonTP1.Text = "TP: Guardar Ubicación"
ButtonTP1.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTP1.TextSize = 14
ButtonTP1.Font = Enum.Font.SourceSans
ButtonTP1.Parent = MainFrame

-- BOTÓN 2: TP2 (Teletransportar)
local ButtonTP2 = Instance.new("TextButton")
ButtonTP2.Size = UDim2.new(0.9, 0, 0, 35)
ButtonTP2.Position = UDim2.new(0.05, 0, 0.47, 0)
ButtonTP2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ButtonTP2.Text = "TP2: Teletransportar"
ButtonTP2.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTP2.TextSize = 14
ButtonTP2.Font = Enum.Font.SourceSans
ButtonTP2.Parent = MainFrame

-- BOTÓN 3: Traer Objetos (Magnet)
local ButtonBring = Instance.new("TextButton")
ButtonBring.Size = UDim2.new(0.9, 0, 0, 35)
ButtonBring.Position = UDim2.new(0.05, 0, 0.72, 0)
ButtonBring.BackgroundColor3 = Color3.fromRGB(255, 100, 0) -- Color llamativo
ButtonBring.Text = "Traer Objetos"
ButtonBring.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonBring.TextSize = 14
ButtonBring.Font = Enum.Font.SourceSansBold
ButtonBring.Parent = MainFrame

--- LÓGICA DE LOS BOTONES ---

-- Función: Guardar Posición
ButtonTP1.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.CFrame
        ButtonTP1.Text = "¡Ubicación Guardada!"
        task.wait(1.5)
        ButtonTP1.Text = "TP: Guardar Ubicación"
    end
end)

-- Función: Teletransportarse
ButtonTP2.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if savedPosition then
            character.HumanoidRootPart.CFrame = savedPosition
        else
            ButtonTP2.Text = "Primero guarda ubicación"
            task.wait(1.5)
            ButtonTP2.Text = "TP2: Teletransportar"
        end
    end
end)

-- Función: Traer Objetos (Magnet)
ButtonBring.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local myPos = character.HumanoidRootPart.CFrame
        local count = 0
        
        -- Busca en todo el Workspace
        for _, object in pairs(Workspace:GetDescendants()) do
            -- Verifica si es una herramienta (Tool) tirada en el suelo
            if object:IsA("Tool") and not object:IsDescendantOf(Players) then
                -- Busca la parte física principal de la herramienta (suele ser 'Handle')
                local handle = object:FindFirstChild("Handle") or object:FindFirstChildWhichIsA("BasePart")
                if handle then
                    handle.CFrame = myPos
                    count = count + 1
                end
            end
        end
        
        -- Mostrar cuántos objetos se trajeron
        ButtonBring.Text = "¡Traídos: " .. count .. " objetos!"
        task.wait(1.5)
        ButtonBring.Text = "Traer Objetos"
    end
end)