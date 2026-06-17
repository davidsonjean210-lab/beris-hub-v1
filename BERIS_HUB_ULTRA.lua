--====================================================================
-- HUB NAME: beris
-- Motor V5: Imán por Expansión de Hitbox (Aura Física Invisible)
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpieza de interfaz en pantalla
if PlayerGui:FindFirstChild("BerisHubTycoon") then
    PlayerGui.BerisHubTycoon:Destroy()
end

-- Interfaz Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubTycoon"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Marco Principal
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

-- Línea de Acento (Neon Blue)
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, 0, 0, 3)
AccentLine.Position = UDim2.new(0, 0, 0, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame

local AccentCorner = Instance.new("UICorner")
AccentCorner.CornerRadius = UDim.new(0, 12)
AccentCorner.Parent = AccentLine

-- Título
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

-- Etiqueta de Estado
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 1, -22)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Estado: Listo para usar"
StatusLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Variables Globales
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

-- Botones
local ButtonMagnet = crearBoton("🧲 Imán Automático: OFF", 50, Color3.fromRGB(45, 45, 55))
local ButtonLag = crearBoton("Modo Anti-Lag: OFF", 100, Color3.fromRGB(45, 45, 55))

-- LÓGICA 1: INTERRUPTOR DEL AURA FÍSICA (EL IMÁN GRATIS)
ButtonMagnet.MouseButton1Click:Connect(function()
    _G.AutoImanMagnet = not _G.AutoImanMagnet
    if _G.AutoImanMagnet then
        ButtonMagnet.Text = "🧲 Imán Automático: ON"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Aura Gigante Activada"
    else
        ButtonMagnet.Text = "🧲 Imán Automático: OFF"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Aura Apagada"
    end
end)

-- LÓGICA 2: OPTIMIZADOR GRÁFICO
ButtonLag.MouseButton1Click:Connect(function()
    _G.AntiLagEnabled = not _G.AntiLagEnabled
    if _G.AntiLagEnabled then
        ButtonLag.Text = "Modo Anti-Lag: ON"
        ButtonLag.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    else
        ButtonLag.Text = "Modo Anti-Lag: OFF"
        ButtonLag.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

--====================================================================
-- MOTOR CENTRAL: EXPANSOR DE CUERPO (HITBOX MAGNET)
--====================================================================
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if _G.AutoImanMagnet and character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local aura = character:FindFirstChild("BerisAuraMagnetica")
            
            -- Si el aura no existe, la creamos y la soldamos a tu pecho
            if not aura then
                aura = Instance.new("Part")
                aura.Name = "BerisAuraMagnetica"
                -- Tamaño masivo: 300x50x300. Cubre prácticamente todo tu terreno de clones
                aura.Size = Vector3.new(300, 50, 300)
                aura.Transparency = 1 -- 100% invisible para no molestar tu vista
                aura.CanCollide = false -- Para que no te atasques en las paredes
                aura.Massless = true -- Para que no te haga caminar lento
                aura.CFrame = hrp.CFrame
                aura.Parent = character
                
                -- Soldadura: Fija el aura gigante para que se mueva a donde tú vayas
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = hrp
                weld.Part1 = aura
                weld.Parent = aura
            end
        else
            -- Si apagas el botón, destruimos el aura para devolver tu tamaño a la normalidad
            if character then
                local aura = character:FindFirstChild("BerisAuraMagnetica")
                if aura then
                    aura:Destroy()
                end
            end
        end
    end)
end)