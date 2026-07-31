-- [[ BERIS HUB - ROTUBE LIFE 2 (ESCUDO ANTI-SPAWN / CAPTURA EN 1RA PASADA) ]]
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

-- Control para evitar el clic instantáneo al aparecer el minijuego
local minijuegoEnPantalla = false
local tiempoAparicionGUI = 0

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
Titulo.Text = " Beris Hub - Foto Perfecta"
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

-- [[ DETECTOR CON ESCUDO ANTI-SPAWN Y ANTICIPACIÓN DE DISPARO ]]
RunService.Heartbeat:Connect(function()
    if not opciones.AutoFotoPerfecta then return end
    
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        
        local barraEncontrada = false
        
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "BerisRoTubeGUI" then
                for _, bar in pairs(gui:GetDescendants()) do
                    -- Identificar la barra principal del minijuego abajo
                    if (bar:IsA("Frame") or bar:IsA("ImageLabel")) and bar.Visible then
                        if bar.AbsoluteSize.X >= 150 and bar.AbsoluteSize.Y >= 12 and bar.AbsoluteSize.Y <= 80 and bar.AbsolutePosition.Y > (Camera.ViewportSize.Y * 0.60) then
                            
                            local lineaMovil = nil
                            local zonaObjetivo = nil
                            
                            for _, elem in pairs(bar:GetDescendants()) do
                                if (elem:IsA("Frame") or elem:IsA("ImageLabel")) and elem.Visible then
                                    local ancho = elem.AbsoluteSize.X
                                    if ancho >= 2 and ancho <= 20 then
                                        lineaMovil = elem
                                    elseif ancho > 20 and ancho <= (bar.AbsoluteSize.X * 0.80) then
                                        zonaObjetivo = elem
                                    end
                                end
                            end
                            
                            if lineaMovil and zonaObjetivo then
                                barraEncontrada = true
                                
                                -- 1. ESCUDO ANTI-SPAWN:
                                -- Si el minijuego acaba de aparecer, iniciamos el cronómetro
                                if not minijuegoEnPantalla then
                                    minijuegoEnPantalla = true
                                    tiempoAparicionGUI = tick()
                                end
                                
                                -- No hacemos NADA durante los primeros 0.35 segundos para que la línea empiece a moverse
                                if (tick() - tiempoAparicionGUI) < 0.35 then
                                    return
                                end
                                
                                -- Respetar tiempo entre clics
                                if (tick() - ultimoClicTime) < 0.30 then
                                    return
                                end
                                
                                local centroLinea = lineaMovil.AbsolutePosition.X + (lineaMovil.AbsoluteSize.X / 2)
                                local centroZona = zonaObjetivo.AbsolutePosition.X + (zonaObjetivo.AbsoluteSize.X / 2)
                                local anchoZona = zonaObjetivo.AbsoluteSize.X
                                
                                -- 2. ZONA DE ANTICIPACIÓN FIJA:
                                -- Como la línea viaja rápido de izquierda a derecha, apuntamos al centro,
                                -- pero permitiendo disparar un poquito antes (20% a la izquierda del centro)
                                -- para compensar el retraso táctil del celular.
                                local zonaInicio = centroZona - (anchoZona * 0.22)
                                local zonaFin = centroZona + (anchoZona * 0.10)
                                
                                if centroLinea >= zonaInicio and centroLinea <= zonaFin then
                                    ultimoClicTime = tick()
                                    
                                    -- Toque limpio al aire (Zona Segura superior)
                                    local safeX = Camera.ViewportSize.X * 0.5
                                    local safeY = Camera.ViewportSize.Y * 0.35
                                    
                                    VirtualInputManager:SendMouseButtonEvent(safeX, safeY, 0, true, game, 0)
                                    VirtualInputManager:SendMouseButtonEvent(safeX, safeY, 0, false, game, 0)
                                    
                                    -- Activar la herramienta de cámara
                                    local char = LocalPlayer.Character
                                    if char then
                                        local tool = char:FindFirstChildOfClass("Tool")
                                        if tool then
                                            tool:Activate()
                                        end
                                    end
                                    
                                    break
                                end
                            end
                            
                        end
                    end
                end
            end
        end
        
        -- Si la barra ya no está en pantalla, reiniciamos el estado
        if not barraEncontrada then
            minijuegoEnPantalla = false
        end
    end)
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

print("Beris Hub - Escudo Anti-Spawn Cargado.")