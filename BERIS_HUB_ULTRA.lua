-- ====================================================================
-- BERIS HUB V6 - COMBAT BURST MULTIPLIER FIXED EDITION (2026)
-- CÓDIGO DEPURADO, OPTIMIZADO Y CORREGIDO SINTÁCTICAMENTE
-- ====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables de optimización y estados estables
local savedPosition = nil
local noclipEnabled = false
local infJumpEnabled = false
local flyEnabled = false
local flySpeed = 50
local walkSpeedEnabled = false
local customWalkSpeed = 16
local isMinimised = false
local espEnabled = false
local chamsEnabled = false 
local aimlockEnabled = false
local fastAimEnabled = false
local autoFamaEnabled = false
local killAuraEnabled = false 
local autoParryEnabled = false 
local instantRespawnEnabled = false 
local fpsBoostEnabled = false 
local hitboxExpanded = false 
local autoCollectEnabled = false
local multiplierEnabled = false 
local hitMultiplierValue = 5   

local MAX_REAL_DISTANCE = 300 
local AURA_RANGE = 25 
local PREDICTION_INTENSITY = 0.14
local originalGravity = workspace.Gravity

-- Corrección 1: Inicialización segura de la tabla de conexiones de red
local connections = {
    walkSpeed = nil,
    fly = nil,
    noclip = nil,
    fastAim = nil,
    aimlock = nil,
    infJump = nil,
    hitMultiplier = nil
}

-- CONTROLADOR DE INTERFAZ GENERAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BerisHubV6_Fixed"
ScreenGui.ResetOnSpawn = false

local function injectGui()
    local success, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if success and coreGui then ScreenGui.Parent = coreGui else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 7) or game
    end
end
injectGui()

local MainFrame = Instance.new("Frame")
local fullSize = UDim2.new(0, 310, 0, 480) 
local miniSize = UDim2.new(0, 310, 0, 45)

MainFrame.Name = "MainFrame"
MainFrame.Size = fullSize
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 19)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 10, 14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 27, 36))
}
UIGradient.Rotation = 60
UIGradient.Parent = MainFrame

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local NeonLine = Instance.new("Frame")
NeonLine.Size = UDim2.new(1, 0, 0, 3)
NeonLine.BackgroundColor3 = Color3.fromRGB(255, 0, 85) 
NeonLine.BorderSizePixel = 0
NeonLine.Parent = MainFrame

-- ENCABEZADO
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "   BERIS HUB V6 • <font color='#FF0055'>FIXED PATCH</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 24, 0, 24)
BtnClose.Position = UDim2.new(1, -34, 0, 10)
BtnClose.Text = "✕"
BtnClose.TextColor3 = Color3.fromRGB(255, 80, 80)
BtnClose.TextSize = 11
BtnClose.Font = Enum.Font.GothamBold
BtnClose.BackgroundColor3 = Color3.fromRGB(32, 18, 22)
BtnClose.BorderSizePixel = 0
BtnClose.Parent = Header
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 6)

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Size = UDim2.new(0, 24, 0, 24)
BtnMinimize.Position = UDim2.new(1, -64, 0, 10)
BtnMinimize.Text = "—"
BtnMinimize.TextColor3 = Color3.fromRGB(255, 0, 85)
BtnMinimize.TextSize = 11
BtnMinimize.Font = Enum.Font.GothamBold
BtnMinimize.BackgroundColor3 = Color3.fromRGB(36, 18, 26)
BtnMinimize.BorderSizePixel = 0
BtnMinimize.Parent = Header
Instance.new("UICorner", BtnMinimize).CornerRadius = UDim.new(0, 6)

-- CONTENEDOR DE PESTAÑAS (TABS)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

-- CONTENEDOR DE PÁGINAS (PAGES)
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, 0, 1, -85)
PagesContainer.Position = UDim2.new(0, 0, 0, 85)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = MainFrame

local pages = {}

local function createTab(name, order)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 54, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(140, 145, 160)
    tabBtn.TextSize = 10
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.LayoutOrder = order
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 470)
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 85)
    page.Visible = false
    page.Parent = PagesContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    pages[name] = page
    
    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in pairs(TabBar:GetChildren()) do 
            if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(140, 145, 160) b.BackgroundColor3 = Color3.fromRGB(20, 22, 30) end 
        end
        page.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 85)
    end)
    
    return page
end

local PageCombat   = createTab("Combat", 1)
local PageFarm     = createTab("Farm", 2)
local PageVisuals  = createTab("Visuals", 3)
local PageMovement = createTab("Movement", 4)
local PageConfig   = createTab("Config", 5)

pages["Combat"].Visible = true
TabBar:FindFirstChildOfClass("TextButton").TextColor3 = Color3.fromRGB(255, 255, 255)
TabBar:FindFirstChildOfClass("TextButton").BackgroundColor3 = Color3.fromRGB(255, 0, 85)

local function createModuleButton(parentPage, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 280, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    frame.BorderSizePixel = 0
    frame.Parent = parentPage
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 1, 0)
    button.Position = UDim2.new(0, 12, 0, 0)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(235, 235, 240)
    button.TextSize = 11
    button.Font = Enum.Font.GothamSemibold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.BackgroundTransparency = 1
    button.Parent = frame

    local led = Instance.new("Frame")
    led.Size = UDim2.new(0, 6, 0, 6)
    led.Position = UDim2.new(1, -16, 0, 14)
    led.BackgroundColor3 = Color3.fromRGB(255, 65, 65)
    led.BorderSizePixel = 0
    led.Parent = frame
    Instance.new("UICorner", led).CornerRadius = UDim.new(1, 0)

    return button, led
end

local function createModuleTextBox(parentPage, placeholder)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 280, 0, 34)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(110, 115, 125)
    textBox.TextSize = 11
    textBox.Font = Enum.Font.Gotham
    textBox.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
    textBox.BorderSizePixel = 0
    textBox.Parent = parentPage
    Instance.new("UICorner", textBox).CornerRadius =