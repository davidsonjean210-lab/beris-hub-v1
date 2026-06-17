--====================================================================
-- HUB NAME: beris
-- Motor V4: Imán de Absorción Total por Escaneo de Componentes
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
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

-- LÓGICA 1: INTERRUPTOR DEL IMÁN DE RECOLECCIÓN
ButtonMagnet.MouseButton1Click:Connect(function()
    _G.AutoImanMagnet = not _G.AutoImanMagnet
    if _G.AutoImanMagnet then
        ButtonMagnet.Text = "🧲 Imán Automático: ON"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(46, 139, 87) -- Verde
        StatusLabel.Text = "Estado: Imán activado masivo"
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

-- BUCLE PRINCIPAL: SIMULACIÓN DE IMÁN TOTAL POR RED
task.spawn(function()
    while true do
        task.wait(0.5) -- Ciclo estable para recolectar las filas sin colapsar el móvil
        
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if _G.AutoImanMagnet and rootPart then
            local todosLosObjetos = Workspace:GetDescendants()
            
            for i = 1, #todosLosObjetos do
                if not _G.AutoImanMagnet then break end
                
                local v = todosLosObjetos[i]
                -- Buscamos los carteles de "Recoger" en el mapa
                if v:IsA("BillboardGui") then
                    local textLabel = v:FindFirstChildOfClass("TextLabel") or v:FindFirstChildWhichIsA("TextLabel")
                    
                    if textLabel and textLabel.Text then
                        local texto = textLabel.Text:lower()
                        
                        -- Filtro estricto para asegurar que es dinero y no compras de Robux
                        if texto:find("recoger") and not texto:find("robux") and not texto:find("saltar") and not texto:find("skip") then
                            
                            -- Obtenemos el modelo completo del clon (o el contenedor donde está el sensor)
                            local modeloContenedor = v.Parent
                            if modeloContenedor then
                                
                                pcall(function()
                                    -- ¡EL SECRETO DEL IMÁN!: Extraemos todas las piezas físicas de ese clon
                                    local piezas = modeloContenedor:GetDescendants()
                                    
                                    for j = 1, #piezas do
                                        local parteCuerpo = piezas[j]
                                        if parteCuerpo:IsA("BasePart") then
                                            
                                            -- Forzamos la colisión física simulada en cada milímetro del objeto
                                            local fireTouch = firetouchinterest or txtouchinterest
                                            if fireTouch then
                                                fireTouch(rootPart, parteCuerpo, 0) -- Conectar toque
                                                fireTouch(rootPart, parteCuerpo, 1) -- Soltar toque
                                            end
                                            
                                        end
                                    end
                                end)
                                
                            end
                        end
                    end
                end
            end
        end
    end
end)