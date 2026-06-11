-- ====================================================================
-- BERIS HUB V6 - MASTER EDITION [VERSION COMPLETA 2026]
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- 1. CREACIÓN DE INTERFAZ FORZADA
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "BerisHubV6"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 300)
Main.Position = UDim2.new(0.5, -125, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Main.Visible = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "BERIS HUB V6"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)

-- 2. LISTA DE FUNCIONES (SISTEMA DE BOTONES)
local function createButton(name, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, #Main:GetChildren() * 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Click:Connect(callback)
end

-- 3. LÓGICA DE LAS FUNCIONES
local noclip = false
createButton("NOCLIP (Atravesar)", function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

createButton("FLY (Vuelo)", function()
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(0, 50, 0)
        task.wait(1)
        bv:Destroy()
    end
end)

createButton("SPEED (Rapidez)", function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 50
end)

createButton("CERRAR MENU", function()
    ScreenGui:Destroy()
end)

-- 4. TECLA DE EMERGENCIA
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.P then
        Main.Visible = not Main.Visible
    end
end)

print("Beris Hub V6: Cargado completamente.")