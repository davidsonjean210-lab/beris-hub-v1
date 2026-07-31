-- [[ BERIS HUB - ROTUBE LIFE 2 (AUTO-CLICKER + FOTO INSTANTÁNEA) ]]
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de Estado
local opciones = {
    AutoFotoPerfecta = false,
    ClicAutomatico = false,
    SuperVelocidad = false,
    SaltoInfinito = false
}
local posicionGuardada = nil
local VELOCIDAD_EXTRA = 60
local ultimoClicFoto = 0
local ultimoClicAuto = 0

-- 1. Crear la Interfaz (GUI)
if CoreGui:FindFirstChild("BerisRoTubeGUI") then
    CoreGui.BerisRoTubeGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisRoTubeGUI"
ScreenGui.Parent = CoreGui

-- Marco Principal (Agrandado a 350 de alto para el nuevo botón)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 350)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -175)
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
Titulo.Text = " Beris Hub - RoTube Life 2"
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
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Spacer = Instance.new("Frame")
Spacer.Size = UDim2.new(1, 0, 0, 3)
Spacer.BackgroundTransparency = 1
Spacer.Parent = Contenedor

-- Función creadora de botones
local function CrearBoton(texto, color, contenedor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 230, 0, 36)
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
local BtnAutoClic = CrearBoton("Clic Automático: OFF", Color3.fromRGB(180, 50, 50), Contenedor)
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
        MainFrame:TweenSize(UDim2.new(0, 260, 0, 350), "Out", "Quad", 0.3, true)
        BtnMinimizar.Text = "-"
    end
end)

BtnCerrar.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    opciones.AutoFotoPerfecta = false
    opciones.ClicAutomatico = false
    opciones.SuperVelocidad = false
    opciones.SaltoInfinito = false
end)

-- 3. Lógica de Botones ON/OFF
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
BtnAutoClic.MouseButton1Click:Connect(function() ToggleBoton(BtnAutoClic, "ClicAutomatico", "Clic Automático") end)
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

-- [[ AUTO-FOTO PERFECTA (DISPARO INSTANTÁNEO EN ZONA VERDE) ]]
RunService.Heartbeat:Connect(function()
    if not opciones.AutoFotoPerfecta then return end
    if (tick() - ultimoClicFoto) < 0.40 then return end -- Evita hacer doble clic en un mismo intento
    
    pcall(function()
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "BerisRoTubeGUI" then
                for _, bar in pairs(gui:GetDescendants()) do
                    -- Buscar la barra inferior del minijuego
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
                                local centroLinea = lineaMovil.AbsolutePosition.X + (lineaMovil.AbsoluteSize.X / 2)
                                
                                -- MARGEN DE SEGURIDAD (5% en los bordes):
                                -- Cubre casi todo el cuadro verde para disparar apenas entre,
                                -- permitiendo que el retraso del celular haga caer el clic dentro.
                                local inicioZona = zonaObjetivo.AbsolutePosition.X
                                local anchoZona = zonaObjetivo.AbsoluteSize.X
                                
                                local zonaSeguraInicio = inicioZona + (anchoZona * 0.05)
                                local zonaSeguraFin = (inicioZona + anchoZona) - (anchoZona * 0.05)
                                
                                -- ¡DISPARO INMEDIATO AL TOCAR LO VERDE!
                                if centroLinea >= zonaSeguraInicio and centroLinea <= zonaSeguraFin then
                                    ultimoClicFoto = tick()
                                    
                                    -- Clic táctil en el centro superior (zona libre de botones)
                                    local safeX = Camera.ViewportSize.X * 0.5
                                    local safeY = Camera.ViewportSize.Y * 0.35
                                    
                                    VirtualInputManager:SendMouseButtonEvent(safeX, safeY, 0, true, game, 0)
                                    VirtualInputManager:SendMouseButtonEvent(safeX, safeY, 0, false, game, 0)
                                    
                                    -- Activar la herramienta equipada por si acaso
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
    end)
end)

-- [[ CLIC AUTOMÁTICO (AUTO-CLICKER PARA FARMEO) ]]
RunService.Heartbeat:Connect(function()
    if opciones.ClicAutomatico and (tick() - ultimoClicAuto) >= 0.10 then
        ultimoClicAuto = tick()
        pcall(function()
            -- 1. Activa la herramienta que tengas en la mano (cámara, teléfono, etc.)
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
            
            -- 2. Manda un toque táctil en pantalla por si el juego requiere clics en el aire
            local safeX = Camera.ViewportSize.X * 0.5
            local safeY = Camera.ViewportSize.Y * 0.35
            VirtualInputManager:SendMouseButtonEvent(safeX, safeY, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(safeX, safeY, 0, false, game, 0)
        end)
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

print("Beris Hub - AutoClicker + Foto Instantánea Cargado.")