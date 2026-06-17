--====================================================================
-- HUB NAME: beris
-- Motor: Teletransporte Físico + Panel Anti-Lag Especial Móvil
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiador de interfaz para evitar clones
if PlayerGui:FindFirstChild("BerisHubTycoon") then
    PlayerGui.BerisHubTycoon:Destroy()
end

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubTycoon"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Marco Principal Estilizado (Ajustado de tamaño para dos opciones)
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
_G.AutoRecogerDinero = false
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
local ButtonToggle = crearBoton("Auto-Recoger: OFF", 50, Color3.fromRGB(45, 45, 55))
local ButtonLag = crearBoton("Modo Anti-Lag: OFF", 100, Color3.fromRGB(45, 45, 55))

-- LÓGICA 1: INTERRUPTOR AUTO-RECOGER (TELEPORT)
ButtonToggle.MouseButton1Click:Connect(function()
    _G.AutoRecogerDinero = not _G.AutoRecogerDinero
    if _G.AutoRecogerDinero then
        ButtonToggle.Text = "Auto-Recoger: ON"
        ButtonToggle.BackgroundColor3 = Color3.fromRGB(46, 139, 87) -- Verde
        StatusLabel.Text = "Estado: Recolectando clones..."
    else
        ButtonToggle.Text = "Auto-Recoger: OFF"
        ButtonToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Estado: Pausado"
    end
end)

-- LÓGICA 2: INTERRUPTOR ANTI-LAG (OPTIMIZADOR GRÁFICO)
ButtonLag.MouseButton1Click:Connect(function()
    _G.AntiLagEnabled = not _G.AntiLagEnabled
    if _G.AntiLagEnabled then
        ButtonLag.Text = "Modo Anti-Lag: ON"
        ButtonLag.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Estado: Gráficos optimizados"
        
        -- Ejecutar limpieza agresiva de rendimiento
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Texture") or v:IsA("Decal") then
                    v.Texture = "" -- Remueve texturas pesadas del suelo/paredes
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") then
                    v.Enabled = false -- Apaga fuegos, brillos o destellos molestos
                elseif v:IsA("BasePart") and not v.Parent:FindFirstChildOfClass("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic -- Convierte bloques en plástico liso para ahorrar memoria
                end
            end
        end)
    else
        ButtonLag.Text = "Modo Anti-Lag: OFF"
        ButtonLag.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Estado: Gráficos normales"
    end
end)

-- BUCLE DE ABSORCIÓN POR MOVIMIENTO ULTRA RÁPIDO
task.spawn(function()
    while true do
        task.wait(0.4)
        
        local char = LocalPlayer.Character
        if _G.AutoRecogerDinero and char and char:FindFirstChild("HumanoidRootPart") then
            local rootPart = char.HumanoidRootPart
            local posicionOriginal = rootPart.CFrame
            
            local todosLosObjetos = Workspace:GetDescendants()
            local clonesListos = {}
            
            for i = 1, #todosLosObjetos do
                local v = todosLosObjetos[i]
                if v:IsA("BillboardGui") then
                    local textLabel = v:FindFirstChildOfClass("TextLabel") or v:FindFirstChildWhichIsA("TextLabel")
                    
                    if textLabel and textLabel.Text then
                        local texto = textLabel.Text:lower()
                        
                        -- Filtro estricto: Debe decir Recoger y NO costar Robux
                        if texto:find("recoger") and not texto:find("robux") and not texto:find("saltar") and not texto:find("skip") then
                            local parteFisica = v.Adornee or v.Parent
                            if parteFisica and parteFisica:IsA("BasePart") then
                                table.insert(clonesListos, parteFisica)
                            end
                        end
                    end
                end
            end
            
            -- Salto físico en ráfaga sobre las coordenadas del Tycoon
            if #clonesListos > 0 then
                for _, clonPart in ipairs(clonesListos) do
                    if not _G.AutoRecogerDinero then break end
                    pcall(function()
                        rootPart.CFrame = clonPart.CFrame + Vector3.new(0, 2, 0)
                    end)
                    task.wait(0.02)
                end
                rootPart.CFrame = posicionOriginal
            end
            
        end
    end
end)