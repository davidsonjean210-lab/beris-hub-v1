-- HUB NAME: beris
-- Versión con Auto-Aura de Hacha por Radio para "99 noches en el bosque"

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiador para reiniciar la interfaz en móviles
if PlayerGui:FindFirstChild("BerisHub") then
    PlayerGui.BerisHub:Destroy()
end

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Marco Principal Estilizado (Ajustado de tamaño para el nuevo botón)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 350)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 19, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Línea de Acento Superior (Neon Style)
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
Title.Text = "  beris hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
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

-- Variables de Estado
local modos = {"Madera (Árboles)", "Chatarra (Zonas Externas)", "Comida (Arbustos/Suelo)", "Cofres (Mapa)"}
local modoActualIdx = 1
local savedPosition = nil
local axeAuraEnabled = false
local radioDeCorte = 40 -- Puedes cambiar este número para aumentar o disminuir el radio

-- Función para fabricar botones modernos
local function createModernButton(text, posY, sizeY, baseColor, isBold)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, sizeY)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = baseColor
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = isBold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    btn.Parent = MainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    return btn
end

-- Creación de la botonera estilizada
local ButtonAura = createModernButton("🪓 Aura de Hacha: OFF", 45, 32, Color3.fromRGB(45, 45, 55), true)
local ButtonSelector = createModernButton("🎯 Buscar: Madera (Árboles)", 85, 32, Color3.fromRGB(28, 30, 38), true)
local ButtonBring = createModernButton("⚡ Traer Recurso", 125, 36, Color3.fromRGB(0, 120, 215), true)
local ButtonCampfire = createModernButton("🔥 Llenar Fogata Central", 170, 32, Color3.fromRGB(180, 40, 40), true)

-- Separador Visual
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0.9, 0, 0, 1)
Separator.Position = UDim2.new(0.05, 0, 0, 215)
Separator.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
Separator.BorderSizePixel = 0
Separator.Parent = MainFrame

-- Sección de Teletransportes de Emergencia
local ButtonTP1 = createModernButton("📍 Guardar Ubicación", 228, 30, Color3.fromRGB(35, 38, 47), false)
local ButtonTP2 = createModernButton("🌀 Volver a Ubicación", 266, 30, Color3.fromRGB(35, 38, 47), false)

-- LÓGICA 1: INTERRUPTOR DEL AURA DEL HACHA (RADIO)
ButtonAura.MouseButton1Click:Connect(function()
    axeAuraEnabled = not axeAuraEnabled
    if axeAuraEnabled then
        ButtonAura.Text = "🪓 Aura de Hacha: ON"
        ButtonAura.BackgroundColor3 = Color3.fromRGB(46, 139, 87) -- Verde Activado
        StatusLabel.Text = "Estado: Aura de tala activa"
    else
        ButtonAura.Text = "🪓 Aura de Hacha: OFF"
        ButtonAura.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Estado: Aura desactivada"
    end
end)

-- Bucle infinito en segundo plano para el Aura por Radio
task.spawn(function()
    while true do
        task.wait(0.2) -- Escanea el entorno 5 veces por segundo
        if axeAuraEnabled then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                -- Verifica si el jugador tiene el hacha equipada (en el personaje) o seleccionada
                local tool = char:FindFirstChildWhichIsA("Tool")
                if tool and (tool.Name:lower():find("axe") or tool.Name:lower():find("hacha")) then
                    
                    local myPos = char.HumanoidRootPart.Position
                    
                    -- Buscar árboles dentro del radio
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) and not obj:IsDescendantOf(Players) then
                            local name = obj.Name:lower()
                            
                            -- Solo atacamos árboles verdaderos del mapa afuera de la base
                            if (name:find("tree") or name:find("log") or name:find("tronco") or name:find("wood")) and not name:find("campfire") and not name:find("table") then
                                local distance = (obj.Position - myPos).Magnitude
                                
                                if distance <= radioDeCorte then
                                    -- Simula la activación/golpe de la herramienta hacia la madera
                                    tool:Activate()
                                    
                                    -- Si el juego requiere interactuar con herramientas específicas,
                                    -- disparamos un toque virtual a la parte del árbol
                                    if tool:FindFirstChild("RemoteEvent") then
                                        tool.RemoteEvent:FireServer(obj)
                                    end
                                    
                                    -- Destello visual opcional: StatusLabel.Text = "Talandos: " .. obj.Name
                                    task.wait(0.05) -- Evita saturar el juego
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- LÓGICA 2: INTERRUPTOR DE RECURSOS DETECTADOS
ButtonSelector.MouseButton1Click:Connect(function()
    modoActualIdx = modoActualIdx + 1
    if modoActualIdx > #modos then modoActualIdx = 1 end
    ButtonSelector.Text = "🎯 Buscar: " .. modos[modoActualIdx]
end)

-- LÓGICA 3: AUTO-FARM SEGURO MEJORADO
ButtonBring.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = char.HumanoidRootPart
    local originalPosition = myRoot.CFrame
    local collectCount = 0
    local recursoElegido = modos[modoActualIdx]
    
    StatusLabel.Text = "Estado: Buscando en el bosque profundo..."
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) and not obj:IsDescendantOf(Players) then
            local name = obj.Name:lower()
            if not name:find("campfire") and not name:find("bench") and not name:find("craft") and not name:find("table") and not name:find("station") and not name:find("base") then
                local esValido = false
                if recursoElegido == "Madera (Árboles)" then
                    if name:find("tree") or name:find("log") or name:find("branch") or name:find("stick") or name:find("wood") then esValido = true end
                elseif recursoElegido == "Chatarra (Zonas Externas)" then
                    if name:find("scrap") or name:find("iron") or name:find("metal") or name:find("junk") then esValido = true end
                elseif recursoElegido == "Comida (Arbustos/Suelo)" then
                    if name:find("berry") or name:find("bush") or name:find("carrot") or name:find("corn") or name:find("pumpkin") then esValido = true end
                elseif recursoElegido == "Cofres (Mapa)" then
                    if name:find("chest") or name:find("caja") or name:find("loot") then esValido = true end
                end
                
                if esValido then
                    local dist = (obj.Position - originalPosition.Position).Magnitude
                    if dist > 35 and dist < 300 then 
                        myRoot.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.12)
                        collectCount = collectCount + 1
                        if collectCount >= 6 then break end 
                    end
                end
            end
        end
    end
    myRoot.CFrame = originalPosition
    StatusLabel.Text = "Estado: Recolectados (" .. collectCount .. ")"
    ButtonBring.Text = "✓ ¡Listo!"
    task.wait(1)
    ButtonBring.Text = "⚡ Traer Recurso"
    StatusLabel.Text = "Estado: Listo"
end)

-- LÓGICA 4: RELLENAR LA FOGATA
ButtonCampfire.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = char.HumanoidRootPart
    local originalPosition = myRoot.CFrame
    local campFirePart = nil
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("campfire") or name:find("fogata") or name:find("centerfire") or name:find("mainfire") then
                campFirePart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if campFirePart then break end
            end
        end
    end
    if campFirePart then
        myRoot.CFrame = campFirePart.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.25)
        myRoot.CFrame = originalPosition
        StatusLabel.Text = "Estado: Fogata alimentada"
    else
        StatusLabel.Text = "Estado: Error, no hallada"
    end
    task.wait(1)
    StatusLabel.Text = "Estado: Listo"
end)

-- LÓGICA 5: TELETRANSPORTE MANUAL
ButtonTP1.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        StatusLabel.Text = "Estado: Posición guardada"
    end
end)

ButtonTP2.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and savedPosition then
        LocalPlayer.Character.HumanoidRootPart.CFrame = savedPosition
    end
end)