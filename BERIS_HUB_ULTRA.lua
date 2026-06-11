--// BERIS HUB - SISTEMA DE INGRESOS

local Players = game:GetService("Players")
local player = Players.LocalPlayer

------------------------------------------------
-- CONFIGURACIÓN DE MODOS
------------------------------------------------
local incomeMode = "BASICO"

local IncomeConfig = {
    BASICO = {
        money = 100,
        delay = 2
    },

    PREMIUM = {
        money = 50000,
        delay = 1.5
    },

    PLUS = {
        money = 80000,
        delay = 1
    }
}

------------------------------------------------
-- FUNCION PARA DAR DINERO
------------------------------------------------
local function giveMoney(amount)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end

    for _, value in pairs(leaderstats:GetChildren()) do
        if value:IsA("IntValue") then
            value.Value += amount
            return
        end
    end
end

------------------------------------------------
-- LOOP PRINCIPAL DE INGRESOS
------------------------------------------------
task.spawn(function()
    while true do
        local config = IncomeConfig[incomeMode]

        if config then
            giveMoney(config.money)
            task.wait(config.delay)
        else
            task.wait(1)
        end
    end
end)