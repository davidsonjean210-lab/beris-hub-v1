-- [[ BERIS HUB - ROTUBE LIFE 2 (DETECCIÓN UNIVERSAL POR COLOR / QTE) ]]
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de Estado
local opciones = {
    SuperVelocidad = false,
    SaltoInfinito = false,
    AutoFotoPerfecta = false
}
local posicionGuardada = nil
local VELOCIDAD_EXTRA = 60
local ultimoClicTime = 0

-- 1. Crear la Interfaz (GUI)
if CoreGui:FindFirstChild("BerisRoTubeGUI") then
    CoreGui.BerisRoTubeGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisRoTubeGUI"
ScreenGui.Parent = CoreGui

-- Marco Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 310)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Título
local Titulo = Instance.new("TextLabel")
Titulo.Size = UDim2.new(1, 0, 0, 40)
Titulo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Titulo.Text = " Beris Hub - Auto Foto Perfecta"
Titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
Titulo.TextSize = 15
Titulo.Font = Enum.Font.GothamBold
Titulo.TextXAlignment = Enum.TextXAlignment.Left
Titulo.Parent = MainFrame

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

local Spacer = Instance.new("Frame")
Spacer.Size = UDim2.new(1, 0, 0, 5)
Spacer.BackgroundTransparency = 1
Spacer.Parent = Contenedor

-- Función creadora de botones
local function CrearBoton(texto, color, contenedor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 38)
    btn.BackgroundColor3 = color
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = contenedor
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local BtnAutoFoto = CrearBoton("Auto-Foto Perfecta (Minijuego): OFF", Color3.fromRGB(180, 50, 50), Contenedor)
local BtnVelocidad = CrearBoton("Súper Velocidad: OFF", Color3.fromRGB(180, 50, 50), Contenedor)
local BtnSalto = CrearBoton("Salto Infinito: OFF", Color3.fromRGB(180, 50, 50), Contenedor)
local BtnTP1 = CrearBoton("TP: Guardar Posición", Color3.fromRGB(50, 100, 180), Contenedor)
local BtnTP2 = CrearBoton("TP2: Ir a Posición", Color3.fromRGB(180, 130, 30), Contenedor)

-- 2. Lógica de Interfaz (Minimizar y Cerrar)
local minimizado = false
BtnMinimizar.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    if minimizado then
        MainFrame:TweenSize(UDim2.new(0, 260, 0, 40), "Out", "Quad", 0.3, true)
        BtnMinimizar.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 260, 0, 310), "Out", "Quad", 0.3, true)
        BtnMinimizar.Text = "-"
    end
end)

BtnCerrar.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    opciones.SuperVelocidad = false
    opciones.SaltoInfinito = false
    opciones.AutoFotoPerfecta = false
end)

-- 3. Lógica de Botones (ON/OFF y TPs)
local function ToggleBoton(btn, opcionNombre, textoBase)
    opciones[opcionNombre] = not opciones[opcionNombre]
    if opciones[opcionNombre] then
        btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        btn.Text = textoBase .. ": ON"
    else
        btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        btn.Text = textoBase .. ": OFF"
    end
end

BtnAutoFoto.MouseButton1Click:Connect(function() ToggleBoton(BtnAutoFoto, "AutoFotoPerfecta", "Auto-Foto Perfecta (Minijuego)") end)
BtnVelocidad.MouseButton1Click:Connect(function() ToggleBoton(BtnVelocidad, "SuperVelocidad", "Súper Velocidad") end)
BtnSalto.MouseButton1Click:Connect(function() ToggleBoton(BtnSalto, "SaltoInfinito", "Salto Infinito") end)

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

-- 4. FUNCIONES DE AUTOMATIZACIÓN

-- [[ DETECTOR POR COLOR Y POSICIÓN (SIN LÍMITES DE PÍXELES ESTRICTOS) ]]
task.spawn(function()
    while task.wait(0.01) do
        if opciones.AutoFotoPerfecta and (tick() - ultimoClicTime) > 0.4 then
            pcall(function()
                local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if playerGui then
                    -- Recorremos las interfaces activas
                    for _, screenGui in pairs(playerGui:GetChildren()) do
                        if screenGui:IsA("ScreenGui") and screenGui.Enabled and screenGui.Name ~= "BerisRoTubeGUI" then
                            
                            local lineaRoja = nil
                            local zonaVerde = nil
                            
                            -- Buscamos elementos en la mitad inferior de la pantalla
                            for _, elem in pairs(screenGui:GetDescendants()) do
                                if (elem:IsA("Frame") or elem:IsA("ImageLabel")) and elem.Visible then
                                    local pos = elem.AbsolutePosition
                                    local size = elem.AbsoluteSize
                                    
                                    -- Filtrar solo lo que esté en la zona de la barra inferior
                                    if pos.Y > (Camera.ViewportSize.Y * 0.6) and size.Y > 5 and size.Y < 80 then
                                        
                                        -- 1. Identificar la Línea Roja (es delgada y roja/anaranjada)
                                        if size.X <= 30 and size.X > 1 then
                                            local color = elem:IsA("Frame") and elem.BackgroundColor3 or Color3.new(1, 1, 1)
                                            -- Si tiene mucho rojo y menos verde/azul (típico color rojo de la línea)
                                            if color.R > 0.7 and color.G < 0.4 then
                                                lineaRoja = elem
                                            end
                                        end
                                        
                                        -- 2. Identificar la Zona Verde/Amarilla (es un bloque más ancho en el centro)
                                        if size.X > 25 and size.X < 300 then
                                            local color = elem:IsA("Frame") and elem.BackgroundColor3 or Color3.new(1, 1, 1)
                                            -- Si tiene verde alto o amarillo (R alto + G alto)
                                            if color.G > 0.6 then
                                                zonaVerde = elem
                                            end
                                        end
                                    end
                                end
                            end
                            
                            -- Si encontró ambos elementos en pantalla, calculamos el cruce
                            if lineaRoja and zonaVerde then
                                local centroX = lineaRoja.AbsolutePosition.X + (lineaRoja.AbsoluteSize.X / 2)
                                local minX = zonaVerde.AbsolutePosition.X
                                local maxX = minX + zonaVerde.AbsoluteSize.X
                                
                                -- Cuando la línea roja entra en la zona verde
                                if centroX >= minX and centroX <= maxX then
                                    ultimoClicTime = tick()
                                    
                                    -- Clic táctil en el centro de la pantalla
                                    local tapX = Camera.ViewportSize.X / 2
                                    local tapY = Camera.ViewportSize.Y / 2
                                    VirtualInputManager:SendMouseButtonEvent(tapX, tapY, 0, true, game, 0)
                                    task.wait()
                                    VirtualInputManager:SendMouseButtonEvent(tapX, tapY, 0, false, game, 0)
                                    break
                                end
                            end
                            
                        end
                    end
                end
            end)
        end
    end
end)

-- Súper Velocidad (Bypass Anti-Cheat)
RunService.RenderStepped:Connect(function(deltaTime)
    if opciones.SuperVelocidad then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.MoveDirection.Magnitude > 0 then
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

print("Beris Hub - Detector por Color Cargado.")