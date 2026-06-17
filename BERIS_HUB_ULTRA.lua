--====================================================================
-- HUB NAME: beris
-- Motor: Emulación de Imán de Recolección Automática de 25 Robux
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiador de interfaz para evitar clones en la pantalla del celular
if PlayerGui:FindFirstChild("BerisHubTycoon") then
    PlayerGui.BerisHubTycoon:Destroy()
end

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubTycoon"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Marco Principal Estilizado
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 210, 0, 215)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Línea de Acento Superior (Neon Blue)
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 3)
AccentLine.Position = UDim2.new(0, 0, 0, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame

local AccentCorner = Instance.new("UICorner")
AccentCorner.CornerRadius = UDim.new(0, 12)
AccentCorner.Parent = AccentLine

-- Título Principal
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 3)
Title.BackgroundTransparency = 1
Title.Text = "  beris hub 💸"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Indicador de Estado Inferior
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Estado: Listo"
StatusLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Variables de control globales
_G.AutoImanMagnet = false
_G.AntiLagEnabled = false

-- Constructor de Botones
local function crearBoton(texto, posY, colorBase)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 42)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = colorBase
    btn.BorderSizePixel = 0
    btn.Text = texto
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    return btn
end

-- Creación de Botones Visuales
local ButtonMagnet = crearBoton("🧲 Imán Automático: OFF", 50, Color3.fromRGB(45, 45, 55))
local ButtonLag = crearBoton("Modo Anti-Lag: OFF", 100, Color3.fromRGB(45, 45, 55))

-- LÓGICA 1: EMULADOR DEL IMÁN DE ROBUX (RECOLECCIÓN REMOTA)
ButtonMagnet.MouseButton1Click:Connect(function()
    _G.AutoImanMagnet = not _G.AutoImanMagnet
    if _G.AutoImanMagnet then
        ButtonMagnet.Text = "🧲 Imán Automático: ON"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(46, 139, 87) -- Verde
        StatusLabel.Text = "Estado: Imán activado (Gratis)"
    else
        ButtonMagnet.Text = "🧲 Imán Automático: OFF"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Estado: Pausado"
    end
end)

-- LÓGICA 2: OPTIMIZADOR GRÁFICO ANTI-LAG
ButtonLag.MouseButton1Click:Connect(function()
    _G.AntiLagEnabled = not _G.AntiLagEnabled
    if _G.AntiLagEnabled then
        ButtonLag.Text = "Modo Anti-Lag: ON"
        ButtonLag.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Estado: Gráficos optimizados"
        
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Texture") or v:IsA("Decal") then
                    v.Texture = ""
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") then
                    v.Enabled = false
                elseif v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    else
        ButtonLag.Text = "Modo Anti-Lag: OFF"
        ButtonLag.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Estado: Gráficos normales"
    end
end)

-- BUCLE CENTRAL: RECOLECCIÓN REMOTA POR EMULACIÓN DE SERVIDOR
task.spawn(function()
    while true do
        task.wait(0.3) -- Recolecta todo de golpe 3 veces por segundo sin moverse
        
        if _G.AutoImanMagnet and LocalPlayer.Character then
            pcall(function()
                -- 1. Buscamos la carpeta de eventos remotos del juego
                local Remotes = ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
                
                -- 2. El imán de estos Tycoons reclama el acumulado activando el evento de colectar del Tycoon asignado al jugador
                local collectRemote = Remotes:FindFirstChild("Collect") or Remotes:FindFirstChild("CollectCash") or Remotes:FindFirstChild("Claim") or Remotes:FindFirstChild("Reward")
                
                if collectRemote and collectRemote:IsA("RemoteEvent") then
                    -- Ejecuta la recolección automática masiva directo en el servidor
                    collectRemote:FireServer()
                else
                    -- 3. Si el juego requiere enviar el objeto como argumento (como en CpsHub), le enviamos los contenedores de dinero detectados
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("cash") or obj.Name:lower():find("money") or obj.Name:lower():find("drop")) then
                            local event = Remotes:FindFirstChild("Collect") or Remotes:FindFirstChild("Pickup")
                            if event then
                                event:FireServer(obj)
                            end
                        end
                    end
                end
            end)
        end
    end
end)