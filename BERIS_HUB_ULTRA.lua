--====================================================================
-- HUB NAME: beris
-- Motor V7: Auto-Ruta Terrestre (Pisar las bases a supervelocidad)
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
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
StatusLabel.Text = "Estado: Esperando..."
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

local ButtonMagnet = crearBoton("⚡ Flash Recolector: OFF", 50, Color3.fromRGB(45, 45, 55))
local ButtonLag = crearBoton("Modo Anti-Lag: OFF", 100, Color3.fromRGB(45, 45, 55))

-- LÓGICA DE BOTONES
ButtonMagnet.MouseButton1Click:Connect(function()
    _G.AutoImanMagnet = not _G.AutoImanMagnet
    if _G.AutoImanMagnet then
        ButtonMagnet.Text = "⚡ Flash Recolector: ON"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Pista: Quédate en el piso del Tycoon"
    else
        ButtonMagnet.Text = "⚡ Flash Recolector: OFF"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Ruta pausada"
    end
end)

ButtonLag.MouseButton1Click:Connect(function()
    _G.AntiLagEnabled = not _G.AntiLagEnabled
    if _G.AntiLagEnabled then
        ButtonLag.Text = "Modo Anti-Lag: ON"
        ButtonLag.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
        end)
    else
        ButtonLag.Text = "Modo Anti-Lag: OFF"
        ButtonLag.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

--====================================================================
-- MOTOR CENTRAL: AUTO-RUTA TERRESTRE
--====================================================================
task.spawn(function()
    while true do
        task.wait(1.5) -- Pausa entre cada recolección masiva para no causar lag
        
        local char = LocalPlayer.Character
        if _G.AutoImanMagnet and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            local hrp = char.HumanoidRootPart
            local humanoid = char.Humanoid
            
            -- Guardamos tu altura actual en el suelo para no hacerte volar
            local nivelDelSueloY = hrp.Position.Y
            local posicionOriginal = hrp.CFrame
            
            -- Recopilar todos los carteles de dinero
            local clonesListos = {}
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BillboardGui") then
                    local txt = v:FindFirstChildWhichIsA("TextLabel")
                    if txt and txt.Text then
                        local texto = txt.Text:lower()
                        if texto:find("recoger") and not texto:find("robux") then
                            local part = v.Adornee or v.Parent
                            if part and part:IsA("BasePart") then
                                table.insert(clonesListos, part)
                            end
                        end
                    end
                end
            end
            
            -- Ejecutar la ruta a supervelocidad por el suelo
            if #clonesListos > 0 then
                StatusLabel.Text = "Recolectando " .. #clonesListos .. " clones..."
                
                for _, clon in ipairs(clonesListos) do
                    if not _G.AutoImanMagnet then break end
                    
                    pcall(function()
                        -- Te movemos a la coordenada X y Z del clon, pero manteniendo tu nivel del piso (Y)
                        local targetX = clon.Position.X
                        local targetZ = clon.Position.Z
                        
                        hrp.CFrame = CFrame.new(targetX, nivelDelSueloY, targetZ)
                    end)
                    
                    -- Micro-pausa para asegurar que el servidor registre que pisaste ese lugar
                    task.wait(0.03) 
                end
                
                -- Al terminar, te devuelve a tu lugar original
                hrp.CFrame = posicionOriginal
                StatusLabel.Text = "Esperando nueva ganancia..."
            end
        end
    end
end)