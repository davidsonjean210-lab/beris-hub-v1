-- [[ BERIS HUB - MENÚ DE MOVIMIENTO AVANZADO ]]
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Variables de Estado
local opciones = {
    SuperVelocidad = false,
    SaltoInfinito = false
}
local posicionGuardada = nil -- Aquí se guardará el TP
local VELOCIDAD_EXTRA = 60 -- Velocidad del empuje (ajusta si quieres más o menos)

-- 1. Crear la Interfaz (GUI)
if CoreGui:FindFirstChild("BerisMovimientoGUI") then
    CoreGui.BerisMovimientoGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisMovimientoGUI"
ScreenGui.Parent = CoreGui

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 280) -- Altura ampliada para más botones
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.ClipsDescendants = true -- Clave para que el minimizar funcione perfecto
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Título
local Titulo = Instance.new("TextLabel")
Titulo.Size = UDim2.new(1, 0, 0, 40)
Titulo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Titulo.Text = " Beris Hub - Movimiento"
Titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
Titulo.TextSize = 16
Titulo.Font = Enum.Font.GothamBold
Titulo.TextXAlignment = Enum.TextXAlignment.Left
Titulo.Parent = MainFrame

-- Padding para que el título no quede pegado al borde izquierdo
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.Parent = Titulo

-- Botón Minimizar (-)
local BtnMinimizar = Instance.new("TextButton")
BtnMinimizar.Size = UDim2.new(0, 30, 0, 30)
BtnMinimizar.Position = UDim2.new(1, -70, 0, 5)
BtnMinimizar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BtnMinimizar.Text = "-"
BtnMinimizar.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnMinimizar.TextSize = 20
BtnMinimizar.Font = Enum.Font.GothamBold
BtnMinimizar.BorderSizePixel = 0
BtnMinimizar.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = BtnMinimizar

-- Botón Cerrar (X)
local BtnCerrar = Instance.new("TextButton")
BtnCerrar.Size = UDim2.new(0, 30, 0, 30)
BtnCerrar.Position = UDim2.new(1, -35, 0, 5)
BtnCerrar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
BtnCerrar.Text = "X"
BtnCerrar.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnCerrar.TextSize = 16
BtnCerrar.Font = Enum.Font.GothamBold
BtnCerrar.BorderSizePixel = 0
BtnCerrar.Parent = MainFrame

local CerCorner = Instance.new("UICorner")
CerCorner.CornerRadius = UDim.new(0, 6)
CerCorner.Parent = BtnCerrar

-- Contenedor de Botones
local Contenedor = Instance.new("Frame")
Contenedor.Size = UDim2.new(1, 0, 1, -40)
Contenedor.Position = UDim2.new(0, 0, 0, 40)
Contenedor.BackgroundTransparency = 1
Contenedor.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Contenedor
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Espacio superior invisible para separar los botones del título
local Spacer = Instance.new("Frame")
Spacer.Size = UDim2.new(1, 0, 0, 5)
Spacer.BackgroundTransparency = 1
Spacer.Parent = Contenedor

-- Función creadora de botones para no repetir código
local function CrearBoton(texto, color, contenedor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 40)
    btn.BackgroundColor3 = color
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = contenedor
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local BtnVelocidad = CrearBoton("Súper Velocidad: OFF", Color3.fromRGB(180, 50, 50), Contenedor)
local BtnSalto = CrearBoton("Salto Infinito: OFF", Color3.fromRGB(180, 50, 50), Contenedor)
local BtnTP1 = CrearBoton("TP: Guardar Posición", Color3.fromRGB(50, 100, 180), Contenedor)
local BtnTP2 = CrearBoton("TP2: Ir a Posición", Color3.fromRGB(180, 130, 30), Contenedor)

-- 2. Lógica de Interfaz (Minimizar y Cerrar)
local minimizado = false
BtnMinimizar.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    if minimizado then
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 40), "Out", "Quad", 0.3, true)
        BtnMinimizar.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 280), "Out", "Quad", 0.3, true)
        BtnMinimizar.Text = "-"
    end
end)

BtnCerrar.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    opciones.SuperVelocidad = false
    opciones.SaltoInfinito = false
end)

-- 3. Lógica de Botones Activos (ON/OFF y TPs)
BtnVelocidad.MouseButton1Click:Connect(function()
    opciones.SuperVelocidad = not opciones.SuperVelocidad
    if opciones.SuperVelocidad then
        BtnVelocidad.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        BtnVelocidad.Text = "Súper Velocidad: ON"
    else
        BtnVelocidad.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        BtnVelocidad.Text = "Súper Velocidad: OFF"
    end
end)

BtnSalto.MouseButton1Click:Connect(function()
    opciones.SaltoInfinito = not opciones.SaltoInfinito
    if opciones.SaltoInfinito then
        BtnSalto.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        BtnSalto.Text = "Salto Infinito: ON"
    else
        BtnSalto.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        BtnSalto.Text = "Salto Infinito: OFF"
    end
end)

BtnTP1.MouseButton1Click:Connect(function()
    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        posicionGuardada = rootPart.CFrame
        BtnTP1.Text = "¡Posición Guardada!"
        task.delay(1.5, function() BtnTP1.Text = "TP: Guardar Posición" end)
    end
end)

BtnTP2.MouseButton1Click:Connect(function()
    if posicionGuardada then
        local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.CFrame = posicionGuardada
        end
    else
        BtnTP2.Text = "¡No hay TP guardado!"
        task.delay(1.5, function() BtnTP2.Text = "TP2: Ir a Posición" end)
    end
end)

-- 4. Funciones de Trampas

-- NUEVA VELOCIDAD BYPASS (Evita el Anti-Cheat)
RunService.RenderStepped:Connect(function(deltaTime)
    if opciones.SuperVelocidad then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            -- Si el jugador se está moviendo usando el joystick o las teclas
            if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
                -- Empujamos el personaje hacia donde mira la cámara/movimiento
                rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * (VELOCIDAD_EXTRA * deltaTime))
            end
        end
    end
end)

-- Salto Infinito
UserInputService.JumpRequest:Connect(function()
    if opciones.SaltoInfinito then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

print("Beris Hub cargado. Bypass de velocidad activado.")