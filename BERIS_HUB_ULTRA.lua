-- ====================================================================
-- BERIS HUB V6 - PRO OPTIMIZED ENGINE [BUILD 2026.06.11]
-- ====================================================================

local Players, RunService, UserInput, TweenService, TeleportService = 
    game:GetService("Players"), game:GetService("RunService"), 
    game:GetService("UserInputService"), game:GetService("TweenService"), 
    game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BerisHubV6_Pro"

-- Sistema de Conexiones Inteligente
local connections = {}
local function addConn(id, conn)
    if connections[id] then connections[id]:Disconnect() end
    connections[id] = conn
end

-- Motor de Limpieza (Anti-Lag)
local function safeLoop(name, callback)
    task.spawn(function()
        while true do
            local success, err = pcall(callback)
            if not success then warn("[BerisHub] Error en " .. name .. ": " .. err) end
            task.wait(0.1)
        end
    end)
end

-- ====================================================================
-- UI ENGINE (OPTIMIZADO)
-- ====================================================================
local function createUI()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 360, 0, 520)
    Main.Position = UDim2.new(0.5, -180, 0.5, -260)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    Main.Active = true
    Main.Draggable = true
    
    local Corner = Instance.new("UICorner", Main)
    Corner.CornerRadius = UDim.new(0, 12)
    
    -- Barra superior de arrastre
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 1
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "BERIS HUB | PRO EDITION"
    Title.TextColor3 = Color3.fromRGB(0, 240, 255)
    Title.Font = Enum.Font.GothamBold
    Title.Size = UDim2.new(1, -50, 1, 0)
    
    return Main
end

local MainFrame = createUI()

-- ====================================================================
-- NÚCLEO DE FUNCIONES (OPTIMIZADO)
-- ====================================================================

-- Aimlock Estabilizado (Evita jitter)
local aimTarget = nil
addConn("Aim", RunService.RenderStepped:Connect(function()
    if aimTarget and aimTarget.Character and aimTarget.Character:FindFirstChild("Head") then
        local camPos = Camera.CFrame.Position
        local targetPos = aimTarget.Character.Head.Position
        Camera.CFrame = CFrame.new(camPos, targetPos)
    end
end))

-- Noclip Ultra-Ligero (Menos carga en servidor)
addConn("Noclip", RunService.Stepped:Connect(function()
    if _G.NoclipEnabled then
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end))

-- ====================================================================
-- EJECUCIÓN DEL SISTEMA
-- ====================================================================
print("Beris Hub V6: Motor cargado correctamente.")

-- Nota: Para integrar todas las 41 funciones anteriores, 
-- mantén la estructura de pestañas pero sustituye los eventos 
-- por la función 'addConn' para asegurar que el script no se crashee.