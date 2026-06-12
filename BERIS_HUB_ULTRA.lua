-- HUB NAME: beris
-- Versión Premium con Interfaz Avanzada para "99 noches en el bosque"

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

-- Marco Principal Estilizado
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 310)
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

-- Subtítulo / Indicador de Estado Inferior
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
local modos = {"Madera (Wood/Stick)", "Chatarra (Scrap)", "Comida (Berry/Meat)", "Cofres (Chests)"}
local modoActualIdx = 1
local savedPosition = nil

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
local ButtonSelector = createModernButton("🎯 Buscar: Madera (Wood/Stick)", 45, 32, Color3.fromRGB(28, 30, 38), true)
local ButtonBring = createModernButton("⚡ Traer Recurso", 85, 36, Color3.fromRGB(0, 120, 215), true)
local ButtonCampfire = createModernButton("🔥 Llenar Fogata Central", 130, 32, Color3.fromRGB(180, 40, 40), true)

-- Separador Visual
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(0.9, 0, 0, 1)
Separator.Position = UDim2.new(0.05, 0, 0, 175)
Separator.BackgroundColor3 = Color3.fromRGB(40, 42, 50)
Separator.BorderSizePixel = 0
Separator.Parent = MainFrame

-- Sección de Teletransportes de Emergencia
local ButtonTP1 = createModernButton("📍 Guardar Ubicación", 188, 30, Color3.fromRGB(35, 38, 47), false)
local ButtonTP2 = createModernButton("🌀 Volver a Ubicación", 226, 30, Color3.fromRGB(35, 38, 47), false)


-- LÓGICA: INTERRUPTOR DE RECURSOS DETECTADOS
ButtonSelector.MouseButton1Click:Connect(function()
    modoActualIdx = modoActualIdx + 1
    if modoActualIdx > #modos then modoActualIdx = 1 end
    ButtonSelector.Text = "🎯 Buscar: " .. modos[modoActualIdx]
end)

-- LÓGICA: AUTO-FARM SEGURO (MÓVIL INTERFACES)
ButtonBring.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = char.HumanoidRootPart
    local originalPosition = myRoot.CFrame
    local collectCount = 0
    
    local recursoElegido = modos[modoActualIdx]
    StatusLabel.Text = "Estado: Escaneando bosque..."
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(char) and not obj:IsDescendantOf(Players) then
            local name = obj.Name:lower()
            local esValido = false
            
            if recursoElegido == "Madera (Wood/Stick)" then
                if name:find("tree") or name:find("log") or name:find("wood") or name:find("stick") or name:find("branch") or name:find("madera") then
                    esValido = true
                end
            elseif recursoElegido == "Chatarra (Scrap)" then
                if name:find("scrap") or name:find("chair") or name:find("metal") or name:find("engine") or name:find("iron") or name:find("chatarra") then
                    esValido = true
                end
            elseif recursoElegido == "Comida (Berry/Meat)" then
                if name:find("berry") or name:find("meat") or name:find("carrot") or name:find("corn") or name:find("pumpkin") or name:find("food") then
                    esValido = true
                end
            elseif recursoElegido == "Cofres (Chests)" then
                if name:find("chest") or name:find("caja") or name:find("loot") or name:find("safe") then
                    esValido = true
                end
            end
            
            if esValido then
                local dist = (obj.Position - originalPosition.Position).Magnitude
                if dist < 250 then 
                    StatusLabel.Text = "Estado: Absorbiendo " .. obj.Name
                    myRoot.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.08) -- Delay óptimo para bypass de rango
                    collectCount = collectCount + 1
                    
                    if collectCount >= 8 then break end 
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

-- LÓGICA: RELLENAR LA FOGATA DE CUALQUIER NIVEL
ButtonCampfire.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = char.HumanoidRootPart
    local originalPosition = myRoot.CFrame
    local campFirePart = nil
    
    StatusLabel.Text = "Estado: Buscando fogata..."
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("campfire") or name:find("fogata") or name:find("centerfire") or name:find("mainfire") or name:find("fuego") then
                campFirePart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if campFirePart then break end
            end
        end
    end
    
    if campFirePart then
        StatusLabel.Text = "Estado: Depositando materiales..."
        myRoot.CFrame = campFirePart.CFrame + Vector3.new(0, 2, 0)
        task.wait(0.22)
        myRoot.CFrame = originalPosition
        StatusLabel.Text = "Estado: Fogata alimentada con éxito"
    else
        StatusLabel.Text = "Estado: Error, fogata no hallada"
    end
    
    task.wait(1.2)
    StatusLabel.Text = "Estado: Listo"
end)

-- LÓGICA: TELETRANSPORTE MANUAL
ButtonTP1.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        StatusLabel.Text = "Estado: Posición guardada"
        task.wait(1)
        StatusLabel.Text = "Estado: Listo"
    end
end)

ButtonTP2.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and savedPosition then
        LocalPlayer.Character.HumanoidRootPart.CFrame = savedPosition
        StatusLabel.Text = "Estado: Teletransportado a base"
        task.wait(1)
        StatusLabel.Text = "Estado: Listo"
    end
end)