-- HUB NAME: beris
-- Versión Especial con Escáner de Nombres Visual para Móvil

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiar versiones anteriores
if PlayerGui:FindFirstChild("BerisHub") then
    PlayerGui.BerisHub:Destroy()
end

-- Pantalla Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Marco Principal (Izquierda)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 140, 0)
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

-- Título Principal
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "beris hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Marco del Escáner (Derecha - Inicialmente invisible)
local ScanFrame = Instance.new("Frame")
ScanFrame.Size = UDim2.new(0, 220, 0, 220)
ScanFrame.Position = UDim2.new(1, 10, 0, 0) -- Se acopla al lado del principal
ScanFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScanFrame.BorderSizePixel = 2
ScanFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
ScanFrame.Visible = false
ScanFrame.Parent = MainFrame

-- Título del Escáner
local ScanTitle = Instance.new("TextLabel")
ScanTitle.Size = UDim2.new(1, 0, 0, 30)
ScanTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ScanTitle.Text = "Nombres Detectados"
ScanTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
ScanTitle.TextSize = 14
ScanTitle.Font = Enum.Font.SourceSansBold
ScanTitle.Parent = ScanFrame

-- Lista con scroll para ver los nombres cómodamente
local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1, -10, 1, -40)
ScrollList.Position = UDim2.new(0, 5, 0, 35)
ScrollList.BackgroundTransparency = 1
ScrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollList.ScrollBarThickness = 6
ScrollList.Parent = ScanFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local savedPosition = nil

-- BOTONES PRINCIPALES
local ButtonTP1 = Instance.new("TextButton")
ButtonTP1.Size = UDim2.new(0.9, 0, 0, 32)
ButtonTP1.Position = UDim2.new(0.05, 0, 0.18, 0)
ButtonTP1.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ButtonTP1.Text = "TP: Guardar Ubicación"
ButtonTP1.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTP1.TextSize = 13
ButtonTP1.Font = Enum.Font.SourceSans
ButtonTP1.Parent = MainFrame

local ButtonTP2 = Instance.new("TextButton")
ButtonTP2.Size = UDim2.new(0.9, 0, 0, 32)
ButtonTP2.Position = UDim2.new(0.05, 0, 0.38, 0)
ButtonTP2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ButtonTP2.Text = "TP2: Teletransportar"
ButtonTP2.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonTP2.TextSize = 13
ButtonTP2.Font = Enum.Font.SourceSans
ButtonTP2.Parent = MainFrame

local ButtonBring = Instance.new("TextButton")
ButtonBring.Size = UDim2.new(0.9, 0, 0, 32)
ButtonBring.Position = UDim2.new(0.05, 0, 0.58, 0)
ButtonBring.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
ButtonBring.Text = "Absorber Todo"
ButtonBring.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonBring.TextSize = 13
ButtonBring.Font = Enum.Font.SourceSansBold
ButtonBring.Parent = MainFrame

local ButtonScan = Instance.new("TextButton")
ButtonScan.Size = UDim2.new(0.9, 0, 0, 32)
ButtonScan.Position = UDim2.new(0.05, 0, 0.78, 0)
ButtonScan.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ButtonScan.Text = "Escanear Nombres"
ButtonScan.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonScan.TextSize = 13
ButtonScan.Font = Enum.Font.SourceSansBold
ButtonScan.Parent = MainFrame

--- LÓGICA ---

ButtonTP1.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedPosition = character.HumanoidRootPart.CFrame
        ButtonTP1.Text = "¡Guardado!"
        task.wait(1)
        ButtonTP1.Text = "TP: Guardar Ubicación"
    end
end)

ButtonTP2.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if savedPosition then
            character.HumanoidRootPart.CFrame = savedPosition
        else
            ButtonTP2.Text = "Sin ubicación"
            task.wait(1)
            ButtonTP2.Text = "TP2: Teletransportar"
        end
    end
end)

ButtonBring.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = character.HumanoidRootPart
    local count = 0
    ButtonBring.Text = "Atrayendo..."
    
    for _, object in pairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") and not object.Anchored and not object:IsDescendantOf(character) and not object:IsDescendantOf(Players) then
            local distancia = (object.Position - myRoot.Position).Magnitude
            if distancia < 300 then
                object.CFrame = myRoot.CFrame + Vector3.new(0, 2, 0)
                count = count + 1
            end
        end
    end
    ButtonBring.Text = "¡Atraídos: " .. count .. "!"
    task.wait(1.2)
    ButtonBring.Text = "Absorber Todo"
end)

-- Lógica del Escáner de Nombres
ButtonScan.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Limpiar escaneos anteriores
    for _, child in pairs(ScrollList:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    
    ScanFrame.Visible = true
    ButtonScan.Text = "Escaneando..."
    
    local nombresEncontrados = {}
    local total = 0
    
    -- Buscar objetos cercanos que no estén anclados (recursos tirados)
    for _, object in pairs(Workspace:GetDescendants()) do
        if object:IsA("BasePart") and not object.Anchored and not object:IsDescendantOf(character) and not object:IsDescendantOf(Players) then
            local distancia = (object.Position - character.HumanoidRootPart.Position).Magnitude
            if distancia < 250 then
                -- Usamos el nombre del objeto o de su modelo padre si aplica
                local nombreFinal = object.Name
                if object.Parent and object.Parent:IsA("Model") and object.Parent.Name ~= "Workspace" then
                    nombreFinal = object.Parent.Name .. " (" .. object.Name .. ")"
                end
                
                if not nombresEncontrados[nombreFinal] then
                    nombresEncontrados[nombreFinal] = true
                    total = total + 1
                    
                    -- Crear etiqueta de texto para la lista de la pantalla
                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, -10, 0, 20)
                    Label.BackgroundTransparency = 0.8
                    Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    Label.Text = "• " .. nombreFinal
                    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Label.TextSize = 12
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.Font = Enum.Font.SourceSans
                    Label.Parent = ScrollList
                end
            end
        end
        if total >= 15 then break end -- Mostrar máximo 15 nombres diferentes para no saturar la pantalla del móvil
    end
    
    if total == 0 then
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -10, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = "No se hallaron ítems sueltos cerca."
        Label.TextColor3 = Color3.fromRGB(255, 100, 100)
        Label.TextSize = 12
        Label.Parent = ScrollList
    end
    
    -- Ajustar el tamaño del scroll automáticamente
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, total * 25)
    
    ButtonScan.Text = "Escanear Nombres"
end)