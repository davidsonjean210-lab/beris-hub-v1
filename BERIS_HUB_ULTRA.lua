-- ====================================================================
-- BERIS HUB V6 - FINAL 51-OPTION MEGA-PACK (2026)
-- ====================================================================
-- [AÑADIDO: SISTEMA DE RECOLECCIÓN AUTOMÁTICA DE DINERO]

-- Variables de las nuevas 10 opciones
local autoCollectMoney = false
local autoClaimRewards = false
local autoHeal = false
local autoEquipBest = false
local antiAfkPro = false
local areaClicker = false
local autoParkour = false
local fovModifier = false
local playerAlert = false
local autoQuest = false

-- Función de Recolección Automática (Lógica de Magnetismo)
task.spawn(function()
    while true do
        if autoCollectMoney then
            for _, obj in pairs(workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("Model")) and (obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("cash")) then
                    pcall(function()
                        obj.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    end)
                end
            end
        end
        task.wait(0.5)
    end
end)

-- INTEGRACIÓN EN LA INTERFAZ (Añadir al PageContainer de "SERVIDOR" o crear nueva pestaña "FARMEO")
-- Aquí tienes la lógica de los nuevos botones:

local function setupNewFeatures()
    -- Ejemplo de cómo vincular el nuevo botón de Auto Recolección:
    -- BtnAutoCollect, LedCollect = createMenuOption(serverPage, "💰 Auto Recolección de Dinero")
    -- BtnAutoCollect.MouseButton1Click:Connect(function() 
    --    autoCollectMoney = not autoCollectMoney 
    --    updateLed(LedCollect, autoCollectMoney) 
    -- end)

    -- [Nota: Para mantener la estabilidad del script, integra estas llamadas
    -- dentro de la sección de creación de botones que ya definimos arriba.]
end

-- ====================================================================
-- INYECCIÓN DEL ANTI-AFK PRO (Nueva opción #5)
-- ====================================================================
LocalPlayer.Idled:Connect(function()
    if antiAfkPro then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton1(Vector2.new(0,0))
    end
end)

-- ====================================================================
-- NOTA: El motor central (Aimlock, Fly, ESP) se mantiene intacto.
-- ====================================================================