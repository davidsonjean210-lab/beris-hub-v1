-- BERIS HUB ULTRA FIXED 😈🔥

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "BerisHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 320)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- BOTONES
local function btn(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,0,0,35)
    b.Position = UDim2.new(0,0,y,0)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    return b
end

local b_tp = btn("Guardar TP",0)
local b_tp2 = btn("Ir TP",0.12)
local b_noclip = btn("Noclip",0.24)
local b_regen = btn("Regen Vida",0.36)
local b_money = btn("Ingresos",0.48)
local b_dup = btn("Duplicar",0.60)
local b_auto = btn("Auto recoger",0.72)
local b_jump = btn("Infinite Jump",0.84)

-- VARIABLES
local savedPos
local noclip = false
local regen = false
local money = false
local dup = false
local auto = false
local infJump = false

local connections = {}

local function char()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- TP
b_tp.MouseButton1Click:Connect(function()
    local hrp = char():FindFirstChild("HumanoidRootPart")
    if hrp then
        savedPos = hrp.Position
    end
end)

b_tp2.MouseButton1Click:Connect(function()
    local hrp = char():FindFirstChild("HumanoidRootPart")
    if hrp and savedPos then
        hrp.CFrame = CFrame.new(savedPos)
    end
end)

-- Noclip
b_noclip.MouseButton1Click:Connect(function()
    noclip = not noclip
end)

-- Regen
b_regen.MouseButton1Click:Connect(function()
    regen = not regen
end)

-- Ingresos
b_money.MouseButton1Click:Connect(function()
    money = not money
end)

-- Duplicar (seguro)
b_dup.MouseButton1Click:Connect(function()
    dup = not dup
end)

-- Auto recoger (mejorado)
b_auto.MouseButton1Click:Connect(function()
    auto = not auto
end)

-- Infinite Jump FIX
b_jump.MouseButton1Click:Connect(function()
    infJump = not infJump

    if infJump then
        connections.jump = UserInput.JumpRequest:Connect(function()
            local hum = char():FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connections.jump then
            connections.jump:Disconnect()
        end
    end
end)

-- LOOP PRINCIPAL
RunService.RenderStepped:Connect(function()
    local c = LocalPlayer.Character
    if not c then return end

    -- Noclip
    if noclip then
        for _,v in pairs(c:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    -- Regen
    if regen then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = math.min(hum.Health + 1, hum.MaxHealth)
        end
    end

    -- Ingresos normales
    if money then
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        if stats then
            for _,v in pairs(stats:GetChildren()) do
                if v:IsA("IntValue") then
                    v.Value += 1
                end
            end
        end
    end

    -- Duplicar (más seguro)
    if dup then
        local stats = LocalPlayer:FindFirstChild("leaderstats")
        if stats then
            for _,v in pairs(stats:GetChildren()) do
                if v:IsA("IntValue") then
                    v.Value += 5
                end
            end
        end
    end

    -- Auto recoger mejorado
    if auto then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _,obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if name:find("coin") or name:find("cash") or name:find("money") then
                        obj.CFrame = hrp.CFrame
                    end
                end
            end
        end
    end
end)