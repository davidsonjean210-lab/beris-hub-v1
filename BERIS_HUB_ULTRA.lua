-- HUB NAME: beris
-- Optimizado para juegos de supervivencia / recolección

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Crear la Pantalla Principal (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Crear el Marco del Menú (Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 190)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 165, 0)
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

-- BOTÓN 3: Recoger Recursos (Optimizado)
local ButtonBring = Instance.new("TextButton")
ButtonBring.Size = UDim2.new(0.9, 0, 0, 35)
ButtonBring.Position = UDim2.new(0.05, 0, 0.72, 0)
ButtonBring.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Azul eléctrico
ButtonBring.Text = "Recoger Madera/Items"
ButtonBring.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonBring.TextSize = 14
ButtonBring.Font = Enum.Font.SourceSansBold
ButtonBring.Parent = MainFrame

--- LÓGICA DE LOS BOTONES ---

ButtonTP1.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.CFrame
        ButtonTP1.Text = "¡Ubicación Guardada!"
        task.wait(1.5)
        ButtonTP1.Text = "TP: Guardar Ubicación"
    end
end)

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

-- Nueva Lógica para 99 Noches en el Bosque (Traer/Auto-Farm)
ButtonBring.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local originalPosition = rootPart.CFrame -- Guarda dónde estás parado para no perderte
    local count = 0
    
    ButtonBring.Text = "Buscando recursos..."
    
    -- Escanea el mapa buscando carpetas comunes de recursos como "Dropped", "Items", "Debris" o "Wood"
    -- También busca cualquier parte suelta que se llame "Wood", "Log", "Madera" o "Item"
    for _, object in pairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") and not object:IsDescendantOf(character) and not object:IsDescendantOf(Players) then
            
            -- FILTRO: Ponemos nombres comunes de los recursos de este tipo de juegos
            local name = object.Name:lower()
            if name:find("wood") or name:find("log") or name:find("item") or name:find("madera") or name:find("pickup") or object.Parent.Name:lower():find("dropped") then
                
                -- Opción A: Intentar traer el objeto a ti (si no está anclado)
                if not object.Anchored then
                    object.CFrame = originalPosition
                else
                    -- Opción B: Si está anclado, tú te teletransportas a él instantáneamente para recogerlo y vuelves
                    rootPart.CFrame = object.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.05) -- Espera un milisegundo para que el juego detecte que lo tocaste
                end
                
                count = count + 1
                if count >= 20 then break end -- Límite por clic para evitar que el juego te eche (Anti-Cheat)
            end
        end
    end
    
    -- Regresar a la posición original seguro
    rootPart.CFrame = originalPosition
    
    ButtonBring.Text = "¡Procesados: " .. count .. "!"
    task.wait(1.5)
    ButtonBring.Text = "Recoger Madera/Items"
end)