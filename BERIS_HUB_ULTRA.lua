--====================================================================
-- HUB NAME: beris
-- Motor V6: Recolección Fantasma (Bypass Anti-Cheat del Servidor)
--====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Limpieza de interfaz
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
StatusLabel.Text = "Estado: Listo"
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

local ButtonMagnet = crearBoton("🧲 Imán Automático: OFF", 50, Color3.fromRGB(45, 45, 55))
local ButtonLag = crearBoton("Modo Anti-Lag: OFF", 100, Color3.fromRGB(45, 45, 55))

-- LÓGICA DE BOTONES
ButtonMagnet.MouseButton1Click:Connect(function()
    _G.AutoImanMagnet = not _G.AutoImanMagnet
    if _G.AutoImanMagnet then
        ButtonMagnet.Text = "🧲 Imán Automático: ON"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
        StatusLabel.Text = "Recolectando en secreto..."
    else
        ButtonMagnet.Text = "🧲 Imán Automático: OFF"
        ButtonMagnet.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        StatusLabel.Text = "Pausado"
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
-- MOTOR CENTRAL: TELETRANSPORTE FANTASMA (ANTI-LAG Y ANTI-CHEAT)
--====================================================================
task.spawn(function()
    while true do
        task.wait(1) -- Escanea cada 1 segundo para no sobrecargar el celular
        
        local char = LocalPlayer.Character
        if _G.AutoImanMagnet and char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
            local hrp = char.HumanoidRootPart
            local originalCFrame = hrp.CFrame
            
            -- Recopilar todos los clones con dinero
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
            
            -- Iniciar la recolección fantasma si hay dinero
            if #clonesListos > 0 then
                -- 1. Creamos un punto de anclaje visual (Para que la cámara no se vuelva loca)
                local anclaCamara = Instance.new("Part")
                anclaCamara.Transparency = 1
                anclaCamara.Anchored = true
                anclaCamara.CFrame = hrp.CFrame
                anclaCamara.Parent = Workspace
                
                -- 2. Fijamos la cámara a este punto invisible
                Camera.CameraSubject = anclaCamara
                
                -- 3. Teletransportamos físicamente el cuerpo rápido a cada clon
                for _, clon in ipairs(clonesListos) do
                    if not _G.AutoImanMagnet then break end
                    pcall(function()
                        hrp.CFrame = clon.CFrame
                    end)
                    task.wait(0.05) -- El tiempo perfecto para que el servidor diga "Okay, es válido"
                end
                
                -- 4. Regresamos el cuerpo a donde estabas originalmente
                hrp.CFrame = originalCFrame
                
                -- 5. Le devolvemos la cámara a tu personaje
                Camera.CameraSubject = char.Humanoid
                anclaCamara:Destroy()
            end
        end
    end
end)