-- [[ MENÚ DE MOVIMIENTO: VELOCIDAD Y SALTO INFINITO ]]
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

local VELOCIDAD_RAPIDA = 100
local VELOCIDAD_NORMAL = 16

-- 1. Crear la Interfaz (GUI)
if CoreGui:FindFirstChild("MenuMovimientoGUI") then
    CoreGui.MenuMovimientoGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MenuMovimientoGUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Permite arrastrar el menú por la pantalla
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local Titulo = Instance.new("TextLabel")
Titulo.Size = UDim2.new(1, 0, 0, 40)
Titulo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Titulo.Text = " Menú de Movimiento"
Titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
Titulo.TextSize = 18
Titulo.Font = Enum.Font.GothamBold
Titulo.Parent = MainFrame

local TituloCorner = Instance.new("UICorner")
TituloCorner.CornerRadius = UDim.new(0, 8)
TituloCorner.Parent = Titulo

-- Botón de Súper Velocidad
local BtnVelocidad = Instance.new("TextButton")
BtnVelocidad.Size = UDim2.new(0, 200, 0, 45)
BtnVelocidad.Position = UDim2.new(0.5, -100, 0, 60)
BtnVelocidad.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Rojo por defecto
BtnVelocidad.Text = "Súper Velocidad: OFF"
BtnVelocidad.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnVelocidad.TextSize = 16
BtnVelocidad.Font = Enum.Font.GothamSemibold
BtnVelocidad.Parent = MainFrame

local VelCorner = Instance.new("UICorner")
VelCorner.CornerRadius = UDim.new(0, 6)
VelCorner.Parent = BtnVelocidad

-- Botón de Salto Infinito
local BtnSalto = Instance.new("TextButton")
BtnSalto.Size = UDim2.new(0, 200, 0, 45)
BtnSalto.Position = UDim2.new(0.5, -100, 0, 120)
BtnSalto.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Rojo por defecto
BtnSalto.Text = "Salto Infinito: OFF"
BtnSalto.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnSalto.TextSize = 16
BtnSalto.Font = Enum.Font.GothamSemibold
BtnSalto.Parent = MainFrame

local SaltoCorner = Instance.new("UICorner")
SaltoCorner.CornerRadius = UDim.new(0, 6)
SaltoCorner.Parent = BtnSalto

-- Botón para minimizar/cerrar
local BtnCerrar = Instance.new("TextButton")
BtnCerrar.Size = UDim2.new(0, 30, 0, 30)
BtnCerrar.Position = UDim2.new(1, -35, 0, 5)
BtnCerrar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnCerrar.Text = "X"
BtnCerrar.TextColor3 = Color3.fromRGB(200, 200, 200)
BtnCerrar.TextSize = 16
BtnCerrar.Font = Enum.Font.GothamBold
BtnCerrar.BorderSizePixel = 0
BtnCerrar.Parent = MainFrame

BtnCerrar.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    opciones.SuperVelocidad = false
    opciones.SaltoInfinito = false
end)

-- 2. Lógica de los Botones (Visual y Funcional)
BtnVelocidad.MouseButton1Click:Connect(function()
    opciones.SuperVelocidad = not opciones.SuperVelocidad
    if opciones.SuperVelocidad then
        BtnVelocidad.BackgroundColor3 = Color3.fromRGB(50, 180, 50) -- Verde
        BtnVelocidad.Text = "Súper Velocidad: ON"
    else
        BtnVelocidad.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Rojo
        BtnVelocidad.Text = "Súper Velocidad: OFF"
    end
end)

BtnSalto.MouseButton1Click:Connect(function()
    opciones.SaltoInfinito = not opciones.SaltoInfinito
    if opciones.SaltoInfinito then
        BtnSalto.BackgroundColor3 = Color3.fromRGB(50, 180, 50) -- Verde
        BtnSalto.Text = "Salto Infinito: ON"
    else
        BtnSalto.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Rojo
        BtnSalto.Text = "Salto Infinito: OFF"
    end
end)

-- 3. Funciones de Trampas (Loops y Eventos)

-- Bucle para forzar la velocidad constantemente (evita que el juego la reinicie)
task.spawn(function()
    while task.wait(0.1) do
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if opciones.SuperVelocidad then
                    humanoid.WalkSpeed = VELOCIDAD_RAPIDA
                else
                    -- Solo restaura a 16 si acaba de apagarse para no interferir con otras funciones
                    if humanoid.WalkSpeed == VELOCIDAD_RAPIDA then
                        humanoid.WalkSpeed = VELOCIDAD_NORMAL
                    end
                end
            end
        end
    end
end)

-- Evento para el Salto Infinito
UserInputService.JumpRequest:Connect(function()
    if opciones.SaltoInfinito then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Obliga al personaje a cambiar al estado de salto incluso si está en el aire
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

print("Menú de movimiento cargado con éxito.")