--====================================================================
-- HUB NAME: beris
-- Diseñado para el Tycoon de Clones (Filtro Anti-Robux Integrado)
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpiador para reiniciar la interfaz en móviles
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
MainFrame.Size = UDim2.new(0, 210, 0, 160)
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
StatusLabel.Text = "Estado: Esperando activación"
StatusLabel.TextColor3 = Color3.fromRGB(130, 135, 145)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Variable de control
_G.AutoRecogerDinero = false

-- Botón Principal Moderno (Toggle)
local ButtonToggle = Instance.new("TextButton")
ButtonToggle.Size = UDim2.new(0.9, 0, 0, 45)
ButtonToggle.Position = UDim2.new(0.05, 0, 0, 55)
ButtonToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55) -- Color apagado inicial
ButtonToggle.BorderSizePixel = 0
ButtonToggle.Text = "Auto-Recoger: OFF"
ButtonToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonToggle.TextSize = 14
ButtonToggle.Font = Enum.Font.GothamBold
ButtonToggle.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ButtonToggle

-- LÓGICA DEL BOTÓN INTERRUPTOR (ENCENDER / APAGAR)
ButtonToggle.MouseButton1Click:Connect(function()
    _G.AutoRecogerDinero = not _G.AutoRecogerDinero
    
    if _G.AutoRecogerDinero then
        ButtonToggle.Text = "Auto-Recoger: ON"
        ButtonToggle.BackgroundColor3 = Color3.fromRGB(46, 139, 87) -- Verde
        StatusLabel.Text = "Estado: Absorbiendo dinero..."
    else
        ButtonToggle.Text = "Auto-Recoger: OFF"
        ButtonToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 55) -- Gris oscuro
        StatusLabel.Text = "Estado: Pausado"
    end
end)

-- FUNCIÓN FILTRO DE SEGURIDAD INTERNA
local function recolectarDineroSeguro(objeto)
    -- Si detecta que pide Robux o pases de juego, lo bloquea por completo
    if objeto:FindFirstChild("GamePassId") or objeto:FindFirstChild("ProductId") or objeto.Name:lower():find("pass") then
        return
    end

    -- 1. Intentar recoger si usa ProximityPrompt
    local prompt = objeto:FindFirstChildOfClass("ProximityPrompt") or objeto.Parent:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        fireproximityprompt(prompt)
        return
    end
    
    -- 2. Intentar recoger simulando colisión física (Touch)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local fireTouch = firetouchinterest or txtouchinterest
        if fireTouch then
            fireTouch(character.HumanoidRootPart, objeto, 0)
            task.wait(0.01)
            fireTouch(character.HumanoidRootPart, objeto, 1)
        end
    end
end

-- BUCLE PRINCIPAL EN SEGUNDO PLANO
task.spawn(function()
    while true do
        task.wait(0.4) -- Escaneo constante optimizado para no generar lag en celular
        
        if _G.AutoRecogerDinero and LocalPlayer.Character then
            local desc = Workspace:GetDescendants()
            
            for i = 1, #desc do
                if not _G.AutoRecogerDinero then break end
                
                local obj = desc[i]
                if obj:IsA("BasePart") then
                    local nombre = obj.Name:lower()
                    
                    -- Solo busca fajos, sacos o nombres relacionados a las ganancias sueltas
                    if nombre:find("drop") or nombre:find("cash") or nombre:find("money") or nombre:find("saco") or obj:FindFirstChildOfClass("BillboardGui") then
                        
                        -- Ignora botones de la tienda o los que sirvan para saltar esperas (Skip)
                        if not nombre:find("skip") and not nombre:find("tienda") and not nombre:find("buy") and not nombre:find("devproduct") then
                            pcall(function()
                                recolectarDineroSeguro(obj)
                            end)
                        end
                        
                    end
                end
            end
        end
    end
end)