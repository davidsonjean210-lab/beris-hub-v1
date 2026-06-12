-- [[ EXTRACTOR DE NOMBRES DE RECURSOS - 99 NIGHTS ]]
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- 1. Escanear el mapa en busca de modelos (recursos)
local nombresEncontrados = {}
for _, objeto in pairs(Workspace:GetChildren()) do
    -- Filtramos para buscar Modelos que no sean jugadores ni infraestructura básica
    if objeto:IsA("Model") and not objeto:FindFirstChild("Humanoid") and objeto.Name ~= "Terrain" then
        -- Verificamos si tiene partes físicas dentro
        if objeto:FindFirstChildWhichIsA("BasePart") then
            nombresEncontrados[objeto.Name] = true
        end
    end
end

-- Convertir el diccionario a una lista de texto limpia
local textoFinal = "--- LISTA DE RECURSOS ENCONTRADOS ---\n\n"
for nombre, _ in pairs(nombresEncontrados) do
    textoFinal = textoFinal .. nombre .. "\n"
end
textoFinal = textoFinal .. "\n-----------------------------------"

-- 2. Crear Interfaz Gráfica (GUI) para copiar el texto fácilmente
-- Evita duplicar la interfaz si la ejecutas varias veces
if CoreGui:FindFirstChild("ResourceDumperGUI") then
    CoreGui.ResourceDumperGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ResourceDumperGUI"
ScreenGui.Parent = CoreGui

-- Contenedor Principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Puedes mover la ventana por la pantalla
MainFrame.Parent = ScreenGui

-- Esquinas redondeadas
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Título de la ventana
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.Text = " Extractor de Recursos (Copia la lista)"
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Botón Cerrar (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Cuadro de texto editable para poder copiarlo
local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 320, 0, 330)
TextBox.Position = UDim2.new(0, 15, 0, 55)
TextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
TextBox.TextColor3 = Color3.fromRGB(180, 255, 180) -- Texto verde tipo consola
TextBox.TextSize = 14
TextBox.Font = Enum.Font.Code
TextBox.Text = textoFinal
TextBox.ClearTextOnFocus = false
TextBox.MultiLine = true
TextBox.ReadOnly = false -- Permitir que el usuario seleccione el texto
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.Parent = MainFrame

local TextCorner = Instance.new("UICorner")
TextCorner.CornerRadius = UDim.new(0, 5)
TextCorner.Parent = TextBox

print("¡Escaneo finalizado! Revisa la interfaz en tu pantalla.")